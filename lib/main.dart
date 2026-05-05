import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'pages/home_page.dart';
import 'features/transfer/pages/transfer_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Selecciona una cuenta'),
      routes: {
        AppRoutes.transfer: (context) => const TransferPage(),
      },
    );
  }
}