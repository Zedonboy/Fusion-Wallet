export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'export_candid' : IDL.Func([], [IDL.Text], ['query']),
    'get_ecdsa_public_key' : IDL.Func(
        [IDL.Opt(IDL.Vec(IDL.Nat8))],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
    'get_ecdsa_signature' : IDL.Func(
        [IDL.Vec(IDL.Nat8), IDL.Opt(IDL.Vec(IDL.Nat8))],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
    'get_schnorr_ed25519_public_key' : IDL.Func(
        [IDL.Opt(IDL.Vec(IDL.Nat8))],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
    'get_schnorr_secp256k1_public_key' : IDL.Func(
        [IDL.Opt(IDL.Vec(IDL.Nat8))],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
    'schnorr_ed25519_signature' : IDL.Func(
        [IDL.Vec(IDL.Nat8), IDL.Opt(IDL.Vec(IDL.Nat8))],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
    'schnorr_secp256k1_signature' : IDL.Func(
        [IDL.Vec(IDL.Nat8), IDL.Opt(IDL.Vec(IDL.Nat8))],
        [IDL.Vec(IDL.Nat8)],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
