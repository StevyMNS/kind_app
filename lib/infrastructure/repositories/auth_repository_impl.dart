import 'package:kind_app/core/error/exceptions.dart';
import 'package:kind_app/core/utils/logger.dart';
import 'package:kind_app/domain/entities/user_entity.dart';
import 'package:kind_app/domain/repositories/auth_repository.dart';
import 'package:kind_app/infrastructure/datasources/auth_remote_datasource.dart';

/// Implémentation du repository d'authentification.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  const AuthRepositoryImpl(this._datasource);

  @override
  Future<UserEntity> signInAnonymously() async {
    try {
      final user = await _datasource.signInAnonymously();
      return UserEntity(
        id: user.id,
        createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      );
    } on AppAuthException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('AuthRepositoryImpl.signInAnonymously', e, st);
      throw AppAuthException('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return _datasource.isSignedIn;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _datasource.currentUser;
    if (user == null) return null;
    return UserEntity(
      id: user.id,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }
}
