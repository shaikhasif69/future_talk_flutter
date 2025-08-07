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

/// Quick touch bar with breathing stone animations for instant comfort sending
class QuickTouchBar extends ConsumerStatefulWidget {
  const QuickTouchBar({super.key});

  @override
  ConsumerState<QuickTouchBar> createState() => _QuickTouchBarState();
}

class _QuickTouchBarState extends ConsumerState<QuickTouchBar>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quickStones = ref.watch(connectionStonesProvider)
        .where((stone) => stone.isQuickAccess)
        .take(4)
        .toList();

    if (quickStones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.spacingM,
        0,
        AppDimensions.spacingM,
        AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          children: [
            // Title
            Text(
              'Quick Comfort',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.softCharcoal,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            // Quick stones row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: quickStones.asMap().entries.map((entry) {
                final index = entry.key;
                final stone = entry.value;
                return _buildQuickStone(stone, index);
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate()
      .slideY(
        begin: 0.3,
        end: 0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
      )
      .fadeIn(
        duration: const Duration(milliseconds: 400),
      );
  }

  Widget _buildQuickStone(ConnectionStone stone, int index) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        // Stagger the breathing animation for each stone
        final staggeredProgress = (_breathingController.value + (index * 0.25)) % 1.0;
        final breatheScale = 1.0 + (0.05 * (1 + (0.5 * staggeredProgress).clamp(0.0, 1.0)));
        
        return StoneTouchDetector(
          onStoneTouch: (touchType, location) => _handleQuickTouch(stone),
          onStoneDetails: () => _showStoneDetails(stone),
          isReceiving: stone.isReceivingComfort,
          isSending: stone.isSendingComfort,
          rippleColor: stone.stoneType.rippleColor,
          child: Transform.scale(
            scale: stone.isReceivingComfort ? 1.0 : breatheScale,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: stone.stoneType.gradient,
                shape: BoxShape.circle,
                boxShadow: stone.isReceivingComfort 
                    ? [
                        BoxShadow(
                          color: stone.stoneType.glowColor,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    stone.stoneType.emoji,
                    key: ValueKey('${stone.id}_${stone.stoneType.emoji}'),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).then(
      delay: Duration(milliseconds: index * 200),
    ).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    ).fadeIn();
  }

  Future<void> _handleQuickTouch(ConnectionStone stone) async {
    // Play haptic feedback
    await HapticFeedbackService.instance.playQuickTouch();
    
    // Send comfort through the stone
    await ref.read(connectionStonesProvider.notifier)
        .touchStone(stone.id, TouchType.quickTouch);
    
    // Show quick feedback
    if (mounted) {
      _showQuickTouchFeedback(stone);
    }
  }

  void _showQuickTouchFeedback(ConnectionStone stone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(stone.stoneType.emoji),
            const SizedBox(width: AppDimensions.spacingS),
            Expanded(
              child: Text(
                'Quick comfort sent to ${stone.friendName}! 💕',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: stone.stoneType.primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(AppDimensions.spacingM),
      ),
    );
  }

  void _showStoneDetails(ConnectionStone stone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickStoneDetailsModal(stone: stone),
    );
  }
}

/// Modal showing quick stone details
class QuickStoneDetailsModal extends ConsumerWidget {
  final ConnectionStone stone;

  const QuickStoneDetailsModal({
    super.key,
    required this.stone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            
            // Stone visual
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: stone.stoneType.gradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stone.stoneType.emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            // Stone name and friend
            Text(
              stone.name,
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacingS),
            
            Text(
              'Connected to ${stone.friendName}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat(
                  label: 'Touches',
                  value: stone.totalTouches.toString(),
                  color: AppColors.sageGreen,
                ),
                _buildQuickStat(
                  label: 'Received',
                  value: stone.totalComfortReceived.toString(),
                  color: AppColors.warmPeach,
                ),
                _buildQuickStat(
                  label: 'Connection',
                  value: stone.connectionStrengthDisplay,
                  color: AppColors.cloudBlue,
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _sendComfort(context, ref);
                    },
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite, size: 18),
                        const SizedBox(width: AppDimensions.spacingS),
                        Text(
                          'Send Comfort',
                          style: AppTextStyles.button,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: AppDimensions.spacingM),
                
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: stone.stoneType.primaryColor),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacingM,
                      horizontal: AppDimensions.spacingL,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.button.copyWith(
                      color: stone.stoneType.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
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

  Widget _buildQuickStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
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

  Future<void> _sendComfort(BuildContext context, WidgetRef ref) async {
    await HapticFeedbackService.instance.playStoneTouch(
      stone.stoneType,
      TouchType.longPress,
    );
    
    await ref.read(connectionStonesProvider.notifier)
        .touchStone(stone.id, TouchType.longPress);
        
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${stone.stoneType.emoji} Deep comfort sent to ${stone.friendName}! 💕',
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
}