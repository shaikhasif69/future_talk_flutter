import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';

/// Premium search bar with debouncing and smooth animations
/// Features introvert-friendly placeholders and gentle focus transitions
class ChatSearchBar extends StatefulWidget {
  const ChatSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    this.focusNode,
  });

  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  final FocusNode? focusNode;

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;

  Timer? _debounceTimer;
  bool _isFocused = false;
  bool _hasContent = false;

  // Gentle placeholder texts for introverts
  static const List<String> _placeholders = [
    'Search conversations...',
    'Find friends or groups...',
    'Search by name or message...',
    'Look for someone special...',
  ];

  int _currentPlaceholderIndex = 0;
  String _currentPlaceholder = _placeholders[0];

  @override
  void initState() {
    super.initState();
    
    _controller = TextEditingController(text: widget.searchQuery);
    _focusNode = widget.focusNode ?? FocusNode();
    _hasContent = widget.searchQuery.isNotEmpty;
    
    _animationController = AnimationController(
      duration: AppDurations.mediumFast,
      vsync: this,
    );
    
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
    
    // Start placeholder rotation
    _startPlaceholderRotation();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _animationController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_handleTextChange);
    
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    
    super.dispose();
  }

  void _startPlaceholderRotation() {
    // Only rotate placeholder when not focused and no content
    if (!_isFocused && !_hasContent) {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_isFocused || _hasContent || !mounted) {
          timer.cancel();
          return;
        }
        
        setState(() {
          _currentPlaceholderIndex = 
              (_currentPlaceholderIndex + 1) % _placeholders.length;
          _currentPlaceholder = _placeholders[_currentPlaceholderIndex];
        });
      });
    }
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused) {
      _animationController.forward();
      // Set focused placeholder
      setState(() {
        _currentPlaceholder = 'Search by name or message...';
      });
    } else {
      _animationController.reverse();
      // Reset to default placeholder if no content
      if (!_hasContent) {
        setState(() {
          _currentPlaceholder = _placeholders[0];
        });
        _startPlaceholderRotation();
      }
    }
  }

  void _handleTextChange() {
    final text = _controller.text;
    final hasContent = text.isNotEmpty;
    
    if (_hasContent != hasContent) {
      setState(() {
        _hasContent = hasContent;
      });
    }
    
    // Debounce search
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged(text);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClearSearch();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.pearlWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: AppColors.sageGreen.withValues(alpha: 0.1),
                blurRadius: 8.0,
                spreadRadius: 0,
              ),
            ] : null,
          ),
          child: Row(
            children: [
              // Search icon
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.spacingL,
                  right: AppDimensions.spacingS,
                ),
                child: AnimatedContainer(
                  duration: AppDurations.mediumFast,
                  child: Icon(
                    Icons.search,
                    size: 20.0,
                    color: AppColors.sageGreen,
                  ),
                ).animate().scale(
                  begin: const Offset(1.0, 1.0),
                  end: _isFocused ? const Offset(1.1, 1.1) : const Offset(1.0, 1.0),
                  duration: AppDurations.mediumFast,
                ),
              ),
              
              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: AppColors.softCharcoal,
                  ),
                  decoration: InputDecoration(
                    hintText: _currentPlaceholder,
                    hintStyle: TextStyle(
                      color: AppColors.softCharcoalLight.withValues(alpha: 0.7),
                      fontSize: 15.0,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingM,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _focusNode.unfocus(),
                ),
              ),
              
              // Clear button
              if (_hasContent)
                Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.spacingS),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: _clearSearch,
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: AppColors.softCharcoalLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16.0,
                          color: AppColors.softCharcoalLight,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn().scaleXY(
                  begin: 0.0,
                  duration: AppDurations.fast,
                  curve: Curves.easeOutBack,
                ),
            ],
          ),
        );
      },
    );
  }
}