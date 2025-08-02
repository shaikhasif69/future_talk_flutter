import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/animations/ft_fade_in.dart';
import '../models/chat_message.dart';

/// Floating quick reactions overlay with premium animations and interactions
class QuickReactions extends StatefulWidget {
  const QuickReactions({
    super.key,
    required this.onReactionTap,
    this.onDismiss,
    this.reactions = QuickReactions.defaultReactions,
  });

  final Function(String emoji) onReactionTap;
  final VoidCallback? onDismiss;
  final List<String> reactions;

  /// Default reactions for general use
  static const List<String> defaultReactions = [
    '❤️', '😊', '👍', '🤗', '💛', '✨', '🙏'
  ];

  /// Supportive reactions for emotional moments
  static const List<String> supportiveReactions = [
    '🤗', '💛', '🙏', '✨', '❤️', '🌟', '💪', '🫂'
  ];

  /// Connection stone themed reactions
  static const List<String> connectionStoneReactions = [
    '🪨', '💎', '🌟', '✨', '💫', '🔮', '🌸', '🍃'
  ];

  @override
  State<QuickReactions> createState() => _QuickReactionsState();
}

class _QuickReactionsState extends State<QuickReactions>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  final List<AnimationController> _buttonControllers = [];
  final List<Animation<double>> _buttonScales = [];
  
  String? _selectedReaction;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    // Main container animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Individual reaction button animations
    for (int i = 0; i < widget.reactions.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 200 + (i * 50)),
        vsync: this,
      );
      
      final scale = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      
      _buttonControllers.add(controller);
      _buttonScales.add(scale);
    }
  }

  void _startEntryAnimation() {
    _slideController.forward();
    _scaleController.forward();
    
    // Stagger button animations
    for (int i = 0; i < _buttonControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) {
          _buttonControllers[i].forward();
        }
      });
    }
  }

  Future<void> _dismiss() async {
    // Reverse animations
    await Future.wait([
      _slideController.reverse(),
      _scaleController.reverse(),
    ]);
    
    widget.onDismiss?.call();
  }

  void _onReactionTap(String emoji) async {
    setState(() {
      _selectedReaction = emoji;
    });
    
    // Create selection animation
    HapticFeedback.lightImpact();
    
    // Brief pause for visual feedback
    await Future.delayed(const Duration(milliseconds: 200));
    
    widget.onReactionTap(emoji);
    await _dismiss();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    
    for (final controller in _buttonControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_slideController, _scaleController]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildReactionsContainer(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReactionsContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.modalShadow,
            blurRadius: 24.0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          _buildTitle(),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Reactions Grid
          _buildReactionsGrid(),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          // Dismiss Hint
          _buildDismissHint(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Quick Reactions',
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.softCharcoal,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildReactionsGrid() {
    const itemsPerRow = 4;
    final rows = (widget.reactions.length / itemsPerRow).ceil();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rows, (rowIndex) {
        final startIndex = rowIndex * itemsPerRow;
        final endIndex = (startIndex + itemsPerRow)
            .clamp(0, widget.reactions.length);
        final rowReactions = widget.reactions.sublist(startIndex, endIndex);
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex < rows - 1 ? AppDimensions.spacingM : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowReactions.asMap().entries.map((entry) {
              final localIndex = entry.key;
              final globalIndex = startIndex + localIndex;
              final emoji = entry.value;
              
              return _buildReactionButton(emoji, globalIndex);
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildReactionButton(String emoji, int index) {
    final isSelected = _selectedReaction == emoji;
    
    return AnimatedBuilder(
      animation: _buttonScales[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScales[index].value,
          child: GestureDetector(
            onTap: () => _onReactionTap(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.sageGreen.withOpacity(0.2)
                    : AppColors.sageGreenWithOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.sageGreen
                      : AppColors.sageGreenWithOpacity(0.15),
                  width: isSelected ? 2.0 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.sageGreen.withOpacity(0.3),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isSelected ? 24.0 : 20.0,
                  ),
                  child: Text(emoji),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDismissHint() {
    return FTFadeIn(
      delay: const Duration(milliseconds: 800),
      child: Text(
        'Tap outside to dismiss',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.softCharcoalLight,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// Specialized quick reactions for different contexts
class ContextualQuickReactions {
  /// Get reactions based on message content and context
  static List<String> getReactionsForMessage(ChatMessage message) {
    final content = message.content.toLowerCase();
    
    // Emotional support context
    if (content.contains('sad') || 
        content.contains('tired') || 
        content.contains('stressed') ||
        content.contains('difficult')) {
      return QuickReactions.supportiveReactions;
    }
    
    // Connection stones context
    if (message.type == MessageType.connectionStone ||
        content.contains('connection') ||
        content.contains('stone') ||
        content.contains('energy')) {
      return QuickReactions.connectionStoneReactions;
    }
    
    // Default reactions
    return QuickReactions.defaultReactions;
  }
  
  /// Get reactions based on social battery status
  static List<String> getReactionsForSocialBattery(String? batteryLevel) {
    switch (batteryLevel?.toLowerCase()) {
      case 'recharging':
      case 'low':
        return ['💤', '🤗', '💛', '🌙', '✨', '🙏', '🫂'];
      case 'selective':
      case 'yellow':
        return ['💛', '😊', '👍', '🤗', '✨', '🌟', '💫'];
      case 'energized':
      case 'green':
      case 'high':
        return ['⚡', '🌟', '😄', '🎉', '✨', '💫', '🚀'];
      default:
        return QuickReactions.defaultReactions;
    }
  }
}

/// Animated reaction picker for custom reactions
class ReactionPicker extends StatefulWidget {
  const ReactionPicker({
    super.key,
    required this.onReactionSelected,
    this.categories = const ['😊', '❤️', '👍', '🎉', '😮', '😢', '😡'],
  });

  final Function(String emoji) onReactionSelected;
  final List<String> categories;

  @override
  State<ReactionPicker> createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<ReactionPicker> {
  String _selectedCategory = '😊';
  
  final Map<String, List<String>> _reactionsByCategory = {
    '😊': ['😊', '😄', '😆', '🥰', '😍', '🤗', '😌', '😋'],
    '❤️': ['❤️', '💕', '💖', '💗', '💓', '💞', '💝', '🧡'],
    '👍': ['👍', '👏', '🙌', '✌️', '🤝', '💪', '🤟', '👌'],
    '🎉': ['🎉', '🎊', '🥳', '🎈', '🎁', '⭐', '🌟', '✨'],
    '😮': ['😮', '😯', '😲', '🤯', '😱', '🙄', '🤔', '🧐'],
    '😢': ['😢', '😭', '😰', '😔', '😞', '😟', '😕', '🙁'],
    '😡': ['😡', '😠', '🤬', '😤', '😑', '🙃', '😒', '😖'],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.0,
            height: 4.0,
            margin: const EdgeInsets.only(
              top: AppDimensions.spacingM,
              bottom: AppDimensions.paddingM,
            ),
            decoration: BoxDecoration(
              color: AppColors.whisperGray,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          
          // Category selector
          SizedBox(
            height: 50.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              itemCount: widget.categories.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppDimensions.spacingM),
              itemBuilder: (context, index) {
                final category = widget.categories[index];
                final isSelected = category == _selectedCategory;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.sageGreen.withOpacity(0.2)
                          : AppColors.sageGreenWithOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.sageGreen
                            : AppColors.sageGreenWithOpacity(0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // Reactions grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: AppDimensions.spacingS,
                mainAxisSpacing: AppDimensions.spacingS,
              ),
              itemCount: _reactionsByCategory[_selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final reactions = _reactionsByCategory[_selectedCategory]!;
                final emoji = reactions[index];
                
                return GestureDetector(
                  onTap: () => widget.onReactionSelected(emoji),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.sageGreenWithOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.spacingS),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}