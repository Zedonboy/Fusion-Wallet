import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface AppInfo {
  'domain' : [] | [string],
  'name' : [] | [string],
  'canister_id' : string,
  'icon_url' : [] | [string],
}
export interface CanisterPermissionInfo {
  'canister_id' : Principal,
  'enabled' : boolean,
  'app_info' : AppInfo,
}
export interface HttpHeader { 'value' : string, 'name' : string }
export interface HttpRequestResult {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpRequestResult,
}
export interface _SERVICE {
  '__candid_method_export_candid' : ActorMethod<[], string>,
  'add_app_permission' : ActorMethod<[string, AppInfo], undefined>,
  'add_device_token' : ActorMethod<[string], undefined>,
  'export_candid' : ActorMethod<[], string>,
  'get_all_device_tokens' : ActorMethod<[], Array<[string, Array<string>]>>,
  'get_canister_permissions' : ActorMethod<[], Array<CanisterPermissionInfo>>,
  'get_device_tokens' : ActorMethod<[], Array<string>>,
  'http_transform' : ActorMethod<[TransformArgs], HttpRequestResult>,
  'remove_canister_permission' : ActorMethod<[Principal], undefined>,
  'remove_device_token' : ActorMethod<[string], undefined>,
  'send_test_message' : ActorMethod<[string, string, string], undefined>,
  'update_canister_permission' : ActorMethod<[Principal, boolean], undefined>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
