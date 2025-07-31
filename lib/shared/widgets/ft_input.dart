import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_durations.dart';

/// Future Talk's premium input component
/// Designed with smooth animations and elegant validation
class FTInput extends StatefulWidget {
  /// Input label text
  final String? label;
  
  /// Input hint text
  final String? hint;
  
  /// Input helper text
  final String? helperText;
  
  /// Input error text
  final String? errorText;
  
  /// Input controller
  final TextEditingController? controller;
  
  /// Input focus node
  final FocusNode? focusNode;
  
  /// Input type
  final TextInputType keyboardType;
  
  /// Text input action
  final TextInputAction textInputAction;
  
  /// Input obscure text (for passwords)
  final bool obscureText;
  
  /// Enable/disable input
  final bool enabled;
  
  /// Input read-only state
  final bool readOnly;
  
  /// Max lines for multiline input
  final int? maxLines;
  
  /// Min lines for multiline input
  final int? minLines;
  
  /// Max length of input
  final int? maxLength;
  
  /// Input validator
  final String? Function(String?)? validator;
  
  /// On changed callback
  final Function(String)? onChanged;
  
  /// On submitted callback
  final Function(String)? onSubmitted;
  
  /// On tap callback
  final VoidCallback? onTap;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Suffix icon
  final IconData? suffixIcon;
  
  /// Suffix icon callback
  final VoidCallback? onSuffixIconTap;
  
  /// Input style variant
  final FTInputStyle style;
  
  /// Auto focus
  final bool autofocus;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  const FTInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.style = FTInputStyle.filled,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  /// Email input with email keyboard and validation
  const FTInput.email({
    super.key,
    this.label = 'Email',
    this.hint = 'Enter your email',
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onSuffixIconTap,
    this.style = FTInputStyle.filled,
    this.autofocus = false,
    this.inputFormatters,
  }) : keyboardType = TextInputType.emailAddress,
       textInputAction = TextInputAction.next,
       obscureText = false,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       prefixIcon = Icons.email_outlined,
       suffixIcon = null,
       textCapitalization = TextCapitalization.none;

  /// Password input with visibility toggle
  const FTInput.password({
    super.key,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.style = FTInputStyle.filled,
    this.autofocus = false,
    this.inputFormatters,
  }) : keyboardType = TextInputType.visiblePassword,
       textInputAction = TextInputAction.done,
       obscureText = true,
       maxLines = 1,
       minLines = null,
       maxLength = null,
       prefixIcon = Icons.lock_outline,
       suffixIcon = null,
       onSuffixIconTap = null,
       textCapitalization = TextCapitalization.none;

  /// Multiline text input
  const FTInput.multiline({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 4,
    this.minLines = 2,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.style = FTInputStyle.filled,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
  }) : keyboardType = TextInputType.multiline,
       textInputAction = TextInputAction.newline,
       obscureText = false;

  @override
  State<FTInput> createState() => _FTInputState();
}

class _FTInputState extends State<FTInput> with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _errorController;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _errorSlideAnimation;
  
  late FocusNode _focusNode;
  late TextEditingController _controller;
  
  bool _isFocused = false;
  bool _obscureText = false;
  String? _currentError;

  @override
  void initState() {
    super.initState();
    
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    
    _focusController = AnimationController(
      duration: AppDurations.inputFocus,
      vsync: this,
    );
    
    _errorController = AnimationController(
      duration: AppDurations.inputValidation,
      vsync: this,
    );
    
    _borderColorAnimation = ColorTween(
      begin: AppColors.whisperGray,
      end: AppColors.sageGreen,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeOut,
    ));
    
    _errorSlideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _errorController,
      curve: Curves.easeOut,
    ));
    
    _focusNode.addListener(_handleFocusChange);
    
    // Set initial error state
    if (widget.errorText != null) {
      _currentError = widget.errorText;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _errorController.forward();
      });
    }
  }

  @override
  void didUpdateWidget(FTInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle error text changes
    if (widget.errorText != oldWidget.errorText) {
      if (widget.errorText != null && oldWidget.errorText == null) {
        // Error appeared
        _currentError = widget.errorText;
        _errorController.forward();
      } else if (widget.errorText == null && oldWidget.errorText != null) {
        // Error disappeared
        _errorController.reverse().then((_) {
          if (mounted) {
            setState(() => _currentError = null);
          }
        });
      } else if (widget.errorText != oldWidget.errorText) {
        // Error text changed
        _currentError = widget.errorText;
      }
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    _errorController.dispose();
    
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    
    super.dispose();
  }

  void _handleFocusChange() {
    final bool focused = _focusNode.hasFocus;
    if (focused != _isFocused) {
      setState(() => _isFocused = focused);
      
      if (focused) {
        _focusController.forward();
        HapticFeedback.selectionClick();
      } else {
        _focusController.reverse();
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelLarge.copyWith(
              color: _currentError != null 
                  ? AppColors.dustyRose 
                  : (_isFocused ? AppColors.sageGreen : AppColors.softCharcoalLight),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
        ],
        
        AnimatedBuilder(
          animation: _borderColorAnimation,
          builder: (context, child) {
            return TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: _obscureText,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              autofocus: widget.autofocus,
              textCapitalization: widget.textCapitalization,
              inputFormatters: widget.inputFormatters,
              style: AppTextStyles.bodyMedium.copyWith(
                color: widget.enabled 
                    ? AppColors.softCharcoal 
                    : AppColors.softCharcoalLight,
              ),
              decoration: _buildInputDecoration(),
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
            );
          },
        ),
        
        // Error message with slide animation
        AnimatedBuilder(
          animation: _errorSlideAnimation,
          builder: (context, child) {
            if (_currentError == null && _errorSlideAnimation.value == 0.0) {
              return const SizedBox.shrink();
            }
            
            return ClipRect(
              child: Align(
                alignment: Alignment.topLeft,
                heightFactor: _errorSlideAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.spacingXS),
                  child: Text(
                    _currentError ?? '',
                    style: AppTextStyles.error,
                  ),
                ),
              ),
            );
          },
        ),
        
        // Helper text
        if (widget.helperText != null && _currentError == null) ...[
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            widget.helperText!,
            style: AppTextStyles.labelMedium,
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    final bool hasError = _currentError != null;
    
    Color borderColor;
    if (hasError) {
      borderColor = AppColors.dustyRose;
    } else if (_isFocused) {
      borderColor = _borderColorAnimation.value ?? AppColors.sageGreen;
    } else {
      borderColor = AppColors.whisperGray;
    }
    
    Color fillColor;
    switch (widget.style) {
      case FTInputStyle.filled:
        fillColor = widget.enabled 
            ? AppColors.warmCreamAlt 
            : AppColors.stoneGray.withOpacity( 0.1);
        break;
      case FTInputStyle.outlined:
        fillColor = Colors.transparent;
        break;
      case FTInputStyle.underlined:
        fillColor = Colors.transparent;
        break;
    }

    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.labelLarge.copyWith(
        color: AppColors.softCharcoalLight,
      ),
      filled: widget.style == FTInputStyle.filled,
      fillColor: fillColor,
      
      // Prefix icon
      prefixIcon: widget.prefixIcon != null 
          ? Icon(
              widget.prefixIcon,
              color: hasError 
                  ? AppColors.dustyRose 
                  : (_isFocused ? AppColors.sageGreen : AppColors.softCharcoalLight),
              size: AppDimensions.iconM,
            )
          : null,
      
      // Suffix icon (with password toggle logic)
      suffixIcon: _buildSuffixIcon(),
      
      // Borders based on style
      border: _buildInputBorder(widget.style, AppColors.whisperGray),
      enabledBorder: _buildInputBorder(widget.style, borderColor),
      focusedBorder: _buildInputBorder(widget.style, borderColor, focused: true),
      errorBorder: _buildInputBorder(widget.style, AppColors.dustyRose),
      focusedErrorBorder: _buildInputBorder(widget.style, AppColors.dustyRose, focused: true),
      disabledBorder: _buildInputBorder(widget.style, AppColors.stoneGray),
      
      // Content padding
      contentPadding: _getContentPadding(),
      
      // Counter
      counterStyle: AppTextStyles.labelSmall,
      
      // Error style (handled by our custom error display)
      errorStyle: const TextStyle(height: 0.0, fontSize: 0.0),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      // Password visibility toggle
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: _isFocused ? AppColors.sageGreen : AppColors.softCharcoalLight,
          size: AppDimensions.iconM,
        ),
        onPressed: _togglePasswordVisibility,
        splashRadius: 20.0,
      );
    } else if (widget.suffixIcon != null) {
      // Custom suffix icon
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: _isFocused ? AppColors.sageGreen : AppColors.softCharcoalLight,
          size: AppDimensions.iconM,
        ),
        onPressed: widget.onSuffixIconTap,
        splashRadius: 20.0,
      );
    }
    
    return null;
  }

  InputBorder _buildInputBorder(FTInputStyle style, Color color, {bool focused = false}) {
    final double width = focused ? 2.0 : 1.0;
    
    switch (style) {
      case FTInputStyle.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: color, width: width),
        );
        
      case FTInputStyle.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
          borderSide: BorderSide(color: color, width: width),
        );
        
      case FTInputStyle.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
    }
  }

  EdgeInsets _getContentPadding() {
    switch (widget.style) {
      case FTInputStyle.filled:
      case FTInputStyle.outlined:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.inputPaddingHorizontal,
          vertical: AppDimensions.inputPaddingVertical,
        );
        
      case FTInputStyle.underlined:
        return const EdgeInsets.only(
          bottom: AppDimensions.spacingS,
        );
    }
  }
}

/// Input style variants
enum FTInputStyle {
  filled,
  outlined,
  underlined,
}

/// Input validation helper class
class FTInputValidators {
  FTInputValidators._();

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    return null;
  }

  /// Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Minimum length validation
  static String? Function(String?) minLength(int length, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.length < length) {
        return '${fieldName ?? 'This field'} must be at least $length characters';
      }
      return null;
    };
  }

  /// Maximum length validation
  static String? Function(String?) maxLength(int length, [String? fieldName]) {
    return (String? value) {
      if (value != null && value.length > length) {
        return '${fieldName ?? 'This field'} cannot exceed $length characters';
      }
      return null;
    };
  }

  /// Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}