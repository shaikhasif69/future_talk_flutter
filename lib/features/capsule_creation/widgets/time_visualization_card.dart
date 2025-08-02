import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/time_capsule_creation_provider.dart';

/// Premium time visualization card with animated metaphors
/// Shows current time selection with beautiful animations matching the HTML design
class TimeVisualizationCard extends ConsumerStatefulWidget {
  const TimeVisualizationCard({super.key});

  @override
  ConsumerState<TimeVisualizationCard> createState() => _TimeVisualizationCardState();
}

class _TimeVisualizationCardState extends ConsumerState<TimeVisualizationCard>
    with TickerProviderStateMixin {
  late AnimationController _metaphorController;
  late AnimationController _floatingController;
  late Animation<double> _metaphorScale;
  late Animation<double> _metaphorOpacity;
  late Animation<Offset> _floatingOffset;
  late Animation<double> _floatingScale;

  String _currentMetaphor = '🌰';

  @override
  void initState() {
    super.initState();
    
    // Metaphor change animation
    _metaphorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Floating background animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    
    _metaphorScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _metaphorController,
      curve: Curves.easeOut,
    ));
    
    _metaphorOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _metaphorController,
      curve: Curves.easeOut,
    ));
    
    _floatingOffset = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-10, 10),
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _floatingScale = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    _metaphorController.forward();
  }

  @override
  void dispose() {
    _metaphorController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _updateMetaphor(String newMetaphor) {
    if (newMetaphor != _currentMetaphor) {
      _metaphorController.reverse().then((_) {
        setState(() {
          _currentMetaphor = newMetaphor;
        });
        _metaphorController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeMetaphor = ref.watch(timeMetaphorProvider);
    final timeDisplay = ref.watch(timeDisplayProvider);
    final timeDescription = ref.watch(timeDescriptionProvider);
    final growthStage = ref.watch(growthStageProvider);
    final animationClass = ref.watch(currentAnimationClassProvider);

    // Update metaphor when it changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMetaphor(timeMetaphor);
    });

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingXXXL),
      padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF7F5F3), // Matching HTML warmCream
            AppColors.pearlWhite,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Floating background animation
          Positioned(
            top: -50,
            right: -50,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                return Transform.translate(
                  offset: _floatingOffset.value,
                  child: Transform.scale(
                    scale: _floatingScale.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.sageGreenWithOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.7],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Main content
          Column(
            children: [
              // Animated metaphor
              AnimatedBuilder(
                animation: _metaphorController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _metaphorScale.value,
                    child: Opacity(
                      opacity: _metaphorOpacity.value,
                      child: _buildAnimatedMetaphor(animationClass),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.spacingS),
              
              // Time display with animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  timeDisplay,
                  key: ValueKey(timeDisplay),
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    color: AppColors.sageGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingS),
              
              // Time description with animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  timeDescription,
                  key: ValueKey(timeDescription),
                  style: AppTextStyles.timeCapsulePreview.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingM),
              
              // Growth stage with animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(growthStage),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreenWithOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    growthStage.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.sageGreen,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMetaphor(String animationClass) {
    Widget metaphorWidget = Text(
      _currentMetaphor,
      style: const TextStyle(fontSize: 48),
    );

    // Add specific animations based on the animation class
    switch (animationClass) {
      case 'seed-growing':
        return _SeedGrowingAnimation(child: metaphorWidget);
      case 'tree-swaying':
        return _TreeSwayingAnimation(child: metaphorWidget);
      case 'crystal-forming':
        return _CrystalFormingAnimation(child: metaphorWidget);
      default:
        return _SeedGrowingAnimation(child: metaphorWidget);
    }
  }
}

/// Seed growing animation (for short time periods)
class _SeedGrowingAnimation extends StatefulWidget {
  final Widget child;

  const _SeedGrowingAnimation({required this.child});

  @override
  State<_SeedGrowingAnimation> createState() => _SeedGrowingAnimationState();
}

class _SeedGrowingAnimationState extends State<_SeedGrowingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Tree swaying animation (for medium time periods)
class _TreeSwayingAnimation extends StatefulWidget {
  final Widget child;

  const _TreeSwayingAnimation({required this.child});

  @override
  State<_TreeSwayingAnimation> createState() => _TreeSwayingAnimationState();
}

class _TreeSwayingAnimationState extends State<_TreeSwayingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _swayAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _swayAnimation = Tween<double>(
      begin: -0.02, // -1 degree in radians
      end: 0.02,    // 1 degree in radians
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _swayAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// Crystal forming animation (for long time periods)
class _CrystalFormingAnimation extends StatefulWidget {
  final Widget child;

  const _CrystalFormingAnimation({required this.child});

  @override
  State<_CrystalFormingAnimation> createState() => _CrystalFormingAnimationState();
}

class _CrystalFormingAnimationState extends State<_CrystalFormingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _brightnessAnimation;
  late Animation<double> _saturationAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _brightnessAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _saturationAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.matrix([
            _brightnessAnimation.value * _saturationAnimation.value, 0, 0, 0, 0,
            0, _brightnessAnimation.value * _saturationAnimation.value, 0, 0, 0,
            0, 0, _brightnessAnimation.value * _saturationAnimation.value, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: widget.child,
        );
      },
    );
  }
}