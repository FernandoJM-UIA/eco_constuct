import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/material_item.dart';
import '../../domain/repositories/impact_repository.dart';
import '../providers/auth_provider.dart';
import '../routes/route_arguments.dart';

class MaterialDetailScreen extends StatelessWidget {
  final MaterialItem item;

  const MaterialDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final isOwner = currentUser?.id == item.sellerId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del material'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: context.read<ImpactRepository>().calculateImpact(item.quantity),
        builder: (context, snapshot) {
          final impact = snapshot.data?.fold((l) => null, (r) => r);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.category, 'Categoría', item.category.toString().split('.').last),
                _buildInfoRow(Icons.scale, 'Cantidad', '${item.quantity} ${item.unit}'),
                _buildInfoRow(Icons.attach_money, 'Precio', '\$${item.price.toStringAsFixed(2)} MXN'),
                _buildInfoRow(Icons.place, 'Ubicación', item.locationDescription),
                
                const SizedBox(height: 24),
                const Text(
                  'Impacto ambiental estimado al reutilizar:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (impact != null) ...[
                  _buildImpactRow(Icons.cloud, 'CO₂ evitado', '${impact.co2Saved.toStringAsFixed(1)} kg'),
                  _buildImpactRow(Icons.bolt, 'Energía ahorrada', '${impact.energySaved.toStringAsFixed(1)} kWh'),
                  _buildImpactRow(Icons.water_drop, 'Agua ahorrada', '${impact.waterSaved.toStringAsFixed(1)} L'),
                ] else
                  const Text('Calculando impacto...'),

                const SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isOwner)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: ChatScreenArgs(
                              otherUserId: item.sellerId,
                              materialId: item.id,
                            ),
                          );
                        },
                        label: const Text('Contactar Vendedor'),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.map),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/map',
                          arguments: MapScreenArgs(item: item),
                        );
                      },
                      label: const Text('Ver Ubicación en Mapa'),
                    ),
                    const SizedBox(height: 8),
                    if (!isOwner)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/payment',
                            arguments: PaymentScreenArgs(material: item),
                          );
                        },
                        label: const Text('Comprar / Intercambiar'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
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
