import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';

class OtpInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final bool enabled;
  final int length;
  final bool shouldClear;
  final VoidCallback? onClearComplete;

  const OtpInputWidget({
    super.key,
    required this.controller,
    required this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.length = 6,
    this.shouldClear = false,
    this.onClearComplete,
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
      // Text change is now handled in onChanged callback
      
      _focusNodes.add(focusNode);
      _controllers.add(controller);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void didUpdateWidget(OtpInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle clear request
    if (widget.shouldClear && !oldWidget.shouldClear) {
      clearOtp();
      widget.onClearComplete?.call();
    }
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
      // Move to next field if not the last one
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus to complete input
        _focusNodes[index].unfocus();
      }
      
      _updateMainController();
      HapticFeedback.lightImpact();
    } else if (text.isEmpty) {
      // Update main controller when field is cleared
      _updateMainController();
    }
  }

  /// Clear all OTP fields
  void clearOtp() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].clear();
    }
    _updateMainController();
    _focusNodes[0].requestFocus();
  }

  /// Handle paste operation for full OTP
  void _handlePasteOperation(String pastedText, int startIndex) {
    // Remove non-digits and take only the required length
    final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    final maxLength = widget.length - startIndex;
    final validDigits = digits.length > maxLength ? digits.substring(0, maxLength) : digits;
    
    // Fill the fields starting from the current index
    for (int i = 0; i < validDigits.length && (startIndex + i) < widget.length; i++) {
      _controllers[startIndex + i].text = validDigits[i];
    }
    
    // Focus the next empty field or the last field if all are filled
    final nextEmptyIndex = _findNextEmptyField();
    if (nextEmptyIndex != -1) {
      _focusNodes[nextEmptyIndex].requestFocus();
    } else {
      _focusNodes[widget.length - 1].unfocus();
    }
    
    _updateMainController();
    HapticFeedback.lightImpact();
  }

  /// Find the next empty field index
  int _findNextEmptyField() {
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        return i;
      }
    }
    return -1; // All fields are filled
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

  void _onKeyDown(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Clear previous field and move focus there
          _controllers[index - 1].clear();
          _focusNodes[index - 1].requestFocus();
          _updateMainController();
          HapticFeedback.lightImpact();
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
                  ? (hasText ? AppColors.lavenderMist.withAlpha(77) : AppColors.warmCreamAlt)
                  : AppColors.stoneGray.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: _getBorderColor(index),
                width: isCurrentField ? 2.0 : 1.0,
              ),
              boxShadow: [
                if (isCurrentField) BoxShadow(
                  color: AppColors.sageGreen.withAlpha(51),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) => _onKeyDown(event, index),
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
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  // Handle text input properly
                  if (value.length > 1) {
                    // Check if it's a paste operation with multiple digits
                    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.length > 1) {
                      // Handle paste operation
                      _handlePasteOperation(digits, index);
                      return;
                    } else {
                      // Multiple characters but only one digit, use it
                      final lastChar = digits.isNotEmpty ? digits[0] : '';
                      if (lastChar.isNotEmpty && RegExp(r'^[0-9]$').hasMatch(lastChar)) {
                        _controllers[index].text = lastChar;
                        _controllers[index].selection = TextSelection.collapsed(offset: 1);
                      } else {
                        _controllers[index].text = '';
                      }
                    }
                  } else if (value.length == 1) {
                    // Single character input - validate it's a digit
                    if (!RegExp(r'^[0-9]$').hasMatch(value)) {
                      _controllers[index].text = '';
                      return;
                    }
                  }
                  
                  // Trigger the text change handler after processing
                  Future.microtask(() => _onTextChange(index));
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