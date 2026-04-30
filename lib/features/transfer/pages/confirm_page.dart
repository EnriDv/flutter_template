import 'package:flutter/material.dart';
import '../../../widgets/transfer_summary_card.dart';

// Confirmación (devuelve resultado con pop)
class ConfirmPage extends StatelessWidget {
  final String accountId;
  final String amount;

  const ConfirmPage({
    super.key,
    required this.accountId,
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
              accountId: accountId,
              amount: amount,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  //Navegación con pop + retorno de valor
                  Navigator.pop(
                    context,
                    '✅ Transferencia de \$$amount exitosa',
                  );
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
