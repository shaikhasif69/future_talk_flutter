import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/time_capsule_creation_data.dart';
import '../../models/message_creation_data.dart';

/// Premium message editor widget with rich text editing and font selection
/// Features expandable full-screen mode, auto-focus, and dynamic greeting
class MessageEditorWidget extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final TimeCapsulePurpose? purpose;
  final MessageFont selectedFont;
  final double fontSize;
  final int wordCount;
  final bool isFullScreen;
  final VoidCallback onFullScreenToggle;
  final ValueChanged<MessageFont> onFontChanged;
  final ValueChanged<double> onFontSizeChanged;

  const MessageEditorWidget({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.purpose,
    required this.selectedFont,
    required this.fontSize,
    required this.wordCount,
    required this.isFullScreen,
    required this.onFullScreenToggle,
    required this.onFontChanged,
    required this.onFontSizeChanged,
  });

  @override
  State<MessageEditorWidget> createState() => _MessageEditorWidgetState();
}

class _MessageEditorWidgetState extends State<MessageEditorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  
  bool _showGreeting = true;
  
  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    ));
    
    // Check if greeting should be shown
    _updateGreetingVisibility();
    
    // Listen to text changes
    widget.textController.addListener(_handleTextChange);
  }
  
  @override
  void didUpdateWidget(MessageEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.isFullScreen != widget.isFullScreen) {
      if (widget.isFullScreen) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }
  
  @override
  void dispose() {
    widget.textController.removeListener(_handleTextChange);
    _expandController.dispose();
    super.dispose();
  }
  
  void _handleTextChange() {
    _updateGreetingVisibility();
  }
  
  void _updateGreetingVisibility() {
    final shouldShowGreeting = widget.textController.text.isEmpty;
    if (shouldShowGreeting != _showGreeting) {
      setState(() {
        _showGreeting = shouldShowGreeting;
      });
    }
  }
  
  void _handleGreetingTap() {
    final greeting = _getGreetingText();
    if (widget.textController.text.isEmpty) {
      widget.textController.text = '$greeting\n\n';
      widget.textController.selection = TextSelection.collapsed(
        offset: widget.textController.text.length,
      );
    }
    
    // Focus the text field
    widget.focusNode.requestFocus();
    
    HapticFeedback.selectionClick();
  }
  
  String _getGreetingText() {
    switch (widget.purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'Dear Future Me,';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Dear Friend,';
      case TimeCapsulePurpose.anonymous:
        return 'Dear Someone,';
      case null:
        return 'Dear Friend,';
    }
  }
  
  String _getPlaceholderText() {
    switch (widget.purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'What would you like to tell your future self? Share your thoughts, dreams, challenges, or wisdom...';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Write a heartfelt message to someone special. What do you want them to know?';
      case TimeCapsulePurpose.anonymous:
        return 'Share words of encouragement, hope, or wisdom. Your message will touch someone\'s heart...';
      case null:
        return 'Start writing your message here...';
    }
  }
  
  TextStyle _getTextStyle() {
    TextStyle baseStyle;
    
    try {
      switch (widget.selectedFont) {
        case MessageFont.crimsonPro:
          baseStyle = GoogleFonts.crimsonPro();
          break;
        case MessageFont.playfairDisplay:
          baseStyle = GoogleFonts.playfairDisplay();
          break;
        case MessageFont.dancingScript:
          baseStyle = GoogleFonts.dancingScript();
          break;
        case MessageFont.caveat:
          baseStyle = GoogleFonts.caveat();
          break;
        case MessageFont.kalam:
          baseStyle = GoogleFonts.kalam();
          break;
        case MessageFont.patrickHand:
          baseStyle = GoogleFonts.patrickHand();
          break;
        case MessageFont.satisfy:
          baseStyle = GoogleFonts.satisfy();
          break;
        case MessageFont.system:
        default:
          baseStyle = AppTextStyles.bodyMedium;
          break;
      }
    } catch (e) {
      // Fallback to system font if Google Fonts fails
      baseStyle = AppTextStyles.bodyMedium;
    }
    
    return baseStyle.copyWith(
      fontSize: widget.fontSize,
      color: AppColors.softCharcoal,
      height: 1.6,
      letterSpacing: 0.2,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = widget.isFullScreen 
        ? screenHeight * 0.7 
        : 200.0;
    
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          constraints: BoxConstraints(
            minHeight: minHeight,
            maxHeight: widget.isFullScreen ? double.infinity : 400,
          ),
          decoration: BoxDecoration(
            color: AppColors.pearlWhite,
            borderRadius: BorderRadius.circular(
              widget.isFullScreen ? 0 : AppDimensions.radiusL,
            ),
            border: widget.isFullScreen ? null : Border.all(
              color: AppColors.sageGreenWithOpacity(0.1),
              width: 1,
            ),
            boxShadow: widget.isFullScreen ? null : [
              BoxShadow(
                color: AppColors.softCharcoalWithOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Editor header (hidden in full-screen)
              if (!widget.isFullScreen) _buildEditorHeader(),
              
              // Text editor area
              Expanded(
                child: Stack(
                  children: [
                    // Main text field
                    Padding(
                      padding: EdgeInsets.all(
                        widget.isFullScreen 
                            ? AppDimensions.spacingXL 
                            : AppDimensions.paddingL,
                      ),
                      child: TextField(
                        controller: widget.textController,
                        focusNode: widget.focusNode,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: _getTextStyle(),
                        decoration: InputDecoration(
                          hintText: _getPlaceholderText(),
                          hintStyle: _getTextStyle().copyWith(
                            color: AppColors.softCharcoalWithOpacity(0.4),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        cursorColor: AppColors.sageGreen,
                        cursorWidth: 2,
                        cursorHeight: widget.fontSize * 1.2,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onTap: () {
                          HapticFeedback.selectionClick();
                        },
                      ),
                    ),
                    
                    // Greeting overlay
                    if (_showGreeting && widget.textController.text.isEmpty)
                      Positioned(
                        top: widget.isFullScreen 
                            ? AppDimensions.spacingXL 
                            : AppDimensions.paddingL,
                        left: widget.isFullScreen 
                            ? AppDimensions.spacingXL 
                            : AppDimensions.paddingL,
                        child: GestureDetector(
                          onTap: _handleGreetingTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.spacingS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sageGreenWithOpacity(0.08),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              border: Border.all(
                                color: AppColors.sageGreenWithOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _getGreetingText(),
                                  style: _getTextStyle().copyWith(
                                    color: AppColors.sageGreen,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.touch_app,
                                  size: 16,
                                  color: AppColors.sageGreenWithOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Editor footer with stats (hidden in full-screen)
              if (!widget.isFullScreen) _buildEditorFooter(),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildEditorHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.warmCream.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusL),
          topRight: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Row(
        children: [
          // Font indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Text(
              widget.selectedFont.displayName,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sageGreen,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingS),
          
          // Font size indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.sageGreenWithOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Text(
              '${widget.fontSize.toInt()}px',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sageGreen,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Full-screen toggle
          GestureDetector(
            onTap: widget.onFullScreenToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.sageGreenWithOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(
                Icons.fullscreen,
                size: 18,
                color: AppColors.sageGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditorFooter() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.warmCream.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusL),
          bottomRight: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Row(
        children: [
          // Word count
          Text(
            '${widget.wordCount} words',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.softCharcoalWithOpacity(0.6),
              fontSize: 12,
            ),
          ),
          
          const Spacer(),
          
          // Auto-save indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 14,
                color: AppColors.sageGreenWithOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                'Auto-saved',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sageGreenWithOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}