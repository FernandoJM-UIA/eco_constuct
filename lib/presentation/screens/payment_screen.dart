import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/material_item.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/impact_repository.dart';
import '../providers/auth_provider.dart';
import '../providers/payment_provider.dart';



class PaymentScreen extends StatefulWidget {
  final MaterialItem material;
  const PaymentScreen({super.key, required this.material});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _completed = false;

  void _confirmPayment() async {
    final currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser == null) return;

    final transaction = Transaction(
      id: const Uuid().v4(),
      buyerId: currentUser.id,
      sellerId: widget.material.sellerId,
      materialId: widget.material.id,
      amount: widget.material.price,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
    );

    final success = await context.read<PaymentProvider>().processPayment(transaction);

    if (success && mounted) {
      setState(() {
        _completed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proceso de pago'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: context.read<ImpactRepository>().calculateImpact(widget.material.quantity),
        builder: (context, snapshot) {
          final impact = snapshot.data?.fold((l) => null, (r) => r);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _completed
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[700], size: 72),
                        const SizedBox(height: 16),
                        const Text('¡Transacción completada!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Gracias por contribuir al reciclaje.', textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, ModalRoute.withName('/home'));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Volver al inicio'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Resumen del pedido', style: Theme.of(context).textTheme.titleLarge),
                              const Divider(),
                              Text('Material: ${widget.material.name}'),
                              Text('Cantidad: ${widget.material.quantity} ${widget.material.unit}'),
                              const SizedBox(height: 8),
                              Text(
                                'Total a pagar: \$${widget.material.price.toStringAsFixed(2)} MXN',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Beneficios ambientales estimados:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (impact != null) ...[
                        _buildImpactRow(Icons.cloud, 'CO₂ evitado', '${impact.co2Saved.toStringAsFixed(1)} kg'),
                        _buildImpactRow(Icons.bolt, 'Energía ahorrada', '${impact.energySaved.toStringAsFixed(1)} kWh'),
                        _buildImpactRow(Icons.water_drop, 'Agua ahorrada', '${impact.waterSaved.toStringAsFixed(1)} L'),
                      ] else
                        const Text('Calculando...'),
                      
                      if (provider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)),
                        ),
                        
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.isProcessing ? null : _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: provider.isProcessing
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Confirmar Transacción'),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildImpactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
