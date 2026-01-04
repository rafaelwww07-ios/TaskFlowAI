import '../errors/failures.dart';

/// Result class for handling success/failure states
sealed class Result<T> {
  const Result();
}

/// Success result
class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Failure result
class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;

  /// Get failure if error, null otherwise
  Failure? get failureOrNull => isError ? (this as Error<T>).failure : null;

  /// Map result data
  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) {
      return Success(mapper((this as Success<T>).data));
    }
    return Error((this as Error<T>).failure);
  }

  /// Fold result
  R fold<R>(R Function(Failure failure) onError, R Function(T data) onSuccess) {
    if (isSuccess) {
      return onSuccess((this as Success<T>).data);
    }
    return onError((this as Error<T>).failure);
  }
}

