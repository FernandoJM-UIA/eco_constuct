import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/material_item.dart';
import '../../domain/repositories/material_repository.dart';
import '../datasources/mock_data_source.dart';
import '../models/material_model.dart';

class MaterialRepositoryImpl implements MaterialRepository {
  final MockDataSource dataSource;

  MaterialRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<MaterialItem>>> getMaterials() async {
    try {
      final materials = await dataSource.getMaterials();
      return Right(materials);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaterialItem>> getMaterialById(String id) async {
    try {
      final material = await dataSource.getMaterialById(id);
      if (material != null) {
        return Right(material);
      } else {
        return const Left(CacheFailure('Material not found'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMaterial(MaterialItem material) async {
    try {
      final model = MaterialModel.fromEntity(material);
      await dataSource.addMaterial(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMaterial(MaterialItem material) async {
    try {
      final model = MaterialModel.fromEntity(material);
      await dataSource.updateMaterial(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaterial(String id) async {
    try {
      await dataSource.deleteMaterial(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MaterialItem>>> getMaterialsBySeller(String sellerId) async {
    try {
      final materials = await dataSource.getMaterials();
      final sellerMaterials = materials.where((m) => m.sellerId == sellerId).toList();
      return Right(sellerMaterials);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
