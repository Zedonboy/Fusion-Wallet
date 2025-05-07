import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface _SERVICE {
  'export_candid' : ActorMethod<[], string>,
  'get_ecdsa_public_key' : ActorMethod<
    [[] | [Uint8Array | number[]]],
    Uint8Array | number[]
  >,
  'get_ecdsa_signature' : ActorMethod<
    [Uint8Array | number[], [] | [Uint8Array | number[]]],
    Uint8Array | number[]
  >,
  'get_schnorr_ed25519_public_key' : ActorMethod<
    [[] | [Uint8Array | number[]]],
    Uint8Array | number[]
  >,
  'get_schnorr_secp256k1_public_key' : ActorMethod<
    [[] | [Uint8Array | number[]]],
    Uint8Array | number[]
  >,
  'schnorr_ed25519_signature' : ActorMethod<
    [Uint8Array | number[], [] | [Uint8Array | number[]]],
    Uint8Array | number[]
  >,
  'schnorr_secp256k1_signature' : ActorMethod<
    [Uint8Array | number[], [] | [Uint8Array | number[]]],
    Uint8Array | number[]
  >,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
