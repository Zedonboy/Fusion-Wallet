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


use std::sync::Arc;

use reqwest::Client;
use serde_json::Value;

use super::{wallet::WalletToken};
use serde::{Deserialize, Serialize};
use anyhow::Result;


#[derive(Debug, Serialize, Deserialize)]
pub struct GithubRelease {
    pub tag_name: String,
    pub html_url: String,
    pub body: Option<String>,
}
pub struct HttpWalletService {
    http_client: Arc<Client>
}

impl HttpWalletService {
    pub(super) fn new(client : Arc<Client>) -> Self {
        Self { http_client: client }
    }

    pub async fn get_price(&self, token: &WalletToken) -> Option<f32> {
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
            Err(_) => return None,
        };

        let json: Value = match http_result.json().await {
            Result::Ok(j) => j,
            Err(_) => return None,
        };

        match json.get("data").and_then(|d| d.get("amount")) {
            Some(amount) => {
                let amount_str = amount.as_str().unwrap_or("");
                match amount_str.parse::<f32>() {
                    Result::Ok(num) => Some(num),
                    Err(_) => None,
                }
            }
            None => None,
        }
    }


    pub async fn get_latest_release(&self) -> Result<GithubRelease> {
        
        let url = "https://api.github.com/repos/zedonboy/Fusion-Wallet/releases/latest";
    
        let response = self.http_client
            .get(url)
            .header("Accept", "application/vnd.github+json")
            .header("X-GitHub-Api-Version", "2022-11-28")
            .header("User-Agent", "reqwest") // GitHub API requires User-Agent
            .send()
            .await?;
    
        if !response.status().is_success() {
            let status = response.status();
            let text = response.text().await?;
            anyhow::bail!("GitHub API request failed: {} - {}", status, text);
        }
    
        let release: GithubRelease = response.json().await?;
        Ok(release)
    }

}