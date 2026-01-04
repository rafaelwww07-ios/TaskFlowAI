import 'package:equatable/equatable.dart';

/// Comment entity for task collaboration
class Comment extends Equatable {
  const Comment({
    required this.id,
    required this.taskId,
    required this.text,
    required this.authorId,
    this.authorName,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String taskId;
  final String text;
  final String authorId;
  final String? authorName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Comment copyWith({
    String? id,
    String? taskId,
    String? text,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        taskId,
        text,
        authorId,
        authorName,
        createdAt,
        updatedAt,
      ];
}

