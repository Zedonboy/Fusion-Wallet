use std::sync::Arc;

use anyhow::{bail, Ok};
use candid::{decode_args, encode_args, CandidType, Decode, Principal};
use flutter_rust_bridge::frb;
use ic_agent::identity::Secp256k1Identity;
use k256::{elliptic_curve::rand_core, Secp256k1, SecretKey};

use super::utils::{ICPayment, PaymentLink};

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

const PAYMENT_CANISTER_ID: &str = "wxakm-ayaaa-aaaam-aejqa-cai";
pub struct PaymentService {
    ic_agent: Arc<ic_agent::Agent>,
}

impl PaymentService {
    #[frb(ignore)]
    pub fn new(ic_agent : Arc<ic_agent::Agent>) -> Self {
        
        Self { ic_agent }
    }

    pub async fn get_payment_link(&self) -> anyhow::Result<Vec<PaymentLink>> {
        let canister_id = Principal::from_text(PAYMENT_CANISTER_ID)?;
        let result = self
            .ic_agent
            .query(&canister_id, "get_payment_links")
            .with_arg(encode_args(())?)
            .call()
            .await?;
        let (payments,): (Vec<PaymentLink>,) = decode_args(&result)?;

        return Ok(payments);
    }

    pub async fn create_payment_link(&self, arg: &PaymentLink) -> anyhow::Result<String> {
        let canister_id = Principal::from_text(PAYMENT_CANISTER_ID)?;
        let result = self
            .ic_agent
            .update(&canister_id, "create_payment_link")
            .with_arg(encode_args((arg,))?)
            .call_and_wait()
            .await?;
        let (payment_id,): (Result<String, String>,) = decode_args(&result)?;

        if payment_id.is_err() {
            bail!(payment_id.unwrap_err());
        }

        return Ok(payment_id.unwrap());
    }
}
