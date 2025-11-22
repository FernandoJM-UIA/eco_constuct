import 'package:equatable/equatable.dart';

enum UserRole { comprador, vendedor, ambos }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = UserRole.ambos,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, name, email, password, role];
}
