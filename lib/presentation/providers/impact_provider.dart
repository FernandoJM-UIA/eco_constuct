import 'package:flutter/foundation.dart';

import '../../domain/entities/impact_log.dart';
import '../../domain/repositories/impact_repository.dart';

class ImpactProvider extends ChangeNotifier {
  final ImpactRepository repository;

  ImpactLog? _aggregatedImpact;
  bool _isLoading = false;

  ImpactProvider(this.repository);

  ImpactLog? get aggregatedImpact => _aggregatedImpact;
  bool get isLoading => _isLoading;

  Future<void> loadUserImpact(String userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await repository.getAggregatedImpact(userId);
    result.fold(
      (failure) {},
      (impact) {
        _aggregatedImpact = impact;
      },
    );
    _isLoading = false;
    notifyListeners();
  }
}
