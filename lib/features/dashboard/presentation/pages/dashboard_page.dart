import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/widgets/task_card.dart';
import '../../../tasks/presentation/widgets/focus_mode_widget.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../tasks/presentation/pages/task_details_page.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart' as auth;
import '../../../../injection.dart' as di;
import '../../../main/presentation/pages/main_page.dart';
import '../../../../core/localization/app_localizations.dart';

/// Dashboard page with overview widgets
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TaskStatusEnum.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error loading tasks'),
            );
          }

          final tasks = state.filteredTasks;
          final upcomingTasks = tasks
              .where((t) => t.dueDate != null && !t.isCompleted)
              .toList()
            ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
          final overdueTasks = tasks.where((t) => t.isOverdue).toList();
          final todayTasks = tasks
              .where((t) =>
                  t.dueDate != null &&
                  date_utils.DateUtils.isSameDay(t.dueDate!, DateTime.now()))
              .toList();
          final completedToday = tasks
              .where((t) =>
                  t.completedAt != null &&
                  date_utils.DateUtils.isSameDay(
                      t.completedAt!, DateTime.now()))
              .length;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    l10n.dashboard,
                    style: TextStyle(
                      color: context.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      MainPage.of(context)?.switchToTab(1);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      MainPage.of(context)?.switchToTab(4);
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FocusModeWidget(),
                      const SizedBox(height: AppConstants.defaultPadding),
                      _StatsRow(
                        totalTasks: tasks.length,
                        completedTasks: tasks
                            .where((t) => t.isCompleted)
                            .length,
                        overdueTasks: overdueTasks.length,
                        completedToday: completedToday,
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: -0.1, end: 0),
                      
                      const SizedBox(height: AppConstants.largePadding),
                      
                      if (overdueTasks.isNotEmpty) ...[
                        _SectionHeader(
                          title: l10n.overdue,
                          count: overdueTasks.length,
                          color: AppColors.priorityHigh,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: overdueTasks.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                                child: SizedBox(
                                  width: 300,
                                  child: ClipRect(
                                    child: TaskCard(
                                      task: overdueTasks[index],
                                      compact: true,
                                      onTap: () {
                                        context.read<TaskBloc>().add(
                                              LoadTaskById(overdueTasks[index].id),
                                            );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<TaskBloc>(),
                                              child: BlocProvider(
                                                create: (_) => di.getIt<auth.AuthBloc>()..add(const auth.CheckAuthStatus()),
                                                child: const TaskDetailsPage(),
                                              ),
                                            ),
                                            settings: RouteSettings(
                                              arguments: overdueTasks[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppConstants.largePadding),
                      ],
                      
                      if (todayTasks.isNotEmpty) ...[
                        _SectionHeader(
                          title: l10n.today,
                          count: todayTasks.length,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        ...todayTasks.map((task) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.defaultPadding,
                            ),
                            child: TaskCard(
                              task: task,
                              onTap: () {
                                context.read<TaskBloc>().add(
                                      LoadTaskById(task.id),
                                    );
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.taskDetails,
                                  arguments: task.id,
                                );
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: AppConstants.largePadding),
                      ],
                      
                      if (upcomingTasks.isNotEmpty) ...[
                        _SectionHeader(
                          title: l10n.upcoming,
                          count: upcomingTasks.length,
                        ),
                        const SizedBox(height: AppConstants.defaultPadding),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingTasks.take(5).length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                                child: SizedBox(
                                  width: 300,
                                  child: ClipRect(
                                    child: TaskCard(
                                      task: upcomingTasks[index],
                                      compact: true,
                                      onTap: () {
                                        context.read<TaskBloc>().add(
                                              LoadTaskById(upcomingTasks[index].id),
                                            );
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.taskDetails,
                                          arguments: upcomingTasks[index].id,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          return FloatingActionButton.extended(
            onPressed: () {
              MainPage.of(context)?.switchToTab(1);
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.newTask),
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.totalTasks,
    required this.completedTasks,
    required this.overdueTasks,
    required this.completedToday,
  });

  final int totalTasks;
  final int completedTasks;
  final int overdueTasks;
  final int completedToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total',
            value: totalTasks.toString(),
            icon: Icons.list_alt,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: _StatCard(
            title: 'Completed',
            value: completedTasks.toString(),
            icon: Icons.check_circle,
            color: AppColors.statusCompleted,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: _StatCard(
            title: 'Today',
            value: completedToday.toString(),
            icon: Icons.today,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.count,
    this.color,
  });

  final String title;
  final int? count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color ?? AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, RouteNames.dashboard);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, RouteNames.tasks);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, RouteNames.calendar);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, RouteNames.analytics);
            break;
          case 4:
            Navigator.pushReplacementNamed(context, RouteNames.settings);
            break;
        }
      },
    );
  }
}

