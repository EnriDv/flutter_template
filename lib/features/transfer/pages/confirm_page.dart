import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../widgets/transfer_summary_card.dart';

// 🔹 PANTALLA 3: Confirmación (devuelve Account actualizado con pop)
class ConfirmPage extends StatelessWidget {
  final Account account;
  final String amount;

  const ConfirmPage({
    super.key,
    required this.account,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Transferencia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Transferencia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TransferSummaryCard(
              accountId: account.id,
              amount: amount,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 🔹 TIPO 3: Pop + retorno de Account actualizado
                  final transferAmount = double.parse(amount);
                  final updatedAccount = account.copyWith(
                    balance: account.balance - transferAmount,
                  );
                  
                  Navigator.pop(context, updatedAccount);
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Confirmar Transferencia'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
