import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockDataSource dataSource;
  User? _currentUser;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await dataSource.login(email, password);
      if (user != null) {
        _currentUser = user;
        return Right(user);
      } else {
        return const Left(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    try {
      final user = await dataSource.register(name, email, password);
      _currentUser = user;
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    _currentUser = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return Right(_currentUser);
  }
}
