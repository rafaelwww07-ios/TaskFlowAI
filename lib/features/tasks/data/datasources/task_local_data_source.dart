import '../../domain/entities/task.dart';
import '../models/task_model.dart';
import '../../../../core/utils/enums.dart';
import 'demo_tasks_data.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source interface for tasks
abstract class TaskLocalDataSource {
  Future<List<Task>> getTasks({String? languageCode});
  Future<Task?> getTaskById(String id);
  Future<Task> createTask(TaskModel task);
  Future<Task> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> clearAllTasks();
}

/// Implementation using in-memory storage (for demo)
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  TaskLocalDataSourceImpl();

  final List<TaskModel> _tasks = [];
  bool _initialized = false;
  String _currentLanguageCode = '';

  void _initDemoData(String languageCode) {
    // If same language already initialized, skip
    if (_initialized && _currentLanguageCode == languageCode) return;
    
    _tasks.clear();
    _initialized = true;
    _currentLanguageCode = languageCode;
    final now = DateTime.now();
    final demoData = DemoTasksData.getTasks(languageCode);
    
    _tasks.addAll(demoData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final taskId = '${index + 1}';
      
      return TaskModel(
        id: taskId,
        title: data['title'] as String,
        description: data['description'] as String?,
        priority: data['priority'] as TaskPriority,
        status: data['status'] as TaskStatus,
        category: data['category'] as TaskCategory,
        dueDate: now.add(Duration(days: 2 + index)),
        createdAt: now.subtract(Duration(days: 3 - index)),
        updatedAt: now.subtract(Duration(days: 3 - index)),
        tags: List<String>.from(data['tags'] as List),
        subTasks: data['subTasks'] != null
            ? (data['subTasks'] as List).map((st) {
                return SubTaskModel(
                  id: '$taskId-${(data['subTasks'] as List).indexOf(st) + 1}',
                  title: st['title'] as String,
                  isCompleted: st['completed'] as bool,
                );
              }).toList()
            : [],
      );
    }).toList());
  }

  Future<List<Task>> getTasks({String? languageCode}) async {
    final locale = ui.PlatformDispatcher.instance.locale;
    String langCode = languageCode ?? '';
    
    // Determine language code
    if (langCode.isEmpty || langCode == 'system') {
      // Try to get from SharedPreferences first
      try {
        final prefs = await SharedPreferences.getInstance();
        final savedLang = prefs.getString('language') ?? '';
        if (savedLang.isNotEmpty && ['en', 'ru', 'es'].contains(savedLang)) {
          langCode = savedLang;
        } else {
          // Fallback to device locale
          if (locale.languageCode == 'ru') {
            langCode = 'ru';
          } else if (locale.languageCode == 'es') {
            langCode = 'es';
          } else {
            langCode = 'en';
          }
        }
      } catch (e) {
        // If SharedPreferences fails, use device locale
        if (locale.languageCode == 'ru') {
          langCode = 'ru';
        } else if (locale.languageCode == 'es') {
          langCode = 'es';
        } else {
          langCode = 'en';
        }
      }
    }
    
    // Reinitialize if language changed or not initialized
    if (!_initialized || _currentLanguageCode != langCode) {
      _initDemoData(langCode);
    }
    
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return _tasks.toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Task> createTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final taskWithDates = task.copyWith(
      createdAt: task.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    ) as TaskModel;
    _tasks.add(taskWithDates);
    return taskWithDates;
  }

  @override
  Future<Task> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final updatedTask = task.copyWith(updatedAt: DateTime.now()) as TaskModel;
      _tasks[index] = updatedTask;
      return updatedTask;
    }
    throw Exception('Task not found');
  }

  @override
  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<void> clearAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.clear();
  }
}

