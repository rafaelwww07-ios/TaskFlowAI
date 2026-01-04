import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/task.dart';
import '../../../../core/utils/enums.dart';
import '../../data/models/task_model.dart';

/// Service for importing tasks
class ImportService {
  /// Import tasks from CSV file
  Future<List<Task>> importFromCSV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.isEmpty) {
      throw Exception('No file selected');
    }

    final file = File(result.files.first.path!);
    final contents = await file.readAsString();
    final csvData = const CsvToListConverter().convert(contents);

    final tasks = <Task>[];
    
    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.length >= 7) {
        try {
          final task = TaskModel(
            id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
            title: row[0]?.toString() ?? 'Imported Task',
            description: row[1]?.toString().isEmpty == true ? null : row[1]?.toString(),
            priority: _parsePriority(row[2]?.toString() ?? 'none'),
            status: _parseStatus(row[3]?.toString() ?? 'pending'),
            category: _parseCategory(row[4]?.toString() ?? 'other'),
            dueDate: row[5]?.toString().isEmpty == true 
                ? null 
                : DateTime.tryParse(row[5].toString()),
            createdAt: row[6]?.toString().isEmpty == true 
                ? DateTime.now()
                : DateTime.tryParse(row[6].toString()) ?? DateTime.now(),
            updatedAt: DateTime.now(),
          );
          tasks.add(task);
        } catch (e) {
          // Skip invalid rows
          continue;
        }
      }
    }

    return tasks;
  }

  /// Import tasks from JSON file
  Future<List<Task>> importFromJSON() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      throw Exception('No file selected');
    }

    final file = File(result.files.first.path!);
    final contents = await file.readAsString();
    final jsonData = jsonDecode(contents) as List;

    return jsonData.map((item) {
      try {
        return TaskModel.fromJson(item as Map<String, dynamic>);
      } catch (e) {
        throw Exception('Invalid JSON format: $e');
      }
    }).toList();
  }

  TaskPriority _parsePriority(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('high')) return TaskPriority.high;
    if (lower.contains('medium')) return TaskPriority.medium;
    if (lower.contains('low')) return TaskPriority.low;
    return TaskPriority.none;
  }

  TaskStatus _parseStatus(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('completed') || lower.contains('done')) {
      return TaskStatus.completed;
    }
    if (lower.contains('progress')) return TaskStatus.inProgress;
    if (lower.contains('cancelled') || lower.contains('canceled')) {
      return TaskStatus.cancelled;
    }
    return TaskStatus.pending;
  }

  TaskCategory _parseCategory(String value) {
    final lower = value.toLowerCase();
    for (final category in TaskCategory.values) {
      if (lower.contains(category.name)) {
        return category;
      }
    }
    return TaskCategory.other;
  }
}

