import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type Result = { 'Ok' : string } |
  { 'Err' : string };
export type Result_1 = { 'Ok' : null } |
  { 'Err' : string };
export interface _SERVICE {
  'export_candid' : ActorMethod<[], string>,
  'get_deposit_address' : ActorMethod<[], string>,
  'get_wallet_address' : ActorMethod<[], [] | [string]>,
  'provision_wallet' : ActorMethod<[], Result>,
  'upgrade_wallets' : ActorMethod<[], Result_1>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
