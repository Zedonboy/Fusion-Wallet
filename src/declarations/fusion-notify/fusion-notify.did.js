export const idlFactory = ({ IDL }) => {
  const AppInfo = IDL.Record({
    'domain' : IDL.Opt(IDL.Text),
    'name' : IDL.Opt(IDL.Text),
    'canister_id' : IDL.Text,
    'icon_url' : IDL.Opt(IDL.Text),
  });
  const CanisterPermissionInfo = IDL.Record({
    'canister_id' : IDL.Principal,
    'enabled' : IDL.Bool,
    'app_info' : AppInfo,
  });
  const HttpHeader = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const HttpResponse = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const TransformArgs = IDL.Record({
    'context' : IDL.Vec(IDL.Nat8),
    'response' : HttpResponse,
  });
  const NotifyMessage = IDL.Record({
    'title' : IDL.Text,
    'body' : IDL.Text,
    'action_url' : IDL.Opt(IDL.Text),
    'icon_url' : IDL.Opt(IDL.Text),
    'data_type' : IDL.Opt(IDL.Text),
  });
  const Result = IDL.Variant({ 'Ok' : IDL.Null, 'Err' : IDL.Text });
  return IDL.Service({
    'add_app_permission' : IDL.Func([IDL.Text, AppInfo], [], []),
    'add_device_token' : IDL.Func([IDL.Text], [], []),
    'export_candid' : IDL.Func([], [IDL.Text], ['query']),
    'get_all_device_tokens' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, IDL.Vec(IDL.Text)))],
        ['query'],
      ),
    'get_canister_permissions' : IDL.Func(
        [],
        [IDL.Vec(CanisterPermissionInfo)],
        ['query'],
      ),
    'get_device_tokens' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
    'http_transform' : IDL.Func([TransformArgs], [HttpResponse], ['query']),
    'remove_canister_permission' : IDL.Func([IDL.Principal], [], []),
    'remove_device_token' : IDL.Func([IDL.Text], [], []),
    'send_notification' : IDL.Func(
        [NotifyMessage, IDL.Principal],
        [Result],
        [],
      ),
    'send_test_message' : IDL.Func(
        [IDL.Text, IDL.Text, IDL.Text],
        [Result],
        [],
      ),
    'send_transfer_message' : IDL.Func([IDL.Text, IDL.Nat64], [Result], []),
    'update_canister_permission' : IDL.Func([IDL.Principal, IDL.Bool], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
