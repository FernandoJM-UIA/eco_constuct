import 'package:uuid/uuid.dart';

import '../../domain/entities/material_item.dart';
import '../../domain/entities/user.dart';
import '../models/impact_log_model.dart';
import '../models/material_model.dart';
import '../models/message_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class MockDataSource {
  final List<UserModel> _users = [];
  final List<MaterialModel> _materials = [];
  final List<MessageModel> _messages = [];
  final List<TransactionModel> _transactions = [];
  final List<ImpactLogModel> _impactLogs = [];
  final Uuid _uuid = const Uuid();

  // Singleton pattern
  static final MockDataSource _instance = MockDataSource._internal();
  factory MockDataSource() => _instance;
  MockDataSource._internal() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    if (_users.isNotEmpty) return;
    
    final user1 = UserModel(
      id: _uuid.v4(),
      name: 'Ana Constructora',
      email: 'ana@example.com',
      password: '123456',
      role: UserRole.ambos,
    );
    final user2 = UserModel(
      id: _uuid.v4(),
      name: 'Carlos Reciclador',
      email: 'carlos@example.com',
      password: '123456',
      role: UserRole.ambos,
    );
    _users.addAll([user1, user2]);

    final item1 = MaterialModel(
      id: _uuid.v4(),
      name: 'Ladrillos reutilizables',
      description: 'Palé de ladrillos recuperados de demolición en buen estado.',
      category: MaterialCategory.concreteMasonry,
      quantity: 500,
      unit: 'piezas',
      price: 1000.0,
      locationDescription: 'Obra en Tlalpan',
      latitude: 19.2906,
      longitude: -99.1503,
      sellerId: user1.id,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: MaterialStatus.available,
    );
    final item2 = MaterialModel(
      id: _uuid.v4(),
      name: 'Barra de acero reciclado',
      description: 'Barra metálica de 3 metros procedente de estructura.',
      category: MaterialCategory.other,
      quantity: 3,
      unit: 'piezas',
      price: 150.0,
      locationDescription: 'Centro de acopio Benito Juárez',
      latitude: 19.3654,
      longitude: -99.1639,
      sellerId: user2.id,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: MaterialStatus.available,
    );
    _materials.addAll([item1, item2]);
  }

  // Auth Methods
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      throw Exception('Email already exists');
    }
    final newUser = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email,
      password: password,
      role: UserRole.ambos,
    );
    _users.add(newUser);
    return newUser;
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  // Material Methods
  Future<List<MaterialModel>> getMaterials() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _materials;
  }

  Future<MaterialModel?> getMaterialById(String id) async {
    try {
      return _materials.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addMaterial(MaterialModel material) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _materials.add(material);
  }

  Future<void> updateMaterial(MaterialModel material) async {
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      _materials[index] = material;
    }
  }

  Future<void> deleteMaterial(String id) async {
    _materials.removeWhere((m) => m.id == id);
  }

  // Messaging Methods
  Future<List<MessageModel>> getConversation(String otherUserId, String currentUserId, String materialId) async {
    return _messages.where((msg) {
      final involvesCurrent = msg.fromUserId == currentUserId || msg.toUserId == currentUserId;
      final involvesOther = msg.fromUserId == otherUserId || msg.toUserId == otherUserId;
      return involvesCurrent && involvesOther && msg.materialId == materialId;
    }).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  Future<void> sendMessage(MessageModel message) async {
    _messages.add(message);
  }

  // Payment Methods
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(seconds: 2));
    _transactions.add(transaction);
    return transaction;
  }

  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    return _transactions.where((t) => t.buyerId == userId || t.sellerId == userId).toList();
  }

  // Impact Methods
  Future<void> logImpact(ImpactLogModel log) async {
    _impactLogs.add(log);
  }

  Future<List<ImpactLogModel>> getUserImpactHistory(String userId) async {
    return _impactLogs.where((l) => l.userId == userId).toList();
  }
}
