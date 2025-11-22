import 'package:flutter/foundation.dart';

import '../../domain/entities/material_item.dart';
import '../../domain/repositories/material_repository.dart';

enum MaterialLoadingStatus { initial, loading, loaded, error }

class MaterialProvider extends ChangeNotifier {
  final MaterialRepository repository;

  List<MaterialItem> _materials = [];
  MaterialLoadingStatus _status = MaterialLoadingStatus.initial;
  String? _errorMessage;

  MaterialProvider(this.repository);

  List<MaterialItem> get materials => _materials;
  MaterialLoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> loadMaterials() async {
    _status = MaterialLoadingStatus.loading;
    notifyListeners();

    final result = await repository.getMaterials();
    result.fold(
      (failure) {
        _status = MaterialLoadingStatus.error;
        _errorMessage = failure.message;
      },
      (items) {
        _materials = items;
        _status = MaterialLoadingStatus.loaded;
      },
    );
    notifyListeners();
  }

  Future<bool> addMaterial(MaterialItem material) async {
    final result = await repository.addMaterial(material);
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      },
      (_) {
        _materials.add(material);
        notifyListeners();
        return true;
      },
    );
  }

  Future<MaterialItem?> getMaterialById(String id) async {
    final result = await repository.getMaterialById(id);
    return result.fold(
      (failure) => null,
      (item) => item,
    );
  }
}
