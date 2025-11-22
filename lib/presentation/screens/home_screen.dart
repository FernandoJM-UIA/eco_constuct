import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/material_item.dart';
import '../providers/auth_provider.dart';
import '../providers/material_provider.dart';
import '../routes/route_arguments.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaterialProvider>().loadMaterials();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace de Materiales'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'impact') {
                Navigator.pushNamed(context, '/impact');
              } else if (value == 'logout') {
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'impact',
                child: Row(
                  children: [
                    Icon(Icons.eco, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Mi impacto'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<MaterialProvider>(
        builder: (context, provider, _) {
          if (provider.status == MaterialLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.status == MaterialLoadingStatus.error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          final items = provider.materials;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay materiales publicados.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadMaterials(),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Icon(_getCategoryIcon(item.category), color: Colors.green[800]),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.locationDescription,
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.quantity} ${item.unit} • \$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/materialDetail',
                        arguments: MaterialDetailArgs(item: item),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/addMaterial'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getCategoryIcon(MaterialCategory category) {
    switch (category) {
      case MaterialCategory.concretoSimple:
      case MaterialCategory.concretoArmado:
        return Icons.foundation;
      case MaterialCategory.mamposteriaRecubierta:
        return Icons.grid_view;
      case MaterialCategory.mezclaAsfaltica:
        return Icons.edit_road;
      case MaterialCategory.prefabricadosMixtos:
        return Icons.layers;
      case MaterialCategory.otros:
        return Icons.category;
    }
  }
}
