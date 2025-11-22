import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../entities/material_item.dart';

abstract class MaterialRepository {
  Future<Either<Failure, List<MaterialItem>>> getMaterials();
  Future<Either<Failure, MaterialItem>> getMaterialById(String id);
  Future<Either<Failure, void>> addMaterial(MaterialItem material);
  Future<Either<Failure, void>> updateMaterial(MaterialItem material);
  Future<Either<Failure, void>> deleteMaterial(String id);
  Future<Either<Failure, List<MaterialItem>>> getMaterialsBySeller(String sellerId);
}
