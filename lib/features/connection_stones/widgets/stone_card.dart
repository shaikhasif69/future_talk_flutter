import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/connection_stone_model.dart';
import '../models/stone_type.dart';
import '../models/touch_interaction_model.dart';
import '../providers/connection_stones_provider.dart';
import '../utils/haptic_feedback_service.dart';
import '../utils/touch_detector.dart';
import 'stone_visual_widget.dart';

/// Premium stone card with magical visual effects and touch interactions
class StoneCard extends ConsumerStatefulWidget {
  final ConnectionStone stone;
  final VoidCallback? onTap;

  const StoneCard({
    super.key,
    required this.stone,
    this.onTap,
  });

  @override
  ConsumerState<StoneCard> createState() => _StoneCardState();
}

class _StoneCardState extends ConsumerState<StoneCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _touchController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _touchAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _touchController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
    
    _touchAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _touchController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _touchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverAnimation, _touchAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _touchAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered 
                        ? widget.stone.stoneType.primaryColor.withOpacity(0.2)
                        : AppColors.cardShadow,
                    blurRadius: _isHovered ? 16 : 8,
                    offset: Offset(0, _isHovered ? 8 : 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: StoneTouchDetector(
                onStoneTouch: _handleStoneTouch,
                onStoneDetails: _handleStoneDetails,
                isReceiving: widget.stone.isReceivingComfort,
                isSending: widget.stone.isSendingComfort,
                rippleColor: widget.stone.stoneType.rippleColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pearlWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isHovered 
                          ? widget.stone.stoneType.primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingL),
                    child: Column(
                      children: [
                        // Stone visual with animations
                        StoneVisualWidget(
                          stone: widget.stone,
                          size: 80,
                          enableAnimations: true,
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingM),
                        
                        // Stone name
                        Text(
                          widget.stone.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.softCharcoal,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingS),
                        
                        // Friend name
                        Text(
                          'Connected to ${widget.stone.friendName}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.softCharcoalLight,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: AppDimensions.spacingM),
                        
                        // Touch indicator
                        _buildTouchIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTouchIndicator() {
    if (widget.stone.isReceivingComfort) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.stone.stoneType.primaryColor,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.5, 1.5),
              duration: const Duration(milliseconds: 1000),
            ),
          
          const SizedBox(width: AppDimensions.spacingS),
          
          Text(
            'Receiving comfort...',
            style: AppTextStyles.labelMedium.copyWith(
              color: widget.stone.stoneType.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ).animate(onPlay: (controller) => controller.repeat())
            .shimmer(
              duration: const Duration(milliseconds: 1500),
              color: widget.stone.stoneType.primaryColor.withOpacity(0.3),
            ),
        ],
      );
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.sageGreen,
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingS),
        
        Text(
          widget.stone.lastTouchDisplay,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
      ],
    );
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  Future<void> _handleStoneTouch(TouchType touchType, TouchLocation? location) async {
    // Animate touch feedback
    _touchController.forward().then((_) {
      _touchController.reverse();
    });
    
    // Play haptic feedback
    await HapticFeedbackService.instance.playStoneTouch(
      widget.stone.stoneType,
      touchType,
    );
    
    // Send comfort through stone
    await ref.read(connectionStonesProvider.notifier)
        .touchStone(widget.stone.id, touchType);
    
    // Show touch feedback
    if (mounted) {
      _showTouchFeedback(touchType);
    }
  }

  void _handleStoneDetails() {
    HapticFeedbackService.instance.playUIFeedback();
    widget.onTap?.call();
    _showStoneDetailsModal();
  }

  void _showTouchFeedback(TouchType touchType) {
    final message = touchType == TouchType.longPress
        ? '💕 Deep comfort sent to ${widget.stone.friendName}'
        : '✨ Quick comfort sent to ${widget.stone.friendName}';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(widget.stone.stoneType.emoji),
            const SizedBox(width: AppDimensions.spacingS),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: widget.stone.stoneType.primaryColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(AppDimensions.spacingM),
      ),
    );
  }

  void _showStoneDetailsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StoneDetailsModal(stone: widget.stone),
    );
  }
}

/// Detailed modal for stone information and actions
class StoneDetailsModal extends ConsumerWidget {
  final ConnectionStone stone;

  const StoneDetailsModal({
    super.key,
    required this.stone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interactions = ref.watch(touchInteractionsProvider)
        .where((interaction) => interaction.stoneId == stone.id)
        .take(5)
        .toList();

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.modalShadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.stoneGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Stone header
              _buildStoneHeader(),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Stone meaning and description
              _buildStoneInfo(),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Statistics
              _buildStatistics(),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Recent interactions
              if (interactions.isNotEmpty) ...[
                _buildRecentInteractions(interactions),
                const SizedBox(height: AppDimensions.spacingL),
              ],
              
              // Action buttons
              _buildActionButtons(context, ref),
            ],
          ),
        ),
      ),
    ).animate()
      .slideY(
        begin: 1.0,
        end: 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      )
      .fadeIn();
  }

  Widget _buildStoneHeader() {
    return Column(
      children: [
        // Large stone visual
        StoneVisualWidget(
          stone: stone,
          size: 120,
          enableAnimations: true,
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Stone name
        Text(
          stone.name,
          style: AppTextStyles.headlineLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppDimensions.spacingS),
        
        // Friend connection
        Text(
          'Connected to ${stone.friendName}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppDimensions.spacingS),
        
        // Connection strength
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: stone.stoneType.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: stone.stoneType.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            stone.connectionStrengthDisplay,
            style: AppTextStyles.labelMedium.copyWith(
              color: stone.stoneType.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoneInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: stone.stoneType.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            stone.stoneType.meaning,
            style: AppTextStyles.titleMedium.copyWith(
              color: stone.stoneType.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            stone.stoneType.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          icon: Icons.touch_app,
          label: 'Touches',
          value: stone.totalTouches.toString(),
          color: AppColors.sageGreen,
        ),
        _buildStatItem(
          icon: Icons.favorite,
          label: 'Received',
          value: stone.totalComfortReceived.toString(),
          color: AppColors.dustyRose,
        ),
        _buildStatItem(
          icon: Icons.calendar_today,
          label: 'Created',
          value: _formatDate(stone.createdAt),
          color: AppColors.lavenderMist,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingS),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacingS),
        
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.softCharcoalLight,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentInteractions(List<TouchInteraction> interactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        ...interactions.map((interaction) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
          child: Row(
            children: [
              Text(interaction.touchTypeEmoji),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Text(
                  interaction.getDisplayMessage(stone.name, stone.friendName),
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Text(
                interaction.timeDisplay,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Primary actions
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _sendComfort(context, ref, TouchType.longPress),
                icon: const Icon(Icons.favorite, size: 18),
                label: Text(
                  'Send Deep Comfort',
                  style: AppTextStyles.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: stone.stoneType.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: AppDimensions.spacingM),
            
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _sendComfort(context, ref, TouchType.quickTouch),
                icon: const Icon(Icons.touch_app, size: 18),
                label: Text(
                  'Quick Touch',
                  style: AppTextStyles.button.copyWith(
                    color: stone.stoneType.primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: stone.stoneType.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        // Secondary actions
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _toggleQuickAccess(context, ref),
                child: Text(
                  stone.isQuickAccess ? 'Remove from Quick Bar' : 'Add to Quick Bar',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.sageGreen,
                  ),
                ),
              ),
            ),
            
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.softCharcoalLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _sendComfort(
    BuildContext context, 
    WidgetRef ref, 
    TouchType touchType,
  ) async {
    Navigator.pop(context);
    
    await HapticFeedbackService.instance.playStoneTouch(
      stone.stoneType,
      touchType,
    );
    
    await ref.read(connectionStonesProvider.notifier)
        .touchStone(stone.id, touchType);
        
    if (context.mounted) {
      final message = touchType == TouchType.longPress
          ? 'Deep comfort sent through your ${stone.name}! 💕'
          : 'Quick comfort sent to ${stone.friendName}! ✨';
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${stone.stoneType.emoji} $message',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: stone.stoneType.primaryColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _toggleQuickAccess(BuildContext context, WidgetRef ref) {
    ref.read(connectionStonesProvider.notifier)
        .toggleQuickAccess(stone.id);
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}m ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}