import '../../domain/entities/task.dart';
import '../../../../core/utils/enums.dart';

/// Task model for data layer
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    super.priority,
    super.status,
    super.category,
    super.dueDate,
    super.reminderDate,
    super.completedAt,
    super.createdAt,
    super.updatedAt,
    super.subTasks,
    super.tags,
    super.isRecurring,
    super.recurrencePattern,
    super.location,
    super.estimatedDuration,
    super.actualDuration,
    super.attachments,
    super.collaborators,
    super.notes,
    super.color,
  });

  /// Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.none,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      category: TaskCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TaskCategory.other,
      ),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      subTasks: (json['subTasks'] as List<dynamic>?)
              ?.map((e) => SubTaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] as String?,
      location: json['location'] as String?,
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(minutes: json['estimatedDuration'] as int)
          : null,
      actualDuration: json['actualDuration'] != null
          ? Duration(minutes: json['actualDuration'] as int)
          : null,
      attachments: (json['attachments'] as List<dynamic>?)?.cast<String>() ?? [],
      collaborators: (json['collaborators'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: json['notes'] as String?,
      color: json['color'] as int?,
    );
  }

  /// Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'category': category.name,
      'dueDate': dueDate?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'subTasks': subTasks
          .map((e) => SubTaskModel.fromSubTask(e).toJson())
          .toList(),
      'tags': tags,
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
      'location': location,
      'estimatedDuration': estimatedDuration?.inMinutes,
      'actualDuration': actualDuration?.inMinutes,
      'attachments': attachments,
      'collaborators': collaborators,
      'notes': notes,
      'color': color,
    };
  }

  /// Create TaskModel from Task entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      category: task.category,
      dueDate: task.dueDate,
      reminderDate: task.reminderDate,
      completedAt: task.completedAt,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      subTasks: task.subTasks,
      tags: task.tags,
      isRecurring: task.isRecurring,
      recurrencePattern: task.recurrencePattern,
      location: task.location,
      estimatedDuration: task.estimatedDuration,
      actualDuration: task.actualDuration,
      attachments: task.attachments,
      collaborators: task.collaborators,
      notes: task.notes,
      color: task.color,
    );
  }
}

/// SubTask model
class SubTaskModel extends SubTask {
  const SubTaskModel({
    required super.id,
    required super.title,
    super.isCompleted,
    super.createdAt,
  });

  factory SubTaskModel.fromJson(Map<String, dynamic> json) {
    return SubTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  factory SubTaskModel.fromSubTask(SubTask subTask) {
    return SubTaskModel(
      id: subTask.id,
      title: subTask.title,
      isCompleted: subTask.isCompleted,
      createdAt: subTask.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

