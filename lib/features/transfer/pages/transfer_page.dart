import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../widgets/transfer_result_box.dart';
import 'confirm_page.dart';

// 🔹 PANTALLA 2: Transferencia (recibe sourceAccount + allAccounts)
class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String _result = '';
  Account? _destinationAccount;

  @override
  Widget build(BuildContext context) {
    // Recuperar argumentos
    final arguments = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final sourceAccount = arguments['sourceAccount'] as Account? ?? 
        Account(id: 'Desconocida', name: 'Desconocida', balance: 0);
    final allAccounts = (arguments['allAccounts'] as List?)?.cast<Account>() ?? [];
    
    // Cuentas disponibles como destino (excluyendo la cuenta origen)
    final destinationOptions = allAccounts.where((acc) => acc.id != sourceAccount.id).toList();
    
    // Inicializar destino si no está seleccionado
    if (_destinationAccount == null && destinationOptions.isNotEmpty) {
      _destinationAccount = destinationOptions.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ORIGEN
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Desde:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      sourceAccount.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saldo: ${sourceAccount.balanceFormatted}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // DESTINO (dropdown)
            const Text(
              'Transferir a:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<Account>(
              isExpanded: true,
              value: _destinationAccount,
              onChanged: (Account? newValue) {
                setState(() {
                  _destinationAccount = newValue;
                });
              },
              items: destinationOptions.map((Account account) {
                return DropdownMenuItem<Account>(
                  value: account,
                  child: Text('${account.name} - ${account.balanceFormatted}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // MONTO
            const Text('Monto a transferir:'),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Monto',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 20),

            // BOTÓN CONTINUAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor ingresa un monto')),
                    );
                    return;
                  }

                  final amount = double.tryParse(_amountController.text);
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Monto inválido')),
                    );
                    return;
                  }

                  if (amount > sourceAccount.balance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saldo insuficiente')),
                    );
                    return;
                  }

                  if (_destinationAccount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selecciona una cuenta destino')),
                    );
                    return;
                  }

                  // 🔹 TIPO 2 y 3: Push imperativo + await
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmPage(
                        sourceAccount: sourceAccount,
                        destinationAccount: _destinationAccount!,
                        amount: _amountController.text,
                      ),
                    ),
                  );

                  if (result != null && result is Map<String, Account>) {
                    setState(() {
                      _result = '✅ Transferencia de \$${_amountController.text} completada';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_result)),
                    );

                    // Devolver ambas cuentas actualizadas al home
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context, result);
                    });
                  }
                },
                child: const Text('Continuar a Confirmación'),
              ),
            ),
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 20),
              TransferResultBox(message: _result),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
