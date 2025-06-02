use candid::{CandidType, Principal};
use handlebars::Handlebars;
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
use ic_cdk::{
    api::{ canister_balance, canister_balance128, data_certificate, set_certified_data},
    *,
};
use ic_http_certification::{
    utils::add_v2_certificate_header, DefaultCelBuilder, DefaultResponseCertification,
    DefaultResponseOnlyCelExpression, HeaderField, HttpCertification, HttpCertificationPath,
    HttpCertificationTree, HttpCertificationTreeEntry, HttpRequest, HttpResponse,
    CERTIFICATE_EXPRESSION_HEADER_NAME,
};
use include_dir::{include_dir, Dir};
use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::{cell::RefCell, collections::HashMap};
use ic_stable_structures::{memory_manager::{MemoryId, MemoryManager, VirtualMemory}, DefaultMemoryImpl, StableBTreeMap, Storable};

#[derive(Debug, Clone, Serialize)]
pub struct Metrics {
    pub cycle_balance: u128,
}

#[derive(CandidType, Deserialize, Clone, Default)]
struct ICPayment {
    id: String,
    amount: u64,
    token_address: String,
    recipient: String,
    memo: String,
}

#[derive(CandidType, Deserialize)]
pub struct PaymentLinkRequest {
    pub amount: String,
    pub token_address: String,
    pub memo: String,
}

#[derive(Deserialize, Clone, Default, Serialize, CandidType)]
pub struct PaymentLink {
    pub qr_data: String,
    pub amount : String,
    pub token_symbol: String,
    pub id: String,
    pub memo: String,
    pub created_at: u64,
    pub recipient: String,
}

impl Storable for PaymentLink {
    
    fn to_bytes(&self) -> std::borrow::Cow<[u8]> {
        let mut bytes = Vec::new();
        ciborium::ser::into_writer(&self, &mut bytes).unwrap();
        std::borrow::Cow::Owned(bytes)
    }
    
    fn from_bytes(bytes: std::borrow::Cow<[u8]>) -> Self {
        ciborium::de::from_reader(bytes.as_ref()).unwrap()
    }
    
    const BOUND: ic_stable_structures::storable::Bound = ic_stable_structures::storable::Bound::Unbounded;
}

// Storage
#[derive(Clone)]
struct CertifiedHttpResponse<'a> {
    response: HttpResponse<'a>,
    certification: HttpCertification,
}

type Memory = VirtualMemory<DefaultMemoryImpl>;

thread_local! {
    // return a memory that can be used by stable structures.
    static MEMORY_MANAGER: RefCell<MemoryManager<DefaultMemoryImpl>> =
        RefCell::new(MemoryManager::init(DefaultMemoryImpl::default()));
        
    static HTTP_TREE: RefCell<HttpCertificationTree> = RefCell::new(HttpCertificationTree::default());
    static ENCODED_RESPONSES: RefCell<HashMap<(String, String), CertifiedHttpResponse<'static>>> = RefCell::new(HashMap::new());
    static RESPONSES: RefCell<HashMap<String, CertifiedHttpResponse<'static>>> = RefCell::new(HashMap::new());
    static TEMPLATE_ENGINE: RefCell<Handlebars<'static>> = RefCell::new(Handlebars::new());
    static PAYMENT_LINK_STORE: RefCell<StableBTreeMap<String, PaymentLink, Memory>> = RefCell::new(StableBTreeMap::new(MEMORY_MANAGER.with(|m| m.borrow().get(MemoryId::new(0))),));
   static USER_PAYMENT_LINKS: RefCell<HashMap<Principal, Vec<String>>> = RefCell::new(HashMap::new());
}
const CHARGE_PAGE_TEMPLATE: &str = include_str!("../frontend/dist/payment.html");
static ASSETS_DIR: Dir<'_> = include_dir!("$CARGO_MANIFEST_DIR/frontend/dist");

lazy_static! {
    static ref INDEX_REQ_PATH: &'static str = "";
    static ref INDEX_TREE_PATH: HttpCertificationPath<'static> =
        HttpCertificationPath::wildcard(*INDEX_REQ_PATH);
    static ref INDEX_FILE_PATH: &'static str = "index.html";
    static ref ASSET_CEL_EXPR_DEF: DefaultResponseOnlyCelExpression<'static> =
        DefaultCelBuilder::response_only_certification()
            .with_response_certification(DefaultResponseCertification::response_header_exclusions(
                vec![],
            ))
            .build();
    static ref ASSET_CEL_EXPR: String = ASSET_CEL_EXPR_DEF.to_string();
}

const NO_CACHE_ASSET_CACHE_CONTROL: &str = "public, no-cache, no-store";

pub fn init_template_engine() {
    TEMPLATE_ENGINE.with_borrow_mut(|engine| {
        engine
            .register_template_string("charge_page", CHARGE_PAGE_TEMPLATE)
            .unwrap();
        // engine.register_templates_directory(".hbs", ASSETS_DIR).unwrap();
    });
}

// Certification

pub fn certify_all_assets() {
    add_certification_skips();

    certify_index_asset();
    certify_payment_link();
    certify_asset_glob("assets/**/*.css", "text/css");
    certify_asset_glob("assets/**/*.js", "text/javascript");
    certify_asset_glob("assets/**/*.ico", "image/x-icon");
    certify_asset_glob("assets/**/*.svg", "image/svg+xml");
    certify_asset_glob("assets/**/*.png", "image/png");

    update_certified_data();
}

const METRICS_REQ_PATH: &str = "/metrics";

fn add_certification_skips() {
    let metrics_tree_path = HttpCertificationPath::exact(METRICS_REQ_PATH);
    let metrics_certification = HttpCertification::skip();

    HTTP_TREE.with_borrow_mut(|http_tree| {
        http_tree.insert(&HttpCertificationTreeEntry::new(
            metrics_tree_path,
            &metrics_certification,
        ));
    });
}

pub fn add_payment_link(payment: PaymentLink) {
    let id = payment.id.clone();
    PAYMENT_LINK_STORE.with_borrow_mut(|store| {
        add_payment_response(&payment);
        store.insert(id.clone(), payment);
    });

    USER_PAYMENT_LINKS.with_borrow_mut(|store| {
        store.entry(caller()).or_insert(vec![]).push(id.clone());
    });

    update_certified_data();
}

pub fn get_payment_links(caller: Principal) -> Vec<PaymentLink> {
    USER_PAYMENT_LINKS.with_borrow(|store| {
        store.get(&caller).unwrap_or(&vec![]).iter().map(|id| {
            PAYMENT_LINK_STORE.with_borrow(|store| {
                store.get(id).unwrap_or_default()
            })
        }).collect()
    })
}

fn add_payment_response(payment: &PaymentLink) {
    let body = TEMPLATE_ENGINE.with_borrow(|engine| {
        engine
            .render(
                "charge_page",
                &json!({
                    "message": format!("Pay {} {}", payment.amount, payment.token_symbol),
                    "qr_data": payment.qr_data,
                    "memo": payment.memo,
                    "http_url": payment.qr_data.replace("fusion://", "https://")
                }),
            )
            .unwrap()
    });

    let asset_file_path = format!("link/{}", payment.id);
    let asset_tree_path = HttpCertificationPath::exact(&asset_file_path);
    let asset_req_path = format!("/link/{}", payment.id);
    let additional_headers = vec![
        ("content-type".to_string(), "text/html".to_string()),
        (
            "cache-control".to_string(),
            NO_CACHE_ASSET_CACHE_CONTROL.to_string(),
        ),
    ];

    certify_payment_page(
        body.as_bytes().to_vec(),
        additional_headers,
        &asset_tree_path,
        asset_req_path,
    );
}

fn certify_payment_link() {
    PAYMENT_LINK_STORE.with_borrow(|store| for (id, payment) in store.iter() {
        add_payment_response(&payment);
    });
}

fn certify_index_asset() {
    let additional_headers = vec![
        ("content-type".to_string(), "text/html".to_string()),
        (
            "cache-control".to_string(),
            NO_CACHE_ASSET_CACHE_CONTROL.to_string(),
        ),
    ];

    let identity_file = ASSETS_DIR
        .get_file(*INDEX_FILE_PATH)
        .expect("No index.html file found!!!");
    let body = identity_file.contents();

    certify_asset(
        body,
        INDEX_FILE_PATH.to_string(),
        &*INDEX_TREE_PATH,
        INDEX_REQ_PATH.to_string(),
        additional_headers,
    );
}

fn certify_asset_glob(glob: &str, content_type: &str) {
    // iterate over every asset matching the glob
    for identity_file in ASSETS_DIR
        .find(glob)
        .unwrap()
        .map(|entry| entry.as_file().unwrap())
    {
        // compute the different paths needed for this asset
        let asset_file_path = identity_file.path().to_str().unwrap().to_string();
        let asset_req_path = if !asset_file_path.starts_with("/") {
            format!("/{}", asset_file_path)
        } else {
            asset_file_path.clone()
        };
        let asset_tree_path = HttpCertificationPath::exact(&asset_req_path);

        // add the content-type and cache-control headers
        let additional_headers = vec![
            ("content-type".to_string(), content_type.to_string()),
            (
                "cache-control".to_string(),
                "public, max-age=31536000, immutable".to_string(),
            ),
        ];

        let body = identity_file.contents();
        certify_asset(
            body,
            asset_file_path,
            &asset_tree_path,
            asset_req_path.clone(),
            additional_headers,
        );
    }
}

fn certify_payment_page(
    body: Vec<u8>,
    additional_headers: Vec<HeaderField>,
    asset_tree_path: &HttpCertificationPath,
    asset_req_path: String,
) {
    // create the response
    let response = create_page_response(additional_headers, body, ASSET_CEL_EXPR.clone());

    // certify the response
    let certification =
        HttpCertification::response_only(&ASSET_CEL_EXPR_DEF, &response, None).unwrap();

    HTTP_TREE.with_borrow_mut(|http_tree| {
        // add the certification to the certification tree
        http_tree.insert(&HttpCertificationTreeEntry::new(
            asset_tree_path,
            &certification,
        ));

        
    });

    RESPONSES.with_borrow_mut(|responses| {
        // store the response for later retrieval
        responses.insert(
            asset_req_path,
            CertifiedHttpResponse {
                response,
                certification,
            },
        );
    });
}

fn certify_asset(
    body: &'static [u8],
    asset_file_path: String,
    asset_tree_path: &HttpCertificationPath,
    asset_req_path: String,
    additional_headers: Vec<HeaderField>,
) {
    certify_asset_response(
        body,
        additional_headers.clone(),
        asset_tree_path,
        asset_req_path.to_string(),
    );
    certify_asset_with_encoding(
        &asset_file_path,
        asset_tree_path,
        asset_req_path.to_string(),
        "gzip",
        additional_headers.clone(),
    );
    certify_asset_with_encoding(
        &asset_file_path,
        asset_tree_path,
        asset_req_path.to_string(),
        "br",
        additional_headers,
    );
}

fn certify_asset_with_encoding(
    asset_file_path: &str,
    asset_tree_path: &HttpCertificationPath,
    asset_req_path: String,
    encoding: &str,
    additional_headers: Vec<HeaderField>,
) {
    // check if the file exists before certifying it
    if let Some(file) = ASSETS_DIR.get_file(format!("{}.{}", asset_file_path, encoding)) {
        let body = file.contents();

        // add the content encoding header
        let mut headers = vec![("content-encoding".to_string(), encoding.to_string())];
        headers.extend(additional_headers);

        // create the response
        let response = create_asset_response(headers, body, ASSET_CEL_EXPR.clone());

        // certify the response
        let certification =
            HttpCertification::response_only(&ASSET_CEL_EXPR_DEF, &response, None).unwrap();

        HTTP_TREE.with_borrow_mut(|http_tree| {
            // add the certification to the certification tree
            http_tree.insert(&HttpCertificationTreeEntry::new(
                asset_tree_path,
                &certification,
            ));
        });

        ENCODED_RESPONSES.with_borrow_mut(|responses| {
            // store the response for later retrieval
            responses.insert(
                (asset_req_path, encoding.to_string()),
                CertifiedHttpResponse {
                    response,
                    certification,
                },
            );
        });
    };
}

fn certify_asset_response(
    body: &'static [u8],
    additional_headers: Vec<HeaderField>,
    asset_tree_path: &HttpCertificationPath,
    asset_req_path: String,
) {
    // create the response
    let response = create_asset_response(additional_headers, body, ASSET_CEL_EXPR.clone());

    // certify the response
    let certification =
        HttpCertification::response_only(&ASSET_CEL_EXPR_DEF, &response, None).unwrap();

    HTTP_TREE.with_borrow_mut(|http_tree| {
        // add the certification to the certification tree
        http_tree.insert(&HttpCertificationTreeEntry::new(
            asset_tree_path,
            &certification,
        ));
    });

    RESPONSES.with_borrow_mut(|responses| {
        // store the response for later retrieval
        responses.insert(
            asset_req_path,
            CertifiedHttpResponse {
                response,
                certification,
            },
        );
    });
}

fn update_certified_data() {
    HTTP_TREE.with_borrow(|http_tree| {
        set_certified_data(&http_tree.root_hash());
    });
}

// Handlers
pub fn asset_handler(req: &HttpRequest) -> HttpResponse<'static> {
    let req_path = req.get_path().expect("Failed to get req path");

    RESPONSES.with_borrow(|responses| {
        ENCODED_RESPONSES.with_borrow(|encoded_responses| {
            let (asset_req_path, asset_tree_path, identity_response) =
             // if the request path matches the metrics path, serve that uncertified
             if req_path == METRICS_REQ_PATH {
                 (
                     METRICS_REQ_PATH.to_string(),
                     HttpCertificationPath::exact(METRICS_REQ_PATH),
                     CertifiedHttpResponse {
                         response: create_metrics_response(),
                         certification: HttpCertification::skip(),
                     },
                 )
             }
             // if the requested path matches a static asset, serve that
             else if let Some(identity_response) = responses.get(&req_path) {
                 (
                     req_path.to_string(),
                     HttpCertificationPath::exact(&req_path),
                     identity_response.clone(),
                 )
             // otherwise serve the index.html
             } else {
                 (
                     INDEX_REQ_PATH.to_string(),
                     INDEX_TREE_PATH.to_owned(),
                     responses.get(*INDEX_REQ_PATH).unwrap().clone(),
                 )
             };

            // extract the content encoding header
            let content_encoding = req.headers().iter().find_map(|(name, value)| {
                if name.to_lowercase() == "accept-encoding" {
                    Some(value)
                } else {
                    None
                }
            });

            let CertifiedHttpResponse {
                certification,
                response,
            } = content_encoding
                .and_then(|encoding| {
                    // if the request asks for Brotli and it's available for this file, serve that version
                    if encoding.contains("br") {
                        if let Some(br_response) =
                            encoded_responses.get(&(asset_req_path.clone(), "br".to_string()))
                        {
                            return Some(br_response.clone());
                        }
                    }

                    // if the request asks for Gzip and it's available for this file, serve that version
                    if encoding.contains("gzip") {
                        if let Some(gzip_response) =
                            encoded_responses.get(&(asset_req_path, "gzip".to_string()))
                        {
                            return Some(gzip_response.clone());
                        }
                    }

                    None
                })
                // otherwise serve the identity version
                .unwrap_or(identity_response);

            let mut response = response.clone();

            HTTP_TREE.with_borrow(|http_tree| {
                add_v2_certificate_header(
                    &data_certificate().expect("No data certificate available"),
                    &mut response,
                    &http_tree
                        .witness(
                            &HttpCertificationTreeEntry::new(&asset_tree_path, certification),
                            &req_path,
                        )
                        .unwrap(),
                    &asset_tree_path.to_expr_path(),
                );
            });

            response
        })
    })
}

fn create_metrics_response() -> HttpResponse<'static> {
    let metrics = Metrics {
        cycle_balance: canister_balance128(),
    };
    let body = serde_json::to_vec(&metrics).expect("Failed to serialize metrics");
    let additional_headers = vec![
        ("content-type".to_string(), "application/json".to_string()),
        (
            "cache-control".to_string(),
            NO_CACHE_ASSET_CACHE_CONTROL.to_string(),
        ),
    ];
    let headers = get_asset_headers(
        additional_headers,
        body.len(),
        DefaultCelBuilder::skip_certification().to_string(),
    );

    HttpResponse::ok(body, headers).build()
}

fn get_asset_headers(
    additional_headers: Vec<HeaderField>,
    content_length: usize,
    cel_expr: String,
) -> Vec<(String, String)> {
    // set up the default headers and include additional headers provided by the caller
    let mut headers = vec![
         ("strict-transport-security".to_string(), "max-age=31536000; includeSubDomains".to_string()),
         ("x-frame-options".to_string(), "DENY".to_string()),
         ("x-content-type-options".to_string(), "nosniff".to_string()),
         ("content-security-policy".to_string(), "default-src 'self'; form-action 'self'; object-src 'none'; frame-ancestors 'none'; upgrade-insecure-requests; block-all-mixed-content".to_string()),
         ("referrer-policy".to_string(), "no-referrer".to_string()),
         ("permissions-policy".to_string(), "accelerometer=(),ambient-light-sensor=(),autoplay=(),battery=(),camera=(),display-capture=(),document-domain=(),encrypted-media=(),fullscreen=(),gamepad=(),geolocation=(),gyroscope=(),layout-animations=(self),legacy-image-formats=(self),magnetometer=(),microphone=(),midi=(),oversized-images=(self),payment=(),picture-in-picture=(),publickey-credentials-get=(),speaker-selection=(),sync-xhr=(self),unoptimized-images=(self),unsized-media=(self),usb=(),screen-wake-lock=(),web-share=(),xr-spatial-tracking=()".to_string()),
         ("cross-origin-embedder-policy".to_string(), "require-corp".to_string()),
         ("cross-origin-opener-policy".to_string(), "same-origin".to_string()),
         ("content-length".to_string(), content_length.to_string()),
         (CERTIFICATE_EXPRESSION_HEADER_NAME.to_string(), cel_expr),
     ];
    headers.extend(additional_headers);

    headers
}

fn create_asset_response(
    additional_headers: Vec<HeaderField>,
    body: &[u8],
    cel_expr: String,
) -> HttpResponse {
    let headers = get_asset_headers(additional_headers, body.len(), cel_expr);

    HttpResponse::ok(body, headers).build()
}

fn create_page_response(
    additional_headers: Vec<HeaderField>,
    body: Vec<u8>,
    cel_expr: String,
) -> HttpResponse<'static> {
    let headers = get_asset_headers(additional_headers, body.len(), cel_expr);

    HttpResponse::ok(body, headers).build()
}
