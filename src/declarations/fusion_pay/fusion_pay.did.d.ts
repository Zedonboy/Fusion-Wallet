import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface HttpRequest {
  'url' : string,
  'method' : string,
  'body' : Uint8Array | number[],
  'headers' : Array<[string, string]>,
  'certificate_version' : [] | [number],
}
export interface HttpResponse {
  'body' : Uint8Array | number[],
  'headers' : Array<[string, string]>,
  'upgrade' : [] | [boolean],
  'status_code' : number,
}
export interface PaymentLink {
  'id' : string,
  'token_symbol' : string,
  'memo' : string,
  'recipient' : string,
  'created_at' : bigint,
  'amount' : string,
  'qr_data' : string,
}
export interface PaymentLinkRequest {
  'memo' : string,
  'token_address' : string,
  'amount' : string,
}
export type Result = { 'Ok' : string } |
  { 'Err' : string };
export interface _SERVICE {
  'create_payment_link' : ActorMethod<[PaymentLinkRequest], Result>,
  'export_candid' : ActorMethod<[], string>,
  'get_payment_links' : ActorMethod<[], Array<PaymentLink>>,
  'http_request' : ActorMethod<[HttpRequest], HttpResponse>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
