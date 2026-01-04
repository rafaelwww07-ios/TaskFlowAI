import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Focus mode widget for blocking distractions
class FocusModeWidget extends StatefulWidget {
  const FocusModeWidget({super.key});

  @override
  State<FocusModeWidget> createState() => _FocusModeWidgetState();
}

class _FocusModeWidgetState extends State<FocusModeWidget>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  late AnimationController _controller;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  void _toggleFocusMode() {
    setState(() {
      _isActive = !_isActive;
      if (_isActive) {
        _startTime = DateTime.now();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        HapticFeedback.mediumImpact();
      } else {
        _elapsed = Duration.zero;
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDisposed && _isActive && _startTime != null) {
      _elapsed = DateTime.now().difference(_startTime!);
    }

    return Card(
      color: _isActive ? AppColors.primary.withOpacity(0.1) : null,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.center_focus_strong,
                  color: _isActive ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Focus Mode',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        _isActive
                            ? 'Stay focused on your tasks'
                            : 'Block distractions and focus',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isActive,
                  onChanged: (_) => _toggleFocusMode(),
                ),
              ],
            ),
            if (_isActive) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(_elapsed),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}

