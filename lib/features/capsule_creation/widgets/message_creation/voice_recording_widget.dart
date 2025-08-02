import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/message_creation_data.dart';

/// Premium voice recording widget with circular record button and waveform visualization
/// Features inline voice notes and recording animations with haptic feedback
class VoiceRecordingWidget extends StatefulWidget {
  final List<VoiceRecording> recordings;
  final bool isRecording;
  final int currentRecordingDuration;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final ValueChanged<int> onDeleteRecording;
  final ValueChanged<int> onInsertIntoText;

  const VoiceRecordingWidget({
    super.key,
    required this.recordings,
    required this.isRecording,
    required this.currentRecordingDuration,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onDeleteRecording,
    required this.onInsertIntoText,
  });

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with TickerProviderStateMixin {
  late AnimationController _recordingController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Recording button animation
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Pulse animation for recording state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Wave animation for visual feedback
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _recordingController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));
  }
  
  @override
  void didUpdateWidget(VoiceRecordingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.isRecording != widget.isRecording) {
      if (widget.isRecording) {
        _recordingController.forward();
        _pulseController.repeat(reverse: true);
        _waveController.repeat();
      } else {
        _recordingController.reverse();
        _pulseController.stop();
        _waveController.stop();
      }
    }
  }
  
  @override
  void dispose() {
    _recordingController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }
  
  void _handleRecordingToggle() {
    if (widget.isRecording) {
      widget.onStopRecording();
    } else {
      widget.onStartRecording();
    }
  }
  
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoalWithOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Recording interface
          _buildRecordingInterface(),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Recordings list
          if (widget.recordings.isNotEmpty) _buildRecordingsList(),
        ],
      ),
    );
  }
  
  Widget _buildRecordingInterface() {
    return Column(
      children: [
        // Recording status
        if (widget.isRecording) ...[
          Text(
            'Recording...',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.dustyRose,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            _formatDuration(widget.currentRecordingDuration),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.dustyRose,
              fontWeight: FontWeight.w500,
              fontFamily: 'Courier', // Monospace for timer
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          
          // Recording waveform visualization
          _buildWaveformVisualization(),
          
          const SizedBox(height: AppDimensions.spacingL),
        ] else ...[
          Text(
            'Voice Message',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Tap and hold to record, release to stop',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalWithOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),
        ],
        
        // Record button
        _buildRecordButton(),
      ],
    );
  }
  
  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: _handleRecordingToggle,
      onLongPressStart: (_) {
        if (!widget.isRecording) {
          HapticFeedback.mediumImpact();
          widget.onStartRecording();
        }
      },
      onLongPressEnd: (_) {
        if (widget.isRecording) {
          HapticFeedback.heavyImpact();
          widget.onStopRecording();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
        builder: (context, child) {
          final scale = widget.isRecording 
              ? _pulseAnimation.value 
              : _scaleAnimation.value;
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isRecording 
                      ? [AppColors.dustyRose, AppColors.dustyRoseHover]
                      : [AppColors.sageGreen, AppColors.sageGreenHover],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isRecording 
                        ? AppColors.dustyRose.withOpacity(0.3)
                        : AppColors.sageGreenWithOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.isRecording ? Icons.stop : Icons.mic,
                color: AppColors.pearlWhite,
                size: 32,
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildWaveformVisualization() {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              animationValue: _waveAnimation.value,
              color: AppColors.dustyRose,
            ),
            size: const Size(double.infinity, 60),
          );
        },
      ),
    );
  }
  
  Widget _buildRecordingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recordings (${widget.recordings.length})',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        
        ...widget.recordings.asMap().entries.map((entry) {
          final index = entry.key;
          final recording = entry.value;
          return _RecordingItem(
            recording: recording,
            index: index,
            onDelete: () => widget.onDeleteRecording(index),
            onInsertIntoText: () => widget.onInsertIntoText(index),
          );
        }).toList(),
      ],
    );
  }
}

/// Individual recording item widget
class _RecordingItem extends StatelessWidget {
  final VoiceRecording recording;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback onInsertIntoText;

  const _RecordingItem({
    required this.recording,
    required this.index,
    required this.onDelete,
    required this.onInsertIntoText,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.warmCream.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Voice icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: const Icon(
              Icons.volume_up,
              color: AppColors.sageGreen,
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Recording info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recording.displayName ?? 'Audio ${index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.softCharcoal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDuration(recording.duration),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.softCharcoalWithOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Insert into text button
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onInsertIntoText();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreenWithOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: const Icon(
                    Icons.text_fields,
                    color: AppColors.sageGreen,
                    size: 16,
                  ),
                ),
              ),
              
              const SizedBox(width: AppDimensions.spacingS),
              
              // Delete button
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onDelete();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.dustyRose.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColors.dustyRose,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for waveform visualization
class WaveformPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  WaveformPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 30;
    final barWidth = 2.0;
    final spacing = (size.width - (barCount * barWidth)) / (barCount - 1);

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);
      
      // Create varying heights with animation
      final baseHeight = (math.sin((i * 0.5) + (animationValue * math.pi * 2)) + 1) * 0.5;
      final animatedHeight = baseHeight * size.height * 0.4;
      
      final startY = centerY - (animatedHeight / 2);
      final endY = centerY + (animatedHeight / 2);
      
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! WaveformPainter || 
           oldDelegate.animationValue != animationValue;
  }
}