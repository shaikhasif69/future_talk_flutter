import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/chat_message.dart';

/// Premium voice message player with waveform animation and smooth interactions
class VoiceMessagePlayer extends StatefulWidget {
  const VoiceMessagePlayer({
    super.key,
    required this.voiceMessage,
    this.onPlay,
    this.onPause,
    this.onSeek,
  });

  final VoiceMessage voiceMessage;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final Function(double position)? onSeek;

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer>
    with TickerProviderStateMixin {
  late AnimationController _playButtonController;
  late AnimationController _waveController;
  late AnimationController _progressController;
  
  late Animation<double> _playButtonScale;
  late Animation<double> _waveAnimation;
  late Animation<Color?> _playButtonColor;

  bool _isPlaying = false;
  double _playbackProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _updatePlayingState();
  }

  void _initializeAnimations() {
    // Play button animations
    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _playButtonScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _playButtonController,
      curve: Curves.easeInOut,
    ));

    _playButtonColor = ColorTween(
      begin: AppColors.lavenderMist,
      end: AppColors.dustyRose,
    ).animate(_playButtonController);

    // Waveform animation
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    // Progress animation
    _progressController = AnimationController(
      duration: widget.voiceMessage.duration,
      vsync: this,
    );
  }

  void _updatePlayingState() {
    _isPlaying = widget.voiceMessage.isPlaying;
    _playbackProgress = widget.voiceMessage.progress;
    
    if (_isPlaying) {
      _playButtonController.forward();
      _waveController.repeat(reverse: true);
      _progressController.forward();
    } else {
      _playButtonController.reverse();
      _waveController.stop();
      _progressController.stop();
    }
  }

  @override
  void didUpdateWidget(VoiceMessagePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.voiceMessage.isPlaying != widget.voiceMessage.isPlaying ||
        oldWidget.voiceMessage.progress != widget.voiceMessage.progress) {
      _updatePlayingState();
    }
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    _waveController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _onPlayPauseTap() {
    HapticFeedback.lightImpact();
    
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      widget.onPlay?.call();
      _playButtonController.forward();
      _waveController.repeat(reverse: true);
      _startPlaybackSimulation();
    } else {
      widget.onPause?.call();
      _playButtonController.reverse();
      _waveController.stop();
      _progressController.stop();
    }
  }

  void _startPlaybackSimulation() {
    // Simulate voice message playback
    _progressController.reset();
    _progressController.forward().then((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackProgress = 0.0;
        });
        _playButtonController.reverse();
        _waveController.stop();
      }
    });
  }

  void _onWaveformTap(double position) {
    final seekPosition = position.clamp(0.0, 1.0);
    
    setState(() {
      _playbackProgress = seekPosition;
    });
    
    _progressController.value = seekPosition;
    widget.onSeek?.call(seekPosition);
    
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        children: [
          // Play/Pause Button
          _buildPlayButton(),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Waveform and Progress
          Expanded(
            child: _buildWaveformSection(),
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // Duration
          _buildDuration(),
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_playButtonController, _playButtonColor]),
      builder: (context, child) {
        return Transform.scale(
          scale: _playButtonScale.value,
          child: GestureDetector(
            onTap: _onPlayPauseTap,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _playButtonColor.value ?? AppColors.lavenderMist,
                    (_playButtonColor.value ?? AppColors.lavenderMist).withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_playButtonColor.value ?? AppColors.lavenderMist).withOpacity(0.4),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.pearlWhite,
                size: 20.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveformSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Waveform
        _buildWaveform(),
        
        const SizedBox(height: AppDimensions.spacingXS),
        
        // Progress indicator
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildWaveform() {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final relativePosition = localPosition.dx / box.size.width;
        _onWaveformTap(relativePosition);
      },
      child: Container(
        height: 24.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: CustomPaint(
          painter: _WaveformPainter(
            progress: _progressController.value,
            isPlaying: _isPlaying,
            waveAnimation: _waveAnimation,
            activeColor: AppColors.lavenderMist,
            inactiveColor: AppColors.lavenderMist.withOpacity(0.3),
          ),
          size: const Size.fromHeight(24.0),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _progressController.value,
          backgroundColor: AppColors.whisperGray,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.lavenderMist.withOpacity(0.6),
          ),
          minHeight: 2.0,
        );
      },
    );
  }

  Widget _buildDuration() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        final remainingDuration = widget.voiceMessage.duration * (1 - _progressController.value);
        final displayDuration = _isPlaying ? remainingDuration : widget.voiceMessage.duration;
        
        return Text(
          _formatDuration(displayDuration),
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.softCharcoalLight,
            fontFamily: 'monospace',
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Custom painter for voice message waveform
class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.progress,
    required this.isPlaying,
    required this.waveAnimation,
    required this.activeColor,
    required this.inactiveColor,
  });

  final double progress;
  final bool isPlaying;
  final Animation<double> waveAnimation;
  final Color activeColor;
  final Color inactiveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Generate waveform bars
    const barCount = 32;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;
    
    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth;
      final normalizedPosition = i / barCount;
      
      // Generate varied bar heights (simulating voice waveform)
      double baseHeight = _getBarHeight(normalizedPosition);
      
      // Add animation effect when playing
      if (isPlaying) {
        final animationOffset = (waveAnimation.value + normalizedPosition) % 1.0;
        baseHeight += baseHeight * 0.3 * (0.5 + 0.5 * (animationOffset * 2 - 1).abs());
      }
      
      final barHeight = baseHeight * size.height * 0.8;
      
      // Determine bar color based on progress
      final isActive = normalizedPosition <= progress;
      paint.color = isActive ? activeColor : inactiveColor;
      
      // Draw bar
      final rect = Rect.fromLTWH(
        x + barWidth * 0.1,
        centerY - barHeight / 2,
        barWidth * 0.8,
        barHeight,
      );
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.0)),
        paint,
      );
    }
  }

  double _getBarHeight(double position) {
    // Create a realistic voice waveform pattern
    final patterns = [
      0.3, 0.6, 0.8, 0.4, 0.9, 0.7, 0.5, 0.3,
      0.2, 0.5, 0.8, 0.9, 0.6, 0.4, 0.7, 0.3,
      0.5, 0.8, 0.6, 0.3, 0.7, 0.9, 0.4, 0.2,
      0.6, 0.5, 0.8, 0.7, 0.3, 0.9, 0.4, 0.6,
    ];
    
    final index = (position * patterns.length).floor();
    return patterns[index % patterns.length];
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.isPlaying != isPlaying ||
           oldDelegate.waveAnimation.value != waveAnimation.value;
  }
}

/// Voice message recorder widget
class VoiceMessageRecorder extends StatefulWidget {
  const VoiceMessageRecorder({
    super.key,
    required this.onRecordingComplete,
    this.onRecordingCanceled,
    this.maxDuration = const Duration(minutes: 5),
  });

  final Function(VoiceMessage voiceMessage) onRecordingComplete;
  final VoidCallback? onRecordingCanceled;
  final Duration maxDuration;

  @override
  State<VoiceMessageRecorder> createState() => _VoiceMessageRecorderState();
}

class _VoiceMessageRecorderState extends State<VoiceMessageRecorder>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  double _amplitude = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
    });

    _pulseController.repeat(reverse: true);
    
    // Simulate recording with periodic amplitude updates
    _simulateRecording();
    
    HapticFeedback.heavyImpact();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });

    _pulseController.stop();
    _waveController.stop();

    // Create mock voice message
    final voiceMessage = VoiceMessage(
      audioUrl: 'mock_audio_${DateTime.now().millisecondsSinceEpoch}',
      duration: _recordingDuration,
    );

    widget.onRecordingComplete(voiceMessage);
    
    HapticFeedback.lightImpact();
  }

  void _cancelRecording() {
    setState(() {
      _isRecording = false;
      _recordingDuration = Duration.zero;
    });

    _pulseController.stop();
    _waveController.stop();
    
    widget.onRecordingCanceled?.call();
    
    HapticFeedback.heavyImpact();
  }

  void _simulateRecording() {
    if (!_isRecording) return;

    // Update duration
    setState(() {
      _recordingDuration += const Duration(milliseconds: 100);
    });

    // Generate random amplitude
    _amplitude = 0.3 + (0.7 * (DateTime.now().millisecond / 1000));
    _waveController.forward().then((_) => _waveController.reverse());

    // Check max duration
    if (_recordingDuration >= widget.maxDuration) {
      _stopRecording();
      return;
    }

    // Continue simulation
    Future.delayed(const Duration(milliseconds: 100), _simulateRecording);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.dustyRose.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.dustyRose.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Record Button
          _buildRecordButton(),
          
          if (_isRecording) ...[
            const SizedBox(width: AppDimensions.spacingM),
            
            // Waveform Visualization
            Expanded(child: _buildRecordingWaveform()),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            // Duration
            _buildRecordingDuration(),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            // Stop Button
            _buildStopButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isRecording ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: _isRecording ? null : _startRecording,
            onLongPress: _isRecording ? _cancelRecording : null,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: _isRecording ? AppColors.dustyRose : AppColors.sageGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? AppColors.dustyRose : AppColors.sageGreen)
                        .withOpacity(0.4),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: AppColors.pearlWhite,
                size: 20.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordingWaveform() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Container(
          height: 24.0,
          child: CustomPaint(
            painter: _RecordingWaveformPainter(
              amplitude: _amplitude * _scaleAnimation.value,
              color: AppColors.dustyRose,
            ),
            size: const Size.fromHeight(24.0),
          ),
        );
      },
    );
  }

  Widget _buildRecordingDuration() {
    return Text(
      _formatDuration(_recordingDuration),
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.dustyRose,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStopButton() {
    return GestureDetector(
      onTap: _stopRecording,
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: AppColors.sageGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.send,
          color: AppColors.pearlWhite,
          size: 16.0,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Custom painter for recording waveform visualization
class _RecordingWaveformPainter extends CustomPainter {
  _RecordingWaveformPainter({
    required this.amplitude,
    required this.color,
  });

  final double amplitude;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const barCount = 20;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth;
      
      // Create varied heights with current amplitude
      final baseHeight = (0.3 + (i % 3) * 0.2) * amplitude;
      final barHeight = baseHeight * size.height;

      final rect = Rect.fromLTWH(
        x + barWidth * 0.2,
        centerY - barHeight / 2,
        barWidth * 0.6,
        barHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.0)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RecordingWaveformPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}