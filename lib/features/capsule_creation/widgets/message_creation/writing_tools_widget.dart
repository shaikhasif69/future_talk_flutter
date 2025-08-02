import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/message_creation_data.dart';

/// Writing tools widget with font selector, text size controls, and quick actions
/// Premium UI with smooth animations and haptic feedback
class WritingToolsWidget extends StatefulWidget {
  final MessageFont selectedFont;
  final double fontSize;
  final ValueChanged<MessageFont> onFontChanged;
  final ValueChanged<double> onFontSizeChanged;
  final VoidCallback onInsertVoiceNote;

  const WritingToolsWidget({
    super.key,
    required this.selectedFont,
    required this.fontSize,
    required this.onFontChanged,
    required this.onFontSizeChanged,
    required this.onInsertVoiceNote,
  });

  @override
  State<WritingToolsWidget> createState() => _WritingToolsWidgetState();
}

class _WritingToolsWidgetState extends State<WritingToolsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  
  bool _isExpanded = false;
  bool _showFontDropdown = false;
  
  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    ));
  }
  
  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }
  
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
      _showFontDropdown = false;
    }
    
    HapticFeedback.selectionClick();
  }
  
  void _toggleFontDropdown() {
    setState(() {
      _showFontDropdown = !_showFontDropdown;
    });
    
    HapticFeedback.selectionClick();
  }
  
  void _handleFontChanged(MessageFont font) {
    widget.onFontChanged(font);
    setState(() {
      _showFontDropdown = false;
    });
    
    HapticFeedback.selectionClick();
  }
  
  void _increaseFontSize() {
    final newSize = (widget.fontSize + 1.0).clamp(12.0, 28.0);
    widget.onFontSizeChanged(newSize);
    HapticFeedback.selectionClick();
  }
  
  void _decreaseFontSize() {
    final newSize = (widget.fontSize - 1.0).clamp(12.0, 28.0);
    widget.onFontSizeChanged(newSize);
    HapticFeedback.selectionClick();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header with expand toggle
          _buildHeader(),
          
          // Expanded tools
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildExpandedTools(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.warmCream.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Row(
          children: [
            // Tools icon
            Icon(
              Icons.text_format,
              color: AppColors.sageGreen,
              size: 20,
            ),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            // Title
            Text(
              'Writing Tools',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const Spacer(),
            
            // Current font and size info
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
                '${widget.selectedFont.displayName} • ${widget.fontSize.toInt()}px',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sageGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(width: AppDimensions.spacingS),
            
            // Expand icon
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.softCharcoalWithOpacity(0.6),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExpandedTools() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        children: [
          // Font selection row
          _buildFontSelectionRow(),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Text size controls
          _buildTextSizeControls(),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Quick actions
          _buildQuickActions(),
          
          // Font dropdown overlay
          if (_showFontDropdown) ...[
            const SizedBox(height: AppDimensions.spacingM),
            _buildFontDropdown(),
          ],
        ],
      ),
    );
  }
  
  Widget _buildFontSelectionRow() {
    return Row(
      children: [
        Text(
          'Font',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        Expanded(
          child: GestureDetector(
            onTap: _toggleFontDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.warmCream.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: _showFontDropdown 
                      ? AppColors.sageGreen 
                      : AppColors.sageGreenWithOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedFont.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.softCharcoal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  AnimatedRotation(
                    turns: _showFontDropdown ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.softCharcoalWithOpacity(0.6),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTextSizeControls() {
    return Row(
      children: [
        Text(
          'Size',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Decrease button
        GestureDetector(
          onTap: widget.fontSize > 12.0 ? _decreaseFontSize : null,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.fontSize > 12.0 
                  ? AppColors.sageGreenWithOpacity(0.1)
                  : AppColors.stoneGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              border: Border.all(
                color: widget.fontSize > 12.0 
                    ? AppColors.sageGreenWithOpacity(0.3)
                    : AppColors.stoneGray.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.remove,
              color: widget.fontSize > 12.0 
                  ? AppColors.sageGreen 
                  : AppColors.stoneGray,
              size: 18,
            ),
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Font size display
        Container(
          width: 60,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.warmCream.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            border: Border.all(
              color: AppColors.sageGreenWithOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${widget.fontSize.toInt()}px',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Increase button
        GestureDetector(
          onTap: widget.fontSize < 28.0 ? _increaseFontSize : null,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.fontSize < 28.0 
                  ? AppColors.sageGreenWithOpacity(0.1)
                  : AppColors.stoneGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              border: Border.all(
                color: widget.fontSize < 28.0 
                    ? AppColors.sageGreenWithOpacity(0.3)
                    : AppColors.stoneGray.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.add,
              color: widget.fontSize < 28.0 
                  ? AppColors.sageGreen 
                  : AppColors.stoneGray,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickActions() {
    return Row(
      children: [
        Text(
          'Actions',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Voice note button
        Expanded(
          child: GestureDetector(
            onTap: widget.onInsertVoiceNote,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.dustyRose.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.dustyRose.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mic,
                    color: AppColors.dustyRose,
                    size: 16,
                  ),
                  
                  const SizedBox(width: 6),
                  
                  Text(
                    'Add Voice Note',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.dustyRose,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFontDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoalWithOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: MessageFont.values.map((font) {
          final isSelected = font == widget.selectedFont;
          
          return GestureDetector(
            onTap: () => _handleFontChanged(font),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.spacingM,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.sageGreenWithOpacity(0.1) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      font.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected 
                            ? AppColors.sageGreen 
                            : AppColors.softCharcoal,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  
                  // Font category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: Text(
                      font.category.name.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.softCharcoalWithOpacity(0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  if (isSelected) ...[
                    const SizedBox(width: AppDimensions.spacingS),
                    Icon(
                      Icons.check,
                      color: AppColors.sageGreen,
                      size: 18,
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}