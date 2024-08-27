use std::str::FromStr;

use alloy::{
    contract::{ContractInstance, Interface}, dyn_abi::DynSolValue, primitives::{utils::{format_ether, format_units}, Address, U256}, providers::{network::Ethereum, Provider, ProviderBuilder}, transports::http::{Client, Http}
};
use bip32::{
    secp256k1::ecdsa::{SigningKey, VerifyingKey},
    DerivationPath, ExtendedPrivateKey, ExtendedPublicKey, XPrv,
};
use bip39::{Mnemonic, Seed};
use bitcoin_hashes::{hash160, Hash};
use flutter_rust_bridge::frb;
use ic_agent::export::Principal;
use k256::{elliptic_curve::sec1::ToEncodedPoint, PublicKey};
use serde_json::Value;
use tiny_keccak::{Hasher, Keccak};
use std::ops::{Div};

pub fn generate_seed_phrase() -> String {
    let mnenmomic = Mnemonic::new(bip39::MnemonicType::Words12, bip39::Language::English);
    mnenmomic.into_phrase()
}

pub enum WalletTokenNetWork {
    Bitcoin,
    Ethereum,
    InternetComputer,
}

#[frb(opaque)]
pub struct WalletToken {
    pub symbol: String,
    pub network: WalletTokenNetWork,
    pub token_address: Option<String>,
    pub user_address: String,
    pub balance: f64,
    pub usd_worth : f64
}

impl WalletToken {
    async fn fetch_balance(&self) -> Result<f64, String> {
        let balance = match self.network {
            WalletTokenNetWork::Bitcoin => 0.0,
            WalletTokenNetWork::Ethereum => WalletToken::get_eth_balance(&self).await?,
            WalletTokenNetWork::InternetComputer => 0.0,
        };

        Ok(balance)
    }

    pub async fn update_balance_and_worth(&mut self) -> Result<(), String> {
        let bal = self.fetch_balance().await?;
        self.balance = bal;

        let url = format!("https://api.coinbase.com/v2/prices/{}-usd/spot", self.symbol);
        let json_string = reqwest::get(&url).await.map_err(|err| err.to_string())?.text().await.map_err(|err| err.to_string())?;
        let coinbase_json : Value = serde_json::from_str(&json_string).map_err(|err| err.to_string())?;
        let data_value = coinbase_json.get("data");
        if data_value.is_none() {
            // error
            return Err("Coinbase api return err".to_string());
        }

        let usd_value = data_value.unwrap().get("amount").ok_or("counld not found amount".to_string())?;
        if usd_value.is_number() {
            let usd_price = usd_value.as_f64().ok_or("Number is not floating point".to_string())?;
            let worth = usd_price * bal;
            self.usd_worth = worth;
        }
        Ok(())
    }

    async fn get_eth_balance(token: &WalletToken) -> Result<f64, String> {
        let rpc_url = "https://eth.merkle.io".parse().unwrap();

        // Create a provider with the HTTP transport using the `reqwest` crate.
        let provider = ProviderBuilder::new().on_http(rpc_url);
        let address = Address::from_str(&token.user_address).map_err(|err| err.to_string())?;
        if token.token_address.is_none() {
            // native token
            let balance = provider.get_balance(address).await.map_err(|err| err.to_string())?;
            let base = U256::from(10).pow(U256::from(18));
            let human_balance = balance.div(base);
            let ether_bal = format_units(human_balance, "eth").map_err(|err| err.to_string())?;
            let h_bal_f64 = ether_bal.parse::<f64>().map_err(|err| err.to_string())?;
            return Ok(h_bal_f64);
        } else {

            let contract_addr = Address::from_str(token.token_address.as_ref().unwrap().clone().as_str()).map_err(|err| err.to_string())?;
            let erc_20_json_abi = include_str!("../../abi/erc20.json");
            let abi = serde_json::from_str(erc_20_json_abi).map_err(|err| err.to_string())?;
            let contract: ContractInstance<Http<Client>, _, Ethereum> = ContractInstance::new(contract_addr, provider, Interface::new(abi));
            let balance_call_result = contract.function("balanceOf", &[DynSolValue::Address(address)]).map_err(|err| err.to_string())?.call().await.map_err(|err| err.to_string())?;
            let decimal_call_result = contract.function("decimals", &[]).map_err(|err| err.to_string())?.call().await.map_err(|err| err.to_string())?;
            let balance =   balance_call_result.first().ok_or("Error getting Balance result first value".to_string())?.as_uint().ok_or("Erro DynSol to Uint".to_string())?.0;
            let decimal =   decimal_call_result.first().ok_or("Error getting Decimal result first value".to_string())?.as_uint().ok_or("Erro DynSol to Uint".to_string())?.0;

            let base = U256::from(10).pow(decimal);
            let human_balance = balance.div(base);
            let token_bal_str = format_ether(human_balance);

            let h_bal_f64 = token_bal_str.parse::<f64>().map_err(|err| err.to_string())?;
            return Ok(h_bal_f64);

        }
    }
}

fn ascii_to_hardened_derivation_path(input: &str) -> Result<DerivationPath, String> {
    let path_string = input
        .chars()
        .map(|c| format!("{}'", c as u32))
        .collect::<Vec<String>>()
        .join("/");

    let full_path = format!("m/{}", path_string);
    DerivationPath::from_str(&full_path).map_err(|err| err.to_string())
}

pub struct Wallet {
    key: ExtendedPrivateKey<SigningKey>,
}

impl Wallet {
    #[flutter_rust_bridge::frb(sync)]
    pub fn from_seed(seed: Seed) -> Result<Self, String> {
        let root = XPrv::new(seed).map_err(|err| err.to_string())?;
        Ok(Self { key: root })
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn to_bitcoin_address(&self) -> Result<String, String> {
        // Extract the compressed public key bytes
        let pub_key_bytes = self.key.public_key().to_bytes();

        // Perform RIPEMD160(SHA256(public_key))
        let hash160 = hash160::Hash::hash(&pub_key_bytes);

        // Add version byte (0x00 for mainnet)
        let mut address_bytes = vec![0x00];
        address_bytes.extend_from_slice(&hash160.to_byte_array());

        // Perform double SHA256 for checksum
        let checksum = bitcoin_hashes::sha256::Hash::hash(
            &bitcoin_hashes::sha256::Hash::hash(&address_bytes).to_byte_array(),
        );
        address_bytes.extend_from_slice(&checksum[..4]);

        // Encode with Base58
        Ok(bs58::encode(address_bytes).into_string())
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn to_ethereum_address(&self) -> Result<String, String> {
        // Step 1: Parse the compressed public key
        let public_key = PublicKey::from_sec1_bytes(self.key.public_key().to_bytes().as_ref())
            .map_err(|err| err.to_string())?;

        // Step 2: Get the uncompressed public key
        let uncompressed = public_key.to_encoded_point(false);
        let public_key_bytes = &uncompressed.as_bytes()[1..]; // Skip the 0x04 prefix

        // Step 3: Compute Keccak-256 hash
        let mut hasher = Keccak::v256();
        hasher.update(public_key_bytes);
        let mut hash = [0u8; 32];
        hasher.finalize(&mut hash);

        // Step 4: Take the last 20 bytes
        let address_bytes = &hash[12..];

        // Step 5: Convert to checksum address
        Ok(Wallet::to_checksum_address(address_bytes))
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_icp_principal(&self) -> Result<String, String> {
        let der_key = Wallet::pubkey_to_der_encoded(self.key.public_key().to_bytes().as_ref())?;
        let user_principal = Principal::self_authenticating(der_key);
        Ok(user_principal.to_text())
    }

    fn to_checksum_address(address: &[u8]) -> String {
        let address_hex = hex::encode(address);
        let mut hasher = Keccak::v256();
        let mut hash = [0u8; 32];
        hasher.update(address_hex.as_bytes());
        hasher.finalize(&mut hash);

        let mut checksum_address = String::from("0x");
        for (i, ch) in address_hex.chars().enumerate() {
            let n = u8::from_str_radix(&hash[i / 2].to_string(), 16).unwrap();
            if n > 7 {
                checksum_address.push(ch.to_ascii_uppercase());
            } else {
                checksum_address.push(ch.to_ascii_lowercase());
            }
        }
        checksum_address
    }

    fn pubkey_to_der_encoded(compressed_key: &[u8]) -> Result<Vec<u8>, String> {
        // Parse the compressed public key
        let public_key =
            PublicKey::from_sec1_bytes(compressed_key).map_err(|err| err.to_string())?;

        // Get the uncompressed public key bytes
        let uncompressed = public_key.to_encoded_point(false);
        let pk_bytes = uncompressed.as_bytes();

        // OIDs
        let ec_public_key_oid = [0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01];
        let secp256k1_oid = [0x06, 0x05, 0x2B, 0x81, 0x04, 0x00, 0x0A];

        // Construct DER encoding
        let mut der = Vec::new();
        der.extend_from_slice(&[0x30]); // Outer SEQUENCE
        der.push(0x00); // Length placeholder

        // Algorithm Identifier SEQUENCE
        der.extend_from_slice(&[0x30]);
        der.push((ec_public_key_oid.len() + secp256k1_oid.len()) as u8);
        der.extend_from_slice(&ec_public_key_oid);
        der.extend_from_slice(&secp256k1_oid);

        // Public Key BIT STRING
        der.extend_from_slice(&[0x03]);
        der.push((pk_bytes.len() + 1) as u8);
        der.push(0x00); // No unused bits
        der.extend_from_slice(pk_bytes);

        // Fix outer SEQUENCE length
        der[1] = (der.len() - 2) as u8;

        Ok(der)
    }
}

pub struct WalletContext {
    seed: Seed,
}

impl WalletContext {
    #[flutter_rust_bridge::frb(sync)]
    pub fn from_seed_phrase(phrase: String) -> Result<Self, String> {
        let mnemonic = Mnemonic::from_phrase(&phrase, bip39::Language::English)
            .map_err(|err| err.to_string())?;

        let seed = Seed::new(&mnemonic, "");

        Ok(WalletContext { seed })
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn derive_from_domain(&self, domain: String) -> Result<Wallet, String> {
        let d_p = ascii_to_hardened_derivation_path(&domain)?;
        let child_wallet =
            XPrv::derive_from_path(&self.seed, &d_p).map_err(|err| err.to_string())?;
        // let pk = child_wallet.public_key();
        Ok(Wallet { key: child_wallet })
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn get_initial_supported_tokens(&self) -> Vec<WalletToken> {
        let master_wallet =
            Wallet::from_seed(self.seed.clone()).expect("Root Wallet seed is invalid");
        let btc_addr = master_wallet
            .to_bitcoin_address()
            .expect("Bitcoin address gen failed");
        let eth_addr = master_wallet
            .to_ethereum_address()
            .expect("Ethereum address gen failed");
        let icp_principal = master_wallet
            .to_icp_principal()
            .expect("ICP Principal failed");
        vec![
            WalletToken {
                symbol: "BTC".to_string(),
                network: WalletTokenNetWork::Bitcoin,
                token_address: None,
                user_address: btc_addr,
                balance: 0
            },
            WalletToken {
                symbol: "ETH".to_string(),
                network: WalletTokenNetWork::Ethereum,
                token_address: None,
                user_address: eth_addr,
                balance: 0,
            },
            WalletToken {
                symbol: "ICP".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: None,
                user_address: icp_principal,
                balance: 0,
            },
        ]
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_master_wallet(&self) -> Result<Wallet, String> {
        Wallet::from_seed(self.seed.clone())
    }
}
