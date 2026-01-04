/// Base exception class
abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

/// Server exceptions
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message);
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message);
}

