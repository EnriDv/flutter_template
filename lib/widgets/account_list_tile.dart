import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  final String accountId;
  final String accountName;
  final String balance;
  final VoidCallback onTap;

  const AccountListTile({
    super.key,
    required this.accountId,
    required this.accountName,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(accountName),
      subtitle: Text('$accountId - Saldo: $balance'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
