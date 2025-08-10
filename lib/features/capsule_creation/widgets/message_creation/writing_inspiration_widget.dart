import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/time_capsule_creation_data.dart';
import '../../models/message_creation_data.dart';
import '../../models/writing_prompts_data.dart';

/// Writing inspiration widget with rotating quotes and purpose-specific prompts
/// Features expandable/collapsible UI with smooth animations
class WritingInspirationWidget extends StatefulWidget {
  final TimeCapsulePurpose? purpose;
  final bool isExpanded;
  final VoidCallback onExpandToggle;
  final Animation<double> expandAnimation;

  const WritingInspirationWidget({
    super.key,
    required this.purpose,
    required this.isExpanded,
    required this.onExpandToggle,
    required this.expandAnimation,
  });

  @override
  State<WritingInspirationWidget> createState() => _WritingInspirationWidgetState();
}

class _WritingInspirationWidgetState extends State<WritingInspirationWidget>
    with TickerProviderStateMixin {
  late AnimationController _quoteController;
  late Animation<double> _quoteAnimation;
  
  int _currentQuoteIndex = 0;
  String _currentQuote = '';
  
  @override
  void initState() {
    super.initState();
    
    _quoteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _quoteAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _quoteController,
      curve: Curves.easeInOut,
    ));
    
    // Initialize with current quote
    _updateQuote();
    _quoteController.forward();
    
    // Start quote rotation timer
    _startQuoteRotation();
  }
  
  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }
  
  void _startQuoteRotation() {
    // Rotate quotes every 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && widget.isExpanded) {
        _rotateQuote();
        _startQuoteRotation();
      }
    });
  }
  
  void _rotateQuote() {
    _quoteController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentQuoteIndex = (_currentQuoteIndex + 1) % WritingQuotes.quotes.length;
          _updateQuote();
        });
        _quoteController.forward();
      }
    });
  }
  
  void _updateQuote() {
    _currentQuote = WritingQuotes.getQuote(_currentQuoteIndex);
  }
  
  void _handleQuoteRefresh() {
    HapticFeedback.selectionClick();
    _rotateQuote();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.isExpanded) {
      return _buildCollapsedView();
    }
    
    return AnimatedBuilder(
      animation: widget.expandAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.expandAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - widget.expandAnimation.value)),
            child: child,
          ),
        );
      },
      child: _buildExpandedView(),
    );
  }
  
  Widget _buildCollapsedView() {
    return GestureDetector(
      onTap: widget.onExpandToggle,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.lavenderMist.withAlpha(26),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.lavenderMist.withAlpha(77),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Inspiration icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lavenderMist.withAlpha(51),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.lavenderMist,
                size: 20,
              ),
            ),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            // Title
            Expanded(
              child: Text(
                'Writing Inspiration',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Expand icon
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.softCharcoalWithOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExpandedView() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.lavenderMist.withAlpha(51),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with collapse button
          _buildExpandedHeader(),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Rotating quote
          _buildRotatingQuote(),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Writing prompts
          _buildWritingPrompts(),
        ],
      ),
    );
  }
  
  Widget _buildExpandedHeader() {
    return Row(
      children: [
        // Inspiration icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lavenderMist.withAlpha(26),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: const Icon(
            Icons.lightbulb,
            color: AppColors.lavenderMist,
            size: 20,
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Title
        Expanded(
          child: Text(
            'Writing Inspiration',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Collapse button
        GestureDetector(
          onTap: widget.onExpandToggle,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.lavenderMist.withAlpha(26),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.lavenderMist,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildRotatingQuote() {
    return AnimatedBuilder(
      animation: _quoteAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _quoteAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.lavenderMist.withValues(alpha: 0.08),
                  AppColors.cloudBlue.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.lavenderMist.withAlpha(51),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote header
                Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: AppColors.lavenderMist.withAlpha(153),
                      size: 18,
                    ),
                    
                    const SizedBox(width: AppDimensions.spacingS),
                    
                    Text(
                      'Daily Inspiration',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.lavenderMist,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Refresh quote button
                    GestureDetector(
                      onTap: _handleQuoteRefresh,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.lavenderMist.withAlpha(26),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                        ),
                        child: Icon(
                          Icons.refresh,
                          color: AppColors.lavenderMist,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingM),
                
                // Quote text
                Text(
                  _currentQuote,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.softCharcoal,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildWritingPrompts() {
    final prompts = widget.purpose != null 
        ? WritingPromptsData.getPromptsForPurpose(widget.purpose!)
        : WritingPromptsData.prompts.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prompts header
        Row(
          children: [
            Icon(
              Icons.edit_outlined,
              color: AppColors.sageGreen.withAlpha(179),
              size: 18,
            ),
            
            const SizedBox(width: AppDimensions.spacingS),
            
            Text(
              'Writing Prompts',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Prompts list
        ...prompts.take(3).map((prompt) => _buildPromptItem(prompt)),
      ],
    );
  }
  
  Widget _buildPromptItem(WritingPrompt prompt) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.warmCream.withAlpha(77),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.sageGreen.withAlpha(26),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt title
          Text(
            prompt.text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          if (prompt.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              prompt.subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.softCharcoalWithOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
          
          if (prompt.inspiration != null) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.sageGreen.withAlpha(26),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Text(
                prompt.inspiration!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sageGreen,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}