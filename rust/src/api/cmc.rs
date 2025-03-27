
use std::sync::Arc;

use candid::{self, CandidType, Decode, Deserialize, Encode, Nat, Principal};
use flutter_rust_bridge::frb;
use ic_agent::Agent;
use icrc_ledger_types::icrc1::transfer::Memo as ICRCMemo;
use icrc_ledger_types::icrc1::account::Subaccount as ICRCSubaccount;

use super::constants::CYCLES_LEDGER;

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum ExchangeRateCanister { Set(Principal), Unset }


#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct SubnetFilter { subnet_type: Option<String> }

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum SubnetSelection { Filter(SubnetFilter), Subnet{ subnet: Principal } }

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum LogVisibility {
  #[serde(rename="controllers")]
  Controllers,
  #[serde(rename="public")]
  Public,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct CanisterSettings {
  freezing_threshold: Option<candid::Nat>,
  wasm_memory_threshold: Option<candid::Nat>,
  controllers: Option<Vec<Principal>>,
  reserved_cycles_limit: Option<candid::Nat>,
  log_visibility: Option<LogVisibility>,
  wasm_memory_limit: Option<candid::Nat>,
  memory_allocation: Option<candid::Nat>,
  compute_allocation: Option<candid::Nat>,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct CreateCanisterArg {
  subnet_selection: Option<SubnetSelection>,
  settings: Option<CanisterSettings>,
  subnet_type: Option<String>,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum CreateCanisterError {
  Refunded{ create_error: String, refund_amount: candid::Nat },
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum CreateCanisterResult { Ok(Principal), Err(CreateCanisterError) }

#[derive(CandidType, Deserialize)]
pub struct IcpXdrConversionRate {
  pub xdr_permyriad_per_icp: u64,
  pub timestamp_seconds: u64,
}

#[derive(CandidType, Deserialize)]
pub struct IcpXdrConversionRateResponse {
  pub certificate: Vec<u8>,
  pub data: IcpXdrConversionRate,
  pub hash_tree: Vec<u8>,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct PrincipalsAuthorizedToCreateCanistersToSubnetsResponse {
  data: Vec<(Principal,Vec<Principal>,)>,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct SubnetTypesToSubnetsResponse {
  data: Vec<(String,Vec<Principal>,)>,
}

#[frb(ignore)]
type BlockIndex = u64;
#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct NotifyCreateCanisterArg {
  controller: Principal,
  block_index: BlockIndex,
  subnet_selection: Option<SubnetSelection>,
  settings: Option<CanisterSettings>,
  subnet_type: Option<String>,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize, Debug)]
enum NotifyError {
  Refunded{ block_index: Option<BlockIndex>, reason: String },
  InvalidTransaction(String),
  Other{ error_message: String, error_code: u64 },
  Processing,
  TransactionTooOld(BlockIndex),
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum NotifyCreateCanisterResult { Ok(Principal), Err(NotifyError) }


#[frb(ignore)]
type Subaccount = Option<Vec<u8>>;

#[frb(ignore)]
type Memo = Option<Vec<u8>>;

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct NotifyMintCyclesArg {
  block_index: BlockIndex,
  deposit_memo: Memo,
  to_subaccount: Option<ICRCSubaccount>,
}

pub struct MintSuccess {
  pub balance: u64,
  pub block_index: u64,
  pub minted: u128,
}


#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct NotifyMintCyclesSuccess {
  balance: candid::Nat,
  block_index: candid::Nat,
  minted: candid::Nat,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum NotifyMintCyclesResult {
  Ok(NotifyMintCyclesSuccess),
  Err(NotifyError),
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct NotifyTopUpArg {
  block_index: BlockIndex,
  canister_id: Principal,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize)]
struct WithdrawArgs {
  to: Principal,
  from_subaccount: Option<Vec<u8>>,
  created_at_time: Option<u64>,
  amount: candid::Nat,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize, Debug)]
enum RejectionCode {
  NoError,
  CanisterError,
  SysTransient,
  DestinationInvalid,
  Unknown,
  SysFatal,
  CanisterReject,
}

#[frb(ignore)]
#[derive(CandidType, Deserialize, Debug)]
enum WithdrawError {
  FailedToWithdraw{
    rejection_code: RejectionCode,
    fee_block: Option<candid::Nat>,
    rejection_reason: String,
  },
  GenericError{ message: String, error_code: candid::Nat },
  TemporarilyUnavailable,
  Duplicate{ duplicate_of: candid::Nat },
  BadFee{ expected_fee: candid::Nat },
  InvalidReceiver{ receiver: Principal },
  CreatedInFuture{ ledger_time: u64 },
  TooOld,
  InsufficientFunds{ balance: candid::Nat },
}

#[frb(ignore)]
type Cycles = candid::Nat;
#[frb(ignore)]
#[derive(CandidType, Deserialize)]
enum NotifyTopUpResult { Ok(Cycles), Err(NotifyError) }

pub struct CyclesService {
    canister_id: Principal,
    agent: Arc<Agent>,
}

impl CyclesService {

    #[frb(ignore)]
    pub fn new(canister_id: Principal, agent: Arc<Agent>) -> Self {
        Self { canister_id, agent }
    }

    #[frb(ignore)]
  async fn create_canister(&self, arg0: CreateCanisterArg) -> anyhow::Result<CreateCanisterResult> {
    let response = self.agent.query(&self.canister_id, "create_canister")
        .with_arg(candid::encode_one(arg0)?)
        .call()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  #[frb(ignore)]
  async fn get_build_metadata(&self) -> anyhow::Result<String> {
    let response = self.agent.query(&self.canister_id, "get_build_metadata")
        .with_arg(candid::encode_args(())?)
        .call()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  #[frb(ignore)]
  async fn get_default_subnets(&self) -> anyhow::Result<Vec<Principal>> {
    let response = self.agent.query(&self.canister_id, "get_default_subnets")
        .with_arg(candid::encode_args(())?)
        .call()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  pub async fn get_icp_xdr_conversion_rate(&self) -> anyhow::Result<IcpXdrConversionRateResponse> {
    let response = self.agent.query(&self.canister_id, "get_icp_xdr_conversion_rate")
        .with_arg(candid::encode_args(())?)
        .call()
        .await?;
    let result = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  #[frb(ignore)]
  async fn get_principals_authorized_to_create_canisters_to_subnets(
    &self,
  ) -> anyhow::Result<PrincipalsAuthorizedToCreateCanistersToSubnetsResponse> {
    let response = self.agent.query(&self.canister_id, "get_principals_authorized_to_create_canisters_to_subnets")
        .with_arg(candid::encode_args(())?)
        .call()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  #[frb(ignore)]
  async fn get_subnet_types_to_subnets(&self) -> anyhow::Result<SubnetTypesToSubnetsResponse> {
    let response = self.agent.query(&self.canister_id, "get_subnet_types_to_subnets")
        .with_arg(candid::encode_args(())?)
        .call()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  #[frb(ignore)]
  async fn notify_create_canister(
    &self,
    arg0: NotifyCreateCanisterArg,
  ) -> anyhow::Result<NotifyCreateCanisterResult> {
    let response = self.agent.update(&self.canister_id, "notify_create_canister")
        .with_arg(candid::encode_one(arg0)?)
        .call_and_wait()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  pub async fn notify_mint_cycles(&self, block_index: u64, deposit_memo: Option<u64>, to_subaccount: Option<[u8; 32]>) -> anyhow::Result<MintSuccess> {
    let arg0 = NotifyMintCyclesArg {
      block_index,
      deposit_memo: deposit_memo.map(|m| ICRCMemo::from(m).0.to_vec()),
      to_subaccount: to_subaccount.map(|s| ICRCSubaccount::from(s)),
    };
    let response = self.agent.update(&self.canister_id, "notify_mint_cycles")
        .with_arg(candid::encode_one(arg0)?)
        .call_and_wait()
        .await?;
    let result : Result<NotifyMintCyclesSuccess, NotifyError> = candid::decode_one(response.as_slice())?;

    let mint_result = match result {
      Ok(success) => MintSuccess {
        balance: success.balance.0.to_string().parse::<u64>().unwrap(),
        block_index: success.block_index.0.to_string().parse::<u64>().unwrap(),
        minted: success.minted.0.to_string().parse::<u128>().unwrap(),
      },
      Err(error) => return Err(anyhow::anyhow!("Error minting cycles: {:?}", error)),
    };
    Ok(mint_result)
  }

  #[frb(ignore)]
  async fn notify_top_up(&self, arg0: NotifyTopUpArg) -> anyhow::Result<NotifyTopUpResult> {
    let response = self.agent.update(&self.canister_id, "notify_top_up")
        .with_arg(candid::encode_one(arg0)?)
        .call_and_wait()
        .await?;
    let (result,) = candid::decode_one(response.as_slice())?;
    Ok(result)
  }

  pub async fn withdraw(&self, to: String, amount: u128, from_subaccount: Option<Vec<u8>>) -> anyhow::Result<u64> {
    let recipient = Principal::from_text(to)?;
    let ledger = Principal::from_text(CYCLES_LEDGER)?;
    let response = self.agent.update(&ledger, "withdraw")
        .with_arg(candid::encode_one(WithdrawArgs {
          to: recipient,
          from_subaccount,
          created_at_time: None,
          amount: candid::Nat::from(amount),
        })?)
        .call_and_wait()
        .await?;
    let result : Result<Nat, WithdrawError> = candid::decode_one(response.as_slice())?;

    let block_index = result.map_err(|e| anyhow::anyhow!("Error withdrawing: {:?}", e))?;
    Ok(block_index.0.try_into().unwrap())
  }
  
}

#[cfg(test)]
mod tests {
    use crate::api::constants::CYCLES_MINTING_CANISTER;

    use super::*;

    #[tokio::test]
    async fn test_create_canister() {
        let agent = Agent::builder().with_url("https://ic0.app").build().unwrap();
        let service = CyclesService::new(Principal::from_text(CYCLES_MINTING_CANISTER).unwrap(), Arc::new(agent));
        let result = service.get_icp_xdr_conversion_rate().await.unwrap();
        assert!(result.data.xdr_permyriad_per_icp > 0);
        println!("XDR per myriad per ICP: {:?}", result.data.xdr_permyriad_per_icp);
    }
}
