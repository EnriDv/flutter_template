import 'package:flutter/material.dart';
import '../../../models/account.dart';
import '../../../widgets/transfer_result_box.dart';
import 'confirm_page.dart';
// 🔹 PANTALLA 2: Transferencia (recibe Account via pushNamed)
class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    // Recuperar la cuenta pasada por pushNamed
    final account = ModalRoute.of(context)?.settings.arguments as Account? ?? 
        Account(id: 'Desconocida', name: 'Desconocida', balance: 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuenta: ${account.name}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Saldo disponible: ${account.balanceFormatted}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text('Ingresa el monto a transferir:'),
            const SizedBox(height: 10),
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
            // 🔹 TIPO 2: Push imperativo + await
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

                  // Validar saldo suficiente
                  if (amount > account.balance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saldo insuficiente')),
                    );
                    return;
                  }

                  // 🔹 TIPO 2 y 3: Push imperativo + await para recibir resultado
                  final updatedAccount = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmPage(
                        account: account,
                        amount: _amountController.text,
                      ),
                    ),
                  );

                  if (updatedAccount != null && updatedAccount is Account) {
                    setState(() {
                      account.balance = updatedAccount.balance;
                      _result = '✅ Transferencia de \$${_amountController.text} exitosa';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_result)),
                    );
                    
                    // Devolver cuenta actualizada al home
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pop(context, updatedAccount);
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
