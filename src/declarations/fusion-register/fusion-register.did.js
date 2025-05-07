export const idlFactory = ({ IDL }) => {
  const Result = IDL.Variant({ 'Ok' : IDL.Text, 'Err' : IDL.Text });
  const Result_1 = IDL.Variant({ 'Ok' : IDL.Null, 'Err' : IDL.Text });
  return IDL.Service({
    'export_candid' : IDL.Func([], [IDL.Text], ['query']),
    'get_deposit_address' : IDL.Func([], [IDL.Text], ['query']),
    'get_wallet_address' : IDL.Func([], [IDL.Opt(IDL.Text)], ['query']),
    'provision_wallet' : IDL.Func([], [Result], []),
    'upgrade_wallets' : IDL.Func([], [Result_1], []),
  });
};
export const init = ({ IDL }) => { return []; };
