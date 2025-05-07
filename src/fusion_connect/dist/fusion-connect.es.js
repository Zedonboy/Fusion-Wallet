var b = Object.defineProperty;
var N = (t, e, o) => e in t ? b(t, e, { enumerable: !0, configurable: !0, writable: !0, value: o }) : t[e] = o;
var l = (t, e, o) => N(t, typeof e != "symbol" ? e + "" : e, o);
import { createLibp2p as _ } from "libp2p";
import { webSockets as v } from "@libp2p/websockets";
import { webRTC as A } from "@libp2p/webrtc";
import { noise as D } from "@chainsafe/libp2p-noise";
import { yamux as L } from "@chainsafe/libp2p-yamux";
import { tcp as S } from "@libp2p/tcp";
import { circuitRelayTransport as I } from "@libp2p/circuit-relay-v2";
import { identify as O } from "@libp2p/identify";
import { bootstrap as x } from "@libp2p/bootstrap";
import { Circuit as M } from "@multiformats/multiaddr-matcher";
import { lpStream as R } from "it-length-prefixed-stream";
import { ping as T } from "@libp2p/ping";
import w from "cbor";
import { Ed25519KeyIdentity as P, Delegation as q, DelegationChain as k, DelegationIdentity as G } from "@dfinity/identity";
class H {
  constructor() {
    this.modal = null, this.qrCode = null, this.overlay = null, this.initializeModal();
  }
  initializeModal() {
    this.overlay = document.createElement("div"), this.modal = document.createElement("div"), this.qrCode = document.createElement("div");
    const e = document.createElement("button");
    this.overlay.className = "fixed inset-0 bg-black/50 z-50", this.modal.className = "fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white p-6 rounded-lg shadow-xl", this.qrCode.className = "mb-4", e.className = "w-full bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded", e.textContent = "Close", this.modal.appendChild(this.qrCode), this.modal.appendChild(e), this.overlay.appendChild(this.modal), e.addEventListener("click", () => this.hide()), this.overlay.addEventListener("click", (o) => {
      o.target === this.overlay && this.hide();
    });
  }
  show(e, o = {}) {
    const n = qrcode(0, "M");
    n.addData(e), n.make(), this.qrCode.innerHTML = n.createSvgTag({
      cellSize: 8,
      margin: 4,
      ...o
    }), document.body.appendChild(this.overlay), document.body.classList.add("overflow-hidden");
  }
  hide() {
    this.overlay.parentNode && (document.body.removeChild(this.overlay), document.body.classList.remove("overflow-hidden"));
  }
}
var m = /* @__PURE__ */ ((t) => (t[t.HANDSHAKE_WELCOME = 1] = "HANDSHAKE_WELCOME", t[t.PERSONAL_SIGN = 2] = "PERSONAL_SIGN", t[t.GET_DELEGATION_CANISTER = 3] = "GET_DELEGATION_CANISTER", t[t.BLS_ENCRYPT_DATA = 4] = "BLS_ENCRYPT_DATA", t[t.CONNECT = 5] = "CONNECT", t))(m || {});
function ie(t) {
  return Object.values(m).includes(t == null ? void 0 : t.type);
}
function B(t) {
  return t.type;
}
const j = [
  "/dns4/bootstrap.libp2p.io/tcp/443/wss/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN",
  "/dns4/ws-star.discovery.libp2p.io/tcp/443/wss/p2p/QmZa1sAxajnQjVM8WjminX5rkCMSGUwBLMFHo5qsjf1YPd"
], U = "/fusion/1.0.0";
class E {
  constructor(e) {
    l(this, "node", null);
    l(this, "qrModal", null);
    l(this, "wallet_conn", null);
    l(this, "client_stream", null);
    l(this, "delegated_identity", null);
    this.node = e;
  }
  static async create(e) {
    let o = await _({
      transports: [A(), v(), I(), S()],
      connectionEncrypters: [D()],
      streamMuxers: [L()],
      peerDiscovery: [
        x({ list: (e == null ? void 0 : e.bootstrapNodes) || j })
      ],
      services: {
        // @ts-ignore
        identify: O({
          protocolPrefix: "fusion"
        }),
        // @ts-ignore
        ping: T()
      }
    });
    return o.addEventListener("peer:connect", (n) => {
      const r = n.detail;
      console.log("Connected to peer:", r), o.getPeers().length >= 2 && o.hangUp(r);
    }), o.addEventListener("peer:disconnect", (n) => {
      console.log("Disconnected from peer:", n.detail.toString());
    }), new E(o);
  }
  async login(e) {
    var c;
    let o = this.node, n = o == null ? void 0 : o.getMultiaddrs(), r = n == null ? void 0 : n.find(
      (i) => M.exactMatch(i) && i.getPeerId() == (o == null ? void 0 : o.peerId.toString())
    );
    if (!r)
      throw new Error("No circuit address found");
    (c = this.node) == null || c.handle(U, async ({ stream: i, connection: h }) => {
      var u, g;
      const a = R(i);
      let y = await a.read();
      try {
        const s = w.decode(y.subarray());
        switch (console.log("Received message type:", B(s)), s.type) {
          case m.HANDSHAKE_WELCOME:
            console.log("Handshake welcome received"), this.wallet_conn = h, (u = this.qrModal) == null || u.hide();
            const f = {
              type: m.CONNECT,
              domain: window.location.hostname,
              timestamp: Date.now()
            }, C = w.encode(f);
            this.client_stream = a, await a.write(C), console.log(
              "Connect message sent with domain:",
              window.location.hostname
            ), (g = e.onSuccess) == null || g.call(e);
            break;
          default:
            break;
        }
      } catch (s) {
        console.error("Error decoding message:", s);
      }
    });
    const p = r.toString(), d = new H();
    this.qrModal = d, d.show(p);
  }
  async get_delegation() {
    var d, c;
    if (!this.isConnected)
      throw new Error("Not connected to wallet. Please login first.");
    if (!this.wallet_conn || !this.node)
      throw new Error("Wallet connection not established");
    if (this.delegated_identity)
      return this.delegated_identity;
    let e = P.generate(), o = BigInt(Date.now() + 5 * 60 * 60 * 1e3) * BigInt(1e6), n = new q(e.getPublicKey().toDer(), o), r = n.toCBOR();
    const p = {
      type: m.GET_DELEGATION_CANISTER,
      delegation: new Uint8Array(r)
    };
    try {
      const i = w.encode(p);
      await ((d = this.client_stream) == null ? void 0 : d.write(i)), console.log("Delegation request sent");
      const h = await ((c = this.client_stream) == null ? void 0 : c.read()), a = w.decode((h == null ? void 0 : h.subarray()) ?? new Uint8Array());
      let y = new Uint8Array(a.publicKey), u = {
        delegation: n,
        signature: new Uint8Array(a.signature)
      }, g = k.fromDelegations([u], y), s = G.fromDelegation(e, g);
      return this.delegated_identity = s, s;
    } catch (i) {
      throw console.error("Error getting delegation:", i), i;
    }
  }
  async connect() {
    if (!this.isConnected)
      throw new Error("Not connected to wallet. Please login first.");
  }
  get isConnected() {
    var e;
    return ((e = this.wallet_conn) == null ? void 0 : e.status) === "open" && this.node !== null;
  }
  async logout() {
    this.node && (await this.node.stop(), this.node = null);
  }
}
export {
  E as FusionClient,
  m as MessageType,
  B as getMessageType,
  ie as isProtocolMessage
};
