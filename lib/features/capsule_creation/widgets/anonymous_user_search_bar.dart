import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Privacy-focused search bar for anonymous user search
/// Only performs search on explicit confirmation to protect user privacy
class AnonymousUserSearchBar extends StatefulWidget {
  /// Callback when search is confirmed
  final ValueChanged<String> onSearchConfirmed;
  
  /// Callback when search input changes (for validation only)
  final ValueChanged<String>? onSearchChanged;
  
  /// Callback when search is cleared
  final VoidCallback? onSearchCleared;
  
  /// Whether search is currently loading
  final bool isLoading;
  
  /// Initial search text
  final String? initialText;

  const AnonymousUserSearchBar({
    super.key,
    required this.onSearchConfirmed,
    this.onSearchChanged,
    this.onSearchCleared,
    this.isLoading = false,
    this.initialText,
  });

  @override
  State<AnonymousUserSearchBar> createState() => _AnonymousUserSearchBarState();
}

class _AnonymousUserSearchBarState extends State<AnonymousUserSearchBar>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  bool _hasText = false;
  bool _isSearchValid = false;

  @override
  void initState() {
    super.initState();
    
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    _hasText = _controller.text.isNotEmpty;
    _isSearchValid = _validateSearchQuery(_controller.text);
    
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

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newText = _controller.text;
    final newHasText = newText.isNotEmpty;
    final newIsValid = _validateSearchQuery(newText);
    
    if (_hasText != newHasText || _isSearchValid != newIsValid) {
      setState(() {
        _hasText = newHasText;
        _isSearchValid = newIsValid;
      });
    }
    
    widget.onSearchChanged?.call(newText);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  bool _validateSearchQuery(String query) {
    // Privacy-focused validation: minimum length for exact matching
    return query.trim().length >= 3;
  }

  void _handleSearchConfirm() {
    if (!_isSearchValid || widget.isLoading) return;
    
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      // Haptic feedback for search action
      HapticFeedback.mediumImpact();
      
      // Unfocus to hide keyboard
      _focusNode.unfocus();
      
      widget.onSearchConfirmed(query);
    }
  }

  void _handleClearSearch() {
    if (widget.isLoading) return;
    
    HapticFeedback.selectionClick();
    _controller.clear();
    widget.onSearchCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search section title
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.lavenderMist.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.search,
                size: 16,
                color: AppColors.lavenderMist,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              'Find Recipient',
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.softCharcoal,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Search input with confirm button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _focusNode.hasFocus ? _pulseAnimation.value : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: _focusNode.hasFocus
                      ? [
                          BoxShadow(
                            color: AppColors.lavenderMist.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Search input field
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.softCharcoal,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter username or email address...',
                          hintStyle: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.whisperGray,
                            fontStyle: FontStyle.italic,
                          ),
                          filled: true,
                          fillColor: AppColors.pearlWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            borderSide: BorderSide(
                              color: AppColors.whisperGray.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            borderSide: BorderSide(
                              color: AppColors.whisperGray.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            borderSide: const BorderSide(
                              color: AppColors.lavenderMist,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingL,
                            vertical: AppDimensions.paddingL,
                          ),
                          suffixIcon: _hasText
                              ? IconButton(
                                  onPressed: _handleClearSearch,
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppColors.whisperGray,
                                  ),
                                  tooltip: 'Clear search',
                                )
                              : null,
                        ),
                        onSubmitted: (_) => _handleSearchConfirm(),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    
                    const SizedBox(width: AppDimensions.spacingS),
                    
                    // Confirm search button
                    SizedBox(
                      width: 80,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: ElevatedButton(
                          onPressed: _isSearchValid && !widget.isLoading
                              ? _handleSearchConfirm
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSearchValid
                                ? AppColors.lavenderMist
                                : AppColors.whisperGray,
                            foregroundColor: AppColors.pearlWhite,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingM,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                            ),
                            elevation: _isSearchValid ? 2 : 0,
                        ),
                        child: widget.isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.pearlWhite,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.search,
                                size: 18,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        // Privacy hint
        const SizedBox(height: AppDimensions.spacingS),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.warmPeach.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                size: 12,
                color: AppColors.warmPeach,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingXS),
            Expanded(
              child: Text(
                'Type the complete username or email for privacy',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}