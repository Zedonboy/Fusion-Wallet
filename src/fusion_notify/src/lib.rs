use std::collections::{HashMap, HashSet};
use std::cell::RefCell;

use candid::Principal;
use ic_cdk::{api::msg_caller, update};

thread_local! {
    static PUSH_URLS: RefCell<HashMap<Principal, HashSet<String>>> = RefCell::new(HashMap::new());
}

#[update(guard = is_authenticated)]
async fn add_push_url(url: String) {
    let caller = msg_caller();
    PUSH_URLS.with_borrow_mut(|push_urls| {
        push_urls.entry(caller).or_insert_with(HashSet::new).insert(url);
    });
}

fn is_authenticated() -> Result<(), String> {
    let caller = msg_caller();
    if caller != Principal::anonymous() {
        Ok(())
    } else {
        Err("Unauthorized".to_string())
    }
}