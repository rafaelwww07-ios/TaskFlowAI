import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication repository implementation (mock)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl() : _currentUser = null;

  User? _currentUser;

  @override
  Future<Result<User>> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock authentication - accept any valid email/password
    if (email.isNotEmpty && password.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: email.split('@').first,
        createdAt: DateTime.now(),
        isDemo: false,
      );
      return Success(_currentUser!);
    }
    
    return const Error(AuthFailure(message: 'Invalid email or password'));
  }

  @override
  Future<Result<User>> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
        isDemo: false,
      );
      return Success(_currentUser!);
    }
    
    return const Error(ValidationFailure(message: 'Invalid input'));
  }

  @override
  Future<Result<User>> signInAnonymously() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = User(
      id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      email: 'demo@taskflow.ai',
      name: 'Demo User',
      createdAt: DateTime.now(),
      isDemo: true,
    );
    
    return Success(_currentUser!);
  }

  @override
  Future<Result<void>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    return const Success(null);
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Success(_currentUser);
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    final userResult = await getCurrentUser();
    return userResult.map((user) => user != null);
  }
}

