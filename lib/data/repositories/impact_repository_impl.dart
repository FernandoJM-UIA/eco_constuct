import '../../core/constants/impact_constants.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/impact_log.dart';
import '../../domain/repositories/impact_repository.dart';
import '../datasources/mock_data_source.dart';
import '../models/impact_log_model.dart';

class ImpactRepositoryImpl implements ImpactRepository {
  final MockDataSource dataSource;

  ImpactRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, ImpactLog>> calculateImpact(double quantity) async {
    try {
      final co2 = ImpactConstants.co2PerKg * quantity;
      final energy = ImpactConstants.energyPerKg * quantity;
      final water = ImpactConstants.waterPerKg * quantity;
      
      return Right(ImpactLog(
        id: '',
        userId: '',
        materialId: '',
        co2Saved: co2,
        energySaved: energy,
        waterSaved: water,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ImpactLog>>> getUserImpactHistory(String userId) async {
    try {
      final logs = await dataSource.getUserImpactHistory(userId);
      return Right(logs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logImpact(ImpactLog log) async {
    try {
      final model = ImpactLogModel.fromEntity(log);
      await dataSource.logImpact(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ImpactLog>> getAggregatedImpact(String userId) async {
    try {
      final logs = await dataSource.getUserImpactHistory(userId);
      double co2 = 0;
      double energy = 0;
      double water = 0;

      for (var log in logs) {
        co2 += log.co2Saved;
        energy += log.energySaved;
        water += log.waterSaved;
      }

      return Right(ImpactLog(
        id: 'aggregated',
        userId: userId,
        materialId: '',
        co2Saved: co2,
        energySaved: energy,
        waterSaved: water,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
