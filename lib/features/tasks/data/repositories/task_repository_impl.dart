import 'dart:async';
import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/models/task_model.dart';
import '../../data/datasources/task_local_data_source.dart';

/// Implementation of TaskRepository
class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required TaskLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final TaskLocalDataSource _localDataSource;

  @override
  Future<Result<List<Task>>> getTasks({
    TaskStatus? status,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    String? languageCode,
  }) async {
    try {
      final tasks = await _localDataSource.getTasks(languageCode: languageCode);
      
      var filteredTasks = tasks.where((task) {
        if (status != null && task.status != status) return false;
        if (priority != null && task.priority != priority) return false;
        if (category != null && task.category != category) return false;
        if (startDate != null && task.dueDate != null && task.dueDate!.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && task.dueDate != null && task.dueDate!.isAfter(endDate)) {
          return false;
        }
        if (searchQuery != null && searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          if (!task.title.toLowerCase().contains(query) &&
              (task.description?.toLowerCase().contains(query) != true)) {
            return false;
          }
        }
        return true;
      }).toList();

      return Success(filteredTasks);
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Task>> getTaskById(String id) async {
    try {
      final task = await _localDataSource.getTaskById(id);
      if (task != null) {
        return Success(task);
      }
      return Error(CacheFailure(message: 'Task not found'));
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Task>> createTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final createdTask = await _localDataSource.createTask(taskModel);
      return Success(createdTask);
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final updatedTask = await _localDataSource.updateTask(taskModel);
      return Success(updatedTask);
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTask(String id) async {
    try {
      await _localDataSource.deleteTask(id);
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<Task>> completeTask(String id) async {
    try {
      final taskResult = await getTaskById(id);
      if (taskResult.isError) {
        return taskResult as Error<Task>;
      }
      
      final task = (taskResult as Success<Task>).data;
      final completedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      return await updateTask(completedTask);
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Task>>> getTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return getTasks(startDate: startDate, endDate: endDate);
  }

  @override
  Future<Result<List<Task>>> getUpcomingTasks({int limit = 10}) async {
    try {
      final now = DateTime.now();
      final tasksResult = await getTasks(
        startDate: now,
        status: TaskStatus.pending,
      );
      
      if (tasksResult.isError) {
        return tasksResult as Error<List<Task>>;
      }
      
      final tasks = (tasksResult as Success<List<Task>>).data;
      tasks.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
      
      return Success(tasks.take(limit).toList());
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Task>>> getOverdueTasks() async {
    try {
      final now = DateTime.now();
      final tasksResult = await getTasks();
      
      if (tasksResult.isError) {
        return tasksResult as Error<List<Task>>;
      }
      
      final tasks = (tasksResult as Success<List<Task>>).data;
      final overdueTasks = tasks.where((task) => task.isOverdue).toList();
      
      return Success(overdueTasks);
    } catch (e) {
      return Error(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Task>>> getTasksByCategory(TaskCategory category) async {
    return getTasks(category: category);
  }

  @override
  Future<Result<List<Task>>> searchTasks(String query) async {
    return getTasks(searchQuery: query);
  }
}

