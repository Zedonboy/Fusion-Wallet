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

// This is an experimental feature to generate Rust binding from Candid.
// You may want to manually adjust some of the types.

use candid::{CandidType, Deserialize, Principal};
use ic_cdk::api::call::CallResult;

#[derive(CandidType, Deserialize)]
pub struct SubnetFilter { pub subnet_type: Option<String> }

#[derive(CandidType, Deserialize)]
pub enum SubnetSelection { Filter(SubnetFilter), Subnet{ subnet: Principal } }

#[derive(CandidType, Deserialize)]
pub enum LogVisibility {
  #[serde(rename="controllers")]
  Controllers,
  #[serde(rename="public")]
  Public,
}

#[derive(CandidType, Deserialize)]
pub struct CanisterSettings {
  pub freezing_threshold: Option<candid::Nat>,
  pub wasm_memory_threshold: Option<candid::Nat>,
  pub controllers: Option<Vec<Principal>>,
  pub reserved_cycles_limit: Option<candid::Nat>,
  pub log_visibility: Option<LogVisibility>,
  pub wasm_memory_limit: Option<candid::Nat>,
  pub memory_allocation: Option<candid::Nat>,
  pub compute_allocation: Option<candid::Nat>,
}

#[derive(CandidType, Deserialize)]
pub struct CreateCanisterArg {
  pub subnet_selection: Option<SubnetSelection>,
  pub settings: Option<CanisterSettings>,
  pub subnet_type: Option<String>,
}

#[derive(CandidType, Deserialize)]
pub enum CreateCanisterError {
  Refunded{ create_error: String, refund_amount: candid::Nat },
}

#[derive(CandidType, Deserialize)]
pub enum CreateCanisterResult { Ok(Principal), Err(CreateCanisterError) }



pub type BlockIndex = u64;
#[derive(CandidType, Deserialize)]
pub struct NotifyCreateCanisterArg {
  pub controller: Principal,
  pub block_index: BlockIndex,
  pub subnet_selection: Option<SubnetSelection>,
  pub settings: Option<CanisterSettings>,
  pub subnet_type: Option<String>,
}

#[derive(CandidType, Deserialize, Debug)]
pub enum NotifyError {
  Refunded{ block_index: Option<BlockIndex>, reason: String },
  InvalidTransaction(String),
  Other{ error_message: String, error_code: u64 },
  Processing,
  TransactionTooOld(BlockIndex),
}

#[derive(CandidType, Deserialize)]
pub enum NotifyCreateCanisterResult { Ok(Principal), Err(NotifyError) }

#[derive(CandidType, Deserialize)]
pub struct NotifyMintCyclesSuccess {
  pub balance: candid::Nat,
  pub block_index: candid::Nat,
  pub minted: candid::Nat,
}

#[derive(CandidType, Deserialize)]
pub enum NotifyMintCyclesResult {
  Ok(NotifyMintCyclesSuccess),
  Err(NotifyError),
}

#[derive(CandidType, Deserialize)]
pub struct NotifyTopUpArg {
  pub block_index: BlockIndex,
  pub canister_id: Principal,
}

pub type Cycles = candid::Nat;
#[derive(CandidType, Deserialize)]
pub enum NotifyTopUpResult { Ok(Cycles), Err(NotifyError) }

pub struct Service(pub Principal);
impl Service {
  // pub async fn create_canister(&self, arg0: CreateCanisterArg) -> CallResult<
  //   (CreateCanisterResult,)
  // > { ic_cdk::call(self.0, "create_canister", (arg0,)).await }

  pub async fn notify_create_canister(
    &self,
    arg0: NotifyCreateCanisterArg,
  ) -> CallResult<(Result<Principal, NotifyError>,)> {
    ic_cdk::call(self.0, "notify_create_canister", (arg0,)).await
  }
}
