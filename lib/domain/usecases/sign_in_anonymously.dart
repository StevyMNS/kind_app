import 'package:kind_app/domain/entities/user_entity.dart';
import 'package:kind_app/domain/repositories/auth_repository.dart';

/// Use case : connexion anonyme.
class SignInAnonymously {
  final AuthRepository _repository;

  const SignInAnonymously(this._repository);

  Future<UserEntity> call() => _repository.signInAnonymously();
}
