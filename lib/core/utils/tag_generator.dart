import '../../features/tasks/domain/entities/task.dart';
import 'enums.dart';

/// Smart tag generator using NLP-like rules
class TagGenerator {
  TagGenerator._();

  /// Generate tags for a task based on its content
  static List<String> generateTags(Task task) {
    final tags = <String>[];
    final titleLower = task.title.toLowerCase();
    final descriptionLower = (task.description ?? '').toLowerCase();

    // Category-based tags
    tags.add(task.category.name);

    // Priority-based tags
    if (task.priority != TaskPriority.none) {
      tags.add('priority-${task.priority.name}');
    }

    // Time-based tags
    if (task.dueDate != null) {
      final now = DateTime.now();
      final due = task.dueDate!;
      final difference = due.difference(now);

      if (difference.inDays < 0) {
        tags.add('overdue');
      } else if (difference.inDays == 0) {
        tags.add('today');
      } else if (difference.inDays <= 7) {
        tags.add('this-week');
      } else if (difference.inDays <= 30) {
        tags.add('this-month');
      }
    }

    // Content-based tags (keyword detection)
    final keywords = {
      'urgent': ['urgent', 'asap', 'immediately', 'critical'],
      'meeting': ['meeting', 'call', 'conference', 'discussion'],
      'review': ['review', 'check', 'examine', 'approve'],
      'deadline': ['deadline', 'due', 'submit', 'deliver'],
      'home': ['home', 'house', 'household', 'family'],
      'work': ['work', 'office', 'business', 'project'],
      'shopping': ['buy', 'purchase', 'shop', 'grocery'],
      'health': ['health', 'exercise', 'workout', 'doctor', 'medical'],
      'travel': ['travel', 'trip', 'flight', 'hotel', 'vacation'],
      'finance': ['money', 'payment', 'bill', 'budget', 'expense'],
    };

    for (final entry in keywords.entries) {
      final keyword = entry.key;
      final patterns = entry.value;

      if (patterns.any((pattern) =>
          titleLower.contains(pattern) ||
          descriptionLower.contains(pattern))) {
        if (!tags.contains(keyword)) {
          tags.add(keyword);
        }
      }
    }

    // Existing tags
    tags.addAll(task.tags);

    return tags.toSet().toList(); // Remove duplicates
  }

  /// Suggest tags based on similar tasks
  static List<String> suggestTags(List<Task> similarTasks) {
    final tagFrequency = <String, int>{};

    for (final task in similarTasks) {
      for (final tag in task.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
      }
    }

    final sortedTags = tagFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedTags.take(5).map((e) => e.key).toList();
  }
}

