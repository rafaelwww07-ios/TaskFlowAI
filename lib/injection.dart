import 'package:get_it/get_it.dart';
import 'features/tasks/data/datasources/task_local_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> configureDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      localDataSource: getIt<TaskLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // BLoCs
  getIt.registerFactory<TaskBloc>(
    () => TaskBloc(
      repository: getIt<TaskRepository>(),
    ),
  );

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      repository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<SettingsBloc>(
    () => SettingsBloc(),
  );
}

