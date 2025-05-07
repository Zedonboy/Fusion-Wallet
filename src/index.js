import { AuthClient} from "@dfinity/auth-client"
import {createActor as createFusionRegisterActor, canisterId as fusionRegisterCanisterId} from "./declarations/fusion-register"
import {createActor as createFusionWalletActor} from "./declarations/fusion-wallet"
import { HOST } from "./config"

let wallet_id;
async function identity_sign_in() {
    const authClient = await AuthClient.create()

    let auth = await authClient.isAuthenticated()

    if(auth) {
        console.log("Signed in")
        console.log(authClient.getIdentity())
        globalThis.dart_sign_in_success();
        return;
    }

    await authClient.login({
        identityProvider: process.env.NODE_ENV === "development" ? "http://be2us-64aaa-aaaaa-qaabq-cai.localhost:4943" : "https://identity.ic0.app/",
        maxTimeToLive: 5 * 60 * 60 * 1000000000, // 5 hours in nanoseconds,
        
        onSuccess: () => {
            console.log("Signed in")
            console.log(authClient.getIdentity())
            globalThis.dart_sign_in_success();
            
        },
        onError: (error) => {
            globalThis.dart_sign_in_error();
            console.error("Error signing in", error)
        }
    })
}

async function logout() {
    const authClient = await AuthClient.create()
    await authClient.logout()
    globalThis.dart_sign_out_success();
}

async function fetch_wallet_info() {
    let auth = await AuthClient.create();
    if(!await auth.isAuthenticated()) {
        throw new Error("Not authenticated");
    }

    let fusionRegister = createFusionRegisterActor(fusionRegisterCanisterId, {
        agentOptions: {
            host: HOST,
            identity: auth.getIdentity()
        }
    });

    let [wallet] = await fusionRegister.get_wallet_address();

    if(wallet) {
        globalThis.wallet_id = wallet;
        wallet_id = wallet;
        console.log("Wallet id", wallet)
        return wallet;
    }
}


async function provision_wallet() {
    let auth = await AuthClient.create();
    if(!await auth.isAuthenticated()) {
        throw new Error("Not authenticated");
    }

    let fusionRegister = createFusionRegisterActor(fusionRegisterCanisterId, {
        agentOptions: {
            host: HOST,
            identity: auth.getIdentity()
        }
    });

    let result = await fusionRegister.provision_wallet();

    if(result.Ok) {
        globalThis.wallet_id = result.Ok;
        wallet_id = result.Ok;
        console.log("Wallet id", wallet_id)
        return wallet_id;
    }

    throw new Error(result.Err);
}

async function sign_delegation(data) {
    let auth = await AuthClient.create();
    if(!await auth.isAuthenticated()) {
        throw new Error("Not authenticated");
    }

    if(!wallet_id) {
        throw new Error("No wallet id");
    }

    let fusionWallet = createFusionWalletActor(wallet_id, {
        agentOptions: {
            host: HOST,
            identity: auth.getIdentity()
        }
    });

    let result = await fusionWallet.schnorr_ed25519_signature(data, [])

    return result;
}

async function get_wallet_root_public_key() {
    let auth = await AuthClient.create();
    if(!await auth.isAuthenticated()) {
        throw new Error("Not authenticated");
    }

    let fusionWallet = createFusionWalletActor(wallet_id, {
        agentOptions: {
            host: HOST,
            identity: auth.getIdentity()
        }
    });

    let result = await fusionWallet.get_schnorr_ed25519_public_key([]);

    return result;
    
}

async function get_deposit_address() {
    let auth = await AuthClient.create();
    if(!await auth.isAuthenticated()) {
        throw new Error("Not authenticated");
    }

    let fusionRegister = createFusionRegisterActor(fusionRegisterCanisterId, {
        agentOptions: {
            host: HOST,
            identity: auth.getIdentity()
        }
    });

    let address = await fusionRegister.get_deposit_address();

    return address;
}


globalThis.identity_sign_in = identity_sign_in;
globalThis.fetch_wallet_info = fetch_wallet_info;
globalThis.provision_wallet = provision_wallet;
globalThis.sign_delegation = sign_delegation;
globalThis.get_wallet_root_public_key = get_wallet_root_public_key;
globalThis.get_deposit_address = get_deposit_address;
globalThis.logout = logout;