use std::sync::Arc;

use candid::{decode_args, encode_one, Decode, Encode, Nat, Principal, CandidType, Deserialize};
use flutter_rust_bridge::frb;
use ic_agent::Agent;

use super::wallet::WalletToken;

#[derive(CandidType, Deserialize, Clone)]
pub(super) struct SwapArgs {
    pub(super) receive_token: String,
    pub(super) max_slippage: Option<f64>,
    pub(super) pay_amount: Nat,
    pub(super) referred_by: Option<String>,
    pub(super) receive_amount: Option<Nat>,
    pub(super) receive_address: Option<String>,
    pub(super) pay_token: String,
    pub(super) pay_tx_id: Option<TxId>,
}

#[derive(CandidType, Deserialize, Clone)]
pub(super) enum TxId {
    TransactionId(String),
    BlockIndex(Nat),
}

#[derive(CandidType, Deserialize)]
pub(super) struct SwapTxReply {
    pub(super) ts: u64,
    pub(super) receive_chain: String,
    pub(super) pay_amount: Nat,
    pub(super) receive_amount: Nat,
    pub(super) pay_symbol: String,
    pub(super) receive_symbol: String,
    pub(super) receive_address: String,
    pub(super) pool_symbol: String,
    pub(super) pay_address: String,
    pub(super) price: f64,
    pub(super) pay_chain: String,
    pub(super) lp_fee: Nat,
    pub(super) gas_fee: Nat,
}

#[derive(CandidType, Deserialize)]
pub(super) struct SwapReply {
    pub(super) ts: u64,
    pub(super) txs: Vec<SwapTxReply>,
    pub(super) request_id: u64,
    pub(super) status: String,
    pub(super) tx_id: u64,
    pub(super) transfer_ids: Vec<TransferIdReply>,
    pub(super) receive_chain: String,
    pub(super) mid_price: f64,
    pub(super) pay_amount: Nat,
    pub(super) receive_amount: Nat,
    pub(super) claim_ids: Vec<u64>,
    pub(super) pay_symbol: String,
    pub(super) receive_symbol: String,
    pub(super) receive_address: String,
    pub(super) pay_address: String,
    pub(super) price: f64,
    pub(super) pay_chain: String,
    pub(super) slippage: f64,
}

#[derive(CandidType, Deserialize)]
pub(super) struct TransferIdReply {
    pub(super) transfer_id: u64,
    pub(super) transfer: TransferReply,
}

#[derive(CandidType, Deserialize)]
pub(super) enum TransferReply {
    Ic(IcTransferReply),
}

#[derive(CandidType, Deserialize)]
pub(super) struct IcTransferReply {
    pub(super) is_send: bool,
    pub(super) block_index: Nat,
    pub(super) chain: String,
    pub(super) canister_id: String,
    pub(super) amount: Nat,
    pub(super) symbol: String,
}

pub(super) struct ICSwapService {
    ic_agent: Arc<Agent>,
    swap_canister_id: Principal,
}

impl ICSwapService {
    pub(super) fn new(ic_agent: Arc<Agent>, swap_canister_id: Principal) -> Self {
        Self {
            ic_agent,
            swap_canister_id,
        }
    }

    pub(super) async fn swap(&self, args: SwapArgs) -> anyhow::Result<SwapReply> {
        // Create an actor to interact with the swap canister
        let swap_canister = self.ic_agent.update(
            &self.swap_canister_id,
            "swap"
        ).with_arg(Encode!(&args)?);

        // Execute the swap
        let result = swap_canister
            .call_and_wait()
            .await
            .map_err(|err| anyhow::Error::msg(format!("Swap failed: {}", err)))?;

        let (swap_result,): (Result<SwapReply, String>,) = decode_args(&result)?;

        match swap_result {
            Ok(reply) => Ok(reply),
            Err(e) => Err(anyhow::Error::msg(format!("Swap anyhow::Error: {}", e)))
        }
    }

    pub(super) async fn get_swap_amounts(
        &self,
        pay_token: String,
        pay_amount: Nat,
        receive_token: String
    ) -> anyhow::Result<SwapAmountsReply> {
        let swap_canister = self.ic_agent.query(
            &self.swap_canister_id,
            "swap_amounts"
        ).with_arg(Encode!(&(pay_token, pay_amount, receive_token))?);

        let result = swap_canister
            .call()
            .await
            .map_err(|err| anyhow::Error::msg(format!("Failed to get swap amounts: {}", err)))?;

        let (amounts_result,): (Result<SwapAmountsReply, String>,) = decode_args(&result)?;

        match amounts_result {
            Ok(reply) => Ok(reply),
            Err(e) => Err(anyhow::Error::msg(format!("anyhow::Error getting swap amounts: {}", e)))
        }
    }

    pub(super) async fn get_pools(&self, filter_token: Option<String>) -> anyhow::Result<PoolsReply> {
        let pools_canister = self.ic_agent.query(
            &self.swap_canister_id,
            "pools"
        ).with_arg(Encode!(&filter_token)?);

        let result = pools_canister
            .call()
            .await
            .map_err(|err| anyhow::Error::msg(format!("Failed to get pools: {}", err)))?;

        let (pools_result,): (Result<PoolsReply, String>,) = decode_args(&result)?;

        match pools_result {
            Ok(reply) => Ok(reply),
            Err(e) => Err(anyhow::Error::msg(format!("anyhow::Error getting pools: {}", e)))
        }
    }

    pub(super) async fn get_tokens(&self, filter_symbol: Option<String>) -> anyhow::Result<Vec<TokenReply>> {
        let tokens_canister = self.ic_agent.query(
            &self.swap_canister_id,
            "tokens"
        ).with_arg(Encode!(&filter_symbol)?);

        let result = tokens_canister
            .call()
            .await
            .map_err(|err| anyhow::Error::msg(format!("Failed to get tokens: {}", err)))?;

        let (tokens_result,): (Result<Vec<TokenReply>, String>,) = decode_args(&result)?;

        match tokens_result {
            Ok(reply) => Ok(reply),
            Err(e) => Err(anyhow::Error::msg(format!("anyhow::Error getting tokens: {}", e)))
        }
    }

    pub(super) async fn get_user_balances(&self, principal_id: String) -> anyhow::Result<Vec<UserBalancesReply>> {
        let balances_canister = self.ic_agent.query(
            &self.swap_canister_id,
            "user_balances"
        ).with_arg(Encode!(&principal_id)?);

        let result = balances_canister
            .call()
            .await
            .map_err(|err| anyhow::Error::msg(format!("Failed to get user balances: {}", err)))?;

        let (balances_result,): (Result<Vec<UserBalancesReply>, String>,) = decode_args(&result)?;

        match balances_result {
            Ok(reply) => Ok(reply),
            Err(e) => Err(anyhow::Error::msg(format!("anyhow::Error getting user balances: {}", e)))
        }
    }
}

// Additional types needed for the service
#[derive(CandidType, Deserialize)]
pub(super) struct SwapAmountsReply {
    pub(super) txs: Vec<SwapAmountsTxReply>,
    pub(super) receive_chain: String,
    pub(super) mid_price: f64,
    pub(super) pay_amount: Nat,
    pub(super) receive_amount: Nat,
    pub(super) pay_symbol: String,
    pub(super) receive_symbol: String,
    pub(super) receive_address: String,
    pub(super) pay_address: String,
    pub(super) price: f64,
    pub(super) pay_chain: String,
    pub(super) slippage: f64,
}

#[derive(CandidType, Deserialize)]
pub(super) struct SwapAmountsTxReply {
    pub(super) receive_chain: String,
    pub(super) pay_amount: Nat,
    pub(super) receive_amount: Nat,
    pub(super) pay_symbol: String,
    pub(super) receive_symbol: String,
    pub(super) receive_address: String,
    pub(super) pool_symbol: String,
    pub(super) pay_address: String,
    pub(super) price: f64,
    pub(super) pay_chain: String,
    pub(super) lp_fee: Nat,
    pub(super) gas_fee: Nat,
}

#[derive(CandidType, Deserialize)]
pub(super) struct PoolsReply {
    pub(super) total_24h_lp_fee: Nat,
    pub(super) total_tvl: Nat,
    pub(super) total_24h_volume: Nat,
    pub(super) pools: Vec<PoolReply>,
    pub(super) total_24h_num_swaps: Nat,
}

#[derive(CandidType, Deserialize)]
pub(super) struct PoolReply {
    pub(super) tvl: Nat,
    pub(super) lp_token_symbol: String,
    pub(super) name: String,
    pub(super) lp_fee_0: Nat,
    pub(super) lp_fee_1: Nat,
    pub(super) balance_0: Nat,
    pub(super) balance_1: Nat,
    pub(super) rolling_24h_volume: Nat,
    pub(super) rolling_24h_apy: f64,
    pub(super) address_0: String,
    pub(super) address_1: String,
    pub(super) rolling_24h_num_swaps: Nat,
    pub(super) symbol_0: String,
    pub(super) symbol_1: String,
    pub(super) pool_id: u32,
    pub(super) price: f64,
    pub(super) chain_0: String,
    pub(super) chain_1: String,
    pub(super) is_removed: bool,
    pub(super) symbol: String,
    pub(super) rolling_24h_lp_fee: Nat,
    pub(super) lp_fee_bps: u8,
}

#[derive(CandidType, Deserialize)]
pub(super) enum TokenReply {
    Ic(IcTokenReply),
    Lp(LpTokenReply),
}

#[derive(CandidType, Deserialize)]
pub(super) struct IcTokenReply {
    pub(super) fee: Nat,
    pub(super) decimals: u8,
    pub(super) token_id: u32,
    pub(super) chain: String,
    pub(super) name: String,
    pub(super) canister_id: String,
    pub(super) icrc1: bool,
    pub(super) icrc2: bool,
    pub(super) icrc3: bool,
    pub(super) is_removed: bool,
    pub(super) symbol: String,
}

#[derive(CandidType, Deserialize)]
pub(super) struct LpTokenReply {
    pub(super) fee: Nat,
    pub(super) decimals: u8,
    pub(super) token_id: u32,
    pub(super) chain: String,
    pub(super) name: String,
    pub(super) address: String,
    pub(super) pool_id_of: u32,
    pub(super) is_removed: bool,
    pub(super) total_supply: Nat,
    pub(super) symbol: String,
}

#[derive(CandidType, Deserialize)]
pub(super) enum UserBalancesReply {
    Lp(LpBalancesReply),
}

#[derive(CandidType, Deserialize)]
pub(super) struct LpBalancesReply {
    pub(super) ts: u64,
    pub(super) usd_balance: f64,
    pub(super) balance: f64,
    pub(super) name: String,
    pub(super) amount_0: f64,
    pub(super) amount_1: f64,
    pub(super) address_0: String,
    pub(super) address_1: String,
    pub(super) symbol_0: String,
    pub(super) symbol_1: String,
    pub(super) usd_amount_0: f64,
    pub(super) usd_amount_1: f64,
    pub(super) chain_0: String,
    pub(super) chain_1: String,
    pub(super) symbol: String,
}