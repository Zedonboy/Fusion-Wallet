use std::{borrow::Cow, collections::{BTreeMap, HashMap, HashSet}};

use candid::{CandidType, Decode, Principal};
use ic_stable_structures::{storable::Bound, Storable};
use icrc_ledger_types::{icrc::{generic_metadata_value::MetadataValue, generic_value::ICRC3Value}, icrc1::account::Account};
use serde::{Deserialize, Serialize};

/**
 * Copyright (C) 2025 Fusion Wallet
 * 
 * This file is part of Fusion Wallet.
 * 
 * Fusion Wallet is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Fusion Wallet is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Fusion Wallet.  If not, see <https://www.gnu.org/licenses/>.
 */

 #[derive(Debug, Serialize, Deserialize, Clone)]
 pub enum ProxyMethod {
     GET,
     POST,
 }
 // Request model that includes the idempotency key
 #[derive(Debug, Serialize, Deserialize, Clone)]
 pub struct ProxyRequest {
     pub idempotency_key: String,
     pub destination_url: String,
     pub method: ProxyMethod,
     pub headers: Vec<(String, String)>,
     pub body: Option<serde_json::Value>,
 }

 #[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
pub struct AppInfo {
    pub domain: Option<String>,
    pub name: Option<String>,
    pub icon_url: Option<String>,
    pub canister_id: String,
}

#[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
pub struct WalletDelegation {
    target: Vec<AppInfo>
}

#[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
pub enum WalletAlgorithm {
    Ed25519,
    Secp256k1,
}

#[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
pub struct SignedWalletDelegation {
    wallet_delegation: WalletDelegation,
    signature: Vec<u8>,
    public_key: Vec<u8>,
    algorithm: WalletAlgorithm,
}


 #[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
pub struct CanisterPermission {
    pub app_info: AppInfo,
    pub enabled: bool,
}

#[derive(Debug, Deserialize, Serialize, Default)]
pub struct AppPermissionMap(pub HashMap<Principal, CanisterPermission>);

impl Storable for AppPermissionMap {
    const BOUND: Bound = Bound::Unbounded;

    fn to_bytes(&self) -> std::borrow::Cow<[u8]> {
        let mut writer = Vec::new();
        ciborium::into_writer(&self.0, &mut writer).unwrap();
        Cow::Owned(writer)
    }

    fn from_bytes(bytes: std::borrow::Cow<[u8]>) -> Self {
        let map: HashMap<Principal, CanisterPermission> = ciborium::de::from_reader(bytes.as_ref()).unwrap();
        AppPermissionMap(map)
    }
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq, Hash)]
pub enum DeviceToken {
    OwnedToken(String),
    DelegatedToken(Principal),
}

impl Storable for DeviceToken {
    const BOUND: Bound = Bound::Unbounded;
    
    fn to_bytes(&self) -> std::borrow::Cow<[u8]> {
        let mut writer = Vec::new();
        ciborium::into_writer(self, &mut writer).unwrap();
        Cow::Owned(writer)
    }
    
    fn from_bytes(bytes: std::borrow::Cow<[u8]>) -> Self {
        ciborium::de::from_reader(bytes.as_ref()).unwrap()
    }
}

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct AppSet(pub HashSet<DeviceToken>);

#[derive(Debug, Default, Clone, CandidType, Deserialize, Serialize)]
 pub struct NotifyMessage{
    pub title: String,
    pub body: String,
    pub action_url: Option<String>,
    pub icon_url: Option<String>,
    pub data_type: Option<String>
 }

 impl Storable for AppSet {
    const BOUND: Bound = Bound::Unbounded;

    fn to_bytes(&self) -> std::borrow::Cow<[u8]> {
        let mut writer = Vec::new();
        ciborium::into_writer(&self.0, &mut writer).unwrap();
        Cow::Owned(writer)
    }

    fn from_bytes(bytes: std::borrow::Cow<[u8]>) -> Self {
        let set: HashSet<DeviceToken> = ciborium::de::from_reader(bytes.as_ref()).unwrap();
        AppSet(set)
    }
 }

// pub fn convert_icrc3_map_to_hashmap(icrc3_map: ICRC3Value) -> HashMap<String, icrc_ledger_types::icrc::generic_value::ICRC3Value> {
//     let mut hashmap = HashMap::new();
    
//     if let ICRC3Value::Map(map) = icrc3_map {
//         for (key, value) in map {
//             hashmap.insert(key, value);
//         }
//     }
    
//     hashmap
// }

pub fn verify_transfer_block(block_data: &BTreeMap<String, ICRC3Value>, from: Account) -> Result<(Principal, u64), String> {
    // Check if this is a transfer block by verifying btype or tx.op
    if let Some(ICRC3Value::Text(btype)) = block_data.get("btype") {
        if btype != "1xfer" && btype != "2xfer" {
            return Err(format!("Invalid btype: {}", btype));
        }
    }
    if let Some(ICRC3Value::Text(op)) = block_data.get("tx").and_then(|tx| {
        if let ICRC3Value::Map(tx_map) = tx {
            tx_map.get("op")
        } else {
            None
        }
    }) {
        if op != "xfer" {
            return Err("Not a transfer block".to_string());
        }
    } else {
        return Err("Not a transfer block".to_string());
    }

    // Get tx map
    if let Some(ICRC3Value::Map(tx_map)) = block_data.get("tx") {
        if !tx_map.contains_key("from") {
            return Err("Missing tx.from field".to_string());
        }
        if !tx_map.contains_key("to") {
            return Err("Missing tx.to field".to_string());
        }

        if let Some(ICRC3Value::Array(account_vec)) = tx_map.get("from") {
            if let Some(ICRC3Value::Blob(from_blob)) = account_vec.first() {
                let principal = Principal::from_slice(&from_blob.as_slice());
                let from_account = Account::from(principal);
                if from_account != from {
                    return Err("You are not the sender of this transfer".to_string());
                }
            }
        }

        let mut amt: u64 = 0;

        if let Some(ICRC3Value::Nat(amount)) = tx_map.get("amt") {
            amt = u64::try_from(amount.0.clone()).unwrap();
        }

        if let Some(ICRC3Value::Array(account_vec)) = tx_map.get("to") {    
            if let Some(ICRC3Value::Blob(to_blob)) = account_vec.first() {
                let principal = Principal::from_slice(&to_blob.as_slice());
                return Ok((principal, amt));
            }
        }
    }




    Err("Invalid transfer block".to_string())
}

pub async fn get_icrc1_metadata(canister_id: Principal) -> Result<HashMap<String, MetadataValue>, String> {
    let (result,) : (Vec<(String, MetadataValue)>,) = ic_cdk::call(canister_id, "icrc1_metadata", ()).await.map_err(|e| e.1.to_string())?;

    let mut metadata_map = HashMap::new();
    for (key, value) in result {
        metadata_map.insert(key, value);
    }

    Ok(metadata_map)
}

pub fn normalize_blockchain_amount(amount: u64, decimals: u8) -> String {
    let divisor = 10u64.pow(decimals as u32);
    let whole = amount / divisor;
    let fractional = amount % divisor;
    
    if fractional == 0 {
        whole.to_string()
    } else {
        format!("{}.{:0width$}", whole, fractional, width = decimals as usize)
    }
}



