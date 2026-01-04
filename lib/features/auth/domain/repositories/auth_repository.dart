import '../../../../core/utils/result.dart';
import '../entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Result<User>> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<Result<User>> signUpWithEmail(String email, String password, String name);

  /// Sign in anonymously (demo mode)
  Future<Result<User>> signInAnonymously();

  /// Sign out
  Future<Result<void>> signOut();

  /// Get current user
  Future<Result<User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<Result<bool>> isAuthenticated();
}

