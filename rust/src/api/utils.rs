use core::fmt;
use std::{collections::HashMap, fmt::{Display, Formatter}, ops::{Add, AddAssign, Sub, SubAssign}};

use candid::{CandidType, Nat, Principal};
use flutter_rust_bridge::frb;
use icrc_ledger_types::icrc::generic_metadata_value::MetadataValue;
use k256::sha2::{self, Digest};
use serde::{Deserialize, Serialize};

pub const DEFAULT_FEE: Tokens = Tokens { e8s: 10_000 };
/// The sequence number of a block in the Tokens ledger blockchain.
pub type BlockIndex = u64;


#[frb(ignore)]
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
    #[frb(ignore)]
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

#[frb(ignore)]
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

/// Subaccount is an arbitrary 32-byte byte array.
/// Ledger uses subaccounts to compute account address, which enables one
/// principal to control multiple ledger accounts.
#[frb(ignore)]
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub struct Subaccount(pub(super) [u8; 32]);

impl Subaccount {
    pub fn empty() -> Self {
        Self([0; 32])
    }
}

impl From<Principal> for Subaccount {
    #[frb(ignore)]
    fn from(principal: Principal) -> Self {
        let mut subaccount = [0; 32];
        let principal = principal.as_slice();
        subaccount[0] = principal.len().try_into().unwrap();
        subaccount[1..1 + principal.len()].copy_from_slice(principal);
        Subaccount(subaccount)
    }
}

/// An error for reporting invalid checksums.
#[derive(Debug, PartialEq, Eq)]
pub(super) struct ChecksumError {
    input: [u8; 32],
    expected_checksum: [u8; 4],
    found_checksum: [u8; 4],
}

impl Display for ChecksumError {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "Checksum failed for {}, expected check bytes {} but found {}",
            hex::encode(&self.input[..]),
            hex::encode(self.expected_checksum),
            hex::encode(self.found_checksum),
        )
    }
}

/// An error for reporting invalid Account Identifiers.
#[derive(Debug, PartialEq, Eq)]
pub(super) enum AccountIdParseError {
    /// The checksum failed to verify.
    InvalidChecksum(ChecksumError),
    /// The length of the input was invalid.
    InvalidLength(Vec<u8>),
}

impl Display for AccountIdParseError {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidChecksum(err) => write!(f, "{}", err),
            Self::InvalidLength(input) => write!(
                f,
                "Received an invalid AccountIdentifier with length {} bytes instead of the expected 28 or 32.",
                input.len()
            ),
        }
    }
}


/// AccountIdentifier is a 32-byte array.
/// The first 4 bytes is a big-endian encoding of a CRC32 checksum of the last 28 bytes.
#[frb(ignore)]
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub struct AccountIdentifier([u8; 32]);

impl AccountIdentifier {
    /// Creates a new account identifier from a principal and subaccount.
    #[frb(ignore)]
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

    /// Convert hex string into AccountIdentifier.
    #[frb(ignore)]
    pub fn from_hex(hex_str: &str) -> Result<AccountIdentifier, String> {
        let hex: Vec<u8> = hex::decode(hex_str).map_err(|e| e.to_string())?;
        Self::from_slice(&hex[..]).map_err(|err| match err {
            // Since the input was provided in hex, return an error that is hex-friendly.
            AccountIdParseError::InvalidLength(_) => format!(
                "{} has a length of {} but we expected a length of 64 or 56",
                hex_str,
                hex_str.len()
            ),
            AccountIdParseError::InvalidChecksum(err) => err.to_string(),
        })
    }

    /// Converts a blob into an `AccountIdentifier`.
    ///
    /// The blob can be either:
    ///
    /// 1. The 32-byte canonical format (4 byte checksum + 28 byte hash).
    /// 2. The 28-byte hash.
    ///
    /// If the 32-byte canonical format is provided, the checksum is verified.
    fn from_slice(v: &[u8]) -> Result<AccountIdentifier, AccountIdParseError> {
        // Try parsing it as a 32-byte blob.
        match v.try_into() {
            Ok(h) => {
                // It's a 32-byte blob. Validate the checksum.
                check_sum(h).map_err(AccountIdParseError::InvalidChecksum)
            }
            Err(_) => {
                // Try parsing it as a 28-byte hash.
                match <&[u8] as TryInto<[u8; 28]>>::try_into(v) {
                    Ok(hash) => AccountIdentifier::try_from(hash)
                        .map_err(|_| AccountIdParseError::InvalidLength(v.to_vec())),
                    Err(_) => Err(AccountIdParseError::InvalidLength(v.to_vec())),
                }
            }
        }
    }


    /// Convert AccountIdentifier into hex string.
    #[frb(ignore)]
    pub(super) fn to_hex(&self) -> String {
        hex::encode(self.0)
    }

    /// Provide the account identifier as bytes.
    #[frb(ignore)]
    fn as_bytes(&self) -> &[u8; 32] {
        &self.0
    }

    /// Returns the checksum of the account identifier.
    #[frb(ignore)]
    fn generate_checksum(&self) -> [u8; 4] {
        let mut hasher = crc32fast::Hasher::new();
        hasher.update(&self.0[4..]);
        hasher.finalize().to_be_bytes()
    }
}

impl TryFrom<[u8; 32]> for AccountIdentifier {
    type Error = String;

    fn try_from(bytes: [u8; 32]) -> Result<Self, Self::Error> {
        let hash = &bytes[4..];
        let mut hasher = crc32fast::Hasher::new();
        hasher.update(hash);
        let crc32_bytes = hasher.finalize().to_be_bytes();
        if bytes[0..4] == crc32_bytes[0..4] {
            Ok(Self(bytes))
        } else {
            Err("CRC-32 checksum failed to verify".to_string())
        }
    }
}

impl TryFrom<[u8; 28]> for AccountIdentifier {
    type Error = String;

    #[frb(ignore)]
    fn try_from(bytes: [u8; 28]) -> Result<Self, Self::Error> {
        let mut hasher = crc32fast::Hasher::new();
        hasher.update(bytes.as_slice());
        let crc32_bytes = hasher.finalize().to_be_bytes();

        let mut aid_bytes = [0u8; 32];
        aid_bytes[..4].copy_from_slice(&crc32_bytes[..4]);
        aid_bytes[4..].copy_from_slice(&bytes[..]);

        Ok(Self(aid_bytes))
    }
}


fn check_sum(hex: [u8; 32]) -> Result<AccountIdentifier, ChecksumError> {
    // Get the checksum provided
    let found_checksum = &hex[0..4];

    let mut hasher = crc32fast::Hasher::new();
    hasher.update(&hex[4..]);
    let expected_checksum = hasher.finalize().to_be_bytes();

    // Check the generated checksum matches
    if expected_checksum == found_checksum {
        Ok(AccountIdentifier(hex))
    } else {
        Err(ChecksumError {
            input: hex,
            expected_checksum,
            found_checksum: found_checksum.try_into().unwrap(),
        })
    }
}

/// A type for representing amounts of Tokens.
///
/// # Panics
///
/// * Arithmetics (addition, subtraction) on the Tokens type panics if the underlying type
///   overflows.
#[frb(ignore)]
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub(super) struct Tokens {
    pub(super) e8s: u64,
}

impl Tokens {
    /// The maximum number of Tokens we can hold on a single account.
    pub(super) const MAX: Self = Tokens { e8s: u64::MAX };
    /// Zero Tokens.
    pub(super) const ZERO: Self = Tokens { e8s: 0 };
    /// How many times can Tokenss be divided
    pub(super) const SUBDIVIDABLE_BY: u64 = 100_000_000;

    /// Constructs an amount of Tokens from the number of 10^-8 Tokens.
    #[frb(ignore)]
    pub(super) const fn from_e8s(e8s: u64) -> Self {
        Self { e8s }
    }

    /// Returns the number of 10^-8 Tokens in this amount.
    #[frb(ignore)]
    pub(super) const fn e8s(&self) -> u64 {
        self.e8s
    }
}

impl Add for Tokens {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        let e8s = self.e8s.checked_add(other.e8s).unwrap_or_else(|| {
            panic!(
                "Add Tokens {} + {} failed because the underlying u64 overflowed",
                self.e8s, other.e8s
            )
        });
        Self { e8s }
    }
}

impl AddAssign for Tokens {
    fn add_assign(&mut self, other: Self) {
        *self = *self + other;
    }
}

impl Sub for Tokens {
    type Output = Self;
    
    fn sub(self, other: Self) -> Self {
        let e8s = self.e8s.checked_sub(other.e8s).unwrap_or_else(|| {
            panic!(
                "Subtracting Tokens {} - {} failed because the underlying u64 underflowed",
                self.e8s, other.e8s
            )
        });
        Self { e8s }
    }
}

impl SubAssign for Tokens {
    fn sub_assign(&mut self, other: Self) {
        *self = *self - other;
    }
}

impl Display for Tokens {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}.{:08}",
            self.e8s / Tokens::SUBDIVIDABLE_BY,
            self.e8s % Tokens::SUBDIVIDABLE_BY
        )
    }
}


/// An arbitrary number associated with a transaction.
/// The caller can set it in a `transfer` call as a correlation identifier.
#[frb(ignore)]
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub(super) struct Memo(pub(super) u64);

/// Number of nanoseconds from the UNIX epoch in UTC timezone.
#[frb(ignore)]
#[derive(
    CandidType, Serialize, Deserialize, Clone, Copy, Hash, Debug, PartialEq, Eq, PartialOrd, Ord,
)]
pub(super) struct Timestamp {
    /// Number of nanoseconds from the UNIX epoch in UTC timezone.
    pub(super) timestamp_nanos: u64,
}



#[frb(ignore)]
#[derive(CandidType, Serialize, Deserialize, Clone, Debug)]
pub struct TransferArgs {
    /// Transaction memo.
    /// See docs for the [`Memo`] type.
    pub(super) memo: Memo,
    /// The amount that the caller wants to transfer to the destination address.
    pub(super) amount: Tokens,
    /// The amount that the caller pays for the transaction.
    /// Must be 10000 e8s.
    pub(super) fee: Tokens,
    /// The subaccount from which the caller wants to transfer funds.
    /// If `None`, the ledger uses the default (all zeros) subaccount to compute the source address.
    /// See docs for the [`Subaccount`] type.
    pub(super) from_subaccount: Option<Subaccount>,
    /// The destination account.
    /// If the transfer is successful, the balance of this address increases by `amount`.
    pub(super) to: AccountIdentifier,
    /// The point in time when the caller created this request.
    /// If `None`, the ledger uses the current IC time as the timestamp.
    /// Transactions more than one day old will be rejected.
    pub(super) created_at_time: Option<Timestamp>,
}

/// Error of the `transfer` call.
#[frb(ignore)]
#[derive(CandidType, Serialize, Deserialize, Clone, Debug, PartialEq, Eq)]
pub(super) enum TransferError {
    /// The fee that the caller specified in the transfer request was not the one that the ledger expects.
    /// The caller can change the transfer fee to the `expected_fee` and retry the request.
    BadFee {
        /// The account specified by the caller doesn't have enough funds.
        expected_fee: Tokens,
    },
    /// The caller did not have enough ICP in the specified subaccount.
    InsufficientFunds {
        /// The caller's balance.
        balance: Tokens,
    },
    /// The request is too old.
    /// The ledger only accepts requests created within a 24-hour window.
    /// This is a non-recoverable error.
    TxTooOld {
        /// The permitted duration between `created_at_time` and now.
        allowed_window_nanos: u64,
    },
    /// The caller specified a `created_at_time` that is too far in the future.
    /// The caller can retry the request later.
    /// This may also be caused by clock desynchronization.
    TxCreatedInFuture,
    /// The ledger has already executed the request.
    TxDuplicate {
        /// The index of the block containing the original transaction.
        duplicate_of: BlockIndex,
    },
}

impl Display for TransferError {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        match self {
            Self::BadFee { expected_fee } => {
                write!(f, "transaction fee should be {}", expected_fee)
            }
            Self::InsufficientFunds { balance } => {
                write!(
                    f,
                    "the debit account doesn't have enough funds to complete the transaction, current balance: {}",
                    balance
                )
            }
            Self::TxTooOld {
                allowed_window_nanos,
            } => write!(
                f,
                "transaction is older than {} seconds",
                allowed_window_nanos / 1_000_000_000
            ),
            Self::TxCreatedInFuture => write!(f, "transaction's created_at_time is in future"),
            Self::TxDuplicate { duplicate_of } => write!(
                f,
                "transaction is a duplicate of another transaction in block {}",
                duplicate_of
            ),
        }
    }
}