import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';

/// Recurring task editor widget
class RecurringTaskEditor extends StatefulWidget {
  const RecurringTaskEditor({
    super.key,
    this.isRecurring = false,
    this.recurrencePattern,
    this.onChanged,
  });

  final bool isRecurring;
  final String? recurrencePattern;
  final ValueChanged<Map<String, dynamic>>? onChanged;

  @override
  State<RecurringTaskEditor> createState() => _RecurringTaskEditorState();
}

class _RecurringTaskEditorState extends State<RecurringTaskEditor> {
  bool _isRecurring = false;
  String _recurrenceType = 'daily';
  int _interval = 1;
  List<int> _daysOfWeek = [];

  @override
  void initState() {
    super.initState();
    _isRecurring = widget.isRecurring;
    if (widget.recurrencePattern != null) {
      _parsePattern(widget.recurrencePattern!);
    }
  }

  void _parsePattern(String pattern) {
    // Simple pattern parsing: "daily:1", "weekly:1:1,3,5", "monthly:1"
    final parts = pattern.split(':');
    if (parts.isNotEmpty) {
      _recurrenceType = parts[0];
      if (parts.length > 1) {
        _interval = int.tryParse(parts[1]) ?? 1;
      }
      if (parts.length > 2 && _recurrenceType == 'weekly') {
        _daysOfWeek = parts[2].split(',').map((e) => int.tryParse(e) ?? 0).toList();
      }
    }
  }

  String _buildPattern() {
    if (_recurrenceType == 'weekly' && _daysOfWeek.isNotEmpty) {
      return '$_recurrenceType:$_interval:${_daysOfWeek.join(',')}';
    }
    return '$_recurrenceType:$_interval';
  }

  void _notifyChanged() {
    widget.onChanged?.call({
      'isRecurring': _isRecurring,
      'recurrencePattern': _isRecurring ? _buildPattern() : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.repeat),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recurring Task',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Switch(
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                    _notifyChanged();
                  },
                ),
              ],
            ),
            if (_isRecurring) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _recurrenceType,
                decoration: const InputDecoration(
                  labelText: 'Repeat',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _recurrenceType = value;
                    });
                    _notifyChanged();
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Every'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: _interval.toString(),
                      )..selection = TextSelection.collapsed(
                          offset: _interval.toString().length,
                        ),
                      onChanged: (value) {
                        _interval = int.tryParse(value) ?? 1;
                        _notifyChanged();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_getIntervalLabel()),
                ],
              ),
              if (_recurrenceType == 'weekly') ...[
                const SizedBox(height: 16),
                Text(
                  'Days of week',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(7, (index) {
                    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    final isSelected = _daysOfWeek.contains(index);
                    return FilterChip(
                      label: Text(dayNames[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (!_daysOfWeek.contains(index)) {
                              _daysOfWeek.add(index);
                            }
                          } else {
                            _daysOfWeek.remove(index);
                          }
                        });
                        _notifyChanged();
                      },
                    );
                  }),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _getIntervalLabel() {
    switch (_recurrenceType) {
      case 'daily':
        return _interval == 1 ? 'day' : 'days';
      case 'weekly':
        return _interval == 1 ? 'week' : 'weeks';
      case 'monthly':
        return _interval == 1 ? 'month' : 'months';
      case 'yearly':
        return _interval == 1 ? 'year' : 'years';
      default:
        return '';
    }
  }
}

