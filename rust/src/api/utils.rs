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

    let value: u128 = amount.0.clone().try_into().unwrap();
    if decimals == 0 {
        return value.to_string();
    }

    let divisor = 10u128.pow(decimals as u32);
    let integer_part = value / divisor;
    let fractional_part = value % divisor;

    // If fractional part is 0, return just the integer part
    if fractional_part == 0 {
        return integer_part.to_string();
    }

    // Convert fractional part to string and pad with leading zeros if necessary
    let mut fractional_str = fractional_part.to_string();
    let padding_needed = decimals as usize - fractional_str.len();
    
    if padding_needed > 0 {
        fractional_str = "0".repeat(padding_needed) + &fractional_str;
    }

    // Trim trailing zeros
    while fractional_str.ends_with('0') {
        fractional_str.pop();
    }

    if fractional_str.is_empty() {
        integer_part.to_string()
    } else {
        format!("{}.{}", integer_part, fractional_str)
    }
}