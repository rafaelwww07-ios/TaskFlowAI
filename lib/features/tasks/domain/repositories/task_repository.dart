import '../../../../core/utils/result.dart';
import '../entities/task.dart';
import '../../../../core/utils/enums.dart';

/// Repository interface for task operations
abstract class TaskRepository {
  /// Get all tasks
  Future<Result<List<Task>>> getTasks({
    TaskStatus? status,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    String? languageCode,
  });

  /// Get task by ID
  Future<Result<Task>> getTaskById(String id);

  /// Create new task
  Future<Result<Task>> createTask(Task task);

  /// Update task
  Future<Result<Task>> updateTask(Task task);

  /// Delete task
  Future<Result<void>> deleteTask(String id);

  /// Complete task
  Future<Result<Task>> completeTask(String id);

  /// Get tasks by date range
  Future<Result<List<Task>>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get upcoming tasks
  Future<Result<List<Task>>> getUpcomingTasks({int limit = 10});

  /// Get overdue tasks
  Future<Result<List<Task>>> getOverdueTasks();

  /// Get tasks by category
  Future<Result<List<Task>>> getTasksByCategory(TaskCategory category);

  /// Search tasks
  Future<Result<List<Task>>> searchTasks(String query);
}

