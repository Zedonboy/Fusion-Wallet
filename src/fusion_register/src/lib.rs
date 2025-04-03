use std::{cell::RefCell, collections::HashMap};

use candid::Principal;
use ic_cdk::query;


const ONCHAIN_WALLET_WASM : &[u8] = include_bytes!("../../bin/fusion_wallet.wasm");

thread_local! {
    static WALLET_ADDRESS: RefCell<HashMap<Principal, String>> = RefCell::new(HashMap::new());
}


#[ic_cdk::query(guard = not_anonymous)]
async fn get_wallet_address() -> Option<String> {
    let caller = ic_cdk::caller();
    WALLET_ADDRESS.with_borrow(|wallet_address| {
        wallet_address.get(&caller).cloned()
    })
}



fn not_anonymous() -> Result<(), String>     {
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










