import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_durations.dart';

/// Future Talk's premium button component
/// Designed with smooth animations and haptic feedback for premium feel
class FTButton extends StatefulWidget {
  /// Button text
  final String text;
  
  /// Button press callback
  final VoidCallback? onPressed;
  
  /// Button style variant
  final FTButtonStyle style;
  
  /// Button size variant
  final FTButtonSize size;
  
  /// Show loading state
  final bool isLoading;
  
  /// Button disabled state
  final bool isDisabled;
  
  /// Custom icon (optional)
  final IconData? icon;
  
  /// Icon position
  final FTButtonIconPosition iconPosition;
  
  /// Custom width (if null, uses full width)
  final double? width;
  
  /// Custom height (if null, uses size-based height)
  final double? height;

  const FTButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = FTButtonStyle.primary,
    this.size = FTButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = FTButtonIconPosition.left,
    this.width,
    this.height,
  });

  /// Primary button (main actions)
  const FTButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = FTButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = FTButtonIconPosition.left,
    this.width,
    this.height,
  }) : style = FTButtonStyle.primary;

  /// Secondary button (alternative actions)
  const FTButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = FTButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = FTButtonIconPosition.left,
    this.width,
    this.height,
  }) : style = FTButtonStyle.secondary;

  /// Outlined button (less prominent actions)
  const FTButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.size = FTButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = FTButtonIconPosition.left,
    this.width,
    this.height,
  }) : style = FTButtonStyle.outlined;

  /// Text button (subtle actions)
  const FTButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = FTButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = FTButtonIconPosition.left,
    this.width,
    this.height,
  }) : style = FTButtonStyle.text;

  @override
  State<FTButton> createState() => _FTButtonState();
}

class _FTButtonState extends State<FTButton> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _pressController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: AppDurations.buttonHover,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOut,
    ));
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isEnabled) return;
    
    setState(() => _isPressed = true);
    _pressController.forward();
    
    // Haptic feedback for premium feel
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isEnabled) return;
    
    setState(() => _isPressed = false);
    _pressController.reverse();
    
    // Stronger haptic feedback on release
    HapticFeedback.mediumImpact();
    
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleHoverEnter(PointerEnterEvent event) {
    if (!_isEnabled) return;
    
    setState(() => _isHovered = true);
    _hoverController.forward();
  }

  void _handleHoverExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  bool get _isEnabled => 
      widget.onPressed != null && !widget.isDisabled && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    Widget button = MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _hoverAnimation]),
          child: _buildButtonContent(),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value * _hoverAnimation.value,
              child: child,
            );
          },
        ),
      ),
    );

    // If no explicit width is provided, make the button intrinsic to its content
    if (widget.width == null) {
      return IntrinsicWidth(child: button);
    }
    
    return button;
  }

  Widget _buildButtonContent() {
    final buttonConfig = _getButtonConfig();
    
    return Container(
      width: widget.width,
      height: widget.height ?? buttonConfig.height,
      constraints: widget.width == null 
          ? null 
          : BoxConstraints(minWidth: 0, maxWidth: widget.width!),
      decoration: _buildButtonDecoration(buttonConfig),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          onTap: null, // Handled by gesture detector
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: buttonConfig.paddingHorizontal,
              vertical: buttonConfig.paddingVertical,
            ),
            child: _buildButtonChild(buttonConfig),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonChild(ButtonConfig config) {
    if (widget.isLoading) {
      return _buildLoadingContent(config);
    }
    
    if (widget.icon != null) {
      return _buildIconContent(config);
    }
    
    return _buildTextContent(config);
  }

  Widget _buildLoadingContent(ButtonConfig config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: config.iconSize,
          height: config.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(config.textColor),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(
          'Loading...',
          style: config.textStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIconContent(ButtonConfig config) {
    final iconWidget = Icon(
      widget.icon,
      size: config.iconSize,
      color: config.textColor,
    );
    
    final textWidget = Text(
      widget.text,
      style: config.textStyle,
      textAlign: TextAlign.center,
    );

    if (widget.iconPosition == FTButtonIconPosition.left) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: AppDimensions.spacingS),
          Flexible(child: textWidget),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: textWidget),
          const SizedBox(width: AppDimensions.spacingS),
          iconWidget,
        ],
      );
    }
  }

  Widget _buildTextContent(ButtonConfig config) {
    return Text(
      widget.text,
      style: config.textStyle,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  BoxDecoration _buildButtonDecoration(ButtonConfig config) {
    return BoxDecoration(
      gradient: config.gradient,
      color: config.backgroundColor,
      border: config.border,
      borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
      boxShadow: _isEnabled && config.showShadow ? [
        BoxShadow(
          color: config.shadowColor,
          blurRadius: _isPressed ? 4.0 : 8.0,
          offset: Offset(0, _isPressed ? 1.0 : 2.0),
        ),
      ] : null,
    );
  }

  ButtonConfig _getButtonConfig() {
    final isEnabled = _isEnabled;
    
    switch (widget.style) {
      case FTButtonStyle.primary:
        return ButtonConfig(
          backgroundColor: isEnabled 
              ? (_isHovered ? AppColors.sageGreenHover : AppColors.sageGreen)
              : AppColors.stoneGray,
          textColor: isEnabled ? AppColors.pearlWhite : AppColors.softCharcoalLight,
          textStyle: _getTextStyle().copyWith(
            color: isEnabled ? AppColors.pearlWhite : AppColors.softCharcoalLight,
          ),
          height: _getHeight(),
          paddingHorizontal: _getPaddingHorizontal(),
          paddingVertical: _getPaddingVertical(),
          iconSize: _getIconSize(),
          showShadow: true,
          shadowColor: AppColors.buttonShadow,
        );
        
      case FTButtonStyle.secondary:
        return ButtonConfig(
          backgroundColor: isEnabled 
              ? (_isHovered ? AppColors.lavenderMistHover : AppColors.lavenderMist)
              : AppColors.stoneGray,
          textColor: isEnabled ? AppColors.softCharcoal : AppColors.softCharcoalLight,
          textStyle: _getTextStyle().copyWith(
            color: isEnabled ? AppColors.softCharcoal : AppColors.softCharcoalLight,
          ),
          height: _getHeight(),
          paddingHorizontal: _getPaddingHorizontal(),
          paddingVertical: _getPaddingVertical(),
          iconSize: _getIconSize(),
          showShadow: true,
          shadowColor: AppColors.cardShadow,
        );
        
      case FTButtonStyle.outlined:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          textColor: isEnabled 
              ? (_isHovered ? AppColors.sageGreenHover : AppColors.sageGreen)
              : AppColors.stoneGray,
          textStyle: _getTextStyle().copyWith(
            color: isEnabled 
                ? (_isHovered ? AppColors.sageGreenHover : AppColors.sageGreen)
                : AppColors.stoneGray,
          ),
          border: Border.all(
            color: isEnabled 
                ? (_isHovered ? AppColors.sageGreenHover : AppColors.sageGreen)
                : AppColors.stoneGray,
            width: 1.5,
          ),
          height: _getHeight(),
          paddingHorizontal: _getPaddingHorizontal(),
          paddingVertical: _getPaddingVertical(),
          iconSize: _getIconSize(),
          showShadow: false,
        );
        
      case FTButtonStyle.text:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          textColor: isEnabled 
              ? (_isHovered ? AppColors.sageGreenHover : AppColors.sageGreen)
              : AppColors.stoneGray,
          textStyle: AppTextStyles.link.copyWith(
            color: isEnabled 
                ? (_isHovered ? AppColors.sageGreenHover : AppColors.sageGreen)
                : AppColors.stoneGray,
            decoration: TextDecoration.none,
          ),
          height: _getHeight(),
          paddingHorizontal: AppDimensions.spacingL,
          paddingVertical: AppDimensions.spacingM,
          iconSize: _getIconSize(),
          showShadow: false,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case FTButtonSize.small:
        return AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w500);
      case FTButtonSize.medium:
        return AppTextStyles.button;
      case FTButtonSize.large:
        return AppTextStyles.titleMedium;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case FTButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case FTButtonSize.medium:
        return AppDimensions.buttonHeightMedium;
      case FTButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  double _getPaddingHorizontal() {
    switch (widget.size) {
      case FTButtonSize.small:
        return AppDimensions.spacingL;
      case FTButtonSize.medium:
        return AppDimensions.buttonPaddingHorizontal;
      case FTButtonSize.large:
        return AppDimensions.spacingXXXL;
    }
  }

  double _getPaddingVertical() {
    switch (widget.size) {
      case FTButtonSize.small:
        return AppDimensions.spacingS;
      case FTButtonSize.medium:
        return AppDimensions.buttonPaddingVertical;
      case FTButtonSize.large:
        return AppDimensions.spacingL;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case FTButtonSize.small:
        return AppDimensions.iconS;
      case FTButtonSize.medium:
        return AppDimensions.iconM;
      case FTButtonSize.large:
        return AppDimensions.iconL;
    }
  }
}

/// Button style variants
enum FTButtonStyle {
  primary,
  secondary,
  outlined,
  text,
}

/// Button size variants
enum FTButtonSize {
  small,
  medium,
  large,
}

/// Icon position for buttons with icons
enum FTButtonIconPosition {
  left,
  right,
}

/// Internal button configuration
class ButtonConfig {
  final Color? backgroundColor;
  final Color textColor;
  final TextStyle textStyle;
  final Border? border;
  final Gradient? gradient;
  final double height;
  final double paddingHorizontal;
  final double paddingVertical;
  final double iconSize;
  final bool showShadow;
  final Color shadowColor;

  const ButtonConfig({
    this.backgroundColor,
    required this.textColor,
    required this.textStyle,
    this.border,
    this.gradient,
    required this.height,
    required this.paddingHorizontal,
    required this.paddingVertical,
    required this.iconSize,
    this.showShadow = false,
    this.shadowColor = Colors.transparent,
  });
}