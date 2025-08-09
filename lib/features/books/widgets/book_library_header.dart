import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

/// Enhanced header for Book Library with social battery and search
class BookLibraryHeader extends StatefulWidget {
  final String userName;
  final String greeting;
  final String moodSuggestion;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const BookLibraryHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.moodSuggestion,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  State<BookLibraryHeader> createState() => _BookLibraryHeaderState();
}

class _BookLibraryHeaderState extends State<BookLibraryHeader>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Floating animation for decorative elements
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation for battery indicator
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.sageGreen,
            AppColors.sageGreenLight,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating decorative elements
          Positioned(
            top: -25,
            right: -25,
            child: AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatingAnimation.value),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.pearlWhite.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Floating book emoji
          Positioned(
            top: 60,
            right: 40,
            child: AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_floatingAnimation.value * 0.7),
                  child: Text(
                    '📚',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.pearlWhite.withValues(alpha: 0.6),
                    ),
                  ),
                );
              },
            ),
          ),

          // Main header content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                AppDimensions.spacingL,
                AppDimensions.screenPadding,
                AppDimensions.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with back button and social battery
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBackButton(),
                      Text(
                        'Library',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: AppColors.pearlWhite,
                          fontFamily: AppTextStyles.headingFont,
                        ),
                      ),
                      _buildSocialBatteryIndicator(),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spacingL),

                  // Personalized greeting section
                  _buildGreetingSection(),

                  const SizedBox(height: AppDimensions.spacingL),

                  // Enhanced search bar
                  _buildSearchBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).maybePop();
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.pearlWhite,
            size: 18,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.3, end: 0);
  }

  Widget _buildSocialBatteryIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.pearlWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50), // Green battery
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Green',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.pearlWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.greeting,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.pearlWhite.withValues(alpha: 0.9),
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: AppDimensions.spacingXS),
        
        Text(
          widget.moodSuggestion,
          style: AppTextStyles.personalContent.copyWith(
            color: AppColors.pearlWhite.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.softCharcoal.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.searchController,
        onChanged: widget.onSearchChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search books, authors, moods...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.softCharcoalLight,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Text(
              '🔍',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingM,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0);
  }
}