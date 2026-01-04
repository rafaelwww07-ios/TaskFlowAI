import 'package:equatable/equatable.dart';

/// Base failure class for error handling
abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({super.message});
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
}

/// Generic failure
class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}

