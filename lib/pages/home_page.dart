import 'package:flutter/material.dart';
import '../widgets/account_list_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> accounts = [
    {'id': 'ACC001', 'name': 'Cuenta Corriente', 'balance': '\$5,000'},
    {'id': 'ACC002', 'name': 'Cuenta Ahorro', 'balance': '\$12,500'},
    {'id': 'ACC003', 'name': 'Cuenta Inversión', 'balance': '\$25,000'},
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
            accountId: account['id']!,
            accountName: account['name']!,
            balance: account['balance']!,
            //  Navegación con pushNamed + parámetro
            onTap: () {
              Navigator.pushNamed(
                context,
                '/transfer',
                arguments: account['id'],
              );
            },
          );
        },
      ),
    );
  }
}

