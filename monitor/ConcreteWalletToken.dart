import 'package:fusion_wallet/src/rust/api/wallet.dart';

class ConcreteWalletToken implements WalletToken {
  @override
  String? imageUrl;

  @override
  String? indexCanister;

  @override
  WalletTokenNetWork network;

  @override
  String symbol;

  @override
  String tokenAddress;

  @override
  int? tokenDecimal;

  @override
  String tokenName;

  @override
  BigInt transferFee;

  ConcreteWalletToken({
    required this.symbol,
    required this.network,
    required this.tokenAddress,
    required this.tokenName,
    required this.transferFee,
    this.tokenDecimal,
    this.imageUrl,
    this.indexCanister,
  });

  factory ConcreteWalletToken.fromJson(Map<String, dynamic> json) {
    return ConcreteWalletToken(
      symbol: json["symbol"],
      network: switch (json["network"]) {
        "bitcoin" => WalletTokenNetWork.bitcoin,
        "internetComputer" => WalletTokenNetWork.internetComputer,
        _ => WalletTokenNetWork.internetComputer // default case
      },
      tokenAddress: json["token_address"],
      tokenDecimal: json["token_decimal"],
      imageUrl: json["image_url"],
      tokenName: json["token_name"],
      indexCanister: json["index_canister"],
      transferFee: BigInt.parse(json["transfer_fee"] ?? "0"),
    );
  }

  static ConcreteWalletToken fromWalletToken(WalletToken token) {
    return ConcreteWalletToken(
      symbol: token.symbol,
      network: token.network,
      tokenAddress: token.tokenAddress,
      tokenName: token.tokenName,
      transferFee: token.transferFee,
      tokenDecimal: token.tokenDecimal,
      imageUrl: token.imageUrl,
      indexCanister: token.indexCanister,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  // TODO: implement isDisposed
  bool get isDisposed => throw UnimplementedError();

  @override
  String? govCanister;
}
