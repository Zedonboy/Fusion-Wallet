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

use anyhow::{bail, Error, Ok};
use candid::{decode_args, encode_args, encode_one, CandidType, Decode, Encode, Nat};
use ic_agent::{export::Principal, Agent};
// use ic_ledger_types::{AccountIdentifier, BlockIndex, Memo, Tokens, DEFAULT_FEE, MAINNET_LEDGER_CANISTER_ID};
use icrc_ledger_types::{
    icrc::generic_metadata_value::MetadataValue,
    icrc1::{
        account::Account,
        transfer::{TransferArg, TransferError},
    },
    icrc2::{allowance::{Allowance, AllowanceArgs}, approve::{ApproveArgs, ApproveError}},
};
use log::{debug, info};
use reqwest::Client;
use serde::Deserialize;
use serde_json::Value;

use crate::api::icp_index_service::{
    GetAccountIdentifierTransactionsResult, ICPLedgerIndexService,
};

use super::{
    canister::ICCanisterInfoService, cmc::CyclesService, constants::{CYCLES_MINTING_CANISTER, KONG_SWAP_ID, MAINNET_LEDGER_CANISTER_ID}, index_service::{GetTransactionsResult, IcIndexService, Transaction, TransactionWithId}, nft_service::ICCollectionService, swap_service::{KongSwapService, SwapArgs}, utils::{format_amount, AccountIdentifier, BlockIndex, Memo, TokenMetadata, Tokens, TransferArgs, DEFAULT_FEE}, wallet::{WalletToken, WalletTokenNetWork}
};

pub struct ICWalletService {
    ic_agent: Arc<Agent>,
    // http_client: Client,
}

pub struct QuoteResponse {
    pub receive_token_address: String,
    pub slippage: f64,
    pub tx_count: usize,
    pub mid_price: f64,
    pub receive_amount: u128,
    pub estimated_fee_amount: u128,
}

pub struct SwapResponse {
    pub tx_id: u64,
    pub status: String,
    pub pay_symbol: String,
    pub receive_symbol: String,
    pub pay_amount: u128,
    pub receive_amount: u128,
}

pub struct AllowanceResponse {
    pub allowance: u64,
    pub expires_at: Option<u64>,
}

pub struct SimpleTransaction {
    pub kind: String,   // "transfer", "mint", "burn", "approve", "send", "receive"
    pub amount: String, // Transaction amount
    pub to: String,     // Destination address/principal
    pub timestamp: u64, // Transaction timestamp
    pub symbol: String,
}

impl ICWalletService {
    pub(super) fn new(agent: Arc<Agent>) -> Self {
        Self {
            ic_agent: agent,
            // http_client: client,
        }
    }
    // send function for account id ICP Only
    pub async fn icp_account_id_send(&self, to: String, amount: u128, memo : Option<u64>) -> anyhow::Result<u64> {
        let account_id = AccountIdentifier::from_hex(&to).map_err(|mssg| Error::msg(mssg))?;

        let args = TransferArgs {
            memo: memo.map_or(Memo(0), |m| Memo(m)),
            amount: Tokens::from_e8s(amount.try_into().unwrap()),
            fee: DEFAULT_FEE,
            from_subaccount: None,
            to: account_id,
            created_at_time: None,
        };

        let result = self
            .ic_agent
            .update(&MAINNET_LEDGER_CANISTER_ID, "transfer")
            .with_arg(Encode!(&args)?)
            .call_and_wait()
            .await?;

        let (transfer_result,): (Result<BlockIndex, TransferError>,) = decode_args(&result)?;


        if transfer_result.is_err() {
            let err = transfer_result.unwrap_err();
            let message = format!("Transfer Error: {}", err);
            return Err(Error::msg(message));
        }

        Ok(transfer_result.unwrap())
    }

    pub async fn send(&self, token: &WalletToken, to: String, amount: u128) -> anyhow::Result<u64> {
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
        let token_canister = self
            .ic_agent
            .update(&canister_id, "icrc1_transfer")
            .with_arg(Encode!(&transfer_args)?);

        // Execute the transfer
        let result = token_canister
            .call_and_wait()
            .await
            .map_err(|err| Error::msg(format!("Transfer failed: {}", err)))?;

        let (transfer_result,): (Result<Nat, TransferError>,) = decode_args(&result).unwrap();

        match transfer_result {
            std::result::Result::Ok(block_index) => {
                // Convert Nat to u64
                let block: u64 = block_index.0.try_into()?;
                Ok(block)
            }
            Err(e) => Err(Error::msg(format!("Transfer error: {:?}", e))),
        }
    }

    /// Approves another account (spender) to spend tokens on behalf of the caller
    pub async fn approve(
        &self,
        token: &WalletToken,
        spender: String,
        amount: u128,
        expires_at: Option<u64>,
    ) -> anyhow::Result<u64> {
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
            expires_at,
            created_at_time: None, // Let the ledger set the timestamp
        };

        // Get the token's canister ID from the token address
        let canister_id = Principal::from_text(&token.token_address)
            .map_err(|err| Error::msg(format!("Invalid canister ID: {}", err)))?;

        // Create an actor to interact with the token's canister
        let token_canister = self
            .ic_agent
            .update(&canister_id, "icrc2_approve")
            .with_arg(Encode!(&approve_args)?);

        // Execute the approval
        let result = token_canister
            .call_and_wait()
            .await
            .map_err(|err| Error::msg(format!("Approval failed: {}", err)))?;

        let (approve_result,): (Result<Nat, ApproveError>,) = decode_args(&result).unwrap();

        match approve_result {
            std::result::Result::Ok(block_index) => {
                // Convert Nat to u64
                let block: u64 = block_index.0.try_into()?;
                Ok(block)
            }
            Err(e) => Err(Error::msg(format!("Approval error: {:?}", e))),
        }
    }

    /// Checks if a spender is approved for a certain amount
    pub async fn get_allowance(
        &self,
        token: &WalletToken,
        owner: String,
        spender: String,
    ) -> anyhow::Result<AllowanceResponse> {
        let owner_account = Account::from_str(&owner)?;
        let spender_account = Account::from_str(&spender)?;

        let canister_id = Principal::from_text(&token.token_address)?;

        let allowance_args = AllowanceArgs {
            account: owner_account,
            spender: spender_account,
        };

        let token_canister = self
            .ic_agent
            .query(&canister_id, "icrc2_allowance")
            .with_arg(Encode!(&allowance_args)?);

        let result = token_canister
            .call()
            .await
            .map_err(|err| Error::msg(format!("Failed to get allowance: {}", err)))?;

        let (allowance,): (Allowance,) = decode_args(&result)?;

        Ok(AllowanceResponse {
            allowance: allowance.allowance.0.try_into()?,
            expires_at: allowance.expires_at,
        })
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_collection_service(&self) -> anyhow::Result<ICCollectionService> {
        let service = ICCollectionService::new(self.ic_agent.clone());

        anyhow::Ok(service)
    }
    /// Gets the balance of an account for a specific token
    pub async fn get_balance(&self, token: &WalletToken, account: String) -> anyhow::Result<u128> {
        // Parse the account string into an Account type
        let account = Account::from_str(&account)?;

        // Get the token's canister ID
        let canister_id = Principal::from_text(&token.token_address)
            .map_err(|err| Error::msg(format!("Invalid canister ID: {}", err)))?;

        // Create the query to the token's canister
        let token_canister = self
            .ic_agent
            .query(&canister_id, "icrc1_balance_of")
            .with_arg(Encode!(&account)?);

        // Execute the balance query
        let result = token_canister
            .call()
            .await
            .map_err(|err| Error::msg(format!("Failed to get balance: {}", err)))?;

        // Decode the result
        let (balance,): (Nat,) = decode_args(&result)?;

        // Convert from Nat to u128
        Ok(balance.0.try_into()?)
    }

    pub async fn swap_quote(
        &self,
        pay_token: &WalletToken,
        receive_token: &WalletToken,
        pay_amount: u128,
    ) -> anyhow::Result<QuoteResponse> {
        let swap_id = Principal::from_str(KONG_SWAP_ID)?;
        let swap_service = KongSwapService::new(self.ic_agent.clone(), swap_id);
        let result = swap_service
            .get_swap_amounts(
                pay_token.symbol.clone(),
                Nat::from(pay_amount),
                receive_token.symbol.clone(),
            )
            .await?;


       
        let mut total_pay_amount = Nat::from(0u64);

        result.txs.iter().for_each(|tx| {
            
            total_pay_amount += tx.gas_fee.clone() + tx.lp_fee.clone();
        });

        debug!("Total Pay Amount: {:?}", total_pay_amount);


        let quote = QuoteResponse {
            receive_token_address: result.receive_address,
            slippage: result.slippage,
            tx_count: result.txs.len(),
            mid_price: result.mid_price,
            receive_amount: result.receive_amount.0.try_into()?,
            estimated_fee_amount: total_pay_amount.0.try_into()?,
        };

        
        Ok(quote)
    }

    pub async fn swap(&self, pay_token: &WalletToken, receive_token: &WalletToken, pay_amount: u128, slippage: Option<f64>) -> anyhow::Result<SwapResponse> {
        let swap_id = Principal::from_str(KONG_SWAP_ID)?;
        let swap_service = KongSwapService::new(self.ic_agent.clone(), swap_id);
        let swap_args = SwapArgs {
            receive_token: receive_token.symbol.clone(),
            pay_amount: Nat::from(pay_amount),
            receive_amount: None, //Some(Nat::from(receive_amount)),
            max_slippage: slippage,
            referred_by: None,
            receive_address: None,
            pay_token: pay_token.symbol.clone(),
            pay_tx_id: None,
        };
        let result = swap_service.swap(swap_args).await?;

       

        let swap_response = SwapResponse {
            tx_id: result.tx_id,
            status: result.status,
            pay_symbol: result.pay_symbol,
            receive_symbol: result.receive_symbol,
            pay_amount: result.pay_amount.0.try_into()?,
            receive_amount: result.receive_amount.0.try_into()?,
        };

        Ok(swap_response)
    }

    fn create_index_service(&self, index_canister: &String) -> anyhow::Result<IcIndexService> {
        let principal = Principal::from_text(index_canister)?;
        Ok(IcIndexService::new(self.ic_agent.clone(), principal))
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_canister_info_service(&self) -> anyhow::Result<ICCanisterInfoService> {
        let service = ICCanisterInfoService::new(self.ic_agent.clone());
        Ok(service)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_cycles_service(&self) -> anyhow::Result<CyclesService> {
        let service = CyclesService::new(Principal::from_text(CYCLES_MINTING_CANISTER)?, self.ic_agent.clone());
        Ok(service)
    }

    pub async fn get_latest_transactions(
        &self,
        token: &WalletToken,
        account_addr: &str,
        max_results: Option<u32>,
    ) -> anyhow::Result<Vec<SimpleTransaction>> {
        if token.index_canister.is_none() {
            bail!("No Index Canister")
        }
        debug!("Native Domain");

        let account = Account::from_str(account_addr)?;
        let simple_tx: Vec<SimpleTransaction>;
        // if its ICP
        if token.token_address == "ryjl3-tyaaa-aaaaa-aaaba-cai" {
            let index_service = ICPLedgerIndexService::new(
                self.ic_agent.clone(),
                Principal::from_text(token.index_canister.as_ref().unwrap()).unwrap(),
            );
            let result = index_service
                .get_account_transactions(account, None, max_results)
                .await?;

            match result {
                GetAccountIdentifierTransactionsResult::Ok(txs) => {
                    simple_tx = txs
                        .transactions
                        .into_iter()
                        .filter_map(|tx| {
                            ICPLedgerIndexService::convert_to_simple_transaction(
                                tx,
                                account.to_string(),
                                token.token_decimal.unwrap_or(8),
                                &token.symbol.to_uppercase(),
                            )
                        })
                        .collect()
                }
                Err(mssg) => return Err(Error::msg(mssg.message)),
            }
        } else {
            let index_service =
                self.create_index_service(token.index_canister.as_ref().unwrap())?;

            // Get transactions from index service
            let result = index_service
                .get_transactions(account, None, max_results)
                .await?;

            match result {
                GetTransactionsResult::Ok(txs) => {
                    simple_tx = txs
                        .transactions
                        .into_iter()
                        .filter_map(|tx| {
                            IcIndexService::transaction_to_simple(
                                tx,
                                account.to_string(),
                                token.token_decimal.unwrap_or(8),
                                &token.symbol.to_uppercase(),
                            )
                        })
                        .collect();
                }
                GetTransactionsResult::Err(get_transactions_err) => {
                    return Err(Error::msg(get_transactions_err.message))
                }
            }
        }

        Ok(simple_tx)
        // Create index service for the token
    }

    pub async fn get_token(
        &self,
        canister_id: &str,
        index_canister: Option<String>,
    ) -> anyhow::Result<WalletToken> {
        let token_principal = Principal::from_text(canister_id)?;

        if index_canister.is_some() {
            let d = index_canister.as_ref().unwrap();
            let is_verified = self.verify_index(canister_id, d).await?;
            if !is_verified {
                bail!("The Index Canister is not for the token.")
            }
        }

        let metadata_response = self
            .ic_agent
            .query(&token_principal, "icrc1_metadata")
            .with_arg(encode_args(()).unwrap())
            .call()
            .await?;

        let (metadata_list,): (Vec<(String, MetadataValue)>,) = decode_args(&metadata_response)?;

        let token_metadata = TokenMetadata::from_metadata_records(metadata_list);

        // let token = self.create_wallet_token(canister_id, token_metadata);
        let token = WalletToken {
            symbol: token_metadata.symbol,
            network: WalletTokenNetWork::InternetComputer,
            token_address: canister_id.to_string(),
            token_decimal: Some(token_metadata.decimals as u8),
            image_url: token_metadata.logo,
            token_name: token_metadata.name,
            index_canister,
            transfer_fee: token_metadata.fee.0.try_into().unwrap(),
            gov_canister: None,
        };

        Ok(token)
    }

    async fn verify_index(&self, ledger_id: &str, index: &str) -> anyhow::Result<bool> {
        let index_canister = self.create_index_service(&index.to_string())?;
        let ledger = index_canister.ledger_id().await?;
        if ledger.to_text() == ledger_id {
            Ok(true)
        } else {
            Ok(false)
        }
    }
}
