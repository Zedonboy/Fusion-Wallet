use std::borrow::Cow;
use std::cell::RefCell;
use std::collections::{HashMap, HashSet};

use candid::{decode_args, CandidType, Decode, Deserialize, Principal};
use fcm_api::send_message;
use ic_cdk::api::is_controller;
use ic_cdk::api::management_canister::http_request::HttpResponse;
use ic_cdk::{caller, export_candid};
use ic_cdk::{api::management_canister::http_request::{TransformArgs}, query, update};
use ic_stable_structures::memory_manager::VirtualMemory;
use ic_stable_structures::storable::Bound;
use icrc_ledger_types::icrc::generic_metadata_value::MetadataValue;
use icrc_ledger_types::icrc::generic_value::ICRC3Value;
use icrc_ledger_types::icrc1::account::Account;
use icrc_ledger_types::icrc3::blocks;
use serde::Serialize;
mod fcm_api;
mod utils;
use ic_stable_structures::{
    memory_manager::{MemoryId, MemoryManager},
    StableBTreeMap, DefaultMemoryImpl,
};
use utils::AppSet;

type Memory = VirtualMemory<DefaultMemoryImpl>;

thread_local! {
    // The memory manager is used for simulating multiple memories. Given a `MemoryId` it can
    // return a memory that can be used by stable structures.
    static MEMORY_MANAGER: RefCell<MemoryManager<DefaultMemoryImpl>> =
        RefCell::new(MemoryManager::init(DefaultMemoryImpl::default()));

    // Map of user to their device tokens (both owned and delegated)
    static USER_TOKENS: RefCell<StableBTreeMap<Principal, utils::AppSet, Memory>> = RefCell::new(StableBTreeMap::init(MEMORY_MANAGER.with(|m| m.borrow().get(MemoryId::new(0))),));

    // Map of user to their canister permissions (canister_id -> permission)
    static USER_CANISTER_PERMISSIONS: RefCell<StableBTreeMap<Principal, utils::AppPermissionMap, Memory>> = RefCell::new(StableBTreeMap::init(MEMORY_MANAGER.with(|m| m.borrow().get(MemoryId::new(1))),));
}

// Device token management
#[update(guard = is_authenticated)]
async fn add_device_token(token: String) {
    let caller = caller();
    USER_TOKENS.with_borrow_mut(|user_tokens| {
        if !user_tokens.contains_key(&caller) {
            user_tokens.insert(caller, utils::AppSet(HashSet::new()));
        }

        let AppSet(mut set) = user_tokens.get(&caller).unwrap();
        set.insert(utils::DeviceToken::OwnedToken(token));
        user_tokens.insert(caller, AppSet(set));
    });
}

#[update(guard = is_authenticated)]
async fn remove_device_token(token: String) {
    let caller = caller();
    USER_TOKENS.with_borrow_mut(|user_tokens| {
        if let Some(AppSet(mut set)) = user_tokens.get(&caller) {
            set.remove(&utils::DeviceToken::OwnedToken(token));

            user_tokens.insert(caller, AppSet(set));
        }
    });
}

#[query(guard = is_authenticated)]
fn get_device_tokens() -> Vec<String> {
    let caller = caller();
    USER_TOKENS.with_borrow(|user_tokens| {
        user_tokens.get(&caller).map_or_else(Vec::new, |tokens| {
            tokens
                .0
                .iter()
                .filter_map(|token| match token {
                    utils::DeviceToken::OwnedToken(t) => Some(t.clone()),
                    _ => None,
                })
                .collect()
        })
    })
}

// // Wallet delegation management
// #[update(guard = is_authenticated)]
// async fn process_wallet_delegation(delegation: SignedWalletDelegation) -> Result<(), String> {
//     let caller = msg_caller();

//     // Verify the signature
//     if !verify_wallet_delegation_signature(&delegation) {
//         return Err("Invalid signature".to_string());
//     }

//     // Get the principal from the public key
//     let owner_principal = derive_principal_from_public_key(&delegation.public_key, &delegation.algorithm)
//         .ok_or_else(|| "Failed to derive principal from public key".to_string())?;

//     // adding the delegation to the user's tokens
//     USER_TOKENS.with_borrow_mut(|user_tokens| {
//         user_tokens
//             .entry(caller)
//             .or_insert_with(HashSet::new)
//             .insert(DeviceToken::DelegatedToken {
//                 owner: owner_principal
//             });
//     });

//     // Process each target app in the delegation
//     for app in delegation.wallet_delegation.target {
//         // Convert canister_id string to Principal
//         match Principal::from_text(&app.canister_id) {
//             Ok(canister_principal) => {
//                 // Add permission for the canister
//                 USER_CANISTER_PERMISSIONS.with_borrow_mut(|permissions| {
//                     permissions
//                         .entry(owner_principal)
//                         .or_default()
//                         .insert(canister_principal, CanisterPermission { app_info: app, enabled: true });
//                 });
//             },
//             Err(_) => return Err(format!("Invalid canister ID: {}", app.canister_id)),
//         }
//     }

//     Ok(())
// }

#[update(guard = is_authenticated)]
async fn update_canister_permission(canister_id: Principal, enabled: bool) {
    let caller = caller();
    USER_CANISTER_PERMISSIONS.with_borrow_mut(|permissions| {
        if let Some(mut user_permissions) = permissions.get(&caller) {
            if let Some(permission) = user_permissions.0.get_mut(&canister_id) {
                permission.enabled = enabled;
                permissions.insert(caller, user_permissions);
            }
        }
    });
}

#[update(guard = is_authenticated)]
async fn remove_canister_permission(canister_id: Principal) {
    let caller = caller();
    USER_CANISTER_PERMISSIONS.with_borrow_mut(|permissions| {
        if let Some(mut user_permissions) = permissions.get(&caller) {
            user_permissions.0.remove(&canister_id);
            permissions.insert(caller, user_permissions);
        }
    });
}

#[derive(Clone, Debug, CandidType, Serialize)]
struct CanisterPermissionInfo {
    canister_id: Principal,
    enabled: bool,
    app_info: utils::AppInfo,
}

#[query(guard = is_authenticated)]
fn get_canister_permissions() -> Vec<CanisterPermissionInfo> {
    let caller = caller();
    USER_CANISTER_PERMISSIONS.with_borrow(|permissions| {
        permissions
            .get(&caller)
            .map_or_else(Vec::new, |user_permissions| {
                user_permissions
                    .0
                    .iter()
                    .map(|(canister_id, permission)| CanisterPermissionInfo {
                        canister_id: *canister_id,
                        enabled: permission.enabled,
                        app_info: permission.app_info.clone(),
                    })
                    .collect()
            })
    })
}

#[update(guard = is_authenticated)]
async fn add_app_permission(app_id: String, mut app_info: utils::AppInfo) {
    app_info.canister_id = app_id.clone();
    let caller = caller();
    let canister_id = Principal::from_text(app_id.as_str()).unwrap();
    USER_CANISTER_PERMISSIONS.with_borrow_mut(|permissions| {
        if !permissions.contains_key(&caller) {
            permissions.insert(caller, utils::AppPermissionMap(HashMap::new()));
        }
        let mut user_permissions = permissions.get(&caller).unwrap();
        user_permissions.0.insert(
            canister_id,
            utils::CanisterPermission {
                app_info: app_info,
                enabled: true,
            },
        );
        permissions.insert(caller, user_permissions);
    });
}

#[update(guard = is_canister_owner)]
async fn send_test_message(title: String, body: String, owner: String) -> Result<(), String> {
    let owner_principal = Principal::from_text(owner.as_str()).unwrap();
    let tokens = USER_TOKENS.with_borrow(|user_tokens| user_tokens.get(&owner_principal));
    if tokens.is_none() {
        return Err("No tokens found".to_string());
    }
    let tokens = tokens.unwrap();

    for token in tokens.0 {
        if let utils::DeviceToken::OwnedToken(t) = token {
            let t = t.clone();

            let title = title.clone();
            let body = body.clone();
            let result = send_message(
                utils::NotifyMessage {
                    title,
                    body,
                    action_url: None,
                    icon_url: None,
                    data_type: None,
                },
                t,
                true,
            )
            .await;
            if let Err(e) = result {
                return Err(e);
            }
            ic_cdk::println!("Result: {:?}", result);

            if let Err(e) = result {
                ic_cdk::println!("Error sending message: {}", e);
            }
        }
    }

    Ok(())
}

#[update(guard = is_authenticated)]
async fn send_transfer_message(token_ledger_canister_id: String, height: u64) -> Result<(), String> {
    let token_ledger_canister_id = Principal::from_text(token_ledger_canister_id.as_str()).unwrap();
    let args = icrc_ledger_types::icrc3::blocks::GetBlocksRequest {
        start: height.into(),
        length: 1u32.into(),
    };
    let (get_block_result,) : (blocks::GetBlocksResult,) =
        ic_cdk::call(token_ledger_canister_id, "icrc3_get_blocks", (args,)).await.map_err(|e| e.1.to_string())?;
    

    let block_data = get_block_result.blocks.first().unwrap();

    if let ICRC3Value::Map(block) = &block_data.block {
        let (receiver, amt) =
            utils::verify_transfer_block(&block, Account::from(caller())).unwrap();

        let user_tokens = USER_TOKENS.with_borrow(|user_tokens| user_tokens.get(&receiver));

        if user_tokens.is_none() {
            return Err("User not found".to_string());
        }

        let AppSet(device_set) = user_tokens.unwrap();

        let mut tokens = Vec::new();

        for token in &device_set {
            if let utils::DeviceToken::OwnedToken(t) = token {
                tokens.push(t.clone());
            }

            if let utils::DeviceToken::DelegatedToken(owner) = token {
                let owner_tokens = USER_TOKENS.with_borrow(|user_tokens| user_tokens.get(&owner));

                if let Some(owner_tokens) = owner_tokens {
                    for owner_token in &owner_tokens.0 {
                        if let utils::DeviceToken::OwnedToken(t) = owner_token {
                            tokens.push(t.clone());
                        }
                    }
                }
            }
        }

        let metadata = utils::get_icrc1_metadata(token_ledger_canister_id)
            .await
            .unwrap();
        let token_symbol = if let Some(MetadataValue::Text(symbol)) = metadata.get("symbol") {
            symbol.clone()
        } else {
            token_ledger_canister_id.to_string()
        };

        let decimals: u8 = if let Some(MetadataValue::Nat(decimals)) = metadata.get("decimals") {
            u8::try_from(decimals.0.clone()).unwrap()
        } else {
            8
        };

        let title = format!("{} Deposit", token_symbol);
        let body = format!(
            "You received {} {}",
            utils::normalize_blockchain_amount(amt, decimals),
            token_symbol
        );

        for token in tokens {
            let result = send_message(
                utils::NotifyMessage {
                    title: title.clone(),
                    body: body.clone(),
                    action_url: None,
                    icon_url: None,
                    data_type: Some("deposit".to_string()),
                },
                token,
                true,
            )
            .await;
            if let Err(e) = result {
                ic_cdk::println!("Error sending message: {}", e);
            }
        }
    }

    Ok(())
}


#[update(guard = is_authenticated)]
async fn send_notification(message: utils::NotifyMessage, recipient: Principal) -> Result<(), String> {
    let caller = caller();
   
    if !is_canister_permitted(recipient, caller) {
        return Err("Not permitted to send notifications to this user".to_string());
    }

    let tokens = USER_TOKENS.with_borrow(|user_tokens| {
        user_tokens
            .get(&recipient)
            .map(|tokens| tokens.0.clone())
            .unwrap_or_default()
    });

    for token in &tokens {
        if let utils::DeviceToken::OwnedToken(t) = token {
            let result = send_message(message.clone(), t.to_string(), false).await;
            if let Err(e) = result {
                ic_cdk::println!("Error sending message: {}", e);
            }
        }

        if let utils::DeviceToken::DelegatedToken(owner) = &token {
            let owner_tokens = USER_TOKENS.with_borrow(|user_tokens| user_tokens.get(&owner));
            if let Some(owner_tokens) = owner_tokens {
                for owner_token in &owner_tokens.0 {
                    if let utils::DeviceToken::OwnedToken(t) = owner_token {
                        let result = send_message(message.clone(), t.to_string(), false).await;
                    }
                }
            }
        }
    }

    Ok(())
}

#[query]
async fn get_all_device_tokens() -> Vec<(String, Vec<String>)> {
    USER_TOKENS.with_borrow(|user_tokens| {
        user_tokens
            .iter()
            .map(|(user, tokens)| {
                (
                    user.to_string(),
                    tokens
                        .0
                        .iter()
                        .map(|token| match token {
                            utils::DeviceToken::OwnedToken(t) => t.clone(),
                            utils::DeviceToken::DelegatedToken(owner) => owner.to_string(),
                        })
                        .collect::<Vec<String>>(),
                )
            })
            .collect::<Vec<(String, Vec<String>)>>()
    })
}
// Helper function to check if a canister is permitted to send notifications to a user
fn is_canister_permitted(user: Principal, canister_id: Principal) -> bool {
    USER_CANISTER_PERMISSIONS.with_borrow(|permissions| {
        permissions
            .get(&user)
            .and_then(|user_permissions| user_permissions.0.get(&canister_id).cloned())
            .map_or(false, |permission| permission.enabled)
    })
}

// Authentication guard
fn is_authenticated() -> Result<(), String> {
    let caller = caller();
    if caller != Principal::anonymous() {
        Ok(())
    } else {
        Err("Unauthorized".to_string())
    }
}

fn is_canister_owner() -> Result<(), String> {
    let caller = caller();
    if is_controller(&caller) {
        Ok(())
    } else {
        Err("Unauthorized".to_string())
    }
}

#[query]
async fn http_transform(args: TransformArgs) -> HttpResponse {
    let response = args.response;

    // Return the response as is
    HttpResponse {
        status: response.status,
        headers: vec![],
        body: response.body,
    }
}

#[query]
#[candid::candid_method(query)]
fn export_candid() -> String {
    ic_cdk::export_candid!();
    __export_service()
}
