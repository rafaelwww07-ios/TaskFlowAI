import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/task.dart';
import '../../../../core/utils/enums.dart';

/// Task card widget
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onDelete,
    this.compact = false,
  });

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);
    final statusColor = _getStatusColor(task.status);

    return Card(
      margin: compact 
          ? EdgeInsets.zero 
          : const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (task.priority != TaskPriority.none)
                          Container(
                            width: 4,
                            height: compact ? 32 : 40,
                            decoration: BoxDecoration(
                              color: priorityColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                task.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (task.description != null &&
                                  task.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  task.description!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onComplete != null)
                    IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted
                            ? AppColors.statusCompleted
                            : Colors.grey,
                      ),
                      onPressed: onComplete,
                    ),
                ],
              ),
              if (task.dueDate != null ||
                  task.tags.isNotEmpty ||
                  task.subTasks.isNotEmpty) ...[
                SizedBox(height: compact ? 8 : AppConstants.defaultPadding),
                Wrap(
                  spacing: compact ? 6 : 8,
                  runSpacing: compact ? 6 : 8,
                  children: [
                    if (task.dueDate != null)
                      _InfoChip(
                        icon: Icons.calendar_today,
                        label: task.dueDate!.toFormattedString(),
                        color: task.isOverdue
                            ? AppColors.priorityHigh
                            : AppColors.textSecondary,
                      ),
                    if (task.tags.isNotEmpty)
                      ...task.tags.take(2).map((tag) {
                        return _InfoChip(
                          icon: Icons.label,
                          label: tag,
                          color: AppColors.secondary,
                        );
                      }),
                    if (task.subTasks.isNotEmpty)
                      _InfoChip(
                        icon: Icons.list,
                        label:
                            '${task.subTasks.where((t) => t.isCompleted).length}/${task.subTasks.length}',
                        color: AppColors.info,
                      ),
                  ],
                ),
              ],
              if (task.category != TaskCategory.other || task.status == TaskStatus.inProgress) ...[
                SizedBox(height: compact ? 6 : 8),
                Wrap(
                  spacing: compact ? 6 : 8,
                  runSpacing: compact ? 6 : 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (task.category != TaskCategory.other)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.category.name.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (task.status == TaskStatus.inProgress)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.statusInProgress.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 8,
                              height: 8,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.statusInProgress,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'In Progress',
                              style: TextStyle(
                                color: AppColors.statusInProgress,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.priorityHigh;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.low:
        return AppColors.priorityLow;
      case TaskPriority.none:
        return AppColors.priorityNone;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return AppColors.statusCompleted;
      case TaskStatus.inProgress:
        return AppColors.statusInProgress;
      case TaskStatus.pending:
        return AppColors.statusPending;
      case TaskStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

