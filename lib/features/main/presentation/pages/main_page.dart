import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/constants/route_names.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../tasks/presentation/pages/tasks_page.dart';
import '../../../calendar/presentation/pages/calendar_page.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../injection.dart' as di;

/// Main page with bottom navigation
class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();

  static _MainPageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MainPageState>();
  }
}

class _MainPageState extends State<MainPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void switchToTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onItemTapped(int index) {
    switchToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Get BLoCs from context or create new ones
    // Using BlocProvider.of with listen: false is safer
    TaskBloc taskBloc;
    SettingsBloc settingsBloc;
    
    try {
      taskBloc = BlocProvider.of<TaskBloc>(context, listen: false);
    } catch (e) {
      // TaskBloc not found, create new one
      taskBloc = di.getIt<TaskBloc>()..add(const LoadTasks());
    }
    
    try {
      settingsBloc = BlocProvider.of<SettingsBloc>(context, listen: false);
    } catch (e) {
      // SettingsBloc not found, create new one
      settingsBloc = di.getIt<SettingsBloc>()..add(const LoadSettings());
    }
    
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _currentIndex != 0 && mounted) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: taskBloc),
            BlocProvider.value(value: settingsBloc),
          ],
          child: IndexedStack(
            index: _currentIndex,
            children: [
              Builder(
                builder: (context) {
                  try {
                    return const DashboardPage();
                  } catch (e) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: $e'),
                      ),
                    );
                  }
                },
              ),
              Builder(
                builder: (context) {
                  try {
                    return const TasksPage();
                  } catch (e) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: $e'),
                      ),
                    );
                  }
                },
              ),
              Builder(
                builder: (context) {
                  try {
                    return const CalendarPage();
                  } catch (e) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: $e'),
                      ),
                    );
                  }
                },
              ),
              Builder(
                builder: (context) {
                  try {
                    return const AnalyticsPage();
                  } catch (e) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: $e'),
                      ),
                    );
                  }
                },
              ),
              Builder(
                builder: (context) {
                  try {
                    return const SettingsPage();
                  } catch (e) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: $e'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onItemTapped,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 70,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined, size: 24),
              selectedIcon: const Icon(Icons.dashboard, size: 24),
              label: l10n.dashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.list_outlined, size: 24),
              selectedIcon: const Icon(Icons.list, size: 24),
              label: l10n.tasks,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined, size: 24),
              selectedIcon: const Icon(Icons.calendar_today, size: 24),
              label: l10n.calendar,
            ),
            NavigationDestination(
              icon: const Icon(Icons.analytics_outlined, size: 24),
              selectedIcon: const Icon(Icons.analytics, size: 24),
              label: l10n.analytics,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, size: 24),
              selectedIcon: const Icon(Icons.settings, size: 24),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}

