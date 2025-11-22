import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/impact_log.dart';

abstract class ImpactRepository {
  Future<Either<Failure, ImpactLog>> calculateImpact(double quantity);
  Future<Either<Failure, List<ImpactLog>>> getUserImpactHistory(String userId);
  Future<Either<Failure, void>> logImpact(ImpactLog log);
  Future<Either<Failure, ImpactLog>> getAggregatedImpact(String userId);
}
