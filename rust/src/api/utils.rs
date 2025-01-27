use std::collections::HashMap;

use candid::{CandidType, Nat, Principal};
use icrc_ledger_types::icrc::generic_metadata_value::MetadataValue;
use k256::sha2::{self, Digest};
use serde::{Deserialize, Serialize};

#[derive(CandidType, Deserialize)]
pub struct TokenMetadata {
    pub(super) name: String,
    pub(super) symbol: String,
    pub(super) decimals: u8,
    pub(super) fee: Nat,
    pub(super) logo: Option<String>,
}

impl Default for TokenMetadata {
    fn default() -> Self {
        Self {
            decimals: 8,
            name: String::new(),
            symbol: String::new(),
            fee: Nat::from(0u64),
            logo: None
        }
    }
}

impl TokenMetadata {
    pub(super) fn from_metadata_records(records: Vec<(String, MetadataValue)>) -> Self {
        // use num_traits::cast::ToPrimitive;

        let mut metadata = TokenMetadata::default();
        
        for (k, v) in records {
           match k.as_str() {
            "icrc1:decimals" => {
                if let MetadataValue::Nat(nat) = v {
                    metadata.decimals = nat.0.try_into().unwrap_or(8);
                }
            }
            "icrc1:name" => {
                if let MetadataValue::Text(text) = v {
                    metadata.name = text;
                }
            }
            "icrc1:symbol" => {
                if let MetadataValue::Text(text) = v {
                    metadata.symbol = text;
                }
            }
            "icrc1:fee" => {
                if let MetadataValue::Nat(nat) = v {
                    metadata.fee = nat;
                }
            }
            "icrc1:logo" => {
                if let MetadataValue::Text(logo) = v {
                    metadata.logo = Some(logo);
                }
            }
            _ => {}
           }
        }

        metadata
    }
}

pub(super) fn format_amount(amount: &Nat, decimals: u8) -> String {
    let mut amount_str = amount.to_string();
    
    // Handle zero amount
    if amount == &Nat::from(0u8) {
        return "0".to_string();
    }

    // Add leading zeros if needed
    while amount_str.len() <= decimals as usize {
        amount_str.insert(0, '0');
    }
    
    // Insert decimal point
    let decimal_idx = amount_str.len() - decimals as usize;
    amount_str.insert(decimal_idx, '.');
    
    // Remove trailing zeros
    while amount_str.ends_with('0') && amount_str.contains('.') {
        amount_str.pop();
    }
    // Remove decimal if not needed
    if amount_str.ends_with('.') {
        amount_str.pop();
    }

    // If number starts with decimal, add leading zero
    if amount_str.starts_with('.') {
        amount_str.insert(0, '0');
    }
    
    amount_str
}

/// Subaccount is an arbitrary 32-byte byte array.
/// Ledger uses subaccounts to compute account address, which enables one
/// principal to control multiple ledger accounts.
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub(super) struct Subaccount(pub [u8; 32]);

impl From<Principal> for Subaccount {
    fn from(principal: Principal) -> Self {
        let mut subaccount = [0; 32];
        let principal = principal.as_slice();
        subaccount[0] = principal.len().try_into().unwrap();
        subaccount[1..1 + principal.len()].copy_from_slice(principal);
        Subaccount(subaccount)
    }
}

/// AccountIdentifier is a 32-byte array.
/// The first 4 bytes is a big-endian encoding of a CRC32 checksum of the last 28 bytes.
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub(super) struct AccountIdentifier([u8; 32]);

impl AccountIdentifier {
    /// Creates a new account identifier from a principal and subaccount.
    pub(super) fn new(owner: &Principal, subaccount: &Subaccount) -> Self {
        let mut hasher = sha2::Sha224::new();
        hasher.update(b"\x0Aaccount-id");
        hasher.update(owner.as_slice());
        hasher.update(&subaccount.0[..]);
        let hash: [u8; 28] = hasher.finalize().into();

        let mut hasher = crc32fast::Hasher::new();
        hasher.update(&hash);
        let crc32_bytes = hasher.finalize().to_be_bytes();

        let mut result = [0u8; 32];
        result[0..4].copy_from_slice(&crc32_bytes[..]);
        result[4..32].copy_from_slice(hash.as_ref());
        Self(result)
    }

    /// Convert AccountIdentifier into hex string.
    pub(super) fn to_hex(&self) -> String {
        hex::encode(self.0)
    }

}