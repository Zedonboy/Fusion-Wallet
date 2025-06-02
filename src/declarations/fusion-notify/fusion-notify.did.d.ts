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
export interface HttpResponse {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface NotifyMessage {
  'title' : string,
  'body' : string,
  'action_url' : [] | [string],
  'icon_url' : [] | [string],
  'data_type' : [] | [string],
}
export type Result = { 'Ok' : null } |
  { 'Err' : string };
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpResponse,
}
export interface _SERVICE {
  'add_app_permission' : ActorMethod<[string, AppInfo], undefined>,
  'add_device_token' : ActorMethod<[string], undefined>,
  'export_candid' : ActorMethod<[], string>,
  'get_all_device_tokens' : ActorMethod<[], Array<[string, Array<string>]>>,
  'get_canister_permissions' : ActorMethod<[], Array<CanisterPermissionInfo>>,
  'get_device_tokens' : ActorMethod<[], Array<string>>,
  'http_transform' : ActorMethod<[TransformArgs], HttpResponse>,
  'remove_canister_permission' : ActorMethod<[Principal], undefined>,
  'remove_device_token' : ActorMethod<[string], undefined>,
  'send_notification' : ActorMethod<[NotifyMessage, Principal], Result>,
  'send_test_message' : ActorMethod<[string, string, string], Result>,
  'send_transfer_message' : ActorMethod<[string, bigint], Result>,
  'update_canister_permission' : ActorMethod<[Principal, boolean], undefined>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
