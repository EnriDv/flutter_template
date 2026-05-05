import 'package:flutter/material.dart';
import '../../../models/account.dart';

// Confirmación (actualiza origen y destino)
class ConfirmPage extends StatelessWidget {
  final Account sourceAccount;
  final Account destinationAccount;
  final String amount;

  const ConfirmPage({
    super.key,
    required this.sourceAccount,
    required this.destinationAccount,
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
            
            // ORIGEN
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('De:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(sourceAccount.name),
                    const SizedBox(height: 4),
                    Text(
                      'Saldo actual: ${sourceAccount.balanceFormatted}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // MONTO
            Center(
              child: Text(
                '\$${amount}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // DESTINO
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Para:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(destinationAccount.name),
                    const SizedBox(height: 4),
                    Text(
                      'Saldo actual: ${destinationAccount.balanceFormatted}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Pop + retorno (ambas cuentas actualizadas)
                  final transferAmount = double.parse(amount);
                  
                  final updatedSource = sourceAccount.copyWith(
                    balance: sourceAccount.balance - transferAmount,
                  );
                  
                  final updatedDestination = destinationAccount.copyWith(
                    balance: destinationAccount.balance + transferAmount,
                  );
                  
                  final result = {
                    updatedSource.id: updatedSource,
                    updatedDestination.id: updatedDestination,
                  };
                  
                  Navigator.pop(context);
                  
                  Navigator.pop(context, result);
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
