import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../bloc/task_bloc.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/task.dart';
import '../widgets/comments_section.dart';
import '../widgets/timer_widget.dart';
import '../widgets/recurring_task_editor.dart';
import '../../domain/entities/comment.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart' as auth;

/// Task details page
class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskId = ModalRoute.of(context)?.settings.arguments as String?;
      if (taskId != null) {
        context.read<TaskBloc>().add(LoadTaskById(taskId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state.selectedTask != null) {
                return PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context, state.selectedTask!);
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, state.selectedTask!);
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final taskId = ModalRoute.of(context)?.settings.arguments as String?;
          
          if (state.selectedTaskStatus == TaskStatusEnum.loading) {
            return const CenteredLoadingWidget();
          }

          if (state.selectedTaskStatus == TaskStatusEnum.error) {
            return ErrorDisplayWidget(
              message: state.errorMessage ?? 'Failed to load task',
              onRetry: () {
                if (taskId != null) {
                  context.read<TaskBloc>().add(LoadTaskById(taskId));
                }
              },
            );
          }

          // Try to get task from selectedTask first, then from tasks list by ID
          Task? taskNullable = state.selectedTask;
          if (taskNullable == null && taskId != null) {
            try {
              taskNullable = state.tasks.firstWhere((t) => t.id == taskId);
            } catch (e) {
              // Task not found in list
            }
          }
          
          if (taskNullable == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noTasksFound,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          // Task is guaranteed to be non-null here after the null check above
          final task = taskNullable!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () {
                        context.read<TaskBloc>().add(CompleteTask(task.id));
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                _TaskInfoRow(
                  icon: Icons.flag,
                  label: 'Priority',
                  value: task.priority.name.capitalize,
                  color: _getPriorityColor(task.priority),
                ),
                _TaskInfoRow(
                  icon: Icons.category,
                  label: 'Category',
                  value: task.category.name.capitalize,
                ),
                _TaskInfoRow(
                  icon: Icons.info,
                  label: 'Status',
                  value: task.status.name.capitalize,
                  color: _getStatusColor(task.status),
                ),
                if (task.dueDate != null)
                  _TaskInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Due Date',
                    value: task.dueDate!.toFormattedString(),
                  ),
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                  if (task.subTasks.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'Subtasks',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...task.subTasks.map((subTask) {
                    return CheckboxListTile(
                      title: Text(subTask.title),
                      value: subTask.isCompleted,
                      onChanged: (value) {
                        final updatedSubTasks = task.subTasks.map((st) {
                          if (st.id == subTask.id) {
                            return st.copyWith(isCompleted: value ?? false);
                          }
                          return st;
                        }).toList();
                        final updatedTask = task.copyWith(subTasks: updatedSubTasks);
                        context.read<TaskBloc>().add(UpdateTask(updatedTask));
                      },
                    );
                  }),
                ],
                if (task.tags.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: task.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        onDeleted: () {
                          final updatedTags = task.tags.where((t) => t != tag).toList();
                          final updatedTask = task.copyWith(tags: updatedTags);
                          context.read<TaskBloc>().add(UpdateTask(updatedTask));
                        },
                      );
                    }).toList(),
                  ),
                ],
                if (task.estimatedDuration != null || task.actualDuration != null) ...[
                  const SizedBox(height: AppConstants.defaultPadding),
                  TimerWidget(
                    task: task,
                    onTimeUpdate: (duration) {
                      final updatedTask = task.copyWith(
                        actualDuration: duration,
                        updatedAt: DateTime.now(),
                      );
                      context.read<TaskBloc>().add(UpdateTask(updatedTask));
                    },
                  ),
                ],
                if (task.isRecurring || task.recurrencePattern != null) ...[
                  const SizedBox(height: AppConstants.defaultPadding),
                  RecurringTaskEditor(
                    isRecurring: task.isRecurring,
                    recurrencePattern: task.recurrencePattern,
                    onChanged: (data) {
                      final updatedTask = task.copyWith(
                        isRecurring: data['isRecurring'] as bool,
                        recurrencePattern: data['recurrencePattern'] as String?,
                        updatedAt: DateTime.now(),
                      );
                      context.read<TaskBloc>().add(UpdateTask(updatedTask));
                    },
                  ),
                ],
                const SizedBox(height: AppConstants.largePadding),
                BlocBuilder<auth.AuthBloc, auth.AuthState>(
                  builder: (context, authState) {
                    return CommentsSection(
                      comments: _comments,
                      currentUserId: authState.user?.id,
                      currentUserName: authState.user?.name,
                      onAddComment: (text) {
                        if (text.trim().isEmpty) return;
                        final comment = Comment(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          taskId: task.id,
                          text: text.trim(),
                          authorId: authState.user?.id ?? 'anonymous',
                          authorName: authState.user?.name ?? 'Anonymous',
                          createdAt: DateTime.now(),
                        );
                        setState(() {
                          _comments.add(comment);
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  void _showEditDialog(BuildContext context, Task task) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editTask),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: l10n.title),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: l10n.description),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.titleCannotBeEmpty)),
                );
                return;
              }
              final updatedTask = task.copyWith(
                title: titleController.text.trim(),
                description: descriptionController.text.trim().isEmpty
                    ? null
                    : descriptionController.text.trim(),
                updatedAt: DateTime.now(),
              );
              context.read<TaskBloc>().add(UpdateTask(updatedTask));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text('${l10n.deleteTask}: "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(task.id));
              Navigator.pop(context); // Close dialog
              if (context.mounted) {
                Navigator.pop(context); // Go back to previous screen
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _TaskInfoRow extends StatelessWidget {
  const _TaskInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

