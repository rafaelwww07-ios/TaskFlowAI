import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';

/// Task entity representing a task in the domain layer
class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.none,
    this.status = TaskStatus.pending,
    this.category = TaskCategory.other,
    this.dueDate,
    this.reminderDate,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.subTasks = const [],
    this.tags = const [],
    this.isRecurring = false,
    this.recurrencePattern,
    this.location,
    this.estimatedDuration,
    this.actualDuration,
    this.attachments = const [],
    this.collaborators = const [],
    this.notes,
    this.color,
  });

  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final TaskCategory category;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SubTask> subTasks;
  final List<String> tags;
  final bool isRecurring;
  final String? recurrencePattern;
  final String? location;
  final Duration? estimatedDuration;
  final Duration? actualDuration;
  final List<String> attachments;
  final List<String> collaborators;
  final String? notes;
  final int? color;

  /// Check if task is completed
  bool get isCompleted => status == TaskStatus.completed;

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Get completion percentage based on subtasks
  double get completionPercentage {
    if (subTasks.isEmpty) {
      return isCompleted ? 1.0 : 0.0;
    }
    final completedCount =
        subTasks.where((task) => task.isCompleted).length;
    return completedCount / subTasks.length;
  }

  /// Copy with method for immutability
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? reminderDate,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SubTask>? subTasks,
    List<String>? tags,
    bool? isRecurring,
    String? recurrencePattern,
    String? location,
    Duration? estimatedDuration,
    Duration? actualDuration,
    List<String>? attachments,
    List<String>? collaborators,
    String? notes,
    int? color,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subTasks: subTasks ?? this.subTasks,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      location: location ?? this.location,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      attachments: attachments ?? this.attachments,
      collaborators: collaborators ?? this.collaborators,
      notes: notes ?? this.notes,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        category,
        dueDate,
        reminderDate,
        completedAt,
        createdAt,
        updatedAt,
        subTasks,
        tags,
        isRecurring,
        recurrencePattern,
        location,
        estimatedDuration,
        actualDuration,
        attachments,
        collaborators,
        notes,
        color,
      ];
}

/// SubTask entity
class SubTask extends Equatable {
  const SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? createdAt;

  SubTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, createdAt];
}

