import 'package:flutter/material.dart';
import '../core/constants/app_routes.dart';
import '../models/account.dart';
import '../widgets/account_list_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Account> accounts = [
    Account(id: 'ACC001', name: 'Cuenta Corriente', balance: 5000.00),
    Account(id: 'ACC002', name: 'Cuenta Ahorro', balance: 12500.00),
    Account(id: 'ACC003', name: 'Cuenta Inversión', balance: 25000.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return AccountListTile(
            accountId: account.id,
            accountName: account.name,
            balance: account.balanceFormatted,
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.transfer,
                arguments: {
                  AppRoutes.argSourceAccount: account,
                  AppRoutes.argAllAccounts: accounts,
                },
              );

              if (result != null && result is Map<String, Account>) {
                setState(() {
                  // Actualizar ambas cuentas
                  result.forEach((id, updatedAccount) {
                    final accountIndex = accounts.indexWhere((acc) => acc.id == id);
                    if (accountIndex >= 0) {
                      accounts[accountIndex] = updatedAccount;
                    }
                  });
                });
              }
            },
          );
        },
      ),
    );
  }
}


