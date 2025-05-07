use std::{cell::RefCell, collections::HashMap};

use candid::{encode_args, Principal};
use cmc::{CreateCanisterArg, NotifyCreateCanisterArg};
use ic_cdk::{
    api::{is_controller, management_canister::main::{canister_info, install_code, update_settings, CanisterInfoRequest, CanisterSettings, InstallCodeArgument, UpdateSettingsArgument}},
    id, query, update,
};
use ic_ledger_types::{
    AccountBalanceArgs, AccountIdentifier, Memo, Subaccount, Tokens, TransferArgs, DEFAULT_FEE,
    MAINNET_CYCLES_MINTING_CANISTER_ID, MAINNET_LEDGER_CANISTER_ID,
};
use ic_stable_structures::{
    memory_manager::{MemoryId, MemoryManager, VirtualMemory},
    DefaultMemoryImpl, StableBTreeMap,
};

mod cmc;
const PLATFORM_FEE: u64 = 60_000_000;
pub const MEMO_CREATE_CANISTER: u64 = 1095062083_u64;

const ONCHAIN_WALLET_WASM: &[u8] = include_bytes!("../../bin/fusion_wallet.wasm");
type Memory = VirtualMemory<DefaultMemoryImpl>;

thread_local! {
    static MEMORY_MANAGER: RefCell<MemoryManager<DefaultMemoryImpl>> =
    RefCell::new(MemoryManager::init(DefaultMemoryImpl::default()));

    // static WALLET_ADDRESS: RefCell<HashMap<Principal, String>> = RefCell::new(HashMap::new());

     // Initialize a `StableBTreeMap` with `MemoryId(0)`.
     static WALLET_ADDRESS: RefCell<StableBTreeMap<Principal, String, Memory>> = RefCell::new(
        StableBTreeMap::init(
            MEMORY_MANAGER.with(|m| m.borrow().get(MemoryId::new(0))),
        )
    );
}

#[ic_cdk::query(guard = not_anonymous)]
async fn get_deposit_address() -> String {
    let caller = ic_cdk::caller();
    let account_id = AccountIdentifier::new(&id(), &Subaccount::from(caller));
    account_id.to_string()
}

#[cfg(network = "local")]
#[update(guard = not_anonymous)]
async fn provision_wallet() -> Result<String, String> {
    use ic_cdk::api::management_canister::main::{
        create_canister, CanisterSettings, CreateCanisterArgument, LogVisibility,
    };

    let caller = ic_cdk::caller();

    let (res,) = create_canister(
        CreateCanisterArgument {
            settings: Some(CanisterSettings {
                controllers: Some(vec![caller, id()]),
                reserved_cycles_limit: None,
                log_visibility: Some(LogVisibility::Controllers),
                wasm_memory_limit: None,
                memory_allocation: None,
                compute_allocation: None,
                freezing_threshold: None,
            }),
        },
        4_000_000_000_000,
    )
    .await
    .unwrap();

    let canister_id = res.canister_id;

    // install wasm
    let arg = InstallCodeArgument {
        mode: ic_cdk::api::management_canister::main::CanisterInstallMode::Install,
        canister_id,
        wasm_module: ONCHAIN_WALLET_WASM.to_vec(),
        arg: encode_args(()).unwrap(),
    };

    install_code(arg).await.unwrap();

    WALLET_ADDRESS.with_borrow_mut(|wallet_address| {
        wallet_address.insert(caller, canister_id.to_string());
    });

    Ok(canister_id.to_string())
}

#[cfg(network = "ic")]
#[update(guard = not_anonymous)]
async fn provision_wallet() -> Result<String, String> {
    let caller = ic_cdk::caller();
    // get balance
    let balance = ic_ledger_types::account_balance(
        MAINNET_LEDGER_CANISTER_ID,
        AccountBalanceArgs {
            account: AccountIdentifier::new(&id(), &Subaccount::from(caller)),
        },
    )
    .await
    .unwrap();

    // less than 1 ICP minimum balance
    if balance <= Tokens::from_e8s(100_000_000) {
        return Err("Insufficient balance".to_string());
    }

    let taken_amt = balance - DEFAULT_FEE;

    let args = TransferArgs {
        from_subaccount: Some(Subaccount::from(caller)),
        to: AccountIdentifier::new(&id(), &Subaccount([0; 32])),
        amount: taken_amt,
        created_at_time: None,
        fee: DEFAULT_FEE,
        memo: Memo(0),
    };

    // transfer everything
    let _ = ic_ledger_types::transfer(MAINNET_LEDGER_CANISTER_ID, args)
        .await
        .unwrap();

    let payout = taken_amt - (Tokens::from_e8s(PLATFORM_FEE) + DEFAULT_FEE);

    // transfer to cmc
    let args = TransferArgs {
        from_subaccount: None,
        to: AccountIdentifier::new(&MAINNET_CYCLES_MINTING_CANISTER_ID, &Subaccount::from(id())),
        amount: payout,
        created_at_time: None,
        fee: DEFAULT_FEE,
        memo: Memo(MEMO_CREATE_CANISTER),
    };

    // transfer to cmc

    let block_height = ic_ledger_types::transfer(MAINNET_LEDGER_CANISTER_ID, args)
        .await
        .unwrap().map_err(|e| e.to_string())?;

    let cmc_canister = cmc::Service(MAINNET_CYCLES_MINTING_CANISTER_ID);

    let (notify_result,) = cmc_canister.notify_create_canister(NotifyCreateCanisterArg{
        controller: id(),
        block_index: block_height,
        subnet_selection: None,
        settings: Some(cmc::CanisterSettings {
            freezing_threshold: None,
            wasm_memory_threshold: None,
            controllers: Some(vec![caller, id()]),
            reserved_cycles_limit: None,
            log_visibility: Some(cmc::LogVisibility::Controllers),
            wasm_memory_limit: None,
            memory_allocation: None,
            compute_allocation: None,
        }),
        subnet_type: None,
    }).await.map_err(|e| e.1)?;

   

    let canister_id = match notify_result {
        Ok(canister_id) => canister_id,
        Err(e) => {
            return Err(format!("Failed to create canister: {:?}", e));
        }
    };

    // install wasm
    let arg = InstallCodeArgument {
        mode: ic_cdk::api::management_canister::main::CanisterInstallMode::Install,
        canister_id,
        wasm_module: ONCHAIN_WALLET_WASM.to_vec(),
        arg: encode_args(()).unwrap(),
    };

    install_code(arg).await.unwrap();

    let method_args = encode_args(()).unwrap();
    let (prime_controller,): (Result<Principal, String>, ) = ic_cdk::call(canister_id, "get_prime_controller", (method_args,)).await.map_err(|e| e.1)?;

    add_controller(prime_controller.unwrap(), canister_id).await.unwrap();

    WALLET_ADDRESS.with_borrow_mut(|wallet_address| {
        wallet_address.insert(caller, canister_id.to_string());
    });

    Ok(canister_id.to_string())
}

#[update(guard = is_app_controller)]
async fn upgrade_wallets() -> Result<(), String> {
    ic_cdk::println!("Upgrading wallets");
    let wallet_vec : Vec<String> = WALLET_ADDRESS.with_borrow_mut(|wallet_address| {
        wallet_address.iter().map(|(_f, canister_id)| canister_id.clone()).collect()
    });

    for canister_id in wallet_vec {
       
        let arg = InstallCodeArgument {
            mode: ic_cdk::api::management_canister::main::CanisterInstallMode::Upgrade(None),
            canister_id: Principal::from_text(&canister_id).unwrap(),
            wasm_module: ONCHAIN_WALLET_WASM.to_vec(),
            arg: encode_args(()).unwrap(),
        };
        install_code(arg).await.unwrap();
    };

    Ok(())
}

async fn add_controller(controller : Principal, canister_id: Principal) -> Result<(), String> {

    let (info_req,) = canister_info(CanisterInfoRequest{
        canister_id,
        num_requested_changes: None,
    }).await.map_err(|e| e.1)?;

    let mut controllers = info_req.controllers;

    let found = controllers.iter().find(|elm| elm.to_text() == controller.to_text());

    if found.is_some() {
        return Ok(());
    }

    controllers.push(controller);

    update_settings(UpdateSettingsArgument {
        canister_id,
        settings: CanisterSettings {
            controllers: Some(controllers),
            ..Default::default()
        },
    }).await.unwrap();

    Ok(())
}

fn is_app_controller() -> Result<(), String> {
    #[cfg(network = "local")]
    return Ok(());
    
    let caller = ic_cdk::caller();
    if !is_controller(&caller) {
        return Err("Not a controller".to_string());
    }
    Ok(())
}

#[ic_cdk::query(guard = not_anonymous)]
async fn get_wallet_address() -> Option<String> {
    let caller = ic_cdk::caller();
    WALLET_ADDRESS.with_borrow(|wallet_address| wallet_address.get(&caller))
}

fn not_anonymous() -> Result<(), String> {
    #[cfg(network = "local")]
    return Ok(());
    let caller = ic_cdk::caller();
    if caller == Principal::anonymous() {
        Err("Anonymous caller".to_string())
    } else {
        Ok(())
    }
}

#[query]
#[candid::candid_method(query)]
fn export_candid() -> String {
    ic_cdk::export_candid!();
    __export_service()
}
