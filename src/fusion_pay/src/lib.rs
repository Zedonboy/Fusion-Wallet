use assets::PaymentLink;
use ic_cdk::{api::msg_caller, init, management_canister::raw_rand, post_upgrade, query, update};
use ic_http_certification::{HttpRequest, HttpResponse};
mod assets;


// Public methods
#[init]
fn init() {
    assets::init_template_engine();
    assets::certify_all_assets();
}

#[post_upgrade]
fn post_upgrade() {
    init();
}

#[query]
fn http_request(req: HttpRequest) -> HttpResponse {
    assets::asset_handler(&req)
}


#[update]
async fn create_payment_link(mut payment: PaymentLink) -> Result<String, String> {
    let caller = msg_caller();
    let rand_bytes = raw_rand().await.map_err(|op| op.to_string())?;
    let hex_str = hex::encode(&rand_bytes[..8]);
    let payment_id = format!("{}_{}", caller.to_text(), hex_str);
    payment.id = payment_id.clone();
    payment.created_at = ic_cdk::api::time();
    payment.recipient = caller.to_text();
    assets::add_payment_link(payment);
    Ok(payment_id)
}

#[query]
async fn get_payment_links() -> Vec<PaymentLink> {
    let caller = msg_caller();
    assets::get_payment_links(caller)
}

#[query]
#[candid::candid_method(query)]
fn export_candid() -> String {
    ic_cdk::export_candid!();
    __export_service()
}
