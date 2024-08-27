import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CryptoAccountsScreen extends StatelessWidget {
  final List<CryptoAccount> accounts = [
    CryptoAccount('0x1234567890abcdef', 'example.com', true),
    CryptoAccount('0xabcdef1234567890', 'crypto.org', false),
    CryptoAccount('0x9876543210fedcba', 'blockchain.info', true),
    // Add more accounts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Identities'),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => AccountListItem(account: accounts[index]),
              childCount: accounts.length,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountListItem extends StatelessWidget {
  final CryptoAccount account;

  const AccountListItem({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.address,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(account.domain),
                  const SizedBox(height: 8),
                  ConnectionStatus(isConnected: account.isConnected),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: account.address));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address copied to clipboard')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionStatus extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatus({Key? key, required this.isConnected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isConnected ? 'Connected' : 'Disconnected',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class CryptoAccount {
  final String address;
  final String domain;
  final bool isConnected;

  CryptoAccount(this.address, this.domain, this.isConnected);
}
