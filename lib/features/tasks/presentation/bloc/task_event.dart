part of 'task_bloc.dart';

/// Base class for task events
sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Load all tasks
class LoadTasks extends TaskEvent {
  const LoadTasks();
}

/// Load task by ID
class LoadTaskById extends TaskEvent {
  const LoadTaskById(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Create new task
class CreateTask extends TaskEvent {
  const CreateTask(this.task);
  final Task task;

  @override
  List<Object?> get props => [task];
}

/// Update task
class UpdateTask extends TaskEvent {
  const UpdateTask(this.task);
  final Task task;

  @override
  List<Object?> get props => [task];
}

/// Delete task
class DeleteTask extends TaskEvent {
  const DeleteTask(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Complete task
class CompleteTask extends TaskEvent {
  const CompleteTask(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Filter tasks
class FilterTasks extends TaskEvent {
  const FilterTasks({
    this.status,
    this.priority,
    this.category,
    this.startDate,
    this.endDate,
  });

  final TaskStatus? status;
  final TaskPriority? priority;
  final TaskCategory? category;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [status, priority, category, startDate, endDate];
}

/// Search tasks
class SearchTasks extends TaskEvent {
  const SearchTasks(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Clear filters
class ClearFilters extends TaskEvent {
  const ClearFilters();
}

