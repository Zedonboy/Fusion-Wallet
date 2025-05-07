use crate::api::wallet::{IWallet, Wallet, WalletContext};

use super::wallet::generate_seed_phrase;

#[test]
fn test_address_generation() {
    let seed_phrase = generate_seed_phrase();
    assert!(seed_phrase.len() > 0, "Seed phrase is empty");

    let wc = Wallet::from_seed(seed_phrase).unwrap();
    
    // let app_result = wc.create_master_wallet();

    // assert!(app_result.is_ok());

    let master_wallet = wc;

    // let app_result = master_wallet.to_bitcoin_address();

    // assert!(app_result.is_ok(), "Error generating bitcoin address");
    // println!("Bitcoin address: {}", app_result.unwrap().to_lowercase());

    // let app_result = master_wallet.to_evm_address();
    // assert!(app_result.is_ok(), "Error generating Ethereum address");

    // println!("Ethereum address: {}", app_result.unwrap().to_lowercase());

    let app_result = master_wallet.to_icp_principal();
    assert!(app_result.is_ok(), "Error generating ICP address");

    println!("ICP address: {}", app_result.unwrap());

}