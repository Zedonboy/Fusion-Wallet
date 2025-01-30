use std::sync::Arc;
use candid::{decode_args, encode_args, encode_one, CandidType, Decode, Deserialize, Encode, Nat, Principal};
use ic_agent::Agent;
use icrc_ledger_types::icrc1::account::Account;

use super::{utils::format_amount, ic_wallet_service::SimpleTransaction};


#[derive(CandidType, Deserialize)]
pub(super) struct GetAccountTransactionsArgs {
    pub(super) max_results: Nat,
    pub(super) start: Option<Nat>,
    pub(super) account: Account,
}

#[derive(CandidType, Deserialize)]
pub(super) struct Transaction {
    pub(super) burn: Option<Burn>,
    pub(super) kind: String,
    pub(super) mint: Option<Mint>,
    pub(super) approve: Option<Approve>,
    pub(super) timestamp: u64,
    pub(super) transfer: Option<Transfer>
}

#[derive(CandidType, Deserialize)]
pub(super) struct Burn {
    pub(super) from: Account,
    pub(super) memo: Option<Vec<u8>>,
    pub(super) created_at_time: Option<u64>,
    pub(super) amount: Nat,
    pub(super) spender: Option<Account>
}

#[derive(CandidType, Deserialize)]
pub(super) struct Mint {
    pub(super) to: Account,
    pub(super) memo: Option<Vec<u8>>,
    pub(super) created_at_time: Option<u64>,
    pub(super) amount: Nat
}

#[derive(CandidType, Deserialize)]
pub(super) struct Approve {
    pub(super) fee: Option<Nat>,
    pub(super) from: Account,
    pub(super) memo: Option<Vec<u8>>,
    pub(super) created_at_time: Option<u64>,
    pub(super) amount: Nat,
    pub(super) expected_allowance: Option<Nat>,
    pub(super) expires_at: Option<u64>,
    pub(super) spender: Account
}

#[derive(CandidType, Deserialize)]
pub(super) struct Transfer {
    pub(super) to: Account,
    pub(super) fee: Option<Nat>,
    pub(super) from: Account,
    pub(super) memo: Option<Vec<u8>>,
    pub(super) created_at_time: Option<u64>,
    pub(super) amount: Nat,
    pub(super) spender: Option<Account>
}

#[derive(CandidType, Deserialize)]
pub(super) struct TransactionWithId {
    pub(super) id: Nat,
    pub(super) transaction: Transaction
}

#[derive(CandidType, Deserialize)]
pub(super) struct GetTransactions {
    pub(super) balance: Nat,
    pub(super) transactions: Vec<TransactionWithId>,
    pub(super) oldest_tx_id: Option<Nat>
}

#[derive(CandidType, Deserialize)]
pub(super) struct GetTransactionsErr {
    pub(super) message: String
}

pub(super) type GetTransactionsResult = Result<GetTransactions, GetTransactionsErr>;

#[derive(CandidType, Deserialize)]
pub(super) struct Status {
    pub(super) num_blocks_synced: Nat
}

#[derive(CandidType, Deserialize)]
pub(super) struct ListSubaccountsArgs {
    pub(super) owner: Principal,
    pub(super) start: Option<Vec<u8>>
}

pub(super) struct IcIndexService {
    ic_agent: Arc<Agent>,
    index_canister_id: Principal,
}

impl IcIndexService {
    pub(super) fn new(ic_agent: Arc<Agent>, index_canister_id: Principal) -> Self {
        Self {
            ic_agent,
            index_canister_id,
        }
    }

    pub(super) async fn get_transactions(&self, account: Account, from_index: Option<u64>, max_results: Option<u32>) -> anyhow::Result<GetTransactionsResult> {
        let args = GetAccountTransactionsArgs {
            account,
            start: from_index.map(|idx| Nat::from(idx)),
            max_results: Nat::from(max_results.unwrap_or(10))
        };
        
        let response = self.ic_agent
            .query(&self.index_canister_id, "get_account_transactions")
            .with_arg(Encode!(&args)?)
            .call()
            .await?;

        let (result,): (GetTransactionsResult,) = decode_args(&response)?;
        
        Ok(result)
    }

    pub(super) fn transaction_to_simple(tx: TransactionWithId, owner: String, decimal : u8, symbol : &str) -> Option<SimpleTransaction> {
    
        match tx.transaction {
            Transaction { transfer: Some(t), timestamp, .. } => {
                let kind = if t.from.to_string() == owner {
                    "send".to_string()
                } else {
                    "receive".to_string()
                };

                let party = if kind == "send" {t.to.to_string()} else {t.from.to_string()};

                Some(SimpleTransaction {
                    kind,
                    amount: format_amount(&t.amount, decimal),
                    to: party,
                    timestamp,
                    symbol: symbol.to_string()
                })
            },
            Transaction { mint: Some(m), timestamp, .. } => Some(SimpleTransaction {
                kind: "mint".to_string(),
                amount: format_amount(&m.amount, decimal),
                to: m.to.to_string(),
                timestamp,
                symbol: symbol.to_string()
            }),
            Transaction { burn: Some(b), timestamp, .. } => Some(SimpleTransaction {
                kind: "burn".to_string(),
                amount: format_amount(&b.amount, decimal),
                to: b.from.to_string(), // Using 'from' as 'to' for burn transactions
                timestamp,
                symbol: symbol.to_string()
            }),
            Transaction { approve: Some(a), timestamp, .. } => Some(SimpleTransaction {
                kind: "approve".to_string(),
                amount: format_amount(&a.amount, decimal),
                to: a.spender.to_string(),
                timestamp,
                symbol: symbol.to_string()
            }),
            _ => None
        }
    }

   

    // pub(super) async fn get_status(&self) -> anyhow::Result<Status> {
    //     let response = self.ic_agent
    //         .query(&self.index_canister_id, "status")
    //         .call()
    //         .await?;

    //     let (status,): (Status,) = decode_args(&response)?;
    //     Ok(status)
    // }

    // pub(super) async fn list_subaccounts(&self, owner: Principal) -> anyhow::Result<Vec<Vec<u8>>> {
    //     let args = ListSubaccountsArgs {
    //         owner,
    //         start: None
    //     };

    //     let response = self.ic_agent
    //         .query(&self.index_canister_id, "list_subaccounts")
    //         .with_arg(Encode!(&args)?)
    //         .call()
    //         .await?;

    //     let (subaccounts,): (Vec<Vec<u8>>,) = decode_args(&response)?;
    //     Ok(subaccounts)
    // }

    pub(super) async fn ledger_id(&self) -> anyhow::Result<Principal> {
        let response = self.ic_agent
            .query(&self.index_canister_id, "ledger_id")
            .with_arg(encode_args(()).unwrap())
            .call()
            .await?;

        let (principal,): (Principal,) = decode_args(&response)?;
        Ok(principal)
    }

    // pub(super) async fn get_balance(&self, account: Account) -> anyhow::Result<Nat> {
    //     let response = self.ic_agent
    //         .query(&self.index_canister_id, "icrc1_balance_of")
    //         .with_arg(Encode!(&account)?)
    //         .call()
    //         .await?;

    //     let (balance,): (Nat,) = decode_args(&response)?;
    //     Ok(balance)
    // }
}