use candid::{decode_args, encode_args, CandidType, Deserialize, Encode, Nat, Principal};
use ic_agent::Agent;
use ic_ledger_types::{AccountIdentifier, Subaccount};
use icrc_ledger_types::icrc1::account::Account;
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
use std::{str::FromStr, sync::Arc};

use super::{utils::format_amount, ic_wallet_service::SimpleTransaction};

#[derive(CandidType, Deserialize)]
pub(super) struct GetAccountIdentifierTransactionsArgs {
    pub max_results: u64,
    pub start: Option<u64>,
    pub account_identifier: String,
}

#[derive(CandidType, Deserialize)]
pub(super) struct Tokens {
    pub e8s: u64,
}

#[derive(CandidType, Deserialize)]
pub(super) struct TimeStamp {
    pub timestamp_nanos: u64,
}

#[derive(CandidType, Deserialize)]
pub(super) enum Operation {
    Approve {
        fee: Tokens,
        from: String,
        allowance: Tokens,
        expected_allowance: Option<Tokens>,
        expires_at: Option<TimeStamp>,
        spender: String,
    },
    Burn {
        from: String,
        amount: Tokens,
        spender: Option<String>,
    },
    Mint {
        to: String,
        amount: Tokens,
    },
    Transfer {
        to: String,
        fee: Tokens,
        from: String,
        amount: Tokens,
        spender: Option<String>,
    },
}

#[derive(CandidType, Deserialize)]
pub(super) struct ICPTransaction {
    pub memo: u64,
    pub icrc1_memo: Option<Vec<u8>>,
    pub operation: Operation,
    pub timestamp: Option<TimeStamp>,
    pub created_at_time: Option<TimeStamp>,
}

#[derive(CandidType, Deserialize)]
pub(super) struct ICPTransactionWithId {
    pub id: u64,
    pub transaction: ICPTransaction,
}

#[derive(CandidType, Deserialize)]
pub(super) struct GetAccountIdentifierTransactionsResponse {
    pub balance: u64,
    pub transactions: Vec<ICPTransactionWithId>,
    pub oldest_tx_id: Option<u64>,
}

#[derive(CandidType, Deserialize)]
pub(super) struct GetAccountIdentifierTransactionsError {
    pub message: String,
}

pub(super) type GetAccountIdentifierTransactionsResult =
    Result<GetAccountIdentifierTransactionsResponse, GetAccountIdentifierTransactionsError>;

#[derive(CandidType, Deserialize)]
pub(super) struct ICPGetAccountTransactionsArgs {
    max_results: Nat,
    start: Option<Nat>,
    account: Account,
}

// #[derive(CandidType, Deserialize)]
// pub(super) struct GetBlocksRequest {
//     pub start: u64,
//     pub length: u64,
// }

// #[derive(CandidType, Deserialize)]
// pub(super) struct GetBlocksResponse {
//     pub blocks: Vec<Vec<u8>>,
//     pub chain_length: u64,
// }

// #[derive(CandidType, Deserialize)]
// pub(super) struct Status {
//     pub num_blocks_synced: u64,
// }

pub(super) struct ICPLedgerIndexService {
    ic_agent: Arc<Agent>,
    ledger_id: Principal,
}

impl ICPLedgerIndexService {
    pub(super) fn new(ic_agent: Arc<Agent>, ledger_id: Principal) -> Self {
       
        Self {
            ic_agent,
            ledger_id,
        }
    }

    //  pub async fn get_account_identifier_balance(&self, account_identifier: String) -> anyhow::Result<u64> {
    //      let response = self.ic_agent
    //          .query(&self.ledger_id, "get_account_identifier_balance")
    //          .with_arg(Encode!(&account_identifier)?)
    //          .call()
    //          .await?;

    //      let (balance,): (u64,) = decode_args(&response)?;
    //      Ok(balance)
    //  }

    //  pub async fn get_account_identifier_transactions(
    //      &self,
    //      args: GetAccountIdentifierTransactionsArgs
    //  ) -> anyhow::Result<GetAccountIdentifierTransactionsResult> {
    //      let response = self.ic_agent
    //          .query(&self.ledger_id, "get_account_identifier_transactions")
    //          .with_arg(Encode!(&args)?)
    //          .call()
    //          .await?;

    //      let (result,): (GetAccountIdentifierTransactionsResult,) = decode_args(&response)?;
    //      Ok(result)
    //  }

    pub(super) async fn get_account_transactions(
        &self,
        account: Account,
        from_index: Option<u64>,
        max_results: Option<u32>,
    ) -> anyhow::Result<GetAccountIdentifierTransactionsResult> {
        let args = ICPGetAccountTransactionsArgs {
            start: from_index.map(|f| Nat::from(f)),
            max_results: Nat::from(max_results.unwrap_or(10)),
            account,
        };

        let response = self
            .ic_agent
            .query(&self.ledger_id, "get_account_transactions")
            .with_arg(Encode!(&args)?)
            .call()
            .await?;

        let (result,): (GetAccountIdentifierTransactionsResult,) = decode_args(&response)?;
        Ok(result)
    }

    //  pub async fn get_blocks(&self, request: GetBlocksRequest) -> anyhow::Result<GetBlocksResponse> {
    //      let response = self.ic_agent
    //          .query(&self.ledger_id, "get_blocks")
    //          .with_arg(Encode!(&request)?)
    //          .call()
    //          .await?;

    //      let (response,): (GetBlocksResponse,) = decode_args(&response)?;
    //      Ok(response)
    //  }

    //  pub async fn icrc1_balance_of(&self, account: Account) -> anyhow::Result<u64> {
    //      let response = self.ic_agent
    //          .query(&self.ledger_id, "icrc1_balance_of")
    //          .with_arg(Encode!(&account)?)
    //          .call()
    //          .await?;

    //      let (balance,): (u64,) = decode_args(&response)?;
    //      Ok(balance)
    //  }

    pub(super) fn convert_to_simple_transaction(tx: ICPTransactionWithId, owner: String, decimal: u8, symbol: &str) -> Option<SimpleTransaction> {
        let acc_id = AccountIdentifier::new(&Principal::from_text(&owner).unwrap(), &Subaccount([0; 32]));
        match tx.transaction {
            ICPTransaction { operation: Operation::Approve { allowance, spender, .. }, timestamp, created_at_time, .. } => {
                Some(SimpleTransaction { 
                    kind: "approve".to_string(), 
                    amount: format_amount(&Nat::from(allowance.e8s), decimal), 
                    to: spender, 
                    timestamp: timestamp.or(created_at_time).map_or(0, |t| t.timestamp_nanos.div_ceil(1_000_000)), 
                    symbol: symbol.to_string() 
                })
            },
            ICPTransaction { operation: Operation::Transfer { to, from, amount, .. }, timestamp, created_at_time, ..} => {
                let kind = if from == owner || from == acc_id.to_hex() {
                    "send".to_string()
                } else {
                    "receive".to_string()
                };
    
                let party = if kind == "send" {to} else {from};
                Some(SimpleTransaction {
                    kind,
                    amount: format_amount(&Nat::from(amount.e8s), decimal),
                    to: party,
                    timestamp: timestamp.or(created_at_time).map_or(0, |t| t.timestamp_nanos.div_ceil(1_000_000)),
                    symbol: symbol.to_string()
                })
            },
            ICPTransaction { operation: Operation::Mint { to, amount }, timestamp, created_at_time, .. } => {
                Some(SimpleTransaction {
                    kind: "mint".to_string(),
                    amount: format_amount(&Nat::from(amount.e8s), decimal),
                    to,
                    timestamp: timestamp.or(created_at_time).map_or(0, |t| t.timestamp_nanos.div_ceil(1_000_000)),
                    symbol: symbol.to_string()
                })
            },
            ICPTransaction { operation: Operation::Burn { from, amount, .. }, timestamp, created_at_time, .. } => {
                Some(SimpleTransaction {
                    kind: "burn".to_string(),
                    amount: format_amount(&Nat::from(amount.e8s), decimal),
                    to: from, // Using 'from' as 'to' for burn transactions
                    timestamp: timestamp.or(created_at_time).map_or(0, |t| t.timestamp_nanos.div_ceil(1_000_000)),
                    symbol: symbol.to_string()
                })
            }
        }
    }

    // pub async fn ledger_id(&self) -> anyhow::Result<Principal> {
    //     let response = self
    //         .ic_agent
    //         .query(&self.ledger_id, "ledger_id")
    //         .with_arg(encode_args(())?)
    //         .call()
    //         .await?;

    //     let (principal,): (Principal,) = decode_args(&response)?;
    //     Ok(principal)
    // }

    //  pub async fn status(&self) -> anyhow::Result<Status> {
    //      let response = self.ic_agent
    //          .query(&self.ledger_id, "status")
    //          .with_arg(encode_args(())?)
    //          .call()
    //          .await?;

    //      let (status,): (Status,) = decode_args(&response)?;
    //      Ok(status)
    //  }
}
