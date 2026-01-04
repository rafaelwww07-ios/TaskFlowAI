part of 'task_bloc.dart';

/// Task status enum for state management
enum TaskStatusEnum {
  initial,
  loading,
  loaded,
  error,
}

/// Task state
class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatusEnum.initial,
    this.tasks = const [],
    this.filteredTasks = const [],
    this.selectedTask,
    this.selectedTaskStatus = TaskStatusEnum.initial,
    this.statusFilter,
    this.priorityFilter,
    this.categoryFilter,
    this.startDate,
    this.endDate,
    this.searchQuery,
    this.errorMessage,
  });

  final TaskStatusEnum status;
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final Task? selectedTask;
  final TaskStatusEnum selectedTaskStatus;
  final TaskStatus? statusFilter;
  final TaskPriority? priorityFilter;
  final TaskCategory? categoryFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;
  final String? errorMessage;

  TaskState copyWith({
    TaskStatusEnum? status,
    List<Task>? tasks,
    List<Task>? filteredTasks,
    Task? selectedTask,
    TaskStatusEnum? selectedTaskStatus,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
    TaskCategory? categoryFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTask: selectedTask ?? this.selectedTask,
      selectedTaskStatus: selectedTaskStatus ?? this.selectedTaskStatus,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
        filteredTasks,
        selectedTask,
        selectedTaskStatus,
        statusFilter,
        priorityFilter,
        categoryFilter,
        startDate,
        endDate,
        searchQuery,
        errorMessage,
      ];
}

