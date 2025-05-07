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

import { createLibp2p } from "libp2p";
import { webSockets } from "@libp2p/websockets";
import { webRTC } from "@libp2p/webrtc";
import { noise } from "@chainsafe/libp2p-noise";
import { yamux } from "@chainsafe/libp2p-yamux";
import {Connection} from "@libp2p/interface"
import { tcp } from "@libp2p/tcp";
import {
  circuitRelayTransport,
} from "@libp2p/circuit-relay-v2";
import { identify } from "@libp2p/identify";
import type { Libp2p } from "libp2p";
import { bootstrap } from "@libp2p/bootstrap";
import { Circuit } from "@multiformats/multiaddr-matcher";
// @ts-ignore - No types available for qr-modal.js
import { QRModal } from "./qr-modal.js";
import { LengthPrefixedStream, lpStream } from "it-length-prefixed-stream";
import { ping } from "@libp2p/ping";
import cbor from "cbor";
import type { Connect, GetDelegationCanister, ProtocolMessage } from "./protocol";
import { MessageType, getMessageType } from "./protocol";
import { Ed25519KeyIdentity, Delegation, DelegationChain, DelegationIdentity, SignedDelegation } from "@dfinity/identity";
import './styles.css';
type Config = {
  bootstrapNodes?: string[];
};
const bootstrapNodes = [
  "/dns4/bootstrap.libp2p.io/tcp/443/wss/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN",
  "/dns4/ws-star.discovery.libp2p.io/tcp/443/wss/p2p/QmZa1sAxajnQjVM8WjminX5rkCMSGUwBLMFHo5qsjf1YPd",
];

const PROTOCOL_ID = "/fusion/1.0.0";

export class FusionClient {
  private node: Libp2p | null = null;
  private qrModal: QRModal | null = null;
  private wallet_conn: Connection | null = null;
  private client_stream: LengthPrefixedStream | null = null;
  private delegated_identity: DelegationIdentity | null = null;

  private constructor(node: Libp2p) {
    this.node = node;
  }

  static async create(config?: Config) {
    let node = await createLibp2p({
      transports: [webRTC(), webSockets(), circuitRelayTransport(), tcp()],
      connectionEncrypters: [noise()],
      streamMuxers: [yamux()],
      peerDiscovery: [
        bootstrap({ list: config?.bootstrapNodes || bootstrapNodes }),
      ],
      services: {
        // @ts-ignore
        identify: identify({
          protocolPrefix: "fusion"
        }),
        // @ts-ignore
        ping: ping(),
      },
    });

    node.addEventListener("peer:connect", (evt) => {
      const peerId = evt.detail;
      console.log("Connected to peer:", peerId);

      let peers = node.getPeers();
      if (peers.length >= 2) {
        node.hangUp(peerId);
      }
    });

    node.addEventListener("peer:disconnect", (evt) => {
      console.log("Disconnected from peer:", evt.detail.toString());
    });

    return new FusionClient(node);
  }

  async login(option: { onSuccess?: () => void }) {
    let node = this.node;
    let multiaddrs = node?.getMultiaddrs();
    let circuit = multiaddrs?.find(
      (ma) =>
        Circuit.exactMatch(ma) && ma.getPeerId() == node?.peerId.toString()
    );

    if (!circuit) {
      throw new Error("No circuit address found");
    }

    this.node?.handle(PROTOCOL_ID, async ({ stream, connection }) => {
      const client_stream = lpStream(stream);
      let data = await client_stream.read();

      try {
        const message = cbor.decode(data.subarray()) as ProtocolMessage;
        console.log("Received message type:", getMessageType(message));

        switch (message.type) {
          case MessageType.HANDSHAKE_WELCOME:
            console.log("Handshake welcome received");
            this.wallet_conn = connection;
            this.qrModal?.hide();

            // Create a Connect Protocol message with domain name
            const connectMessage = {
              type: MessageType.CONNECT,
              domain: window.location.hostname,
              timestamp: Date.now(),
            } as Connect;

            // Encode and send the connect message
            const encodedMessage = cbor.encode(connectMessage);

            this.client_stream = client_stream;
            await client_stream.write(encodedMessage);
            console.log(
              "Connect message sent with domain:",
              window.location.hostname
            );

            option.onSuccess?.();
            // Handle handshake
            break;
          default:
            break;
        }
      } catch (error) {
        console.error("Error decoding message:", error);
      }
    });

    // Show QR code modal with the circuit address
    const circuitAddr = circuit.toString();
    const modal = new QRModal();
    this.qrModal = modal;
    modal.show(circuitAddr);
  }

  async get_delegation() {
    if (!this.isConnected) {
      throw new Error("Not connected to wallet. Please login first.");
    }

    // Create a new stream to the wallet
    if (!this.wallet_conn || !this.node) {
      throw new Error("Wallet connection not established");
    }

    if (this.delegated_identity) {
      return this.delegated_identity
    }

    let identity = Ed25519KeyIdentity.generate()

    // 5 hours from now in nanoseconds
    let expiration = BigInt(Date.now() + 5 * 60 * 60 * 1000) * BigInt(1000000)
    let delegation = new Delegation(identity.getPublicKey().toDer(), expiration)
    let delegation_cbor = delegation.toCBOR()

    // Create a delegation request message
    const delegationRequest = {
      type: MessageType.GET_DELEGATION_CANISTER,
      delegation: new Uint8Array(delegation_cbor)
    } as GetDelegationCanister;

    try {
      
      // Encode and send the delegation request
      const encodedMessage = cbor.encode(delegationRequest);
      await this.client_stream?.write(encodedMessage);
      console.log("Delegation request sent");
      
      // Wait for response
      const response = await this.client_stream?.read();
      const decodedResponse = cbor.decode(response?.subarray() ?? new Uint8Array());

      let pubkey = new Uint8Array(decodedResponse.publicKey) as ArrayBuffer
      let signed_delegation = {
        delegation: delegation,
        signature: new Uint8Array(decodedResponse.signature) as ArrayBuffer
      } as SignedDelegation; 


      let chain = DelegationChain.fromDelegations([signed_delegation], pubkey)
      let delegated_identity = DelegationIdentity.fromDelegation(identity, chain)

      this.delegated_identity = delegated_identity

      return delegated_identity
    } catch (error) {
      console.error("Error getting delegation:", error);
      throw error;
    }
  }

  async connect() {
    if (!this.isConnected) {
      throw new Error("Not connected to wallet. Please login first.");
    }
  }

 
  get isConnected() {
    return this.wallet_conn?.status === "open" && this.node !== null;
  }

  async logout() {
    if (this.node) {
      await this.node.stop();
      this.node = null;
    }
  }
}

// Example usage:
// const client = new FusionClient()
// await client.start()

export * from './protocol';