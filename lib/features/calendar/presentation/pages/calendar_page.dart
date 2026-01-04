import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_names.dart';
import '../../../tasks/presentation/bloc/task_bloc.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/pages/task_details_page.dart';
import '../../../../core/utils/enums.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart' as auth;
import '../../../../injection.dart' as di;
import '../../../../core/utils/extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import 'package:intl/intl.dart';

/// Calendar page with task integration
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendar),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          // Handle loading state
          if (state.status == TaskStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (state.status == TaskStatusEnum.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load tasks',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(const LoadTasks());
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          // Use all tasks, not just filtered ones
          final tasks = state.tasks;
          final tasksByDate = <DateTime, List<Task>>{};
          
          // Safely process tasks
          if (tasks.isNotEmpty) {
            for (final task in tasks) {
              if (task.dueDate != null) {
                try {
                  final date = DateTime(
                    task.dueDate!.year,
                    task.dueDate!.month,
                    task.dueDate!.day,
                  );
                  final normalizedDate = DateTime(date.year, date.month, date.day);
                  tasksByDate.putIfAbsent(normalizedDate, () => []).add(task);
                } catch (e) {
                  // Skip tasks with invalid dates
                  continue;
                }
              }
            }
          }

          return Column(
            children: [
              TableCalendar<Task>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(day, _selectedDay);
                },
                eventLoader: (day) {
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  return tasksByDate[normalizedDay] ?? [];
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
              ),
              const Divider(),
              Expanded(
                child: _TasksList(
                  tasks: tasksByDate[DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day)] ?? [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList({required this.tasks});

  final List<Task> tasks;

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Icons.flag;
      case TaskPriority.medium:
        return Icons.flag_outlined;
      case TaskPriority.low:
        return Icons.flag_outlined;
      case TaskPriority.none:
        return Icons.circle_outlined;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              l10n.noTasksFound,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
          return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(task.title),
            subtitle: task.dueDate != null
                ? Text(DateFormat('HH:mm').format(task.dueDate!))
                : null,
            trailing: task.isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            leading: Icon(
              _getPriorityIcon(task.priority),
              color: _getPriorityColor(task.priority),
            ),
            onTap: () {
              context.read<TaskBloc>().add(LoadTaskById(task.id));
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
                  settings: RouteSettings(arguments: task.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

