import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/route_names.dart';
import 'injection.dart' as di;
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart' as auth;
import 'features/main/presentation/pages/main_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/tasks/presentation/pages/tasks_page.dart';
import 'features/tasks/presentation/pages/task_details_page.dart';
import 'features/calendar/presentation/pages/calendar_page.dart';
import 'features/analytics/presentation/pages/analytics_page.dart';
import 'features/ai_assistant/presentation/pages/ai_assistant_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'core/theme/color_schemes.dart';
import 'core/localization/app_localizations.dart';
import 'dart:ui' as ui;

/// Main application widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<SettingsBloc>()..add(const LoadSettings()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          // Determine locale - use saved language or device default
          final String deviceLanguageCode = ui.PlatformDispatcher.instance.locale.languageCode;
          final String currentLanguageCode = settingsState.languageCode.isNotEmpty
              ? settingsState.languageCode
              : (['ru', 'es'].contains(deviceLanguageCode) ? deviceLanguageCode : 'en');
          
          return BlocListener<SettingsBloc, SettingsState>(
            listenWhen: (previous, current) => previous.languageCode != current.languageCode,
            listener: (context, state) {
              // When language changes, reload tasks with new language
              // This will be handled when MaterialApp rebuilds with new locale
            },
            child: MaterialApp(
            title: 'TaskFlow AI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme.copyWith(
              colorScheme: ColorSchemes.getColorScheme(settingsState.colorSchemeType, Brightness.light),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              colorScheme: ColorSchemes.getColorScheme(settingsState.colorSchemeType, Brightness.dark),
            ),
            themeMode: settingsState.themeMode,
            locale: Locale(currentLanguageCode),
            localizationsDelegates: [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ru', ''),
              Locale('es', ''),
            ],
            initialRoute: RouteNames.splash,
            routes: {
        RouteNames.splash: (_) => BlocProvider(
              create: (_) => di.getIt<auth.AuthBloc>()..add(const auth.CheckAuthStatus()),
              child: const SplashPage(),
            ),
        RouteNames.login: (_) => BlocProvider(
              create: (_) => di.getIt<auth.AuthBloc>(),
              child: const LoginPage(),
            ),
        RouteNames.dashboard: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => di.getIt<SettingsBloc>()..add(const LoadSettings()),
                ),
                BlocProvider(
                  create: (_) => di.getIt<TaskBloc>()..add(const LoadTasks()),
                ),
              ],
              child: const MainPage(initialIndex: 0),
            ),
        RouteNames.tasks: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => di.getIt<TaskBloc>()..add(const LoadTasks()),
                ),
                BlocProvider(
                  create: (_) => di.getIt<SettingsBloc>()..add(const LoadSettings()),
                ),
              ],
              child: const MainPage(initialIndex: 1),
            ),
        RouteNames.taskDetails: (context) {
              final taskId = ModalRoute.of(context)?.settings.arguments as String?;
              return BlocProvider(
                create: (_) => di.getIt<auth.AuthBloc>()..add(const auth.CheckAuthStatus()),
                child: BlocProvider(
                  create: (_) => di.getIt<TaskBloc>()
                    ..add(taskId != null ? LoadTaskById(taskId) : const LoadTasks()),
                  child: const TaskDetailsPage(),
                ),
              );
            },
        RouteNames.calendar: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => di.getIt<TaskBloc>()..add(const LoadTasks()),
                ),
                BlocProvider(
                  create: (_) => di.getIt<SettingsBloc>()..add(const LoadSettings()),
                ),
              ],
              child: const MainPage(initialIndex: 2),
            ),
        RouteNames.analytics: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => di.getIt<TaskBloc>()..add(const LoadTasks()),
                ),
                BlocProvider(
                  create: (_) => di.getIt<SettingsBloc>()..add(const LoadSettings()),
                ),
              ],
              child: const MainPage(initialIndex: 3),
            ),
        RouteNames.aiAssistant: (_) => const AIAssistantPage(),
                    RouteNames.settings: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (_) => di.getIt<SettingsBloc>()..add(const LoadSettings()),
                            ),
                            BlocProvider(
                              create: (_) => di.getIt<TaskBloc>()..add(const LoadTasks()),
                            ),
                          ],
                          child: const MainPage(initialIndex: 4),
                        ),
            },
          ),
        );
        },
      ),
    );
  }
}

