import 'package:flutter/material.dart';

class TransferResultBox extends StatelessWidget {
  final String message;

  const TransferResultBox({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Resultado: $message',
        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
}
