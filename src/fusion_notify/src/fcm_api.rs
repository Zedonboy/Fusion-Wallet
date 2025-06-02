use candid::{Func, Nat};
use ic_cdk::{api::{call::{msg_cycles_accept128, msg_cycles_available128}, management_canister::{http_request::{http_request, CanisterHttpRequestArgument, HttpHeader, HttpMethod, TransformContext, TransformFunc}, main::raw_rand}}, id};
// use ic_cdk::{api::{canister_self, msg_cycles_accept, msg_cycles_available}, management_canister::{cost_http_request, http_request, raw_rand, HttpHeader, TransformContext, TransformFunc}};
use serde_json::json;

use crate::utils::{NotifyMessage, ProxyMethod, ProxyRequest};

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


const url : &str = "https://fcm.googleapis.com/v1/projects/fusion-wallet-c2a67/messages:send";
const PROXY_URL :&str = "https://ckton-proxy-nqskw.ondigitalocean.app/fcm";
const PROXY_API_KEY :&str = "";

pub async fn send_message(message : NotifyMessage, token : String, free_cycles : bool) -> Result<(), String> {
    let (id_vec,) = raw_rand().await.map_err(|e| e.1.to_string())?;
    let id_key = hex::encode(id_vec);
    let json_data = json!({
        "message": {
            "token": token,
            "notification": {
                "title": message.title,
                "body": message.body,
                "image": message.icon_url
            },
            "data": {
                "action_url": message.action_url,
                "type": message.data_type
            },
        }
    });

    let proxy_request = ProxyRequest{
        idempotency_key: id_key,
        destination_url: url.to_string(),
        method: ProxyMethod::POST,
        headers: vec![("Content-Type".to_string(), "application/json".to_string())],
        body: Some(json_data),
    };

    let json_proxy_str = serde_json::to_string(&proxy_request).map_err(|op| op.to_string())?;
    
    let transform_context = TransformContext{
        function: TransformFunc(Func { principal: id(), method: format!("http_transform") }),
        context: vec![],
    };

    let header = vec![
        HttpHeader{name: "X-API-Key".to_string(), value: PROXY_API_KEY.to_string()}, 
        HttpHeader{name: "Content-Type".to_string(), value: "application/json".to_string()}
    ];

    let canister_request_arg = CanisterHttpRequestArgument{ url: PROXY_URL.to_string(), max_response_bytes: Some(1_000_000), method: HttpMethod::POST, headers: header, body: Some(json_proxy_str.as_bytes().to_vec()), transform: Some(transform_context) };

    let cycles_cost = cost_http_request(&canister_request_arg);

    let cycles_cost = if free_cycles { 0 } else { cycles_cost + (cycles_cost / 2) };
    
    // Check if we have enough cycles
    let available_cycles = msg_cycles_available128();
    if available_cycles < cycles_cost {

        return Err(format!("Not enough cycles. Required: {}, Available: {}", cycles_cost, available_cycles));
    }

    msg_cycles_accept128(cycles_cost);

    // Make the HTTP outcall
    let (response,) = http_request(canister_request_arg, cycles_cost)
    .await
    .map_err(|e| format!("HTTP request failed: {:?}", e))?;

    if response.status != Nat::from(200u16) {
        let error_msssg = String::from_utf8(response.body).map_or("Server Error".to_string(), |d| d);
        return Err(format!("Server returned status: {} with error: {}", response.status, error_msssg));
    }
    Ok(())


}

fn cost_http_request(request: &CanisterHttpRequestArgument) -> u128 {
    // 1 billion
    1_000_000_000
}



