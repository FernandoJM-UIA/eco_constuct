import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/impact_provider.dart';

class ImpactScreen extends StatefulWidget {
  const ImpactScreen({super.key});

  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

class _ImpactScreenState extends State<ImpactScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<ImpactProvider>().loadUserImpact(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final impactProvider = context.watch<ImpactProvider>();
    final impact = impactProvider.aggregatedImpact;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi impacto ambiental'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentUser == null
            ? const Center(child: Text('Inicia sesión para ver tu impacto.'))
            : impactProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Text(currentUser.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currentUser.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text(currentUser.email, style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('Impacto total acumulado:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (impact != null) ...[
                        _buildImpactCard(Icons.cloud, 'CO₂ Evitado', '${impact.co2Saved.toStringAsFixed(1)} kg', Colors.blueGrey),
                        _buildImpactCard(Icons.bolt, 'Energía Ahorrada', '${impact.energySaved.toStringAsFixed(1)} kWh', Colors.orange),
                        _buildImpactCard(Icons.water_drop, 'Agua Ahorrada', '${impact.waterSaved.toStringAsFixed(1)} L', Colors.blue),
                      ] else
                        const Center(child: Text('No hay registros de impacto aún.')),
                      
                      const Spacer(),
                      const Text(
                        'Estos valores son estimaciones basadas en factores promedio de la industria de la construcción.',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildImpactCard(IconData icon, String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
