use assets::{PaymentLink, PaymentLinkRequest};
use ic_cdk::{ api::management_canister::main::raw_rand, caller, init, post_upgrade, query, update};
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
async fn create_payment_link(link: PaymentLinkRequest) -> Result<String, String> {
    let caller = caller();
    let (rand_bytes,) = raw_rand().await.map_err(|op| op.1.to_string())?;
    let hex_str = hex::encode(&rand_bytes[..8]);
    // TODO get token data
    let token_symbol: String = String::default();
    let qr_data = format!("fusion://app.fusionwallet.me/send-screen?amount={}&token={}&recipient={}&memo={}", link.amount, link.token_address, caller.to_text(), link.memo);
    let mut payment = PaymentLink::default();
    let payment_id = format!("{}_{}", caller.to_text(), hex_str);
    payment.id = payment_id.clone();
    payment.created_at = ic_cdk::api::time();
    payment.recipient = caller.to_text();
    payment.qr_data = qr_data;
    payment.token_symbol = token_symbol;
    assets::add_payment_link(payment);
    Ok(payment_id)
}

#[query]
async fn get_payment_links() -> Vec<PaymentLink> {
    let caller = caller();
    assets::get_payment_links(caller)
}

#[query]
#[candid::candid_method(query)]
fn export_candid() -> String {
    ic_cdk::export_candid!();
    __export_service()
}
