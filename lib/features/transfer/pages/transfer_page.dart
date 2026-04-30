import 'package:flutter/material.dart';
import '../../../widgets/transfer_result_box.dart';
import 'confirm_page.dart';

//ransferencia (recibe accountId via pushNamed)
class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String _result = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recuperar el accountId pasado por pushNamed
    final accountId = ModalRoute.of(context)?.settings.arguments as String?;
    debugPrint('Account ID recibido: $accountId');
  }

  @override
  Widget build(BuildContext context) {
    // Recuperar el accountId
    final accountId = ModalRoute.of(context)?.settings.arguments as String? ?? 'Desconocida';

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
              'Cuenta seleccionada: $accountId',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            // Navegación imperativa con push
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

                  //Push imperativo + await para recibir resultado
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmPage(
                        accountId: accountId,
                        amount: _amountController.text,
                      ),
                    ),
                  );

                  if (resultado != null) {
                    setState(() {
                      _result = resultado as String;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_result)),
                    );
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
