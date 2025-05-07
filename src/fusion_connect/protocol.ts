export enum MessageType {
  HANDSHAKE_WELCOME = 0x01,
  PERSONAL_SIGN = 0x02,
  GET_DELEGATION_CANISTER = 0x03,
  BLS_ENCRYPT_DATA = 0x04,
  CONNECT = 0x05,
}

export type HandshakeWelcome = {
  type: MessageType.HANDSHAKE_WELCOME
  message: string
  nonce: Uint8Array
  timestamp: number
}

export type Connect = {
  type: MessageType.CONNECT
  domain: string
  timestamp: number
}

export type PersonalSignRequest = {
  type: MessageType.PERSONAL_SIGN
  data: Uint8Array
  derivationPath: string
  requestId: string
}

export type GetDelegationCanister = {
  type: MessageType.GET_DELEGATION_CANISTER
  delegation: Uint8Array
}

export type BLSEncryptData = {
  type: MessageType.BLS_ENCRYPT_DATA
  data: Uint8Array
  derivationPath: string
  canisterId: string
  nonce: Uint8Array
}

export type ProtocolMessage = 
  | HandshakeWelcome
  | PersonalSignRequest
  | GetDelegationCanister
  | BLSEncryptData
  | Connect
// Helper type guard functions
export function isProtocolMessage(msg: any): msg is ProtocolMessage {
  return Object.values(MessageType).includes(msg?.type)
}

export function getMessageType(msg: ProtocolMessage): MessageType {
  return msg.type
} 