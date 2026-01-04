import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Voice input button widget
class VoiceInputButton extends StatefulWidget {
  const VoiceInputButton({
    super.key,
    required this.onResult,
    this.onListening,
  });

  final ValueChanged<String> onResult;
  final ValueChanged<bool>? onListening;

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    // Don't initialize immediately to avoid requesting permissions on app start
    // Initialize only when user taps the button
  }

  Future<void> _initializeSpeech() async {
    try {
      await _speech.initialize(
        onError: (error) {
          // Silently handle initialization errors
        },
        onStatus: (status) {
          // Silently handle status changes during initialization
        },
      );
    } catch (e) {
      // Handle initialization errors gracefully
    }
  }

  void _listen() async {
    if (!_isListening) {
      try {
        // Initialize on first use
        await _initializeSpeech();
        
        bool available = await _speech.initialize(
          onStatus: (status) {
            if (!mounted) return;
            if (status == 'done' || status == 'notListening') {
              setState(() {
                _isListening = false;
              });
              widget.onListening?.call(false);
              if (_text.isNotEmpty) {
                widget.onResult(_text);
                _text = '';
              }
            }
          },
          onError: (error) {
            if (!mounted) return;
            setState(() {
              _isListening = false;
            });
            widget.onListening?.call(false);
          },
        );

        if (available && mounted) {
          setState(() {
            _isListening = true;
            _text = '';
          });
          widget.onListening?.call(true);
          await _speech.listen(
            onResult: (result) {
              if (mounted) {
                setState(() {
                  _text = result.recognizedWords;
                });
              }
            },
          );
        }
      } catch (e) {
        // Handle errors gracefully - permissions might not be granted
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          widget.onListening?.call(false);
        }
      }
    } else {
      try {
        await _speech.stop();
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          widget.onListening?.call(false);
          if (_text.isNotEmpty) {
            widget.onResult(_text);
            _text = '';
          }
        }
      } catch (e) {
        // Handle stop errors
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          widget.onListening?.call(false);
        }
      }
    }
  }

  @override
  void dispose() {
    try {
      _speech.stop();
    } catch (e) {
      // Ignore errors during dispose
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      backgroundColor: _isListening ? AppColors.error : AppColors.primary,
      onPressed: _listen,
      child: _isListening
          ? const Icon(Icons.stop, color: Colors.white)
          : const Icon(Icons.mic, color: Colors.white),
    );
  }
}

