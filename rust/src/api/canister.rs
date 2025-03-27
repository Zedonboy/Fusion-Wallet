use std::sync::Arc;

use anyhow::Ok;
use candid::{encode_args, CandidType, Principal};
use flutter_rust_bridge::frb;
use ic_agent::Agent;
use ic_utils::{call::SyncCall, interfaces::{management_canister::MgmtMethod, ManagementCanister}};
use serde::{Deserialize, Serialize};


#[frb(json_serializable)]
#[derive(Debug)]
pub struct CanisterMetric {
    pub memory_size: u64,
    pub cycles_balance: u128,
    pub status: String,
    pub canister_id: String,
    pub total_calls: u64,
    pub total_outbound_bytes: u64,
    pub total_inbound_bytes: u64
}


pub struct ICCanisterInfoService {
    ic_agent: Arc<Agent>
}


impl ICCanisterInfoService {

    #[frb(ignore)]
    pub fn new(agent : Arc<Agent>) -> Self {
        Self { ic_agent: agent }
    }

    pub async fn get_canister_status(&self, canister_id: &str) -> anyhow::Result<CanisterMetric> {
        let management = ManagementCanister::create(&self.ic_agent);
        let canister_idx = Principal::from_text(canister_id)?;
        let (status,) = management.canister_status(&canister_idx).await?; 

        let query_stats = status.query_stats;

        let canister_metric = CanisterMetric {
            memory_size: status.memory_size.0.try_into().unwrap(),
            cycles_balance: status.cycles.0.try_into().unwrap(),
            status: status.status.to_string(),
            canister_id: canister_id.to_string(),
            total_calls: query_stats.num_calls_total.0.try_into().unwrap(),
            total_outbound_bytes: query_stats.response_payload_bytes_total.0.try_into().unwrap(),
            total_inbound_bytes: query_stats.request_payload_bytes_total.0.try_into().unwrap()
        };

        Ok(canister_metric)
        // let result = self.ic_agent.
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_is_controller() {
        let agent = Agent::builder().with_url("https://ic0.app").build().unwrap();
        let canister_info_service = ICCanisterInfoService::new(Arc::new(agent));
        let result = canister_info_service.get_canister_status("oj6if-riaaa-aaaaq-aaeha-cai").await;
        println!("{:?}", result);
    }
}