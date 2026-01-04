import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/task.dart';

/// Timer widget for tracking task time
class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.task,
    this.onTimeUpdate,
  });

  final Task task;
  final ValueChanged<Duration>? onTimeUpdate;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool _isRunning = false;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _elapsed = widget.task.actualDuration ?? Duration.zero;
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        // Stop timer
        _elapsed += DateTime.now().difference(_startTime!);
        widget.onTimeUpdate?.call(_elapsed);
        _isRunning = false;
      } else {
        // Start timer
        _startTime = DateTime.now();
        _isRunning = true;
      }
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _elapsed = Duration.zero;
      widget.onTimeUpdate?.call(Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRunning && _startTime != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isRunning) {
          setState(() {});
        }
      });
    }

    final displayDuration = _isRunning && _startTime != null
        ? _elapsed + DateTime.now().difference(_startTime!)
        : _elapsed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timer_outlined),
                const SizedBox(width: 8),
                Text(
                  'Time Tracking',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _formatDuration(displayDuration),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            if (widget.task.estimatedDuration != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: displayDuration.inMinutes > 0
                    ? (displayDuration.inMinutes /
                        widget.task.estimatedDuration!.inMinutes)
                        .clamp(0.0, 1.0)
                    : 0.0,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 4),
              Text(
                'Estimated: ${_formatDuration(widget.task.estimatedDuration!)}',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_elapsed.inSeconds > 0 || _isRunning)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _resetTimer,
                    tooltip: 'Reset',
                  ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _toggleTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning
                        ? AppColors.error
                        : AppColors.statusCompleted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

