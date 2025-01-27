use std::{str::FromStr, sync::Arc};

use anyhow::{bail, Error, Ok};
use candid::{decode_args, encode_args, encode_one, CandidType, Decode, Encode, Nat};
use ic_agent::{export::Principal, Agent};
use icrc_ledger_types::{icrc::generic_metadata_value::MetadataValue, icrc1::{account::Account, transfer::{TransferArg, TransferError}}, icrc2::approve::{ApproveArgs, ApproveError}};
use reqwest::Client;
use serde::Deserialize;
use serde_json::Value;

use super::{constants::KONG_SWAP_ID, index_service::{GetTransactionsResult, IcIndexService, Transaction, TransactionWithId}, swap_service::ICSwapService, utils::{format_amount, TokenMetadata}, wallet::{WalletToken, WalletTokenNetWork}};

pub struct ICWalletService {
    ic_agent: Arc<Agent>,
    http_client: Client
}

pub struct QuoteResponse {
    pub receive_token_address: String,
    pub slippage: f64,
    pub tx_count: usize,
    pub mid_price: f64,
    pub receive_amount: u64
}

pub struct SimpleTransaction {
    pub kind: String,           // "transfer", "mint", "burn", "approve", "send", "receive"
    pub amount: String,            // Transaction amount
    pub to: String,             // Destination address/principal
    pub timestamp: u64,         // Transaction timestamp
    pub symbol : String
}

impl ICWalletService {
    pub (super) fn new(agent : Arc<Agent>) -> Self {
        let client = reqwest::Client::new();
        Self { ic_agent: agent, http_client: client }
    }
    pub async fn send(&self, token: &WalletToken, to: String, amount: u64) -> anyhow::Result<u64> {
        // Parse the recipient address into an Account
        let recipient = Account::from_str(&to)?;

        // Create the transfer arguments
        let transfer_args = TransferArg {
            fee: None, // Let the ledger decide the fee
            from_subaccount: None,
            to: recipient,
            created_at_time: None, // Let the ledger set the timestamp
            memo: None,
            amount: Nat::from(amount),
        };

        // Get the token's canister ID from the token address
        let canister_id = Principal::from_text(&token.token_address)
            .map_err(|err| Error::msg(format!("Invalid canister ID: {}", err)))?;

        // Create an actor to interact with the token's canister
        let token_canister = self.ic_agent.update(
            &canister_id,
            "icrc1_transfer"
        ).with_arg(Encode!(&transfer_args)?);

        // Execute the transfer
        let result = token_canister
            .call_and_wait()
            .await
            .map_err(|err| Error::msg(format!("Transfer failed: {}", err)))?;

        let (transfer_result,) : (Result<Nat, TransferError>, ) = decode_args(&result).unwrap();
       
        match transfer_result {
            std::result::Result::Ok(block_index) => {
                // Convert Nat to u64
                let block : u64 = block_index.0.try_into()?;
                Ok(block)
            },
            Err(e) => Err(Error::msg(format!("Transfer error: {:?}", e)))
        }
    }

    /// Approves another account (spender) to spend tokens on behalf of the caller
    pub async fn approve(&self, token: &WalletToken, spender: String, amount: u64) -> anyhow::Result<u64> {
        // Parse the spender address into an Account
        let spender_account = Account::from_str(&spender)?;

        // Create the approve arguments
        let approve_args = ApproveArgs {
            fee: None, // Let the ledger decide the fee
            memo: None,
            from_subaccount: None,
            spender: spender_account,
            amount: Nat::from(amount),
            expected_allowance: None,
            expires_at: None,
            created_at_time: None, // Let the ledger set the timestamp
        };

        // Get the token's canister ID from the token address
        let canister_id = Principal::from_text(&token.token_address)
            .map_err(|err| Error::msg(format!("Invalid canister ID: {}", err)))?;

        // Create an actor to interact with the token's canister
        let token_canister = self.ic_agent.update(
            &canister_id,
            "icrc2_approve"
        ).with_arg(Encode!(&approve_args)?);

        // Execute the approval
        let result = token_canister
            .call_and_wait()
            .await
            .map_err(|err| Error::msg(format!("Approval failed: {}", err)))?;

        let (approve_result,) : (Result<Nat, ApproveError>, ) = decode_args(&result).unwrap();
       
        match approve_result {
            std::result::Result::Ok(block_index) => {
                // Convert Nat to u64
                let block : u64 = block_index.0.try_into()?;
                Ok(block)
            },
            Err(e) => Err(Error::msg(format!("Approval error: {:?}", e)))
        }
    }

    /// Checks if a spender is approved for a certain amount
    pub async fn get_allowance(&self, token: &WalletToken, owner: String, spender: String) -> anyhow::Result<u64> {
        let owner_account = Account::from_str(&owner)?;
        let spender_account = Account::from_str(&spender)?;

        let canister_id = Principal::from_text(&token.token_address)?;

        let args = (owner_account, spender_account);
        
        let token_canister = self.ic_agent.query(
            &canister_id,
            "icrc2_allowance"
        ).with_arg(Encode!(&args)?);

        let result = token_canister
            .call()
            .await
            .map_err(|err| Error::msg(format!("Failed to get allowance: {}", err)))?;

        let (allowance,): (Nat,) = decode_args(&result)?;
        
        Ok(allowance.0.try_into()?)
    }

    pub async fn get_price(&self, token: &WalletToken) -> f32 {
        let symbol = if token.symbol.starts_with("ck") {
            token.symbol.strip_prefix("ck").unwrap()
        } else {
            token.symbol.as_str()
        };
        
        let url = format!(
            "https://api.coinbase.com/v2/prices/{}-usd/spot",
            symbol.to_ascii_lowercase()
        );
        let http_result = match self.http_client.get(url).send().await {
            Result::Ok(response) => response,
            Err(_) => return -1.0
        };
        
        let json: Value = match http_result.json().await {
            Result::Ok(j) => j,
            Err(_) => return -1.0
        };
        
        match json.get("data").and_then(|d| d.get("amount")) {
            Some(amount) => {
                let amount_str = amount.as_str().unwrap_or("");
                match amount_str.parse::<f32>() {
                    Result::Ok(num) => num,
                    Err(_) => -1.0
                }
            },
            None => -1.0
        }
    }


    /// Gets the balance of an account for a specific token
    pub async fn get_balance(&self, token: &WalletToken, account: String) -> anyhow::Result<u64> {
        // Parse the account string into an Account type
        let account = Account::from_str(&account)?;

        // Get the token's canister ID
        let canister_id = Principal::from_text(&token.token_address)
            .map_err(|err| Error::msg(format!("Invalid canister ID: {}", err)))?;

        // Create the query to the token's canister
        let token_canister = self.ic_agent.query(
            &canister_id,
            "icrc1_balance_of"
        ).with_arg(Encode!(&account)?);

        // Execute the balance query
        let result = token_canister
            .call()
            .await
            .map_err(|err| Error::msg(format!("Failed to get balance: {}", err)))?;

        // Decode the result
        let (balance,): (Nat,) = decode_args(&result)?;
        
        // Convert from Nat to u64
        Ok(balance.0.try_into()?)
    }


    pub async fn swap_quote(&self, pay_token: &WalletToken, receive_token:&WalletToken, pay_amount: u64) -> anyhow::Result<QuoteResponse> {
        let swap_id = Principal::from_str(KONG_SWAP_ID)?;
        let swap_service = ICSwapService::new(self.ic_agent.clone(), swap_id);
        let result = swap_service.get_swap_amounts(pay_token.symbol.clone(), Nat::from(pay_amount), receive_token.symbol.clone()).await?;
        let quote = QuoteResponse {
            receive_token_address: result.receive_address,
            slippage: result.slippage,
            tx_count: result.txs.len(),
            mid_price: result.mid_price,
            receive_amount: result.receive_amount.0.try_into()?,
        };
        Ok(quote)
    }

    fn create_index_service(&self, index_canister: &String) -> anyhow::Result<IcIndexService> {
            
        let principal = Principal::from_text(index_canister)?;
        Ok(IcIndexService::new(self.ic_agent.clone(), principal))
    }

    fn transaction_to_simple(tx: &TransactionWithId, owner: String, decimal : u8, symbol : &str) -> Option<SimpleTransaction> {
        match &tx.transaction {
            Transaction { transfer: Some(t), timestamp, .. } => Some(SimpleTransaction {
                kind: if t.from.owner.to_text() == owner {
                    "send".to_string()
                } else {
                    "receive".to_string()
                },
                amount: format_amount(&t.amount, decimal),
                to: t.to.to_string(),
                timestamp: *timestamp,
                symbol: symbol.to_string()
            }),
            Transaction { mint: Some(m), timestamp, .. } => Some(SimpleTransaction {
                kind: "mint".to_string(),
                amount: format_amount(&m.amount, decimal),
                to: m.to.to_string(),
                timestamp: *timestamp,
                symbol: symbol.to_string()
            }),
            Transaction { burn: Some(b), timestamp, .. } => Some(SimpleTransaction {
                kind: "burn".to_string(),
                amount: format_amount(&b.amount, decimal),
                to: b.from.to_string(), // Using 'from' as 'to' for burn transactions
                timestamp: *timestamp,
                symbol: symbol.to_string()
            }),
            Transaction { approve: Some(a), timestamp, .. } => Some(SimpleTransaction {
                kind: "approve".to_string(),
                amount: format_amount(&a.amount, decimal),
                to: a.spender.to_string(),
                timestamp: *timestamp,
                symbol: symbol.to_string()
            }),
            _ => None
        }
    }


    pub async fn get_latest_transactions(&self, token: &WalletToken, account_addr: &str, max_results: Option<u32>) -> anyhow::Result::<Vec<SimpleTransaction>> {
        if token.index_canister.is_none() {
            return Ok(vec![])
        }
        // Create index service for the token
        let index_service = self.create_index_service(token.index_canister.as_ref().unwrap())?;

        let account= Account::from_str(account_addr)?;
        // Get transactions from index service
        let result = index_service.get_transactions(account, None, max_results).await;
        
        match result {
            Result::Ok(GetTransactionsResult::Ok(txs)) => {
                let vec = txs.transactions
                    .iter()
                    .filter_map(|tx| Self::transaction_to_simple(tx, account.to_string(), token.token_decimal.unwrap_or(8), &token.symbol.to_uppercase()))
                    .collect();

                Ok(vec)
            },
            _ => Ok(vec![])
        }
    }

    pub async fn get_token(&self, canister_id: &str, index_canister : Option<String>) -> anyhow::Result<WalletToken> {
        let token_principal = Principal::from_text(canister_id)?;

        if index_canister.is_some() {
            let d = index_canister.as_ref().unwrap();
            let is_verified = self.verify_index(canister_id, d).await?;
            if !is_verified {
                bail!("The Index Canister is not for the token.")
            }
        }

        print!("Rust Lib");
        
        let metadata_response = self.ic_agent
            .query(&token_principal, "icrc1_metadata")
            .with_arg(encode_args(()).unwrap())
            .call()
            .await?;

        print!("Rust Lib: {}", metadata_response.len());

        let (metadata_list,): (Vec<(String, MetadataValue)>,) = decode_args(&metadata_response)?;

        let token_metadata = TokenMetadata::from_metadata_records(metadata_list);

        let token = self.create_wallet_token(canister_id, token_metadata);

        Ok(token)
    }

    // Helper function to create WalletToken from metadata
    fn create_wallet_token(&self, canister_id: &str, metadata: TokenMetadata) -> WalletToken {
        WalletToken {
            symbol: metadata.symbol,
            network: WalletTokenNetWork::InternetComputer,
            token_address: canister_id.to_string(),
            token_decimal: Some(metadata.decimals as u8),
            image_url: metadata.logo,
            token_name: metadata.name,
            index_canister: None,
            transfer_fee: metadata.fee.0.try_into().unwrap(),
            gov_canister: None
        }
    }


    async fn verify_index(&self, ledger_id : &str, index : &str) -> anyhow::Result<bool>{
        let index_canister = self.create_index_service(&index.to_string())?;
        let ledger = index_canister.ledger_id().await?;
        if ledger.to_text() == ledger_id {
            Ok(true)
        } else {
            Ok(false)
        }
    }



}
