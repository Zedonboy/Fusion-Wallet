use std::{
    borrow::BorrowMut,
    str::FromStr,
    sync::{Arc, Mutex, Once},
};

use anyhow::{bail, Error, Ok};
use bip32::{
    secp256k1::ecdsa::{SigningKey, VerifyingKey},
    ChildNumber, DerivationPath, ExtendedPrivateKey, ExtendedPublicKey, PrivateKey, XPrv,
};
use bip39::{Mnemonic, Seed};
use bitcoin::NetworkKind;
use candid::Principal;
use flutter_rust_bridge::frb;
use ic_agent::{identity::Secp256k1Identity, Identity};
use k256::{
    ecdsa::Signature,
    sha2::{Digest, Sha256},
    SecretKey,
};
use serde::{Deserialize, Serialize};

use super::{
    constants::IC_HOST_URL,
    utils::{AccountIdentifier, Subaccount},
    wallet_service::ICWalletService,
};
// use lazy_static::lazy_static;

// lazy_static! {
//     static ref CLIENT: Arc<reqwest::Client> = Arc::new(reqwest::Client::new());
// }

pub fn generate_seed_phrase() -> String {
    let mnenmomic = Mnemonic::new(bip39::MnemonicType::Words12, bip39::Language::English);
    mnenmomic.into_phrase()
}

#[derive(Serialize, Deserialize, Clone)]
pub enum WalletTokenNetWork {
    Bitcoin,
    // Ethereum,
    InternetComputer,
}

#[derive(Serialize, Deserialize)]
#[frb(opaque)]
pub struct WalletToken {
    pub symbol: String,
    pub network: WalletTokenNetWork,
    pub token_address: String,
    pub token_decimal: Option<u8>,
    pub image_url: Option<String>,
    pub token_name: String,
    pub index_canister: Option<String>,
    pub gov_canister: Option<String>, // governance canister.
    pub transfer_fee: u128,
}

impl WalletToken {
    #[flutter_rust_bridge::frb(sync)]
    pub fn to_string(&self) -> anyhow::Result<String> {
        let json = serde_json::to_string(self)?;
        Ok(json)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn from_string(data : &str) -> anyhow::Result<Self> {
        let value = serde_json::from_str(data)?;
        Ok(value)
    }
}


pub struct Wallet {
    key: ExtendedPrivateKey<SigningKey>,
    seed: Option<Seed>,
}

impl Wallet {
    #[flutter_rust_bridge::frb(sync)]
    pub fn from_seed(seed_phrase: String) -> anyhow::Result<Self> {
        let f = WalletContext::verify_mnemonic(&seed_phrase);
        if (!f) {
            bail!("Invalid Seed Phrase");
        }
        let mnemonic = Mnemonic::from_phrase(&seed_phrase, bip39::Language::English)?;
        let seed = Seed::new(&mnemonic, "");
        let root = XPrv::new(seed.clone())?;
        Ok(Self {
            seed: Some(seed),
            key: root,
        })
    }

    fn from_private_key(key: ExtendedPrivateKey<SigningKey>) -> Self {
        Wallet { key, seed: None }
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_bitcoin_address(&self) -> anyhow::Result<String> {
        let pk = self.key.public_key().to_bytes();
        let bpk = bitcoin::PublicKey::from_slice(&pk).unwrap();
        let b_addr = bitcoin::Address::p2pkh(bpk, NetworkKind::Main);

        Ok(b_addr.to_string())
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_icp_principal(&self) -> anyhow::Result<String> {
        let priv_key = self.key.private_key().to_bytes();
        let sk = SecretKey::from_bytes(&priv_key)?;
        let identity = Secp256k1Identity::from_private_key(sk);
        let user_principal = identity.sender().map_err(|mssg| Error::msg(mssg))?;
        Ok(user_principal.to_text())
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_account_identifier(&self) -> anyhow::Result<String> {
        let principal_str = self.to_icp_principal()?;
        let owner = Principal::from_text(principal_str)?;
        let account_id = AccountIdentifier::new(&owner, &Subaccount([0; 32]));
        Ok(account_id.to_hex())
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_ic_service(&self) -> anyhow::Result<ICWalletService> {
        let secret_key = SecretKey::from_bytes(&self.key.private_key().to_bytes())?;
        let identity = Secp256k1Identity::from_private_key(secret_key);
        let agent = ic_agent::Agent::builder()
            .with_url(IC_HOST_URL)
            .with_identity(identity)
            .build()?;
        let arc_agent = Arc::new(agent);
        let service = ICWalletService::new(arc_agent);
        Ok(service)
    }

    fn ascii_to_hardened_derivation_path(input: &str) -> anyhow::Result<DerivationPath> {
        let path_string = input
            .chars()
            .map(|c| format!("{}'", c as u32))
            .collect::<Vec<String>>()
            .join("/");

        let full_path = format!("m/{}", path_string);
        let derive_path = DerivationPath::from_str(&full_path)?;
        Ok(derive_path)
    }
}

pub trait IWalletService {
    #[flutter_rust_bridge::frb(sync)]
    fn sign_message(&self, message: &[u8]) -> anyhow::Result<Vec<u8>>;
    #[flutter_rust_bridge::frb(sync)]
    fn create_child_wallet(&self, path: &str) -> anyhow::Result<Wallet>;
}

impl IWalletService for Wallet {
    #[flutter_rust_bridge::frb(sync)]
    fn sign_message(&self, message: &[u8]) -> anyhow::Result<Vec<u8>> {
        use k256::ecdsa::signature::Signer;
        use k256::sha2::Digest;

        let k = self.key.private_key();

        // Hash the message first (common practice for ECDSA)
        let mut hasher = Sha256::new();
        hasher.update(message);
        let message_hash = hasher.finalize();

        let signature: Signature = k.sign(&message_hash);

        // Return the signature as bytes
        Ok(signature.to_vec())
    }

    #[flutter_rust_bridge::frb(sync)]
    fn create_child_wallet(&self, path: &str) -> anyhow::Result<Wallet> {
        // Parse the derivation path
        let derivation_path = Wallet::ascii_to_hardened_derivation_path(path)?;

        if self.seed.is_none() {
            return Err(Error::msg("This is not a master key"));
        }

        // Derive child key using the path
        let child_xprv = XPrv::derive_from_path(self.seed.as_ref().unwrap(), &derivation_path)?;

        let child_wallet = Wallet::from_private_key(child_xprv);

        Ok(child_wallet)
    }
}

pub struct WalletContext {
    pub seed_phrase: String,
}

impl WalletContext {
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_initial_supported_tokens() -> Vec<WalletToken> {
        vec![
            WalletToken {
                symbol: "ckBTC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "mxzaz-hqaaa-aaaar-qaada-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/ckbtc.png".to_string()),
                token_name: "ckBTC".to_string(),
                index_canister: Some("n5wcd-faaaa-aaaar-qaaea-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10,
            },
            WalletToken {
                symbol: "ICP".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "ryjl3-tyaaa-aaaaa-aaaba-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/icp.png".to_string()),
                token_name: "Internet Computer".to_string(),
                index_canister: None,
                transfer_fee: 10000,
                gov_canister: None
            },
            WalletToken {
                symbol: "ckETH".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "ss2fx-dyaaa-aaaar-qacoq-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/cketh.png".to_string()),
                token_name: "ckETH".to_string(),
                index_canister: Some("s3zol-vqaaa-aaaar-qacpa-cai".to_string()),
                gov_canister: None,
                transfer_fee: 2000000000000,
            },
            WalletToken {
                symbol: "ckUSDC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "xevnm-gaaaa-aaaar-qafnq-cai".to_string(),
                token_decimal: Some(6),
                image_url: Some("assets/images/ckusdc.png".to_string()),
                token_name: "ckUSDC".to_string(),
                index_canister: Some("xrs4b-hiaaa-aaaar-qafoa-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "ALICE".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "oj6if-riaaa-aaaaq-aaeha-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/alice.png".to_string()),
                token_name: "ALICE".to_string(),
                index_canister: Some("mtcaz-pyaaa-aaaaq-aaeia-cai".to_string()),
                gov_canister: Some("oa5dz-haaaa-aaaaq-aaegq-cai".to_string()),
                transfer_fee: 100000000,
            },
            WalletToken {
                symbol: "BOB".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "7pail-xaaaa-aaaas-aabmq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/bob.png".to_string()),
                token_name: "BOB".to_string(),
                index_canister: None,
                gov_canister: None,
                transfer_fee: 1000000,
            }
        ]
    }
    
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_all_supported_tokens() -> Vec<WalletToken> {
        vec![
            WalletToken {
                symbol: "ckBTC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "mxzaz-hqaaa-aaaar-qaada-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/ckbtc.png".to_string()),
                token_name: "ckBTC".to_string(),
                index_canister: Some("n5wcd-faaaa-aaaar-qaaea-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10,
            },
            WalletToken {
                symbol: "ckUSDT".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "cngnf-vqaaa-aaaar-qag4q-cai".to_string(),
                token_decimal: Some(6),
                image_url: Some("assets/images/ckusdt.png".to_string()),
                token_name: "ckUSDT".to_string(),
                index_canister: Some("cefgz-dyaaa-aaaar-qag5a-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "ckUSDC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "xevnm-gaaaa-aaaar-qafnq-cai".to_string(),
                token_decimal: Some(6),
                image_url: Some("assets/images/ckusdc.png".to_string()),
                token_name: "ckUSDC".to_string(),
                index_canister: Some("xrs4b-hiaaa-aaaar-qafoa-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "ckETH".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "ss2fx-dyaaa-aaaar-qacoq-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/cketh.png".to_string()),
                token_name: "ckETH".to_string(),
                index_canister: Some("s3zol-vqaaa-aaaar-qacpa-cai".to_string()),
                gov_canister: None,
                transfer_fee: 2000000000000,
            },
            WalletToken {
                symbol: "ckLINK".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "g4tto-rqaaa-aaaar-qageq-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/cklink.png".to_string()),
                token_name: "ckLINK".to_string(),
                index_canister: Some("gvqys-hyaaa-aaaar-qagfa-cai".to_string()),
                gov_canister: None,
                transfer_fee: 100000000000000,
            },
            WalletToken {
                symbol: "ckPEPE".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "etik7-oiaaa-aaaar-qagia-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/ckpepe.png".to_string()),
                token_name: "ckPEPE".to_string(),
                index_canister: Some("eujml-dqaaa-aaaar-qagiq-cai".to_string()),
                gov_canister: None,
                transfer_fee: 1000000000000000000000,
            },
            WalletToken {
                symbol: "ckOCT".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "ebo5g-cyaaa-aaaar-qagla-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/ckoct.png".to_string()),
                token_name: "ckOCT".to_string(),
                index_canister: Some("egp3s-paaaa-aaaar-qaglq-cai".to_string()),
                gov_canister: None,
                transfer_fee: 34000000000000000,
            },
            WalletToken {
                symbol: "ckEURC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "pe5t5-diaaa-aaaar-qahwa-cai".to_string(),
                token_decimal: Some(6),
                image_url: Some("assets/images/ckeurc.png".to_string()),
                token_name: "ckEURC".to_string(),
                index_canister: Some("pd4vj-oqaaa-aaaar-qahwq-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "ckXAUT".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "nza5v-qaaaa-aaaar-qahzq-cai".to_string(),
                token_decimal: Some(6),
                image_url: Some("assets/images/ckxaut.png".to_string()),
                token_name: "ckXAUT".to_string(),
                index_canister: Some("nmhmy-riaaa-aaaar-qah2a-cai".to_string()),
                gov_canister: None,
                transfer_fee: 1,
            },
            WalletToken {
                symbol: "ckWSTETH".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "j2tuh-yqaaa-aaaar-qahcq-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/ckwsteth.png".to_string()),
                token_name: "ckWSTETH".to_string(),
                index_canister: Some("jtq73-oyaaa-aaaar-qahda-cai".to_string()),
                gov_canister: None,
                transfer_fee: 1000000000000,
            },
            WalletToken {
                symbol: "ckSHIB".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "fxffn-xiaaa-aaaar-qagoa-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/ckshib.png".to_string()),
                token_name: "ckSHIB".to_string(),
                index_canister: Some("fqedz-2qaaa-aaaar-qagoq-cai".to_string()),
                gov_canister: None,
                transfer_fee: 100000000000000000000,
            },
            WalletToken {
                symbol: "ckUNI".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "ilzky-ayaaa-aaaar-qahha-cai".to_string(),
                token_decimal: Some(18),
                image_url: Some("assets/images/ckuni.png".to_string()),
                token_name: "ckUNI".to_string(),
                index_canister: Some("imymm-naaaa-aaaar-qahhq-cai".to_string()),
                gov_canister: None,
                transfer_fee: 1000000000000000,
            },
            WalletToken {
                symbol: "ckWBTC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "bptq2-faaaa-aaaar-qagxq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/ckwbtc.png".to_string()),
                token_name: "ckWBTC".to_string(),
                index_canister: Some("dso6s-wiaaa-aaaar-qagya-cai".to_string()),
                gov_canister: None,
                transfer_fee: 10,
            },
            WalletToken {
                symbol: "ALICE".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "oj6if-riaaa-aaaaq-aaeha-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/alice.png".to_string()),
                token_name: "ALICE".to_string(),
                index_canister: Some("mtcaz-pyaaa-aaaaq-aaeia-cai".to_string()),
                gov_canister: Some("oa5dz-haaaa-aaaaq-aaegq-cai".to_string()),
                transfer_fee: 100000000,
            },
            WalletToken {
                symbol: "BOOM".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "vtrom-gqaaa-aaaaq-aabia-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/boom.png".to_string()),
                token_name: "BoomDAO".to_string(),
                index_canister: Some("v5tde-5aaaa-aaaaq-aabja-cai".to_string()),
                gov_canister: Some("xomae-vyaaa-aaaaq-aabhq-cai".to_string()),
                transfer_fee: 100000,
            },

            WalletToken {
                symbol: "CTZ".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "uf2wh-taaaa-aaaaq-aabna-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/catalyze.png".to_string()),
                token_name: "CatalyzeDAO".to_string(),
                index_canister: Some("ux4b6-7qaaa-aaaaq-aaboa-cai".to_string()),
                gov_canister: Some("umz53-fiaaa-aaaaq-aabmq-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "DCD".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "xsi2v-cyaaa-aaaaq-aabfq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/dcd.png".to_string()),
                token_name: "DecideAI".to_string(),
                index_canister: Some("xaonm-oiaaa-aaaaq-aabgq-cai".to_string()),
                gov_canister: Some("xvj4b-paaaa-aaaaq-aabfa-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "DOGMI".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "np5km-uyaaa-aaaaq-aadrq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/dogmi.png".to_string()),
                token_name: "DOGMI".to_string(),
                index_canister: Some("n535v-yiaaa-aaaaq-aadsq-cai".to_string()),
                gov_canister: Some("ni4my-zaaaa-aaaaq-aadra-cai".to_string()),
                transfer_fee: 5000000000,
            },
            WalletToken {
                symbol: "DKP".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "zfcdd-tqaaa-aaaaq-aaaga-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/dkp.png".to_string()),
                token_name: "Draggin Karma Points".to_string(),
                index_canister: Some("zlaol-iaaaa-aaaaq-aaaha-cai".to_string()),
                gov_canister: Some("zqfso-syaaa-aaaaq-aaafq-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "ELNA".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "gemj7-oyaaa-aaaaq-aacnq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/elna.png".to_string()),
                token_name: "ELNA".to_string(),
                index_canister: Some("gwk6g-ciaaa-aaaaq-aacoq-cai".to_string()),
                gov_canister: Some("gdnpl-daaaa-aaaaq-aacna-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "EST".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "bliq2-niaaa-aaaaq-aac4q-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/estate.png".to_string()),
                token_name: "ESTATE".to_string(),
                index_canister: Some("bfk5s-wyaaa-aaaaq-aac5q-cai".to_string()),
                gov_canister: Some("bmjwo-aqaaa-aaaaq-aac4a-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "WELL".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "o4zzi-qaaaa-aaaaq-aaeeq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/well.png".to_string()),
                token_name: "FomoWell".to_string(),
                index_canister: Some("os3ua-lqaaa-aaaaq-aaefq-cai".to_string()),
                gov_canister: Some("o3y74-5yaaa-aaaaq-aaeea-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "GOLDAO".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "tyyy3-4aaaa-aaaaq-aab7a-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/golddao.png".to_string()),
                token_name: "GOLDAO".to_string(),
                index_canister: Some("efv5g-kqaaa-aaaaq-aacaa-cai".to_string()),
                gov_canister: Some("tr3th-kiaaa-aaaaq-aab6q-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "GHOST".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "4c4fd-caaaa-aaaaq-aaa3a-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/icghost.png".to_string()),
                token_name: "GHOST".to_string(),
                index_canister: Some("5ithz-aqaaa-aaaaq-aaa4a-cai".to_string()),
                gov_canister: Some("4l7o7-uiaaa-aaaaq-aaa2q-cai".to_string()),
                transfer_fee: 100000000,
            },
            WalletToken {
                symbol: "ICL".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "hhaaz-2aaaa-aaaaq-aacla-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/light.png".to_string()),
                token_name: "ICLighthouse DAO".to_string(),
                index_canister: Some("gnpcd-yqaaa-aaaaq-aacma-cai".to_string()),
                gov_canister: Some("hodlf-miaaa-aaaaq-aackq-cai".to_string()),
                transfer_fee: 1000000,
            },
            WalletToken {
                symbol: "PANDA".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "druyg-tyaaa-aaaaq-aactq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/panda.png".to_string()),
                token_name: "ICPanda".to_string(),
                index_canister: Some("c3324-riaaa-aaaaq-aacuq-cai".to_string()),
                gov_canister: Some("dwv6s-6aaaa-aaaaq-aacta-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "CONF".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "lrtnw-paaaa-aaaaq-aadfa-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/iccpp.png".to_string()),
                token_name: "ICPCC DAO LLC".to_string(),
                index_canister: Some("ldv2p-dqaaa-aaaaq-aadga-cai".to_string()),
                gov_canister: Some("lyqgk-ziaaa-aaaaq-aadeq-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "ICS".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "ca6gz-lqaaa-aaaaq-aacwa-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/icswap.png".to_string()),
                token_name: "ICPSwap Token".to_string(),
                index_canister: Some("co4lr-qaaaa-aaaaq-aacxa-cai".to_string()),
                gov_canister: Some("cvzxu-kyaaa-aaaaq-aacvq-cai".to_string()),
                transfer_fee: 1000000,
            },
            WalletToken {
                symbol: "ICVC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "m6xut-mqaaa-aaaaq-aadua-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/icvc.png".to_string()),
                token_name: "ICVC".to_string(),
                index_canister: Some("mqvz3-xaaaa-aaaaq-aadva-cai".to_string()),
                gov_canister: Some("ntzq5-dyaaa-aaaaq-aadtq-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "KINIC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "73mez-iiaaa-aaaaq-aaasq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/kinic.png".to_string()),
                token_name: "KINIC".to_string(),
                index_canister: Some("7vojr-tyaaa-aaaaq-aaatq-cai".to_string()),
                gov_canister: Some("74ncn-fqaaa-aaaaq-aaasa-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "KONG".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "o7oak-iyaaa-aaaaq-aadzq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/kongswap.png".to_string()),
                token_name: "KongSwap".to_string(),
                index_canister: Some("onixt-eiaaa-aaaaq-aad2q-cai".to_string()),
                gov_canister: Some("oypg6-faaaa-aaaaq-aadza-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "MOTOKO".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "k45jy-aiaaa-aaaaq-aadcq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/motoko.png".to_string()),
                token_name: "Motoko".to_string(),
                index_canister: Some("ks7eq-3yaaa-aaaaq-aaddq-cai".to_string()),
                gov_canister: Some("k34pm-nqaaa-aaaaq-aadca-cai".to_string()),
                transfer_fee: 100000000,
            },
            WalletToken {
                symbol: "NTN".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "f54if-eqaaa-aaaaq-aacea-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/neutrinite.png".to_string()),
                token_name: "Neutrinite".to_string(),
                index_canister: Some("ft6fn-7aaaa-aaaaq-aacfa-cai".to_string()),
                gov_canister: Some("eqsml-lyaaa-aaaaq-aacdq-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "NFIDW".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "mih44-vaaaa-aaaaq-aaekq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/nfid.png".to_string()),
                token_name: "NFID Wallet".to_string(),
                index_canister: Some("mgfru-oqaaa-aaaaq-aaelq-cai".to_string()),
                gov_canister: Some("mpg2i-yyaaa-aaaaq-aaeka-cai".to_string()),
                transfer_fee: 10000,
            },
            WalletToken {
                symbol: "NUA".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "rxdbk-dyaaa-aaaaq-aabtq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/nuance.png".to_string()),
                token_name: "Nuance".to_string(),
                index_canister: Some("q5mdq-biaaa-aaaaq-aabuq-cai".to_string()),
                gov_canister: Some("rqch6-oaaaa-aaaaq-aabta-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "CHAT".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "2ouva-viaaa-aaaaq-aaamq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/chat.png".to_string()),
                token_name: "CHAT".to_string(),
                index_canister: Some("2awyi-oyaaa-aaaaq-aaanq-cai".to_string()),
                gov_canister: Some("2jvtu-yqaaa-aaaaq-aaama-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "OGY".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "lkwrt-vyaaa-aaaaq-aadhq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/origyn.png".to_string()),
                token_name: "ORIGYN".to_string(),
                index_canister: Some("jqkzp-liaaa-aaaaq-aadiq-cai".to_string()),
                gov_canister: Some("lnxxh-yaaaa-aaaaq-aadha-cai".to_string()),
                transfer_fee: 200000,
            },
            WalletToken {
                symbol: "SEER".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "rffwt-piaaa-aaaaq-aabqq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/seer.png".to_string()),
                token_name: "Seers".to_string(),
                index_canister: Some("rlh33-uyaaa-aaaaq-aabrq-cai".to_string()),
                gov_canister: Some("rceqh-cqaaa-aaaaq-aabqa-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "SNEED".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "hvgxa-wqaaa-aaaaq-aacia-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/sneed.png".to_string()),
                token_name: "Sneed DAO".to_string(),
                index_canister: Some("h3e2i-naaaa-aaaaq-aacja-cai".to_string()),
                gov_canister: Some("fi3zi-fyaaa-aaaaq-aachq-cai".to_string()),
                transfer_fee: 1000,
            },
            WalletToken {
                symbol: "SONIC".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "qbizb-wiaaa-aaaaq-aabwq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/sonic.png".to_string()),
                token_name: "Sonic".to_string(),
                index_canister: Some("qpkuj-nyaaa-aaaaq-aabxq-cai".to_string()),
                gov_canister: Some("qgj7v-3qaaa-aaaaq-aabwa-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "TRAX".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "emww2-4yaaa-aaaaq-aacbq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/trax.png".to_string()),
                token_name: "TRAX".to_string(),
                index_canister: Some("e6qbd-qiaaa-aaaaq-aaccq-cai".to_string()),
                gov_canister: Some("elxqo-raaaa-aaaaq-aacba-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "WTN".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "jcmow-hyaaa-aaaaq-aadlq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/waterneuron.png".to_string()),
                token_name: "WaterNeuron".to_string(),
                index_canister: Some("iidmm-fiaaa-aaaaq-aadmq-cai".to_string()),
                gov_canister: Some("jfnic-kaaaa-aaaaq-aadla-cai".to_string()),
                transfer_fee: 1000000
            },
            WalletToken {
                symbol: "DOLR".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "6rdgd-kyaaa-aaaaq-aaavq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/yral.png".to_string()),
                token_name: "YRAL".to_string(),
                index_canister: Some("6dfr2-giaaa-aaaaq-aaawq-cai".to_string()),
                gov_canister: Some("6wcax-haaaa-aaaaq-aaava-cai".to_string()),
                transfer_fee: 100000,
            },
            WalletToken {
                symbol: "YUKU".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "atbfz-diaaa-aaaaq-aacyq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/yuku.png".to_string()),
                token_name: "Yuku AI".to_string(),
                index_canister: Some("a5dir-yyaaa-aaaaq-aaczq-cai".to_string()),
                gov_canister: Some("auadn-oqaaa-aaaaq-aacya-cai".to_string()),
                transfer_fee: 1000000,
            },
            WalletToken {
                symbol: "CLOUD".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "pcj6u-uaaaa-aaaak-aewnq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/cloud.png".to_string()),
                token_name: "Crypto Cloud".to_string(),
                index_canister: None,
                gov_canister: None,
                transfer_fee: 100000000,
            },
            WalletToken {
                symbol: "BOB".to_string(),
                network: WalletTokenNetWork::InternetComputer,
                token_address: "7pail-xaaaa-aaaas-aabmq-cai".to_string(),
                token_decimal: Some(8),
                image_url: Some("assets/images/bob.png".to_string()),
                token_name: "BOB".to_string(),
                index_canister: None,
                gov_canister: None,
                transfer_fee: 1000000,
            }
            // Add more WalletToken instances as needed
        ]
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn hash_data(data: String) -> String {
        let mut hasher = k256::sha2::Sha256::new();
        hasher.update(data);
        let result = hasher.finalize();
        hex::encode(result)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn verify_mnemonic(mnemonic: &str) -> bool {
        let result = Mnemonic::validate(mnemonic, bip39::Language::English);
        result.is_ok()
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn verify_principal(text: &str) -> bool {
        let result = Principal::from_text(text);
        result.is_ok()
    }
}
