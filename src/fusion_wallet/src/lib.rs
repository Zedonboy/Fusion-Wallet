use candid::Principal;
use der::{asn1::BitStringRef, AnyRef, Encode};
use ic_cdk::{
    api::{
        is_controller,
        management_canister::{
            ecdsa::{
                ecdsa_public_key, sign_with_ecdsa, EcdsaCurve, EcdsaKeyId, EcdsaPublicKeyArgument,
            }, main::{canister_info, update_settings, CanisterInfoRequest, CanisterSettings, UpdateSettingsArgument}, schnorr::{
                schnorr_public_key, sign_with_schnorr, SchnorrAlgorithm, SchnorrKeyId,
                SchnorrPublicKeyArgument, SignWithSchnorrArgument,
            }
        },
    },
    id, query, update,
};
use spki::{AlgorithmIdentifier, ObjectIdentifier, SubjectPublicKeyInfo};

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

#[cfg(network = "ic")]
const KEY_ID: &str = "key_1";

#[cfg(network = "local")]
const KEY_ID: &str = "dfx_test_key";

const ED25519_OID: ObjectIdentifier = ObjectIdentifier::new_unwrap("1.3.101.112");
pub type SubjectPublicKeyInfoRef<'a> = SubjectPublicKeyInfo<AnyRef<'a>, BitStringRef<'a>>;

#[update(guard = is_app_controller)]
async fn get_ecdsa_signature(message_hash: Vec<u8>, derivation_path: Option<Vec<u8>>) -> Vec<u8> {
    let path = derivation_path.unwrap_or(vec![]);
    let arg = ic_cdk::api::management_canister::ecdsa::SignWithEcdsaArgument {
        message_hash,
        derivation_path: vec![path],
        key_id: EcdsaKeyId {
            curve: EcdsaCurve::Secp256k1,
            name: KEY_ID.to_string(),
        },
    };

    let (res,) = sign_with_ecdsa(arg).await.unwrap();

    res.signature
}

#[update(guard = is_app_controller)]
async fn schnorr_ed25519_signature(message: Vec<u8>, derivation_path: Option<Vec<u8>>) -> Vec<u8> {
    let path = derivation_path.unwrap_or(vec![]);
    let arg = SignWithSchnorrArgument {
        message,
        derivation_path: vec![path],
        key_id: SchnorrKeyId {
            algorithm: SchnorrAlgorithm::Ed25519,
            name: KEY_ID.to_string(),
        },
    };
    let (res,) = sign_with_schnorr(arg).await.unwrap();
    res.signature
}

#[update(guard = is_app_controller)]
async fn schnorr_secp256k1_signature(
    message: Vec<u8>,
    derivation_path: Option<Vec<u8>>,
) -> Vec<u8> {
    let path = derivation_path.unwrap_or(vec![]);
    let arg = SignWithSchnorrArgument {
        message,
        derivation_path: vec![path],
        key_id: SchnorrKeyId {
            algorithm: SchnorrAlgorithm::Bip340secp256k1,
            name: KEY_ID.to_string(),
        },
    };
    let (res,) = sign_with_schnorr(arg).await.unwrap();
    res.signature
}

#[update(guard = is_app_controller)]
async fn get_schnorr_secp256k1_public_key(derivation_path: Option<Vec<u8>>) -> Vec<u8> {
    let path = derivation_path.unwrap_or(vec![]);

    let arg = SchnorrPublicKeyArgument {
        canister_id: Some(id()),
        derivation_path: vec![path],
        key_id: SchnorrKeyId {
            algorithm: SchnorrAlgorithm::Bip340secp256k1,
            name: KEY_ID.to_string(),
        },
    };

    let (res,) = schnorr_public_key(arg).await.unwrap();
    res.public_key
}

#[update(guard = is_app_controller)]
async fn get_schnorr_ed25519_public_key(derivation_path: Option<Vec<u8>>) -> Vec<u8> {
    let path = derivation_path.unwrap_or(vec![]);

    let arg = SchnorrPublicKeyArgument {
        canister_id: Some(id()),
        derivation_path: vec![path],
        key_id: SchnorrKeyId {
            algorithm: SchnorrAlgorithm::Ed25519,
            name: KEY_ID.to_string(),
        },
    };

    let (res,) = schnorr_public_key(arg).await.unwrap();
    res.public_key
}

#[update(guard = is_app_controller)]
async fn get_ecdsa_public_key(derivation_path: Option<Vec<u8>>) -> Vec<u8> {
    let path = derivation_path.unwrap_or(vec![]);

    let arg = EcdsaPublicKeyArgument {
        canister_id: Some(id()),
        derivation_path: vec![path],
        key_id: EcdsaKeyId {
            curve: EcdsaCurve::Secp256k1,
            name: KEY_ID.to_string(),
        },
    };

    let (res,) = ecdsa_public_key(arg).await.unwrap();
    res.public_key
}

#[update]
async fn get_prime_controller() -> Result<Principal, String> {
    let pub_key = get_schnorr_ed25519_public_key(None).await;
    let der_key = ed25519_public_key_to_der(&pub_key)?;
    let prime_principal = Principal::self_authenticating(der_key);

    Ok(prime_principal)
}

fn ed25519_public_key_to_der(public_key: &[u8]) -> Result<Vec<u8>, String> {
    // Validate the Ed25519 public key length (should be 32 bytes)
    if public_key.len() != 32 {
        return Err("Invalid Ed25519 public key length".to_string());
    }

    // Create the algorithm identifier for Ed25519
    let algorithm = AlgorithmIdentifier {
        oid: ED25519_OID,
        parameters: None,
    };

    // Create a BitString from the public key
    // Note: For Ed25519 in DER, the key is directly encoded as a BitString
    let subject_public_key = BitStringRef::new(0, public_key).map_err(|e| e.to_string())?;

    // Create the SubjectPublicKeyInfo structure
    let spki = SubjectPublicKeyInfoRef {
        algorithm,
        subject_public_key,
    };

    // Encode to DER format
    Ok(spki.to_der().map_err(|e| e.to_string())?)
}

fn is_app_controller() -> Result<(), String> {
    #[cfg(network = "local")]
    return Ok(());

    let caller = ic_cdk::caller();
    if !is_controller(&caller) {
        return Err("Not a controller".to_string());
    }
    Ok(())
}

#[query]
#[candid::candid_method(query)]
fn export_candid() -> String {
    ic_cdk::export_candid!();
    __export_service()
}
