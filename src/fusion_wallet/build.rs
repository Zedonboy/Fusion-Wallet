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
use std::{env, path::Path};

use dotenv::from_path;

fn main() {
    // Specify the path to your .env file
    let env_path = Path::new("../../.env");
    from_path(env_path).expect("There's no env File in the root");
    println!("cargo::rustc-check-cfg=cfg(network, values(\"ic\", \"local\"))");
    let network = env::var("DFX_NETWORK");
    let f = network.expect("There's no DFX_NETWORK in the env File");
    
    if f == "local" {
        println!("cargo:rustc-cfg=network=\"local\"")
    } else {
        println!("cargo:rustc-cfg=network=\"ic\"")
    }
}
