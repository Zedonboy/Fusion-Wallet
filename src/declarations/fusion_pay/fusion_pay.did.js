export const idlFactory = ({ IDL }) => {
  const PaymentLink = IDL.Record({
    'id' : IDL.Text,
    'token_symbol' : IDL.Text,
    'amount' : IDL.Float32,
    'qr_data' : IDL.Text,
  });
  const Result = IDL.Variant({ 'Ok' : IDL.Text, 'Err' : IDL.Text });
  const HttpRequest = IDL.Record({
    'url' : IDL.Text,
    'method' : IDL.Text,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(IDL.Tuple(IDL.Text, IDL.Text)),
    'certificate_version' : IDL.Opt(IDL.Nat16),
  });
  const HttpResponse = IDL.Record({
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(IDL.Tuple(IDL.Text, IDL.Text)),
    'upgrade' : IDL.Opt(IDL.Bool),
    'status_code' : IDL.Nat16,
  });
  return IDL.Service({
    '__candid_method_export_candid' : IDL.Func([], [IDL.Text], ['query']),
    'create_payment_link' : IDL.Func([PaymentLink], [Result], []),
    'export_candid' : IDL.Func([], [IDL.Text], ['query']),
    'get_payment_links' : IDL.Func([], [IDL.Vec(PaymentLink)], ['query']),
    'http_request' : IDL.Func([HttpRequest], [HttpResponse], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
