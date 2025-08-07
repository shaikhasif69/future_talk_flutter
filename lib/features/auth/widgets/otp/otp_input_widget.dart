import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_durations.dart';

class OtpInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final bool enabled;
  final int length;

  const OtpInputWidget({
    super.key,
    required this.controller,
    required this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.length = 6,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> with TickerProviderStateMixin {
  final List<FocusNode> _focusNodes = [];
  final List<TextEditingController> _controllers = [];
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    for (int i = 0; i < widget.length; i++) {
      final focusNode = FocusNode();
      final controller = TextEditingController();
      
      focusNode.addListener(() => _onFocusChange(i));
      controller.addListener(() => _onTextChange(i));
      
      _focusNodes.add(focusNode);
      _controllers.add(controller);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange(int index) {
    if (_focusNodes[index].hasFocus) {
      setState(() => _currentIndex = index);
      _pulseController.repeat(reverse: true);
      HapticFeedback.selectionClick();
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  void _onTextChange(int index) {
    final text = _controllers[index].text;
    
    if (text.length == 1) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      
      _updateMainController();
      HapticFeedback.lightImpact();
    } else if (text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _updateMainController() {
    final otp = _controllers.map((c) => c.text).join();
    widget.controller.text = otp;
    
    widget.onChanged?.call(otp);
    
    if (otp.length == widget.length) {
      HapticFeedback.mediumImpact();
      widget.onCompleted(otp);
    }
  }

  void _onKeyDown(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _controllers[index - 1].clear();
          _focusNodes[index - 1].requestFocus();
          _updateMainController();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.length, (index) {
            return _buildOtpField(index);
          }),
        ),
        
        const SizedBox(height: AppDimensions.spacingL),
        
        _buildProgressIndicator(),
      ],
    );
  }

  Widget _buildOtpField(int index) {
    final bool isCurrentField = _currentIndex == index;
    final bool hasText = _controllers[index].text.isNotEmpty;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isCurrentField ? _pulseAnimation.value : 1.0,
          child: Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: widget.enabled 
                  ? (hasText ? AppColors.lavenderMist.withValues(alpha: 0.3) : AppColors.warmCreamAlt)
                  : AppColors.stoneGray.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: _getBorderColor(index),
                width: isCurrentField ? 2.0 : 1.0,
              ),
              boxShadow: [
                if (isCurrentField) BoxShadow(
                  color: AppColors.sageGreen.withValues(alpha: 0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) => _onKeyDown(event, index),
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: AppTextStyles.displaySmall.copyWith(
                  color: widget.enabled ? AppColors.softCharcoal : AppColors.softCharcoalLight,
                  fontWeight: FontWeight.w600,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  if (value.length > 1) {
                    _controllers[index].text = value[value.length - 1];
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBorderColor(int index) {
    final bool hasText = _controllers[index].text.isNotEmpty;
    final bool isCurrentField = _currentIndex == index;
    
    if (!widget.enabled) {
      return AppColors.stoneGray;
    }
    
    if (hasText) {
      return AppColors.sageGreen;
    }
    
    if (isCurrentField) {
      return AppColors.sageGreen;
    }
    
    return AppColors.whisperGray;
  }

  Widget _buildProgressIndicator() {
    final filledCount = _controllers.where((c) => c.text.isNotEmpty).length;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: AppDimensions.iconS,
              color: AppColors.softCharcoalLight,
            ),
            
            const SizedBox(width: AppDimensions.spacingS),
            
            Text(
              '$filledCount/${widget.length} digits entered',
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        LinearProgressIndicator(
          value: filledCount / widget.length,
          backgroundColor: AppColors.whisperGray,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ],
    );
  }
}