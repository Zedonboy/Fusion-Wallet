use std::sync::Arc;

use candid::{decode_args, encode_args, CandidType, Principal};
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};

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

 const NOTIFICATION_CANISTER_ID: &str = "britu-mqaaa-aaaam-aeknq-cai";
 pub struct NotificationService {
     ic_agent: Arc<ic_agent::Agent>,
 }

#[derive(Clone, Debug, CandidType, Deserialize, Serialize)]
pub struct AppInfo {
    pub domain: Option<String>,
    pub name: Option<String>,
    pub icon_url: Option<String>,
    pub canister_id: String,
}



#[derive(Clone, Debug, CandidType, Serialize, Deserialize)]
struct CanisterPermissionInfo {
    canister_id: Principal,
    enabled: bool,
    app_info: AppInfo,
}

#[frb]
pub struct CanisterPermission {
    pub canister_id: String,
    #[frb(non_final)]
    pub enabled: bool,
    pub app_info: AppInfo,
}



 impl NotificationService {
    #[frb(ignore)]
    pub fn new(ic_agent : Arc<ic_agent::Agent>) -> Self {
        
        Self { ic_agent }
    }

    pub async fn add_device_token(&self,token : String) -> anyhow::Result<()> {
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        // make calls to ic
        self.ic_agent.update(&canister_id, "add_device_token")
            .with_arg(encode_args((token,))?)
            .call_and_wait()
            .await?;
        Ok(())
    }

    pub async fn remove_device_token(&self, token : String) -> anyhow::Result<()> {
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        self.ic_agent.update(&canister_id, "remove_device_token")
            .with_arg(encode_args((token,))?)
            .call_and_wait()
            .await?;
        Ok(())
    }

    pub async fn get_canister_permissions(&self) -> anyhow::Result<Vec<CanisterPermission>> {
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        let result = self.ic_agent.query(&canister_id, "get_canister_permissions")
        .with_arg(encode_args(())?).await?;
        let (permissions,): (Vec<CanisterPermissionInfo>,) = decode_args(&result)?;
        Ok(permissions.into_iter().map(|p| CanisterPermission {
            canister_id: p.canister_id.to_text(),
            enabled: p.enabled,
            app_info: p.app_info,
        }).collect())
    }

    pub async fn update_app_permission(&self, app_id : String, permission : bool) -> anyhow::Result<()> {
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        self.ic_agent.update(&canister_id, "update_app_permission")
            .with_arg(encode_args((app_id, permission))?)
            .call_and_wait()
            .await?;
        Ok(())
    }

    pub async fn remove_app_permission(&self, app_id : String) -> anyhow::Result<()> {
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        self.ic_agent.update(&canister_id, "remove_app_permission")
            .with_arg(encode_args((app_id,))?)
            .call_and_wait()
            .await?;
        Ok(())
    }

    pub async fn add_app_permission(&self, app_id : String, domain : Option<String>, name : Option<String>, icon_url : Option<String>) -> anyhow::Result<()> {
        let app_info = AppInfo {
            domain,
            name,
            icon_url,
            canister_id: app_id.clone(),
        };
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        self.ic_agent.update(&canister_id, "add_app_permission")
            .with_arg(encode_args((app_id, app_info))?)
            .call_and_wait()
            .await?;
        Ok(())
    }

    pub async fn send_transfer_message(&self, ledger_canister_id : String, block_height : u64) -> anyhow::Result<()> {
        let canister_id = Principal::from_text(NOTIFICATION_CANISTER_ID)?;
        self.ic_agent.update(&canister_id, "send_transfer_message")
            .with_arg(encode_args((ledger_canister_id, block_height))?)
            .call_and_wait()
            .await?;
        Ok(())
    }
 }
 