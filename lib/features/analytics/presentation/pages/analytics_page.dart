import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../../core/utils/enums.dart';

/// Analytics page with task statistics
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analytics),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final tasks = state.filteredTasks;
          
          if (tasks.isEmpty) {
            return Center(
              child: Text(l10n.noTasksFound),
            );
          }

          final completedTasks = tasks.where((t) => t.isCompleted).length;
          final pendingTasks = tasks.where((t) => t.status == TaskStatus.pending).length;
          final inProgressTasks = tasks.where((t) => t.status == TaskStatus.inProgress).length;

          final tasksByCategory = <TaskCategory, int>{};
          for (final task in tasks) {
            tasksByCategory[task.category] = (tasksByCategory[task.category] ?? 0) + 1;
          }

          final tasksByPriority = <TaskPriority, int>{};
          for (final task in tasks) {
            tasksByPriority[task.priority] = (tasksByPriority[task.priority] ?? 0) + 1;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatCard(
                  title: 'Total Tasks',
                  value: tasks.length.toString(),
                  icon: Icons.list_alt,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                Row(
                  children: [
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
                        title: 'In Progress',
                        value: inProgressTasks.toString(),
                        icon: Icons.trending_up,
                        color: AppColors.statusInProgress,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.largePadding),
                Text(
                  'Tasks by Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: completedTasks.toDouble(),
                          title: 'Completed',
                          color: AppColors.statusCompleted,
                        ),
                        PieChartSectionData(
                          value: pendingTasks.toDouble(),
                          title: 'Pending',
                          color: AppColors.statusPending,
                        ),
                        PieChartSectionData(
                          value: inProgressTasks.toDouble(),
                          title: 'In Progress',
                          color: AppColors.statusInProgress,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.largePadding),
                Text(
                  'Tasks by Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: tasksByCategory.entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key.index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: AppColors.primary,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

