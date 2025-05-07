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
  'amount' : number,
  'qr_data' : string,
}
export type Result = { 'Ok' : string } |
  { 'Err' : string };
export interface _SERVICE {
  '__candid_method_export_candid' : ActorMethod<[], string>,
  'create_payment_link' : ActorMethod<[PaymentLink], Result>,
  'export_candid' : ActorMethod<[], string>,
  'get_payment_links' : ActorMethod<[], Array<PaymentLink>>,
  'http_request' : ActorMethod<[HttpRequest], HttpResponse>,
}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
