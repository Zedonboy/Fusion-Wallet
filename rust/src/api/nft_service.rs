use std::{collections::HashMap, default, str::FromStr, sync::Arc};

use candid::{decode_args, encode_args, Nat, Principal};
use ic_agent::Agent;
use icrc_ledger_types::{icrc::generic_metadata_value::MetadataValue, icrc1::account::Account};
use serde::{Deserialize, Serialize};

#[derive(Default, Serialize, Deserialize)]
pub struct WalletCollection {
    pub token_address: String,
    pub name: String,
    pub desciption: Option<String>,
    pub image_url: Option<String>,
    pub symbol: String,
}

pub enum CollectMetaValue {
    Text(String),
    Int(i64),
    Nat(u64),
    Blob(Vec<u8>)
}

impl From<MetadataValue> for CollectMetaValue {
    fn from(value: MetadataValue) -> Self {
        match value {
            MetadataValue::Nat(nat) => Self::Nat(nat.0.try_into().unwrap()),
            MetadataValue::Int(int) => Self::Int(int.0.try_into().unwrap()),
            MetadataValue::Text(text) => Self::Text(text),
            MetadataValue::Blob(byte_buf) => Self::Blob(byte_buf.to_vec()),
        }
    }
}

impl WalletCollection {
    pub(super) fn from_metadata_records(records: Vec<(String, MetadataValue)>) -> Self {
        // use num_traits::cast::ToPrimitive;

        let mut metadata = WalletCollection::default();

        for (k, v) in records {
            match k.as_str() {
                "icrc7:description" => {
                    if let MetadataValue::Text(desc) = v {
                        metadata.desciption = Some(desc);
                    }
                }
                "icrc7:name" => {
                    if let MetadataValue::Text(text) = v {
                        metadata.name = text;
                    }
                }
                "icrc7:symbol" => {
                    if let MetadataValue::Text(text) = v {
                        metadata.symbol = text;
                    }
                }

                "icrc7:logo" => {
                    if let MetadataValue::Text(logo) = v {
                        metadata.image_url = Some(logo);
                    }
                }
                _ => {}
            }
        }

        metadata
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn to_string(&self) -> anyhow::Result<String> {
        let json = serde_json::to_string(self)?;
        Ok(json)
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn from_string(data : &str) -> anyhow::Result<Self> {
        let value = serde_json::from_str(data)?;
        Ok(value)
    }
}

pub struct ICCollectionService {
    ic_agent: Arc<Agent>,
}



impl ICCollectionService {
    pub(crate) fn new(arc: Arc<Agent>) -> Self {
        Self { ic_agent: arc }
    }

    pub async fn get_collection(&self, token_addrress: String) -> anyhow::Result<WalletCollection> {
        let result = self
            .ic_agent
            .query(
                &Principal::from_text(&token_addrress).unwrap(),
                "icrc7_collection_metadata",
            )
            .with_arg(encode_args(())?)
            .call()
            .await?;

        let (metadata_vec,): (Vec<(String, MetadataValue)>,) = decode_args(&result)?;
        let mut collection = WalletCollection::from_metadata_records(metadata_vec);
        collection.token_address = token_addrress;

        anyhow::Ok(collection)
    }

    pub async fn get_owned_collectible_count(
        &self,
        collection: &WalletCollection,
        account: String,
    ) -> anyhow::Result<u32> {
        let account = Account {
            owner: Principal::from_text(account)?,
            subaccount: Some([0; 32]),
        };

        let result = self
            .ic_agent
            .query(
                &Principal::from_text(&collection.token_address)?,
                "icrc7_balance_of",
            )
            .with_arg(encode_args((account,))?)
            .call()
            .await?;

        let (balance_vec, ) : (Vec<Nat>, ) = decode_args(&result)?;

        anyhow::Ok(balance_vec[0].clone().0.try_into()?)
    }

    pub async fn get_tokens_owned_by_account(&self, collection: &WalletCollection, account: String) -> anyhow::Result<Vec<(u64, HashMap<String, CollectMetaValue>)>> {
        let account = Account {
            owner: Principal::from_text(account)?,
            subaccount: Some([0; 32]),
        };

        let collection_canister_id = Principal::from_text(&collection.token_address)?;

        let result = self
            .ic_agent
            .query(
                &collection_canister_id,
                "icrc7_balance_of",
            )
            .with_arg(encode_args((account, None::<Nat>, None::<Nat>))?)
            .call()
            .await?;

        let (tokens_id,) : (Vec<Nat>,) = decode_args(&result)?;

        let result = self
            .ic_agent
            .query(&collection_canister_id, "icrc7_token_metadata")
            .with_arg(encode_args((&tokens_id,))?)
            .call()
            .await?;

        let (tokens_metadata, ): (Vec<Option<Vec<(String, MetadataValue)>>>, ) = decode_args(&result)?;

        let mut index = 0;

        let tokens = tokens_metadata.into_iter().filter_map(|f| {
            let id: u64 = tokens_id[index].0.clone().try_into().unwrap();
            index = index + 1;
            f.map(|f| {
                let f = f.into_iter().map(|d| (d.0, CollectMetaValue::from(d.1))).collect();
                (id, f)
            })
        }).collect();

        anyhow::Ok(tokens)

    }

    pub async fn transfer_token(&self, collection: &WalletCollection, token_id: u64, to : String) -> anyhow::Result<u128> {
        let receiver = Account::from_str(to.as_str())?;
        let arg = icrc7_types::icrc7_types::TransferArg{
            from_subaccount: None,
            to: receiver,
            token_id: token_id as u128,
            memo: None,
            created_at_time: None,
        };

        let canister = Principal::from_text(&collection.token_address)?;

        let result = self
            .ic_agent
            .update(&canister, "icrc7_transfer")
            .with_arg(encode_args((arg,))?)
            .call_and_wait()
            .await?;

        let (transfer_result,) : (icrc7_types::icrc7_types::TransferResult,) = decode_args(&result)?;

        let blockid = transfer_result.map_err(|e| anyhow::Error::msg(format!("Transfer Error: {:?}", e)))?;
        anyhow::Ok(blockid)
    }



}
