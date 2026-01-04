import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/result.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository repository})
      : _repository = repository,
        super(const AuthState()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignUpWithEmail>(_onSignUpWithEmail);
    on<SignInAnonymously>(_onSignInAnonymously);
    on<SignOut>(_onSignOut);
  }

  final AuthRepository _repository;

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.getCurrentUser();
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
        ));
      },
      (user) {
        if (user != null) {
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          ));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.signInWithEmail(
      event.email,
      event.password,
    );
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message ?? 'Authentication failed',
        ));
      },
      (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      },
    );
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.signUpWithEmail(
      event.email,
      event.password,
      event.name,
    );
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message ?? 'Registration failed',
        ));
      },
      (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      },
    );
  }

  Future<void> _onSignInAnonymously(
    SignInAnonymously event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.signInAnonymously();
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message ?? 'Demo mode failed',
        ));
      },
      (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      },
    );
  }

  Future<void> _onSignOut(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _repository.signOut();
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      },
    );
  }
}

