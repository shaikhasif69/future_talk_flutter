import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../layouts/ft_scaffold_with_nav.dart';
import '../../providers/navigation_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// Example implementation showing how to use the premium bottom navigation
/// This demonstrates the complete integration with navigation state management
class NavigationExampleScreen extends ConsumerWidget {
  const NavigationExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(navigationProvider);
    final currentItem = NavigationConfig.getItemByIndex(navigationState.selectedIndex);
    
    return FTDashboardScaffold(
      title: currentItem?.label ?? 'Future Talk',
      actions: [
        IconButton(
          icon: Icon(
            navigationState.isVisible ? Icons.visibility_off : Icons.visibility,
            color: AppColors.softCharcoal,
          ),
          onPressed: () {
            ref.read(navigationProvider.notifier)
                .setNavigationVisibility(!navigationState.isVisible);
          },
        ),
      ],
      body: _buildExampleContent(context, ref, navigationState),
    );
  }

  Widget _buildExampleContent(
    BuildContext context, 
    WidgetRef ref, 
    NavigationState navigationState,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNavigationStatusCard(navigationState),
            
            const SizedBox(height: AppDimensions.spacingXXL),
            
            _buildNavigationControlCard(context, ref),
            
            const SizedBox(height: AppDimensions.spacingXXL),
            
            _buildAnimationDemoCard(),
            
            const SizedBox(height: AppDimensions.spacingXXL),
            
            _buildNavigationHistoryCard(navigationState),
            
            const SizedBox(height: AppDimensions.spacingHuge), // Extra space for nav
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationStatusCard(NavigationState navigationState) {
    return Card(
      elevation: 4,
      color: AppColors.pearlWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.sageGreen,
                  size: AppDimensions.iconM,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Navigation Status',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.softCharcoal,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            _buildStatusRow('Selected Tab', '${navigationState.selectedIndex}'),
            _buildStatusRow('Previous Tab', '${navigationState.previousIndex}'),
            _buildStatusRow('Is Animating', '${navigationState.isAnimating}'),
            _buildStatusRow('Is Visible', '${navigationState.isVisible}'),
            _buildStatusRow('History Length', '${navigationState.navigationHistory.length}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.sageGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControlCard(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      color: AppColors.pearlWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: AppColors.lavenderMist,
                  size: AppDimensions.iconM,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Navigation Controls',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.softCharcoal,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            Text(
              'Navigate directly to any tab:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            Wrap(
              spacing: AppDimensions.spacingS,
              runSpacing: AppDimensions.spacingS,
              children: List.generate(
                NavigationConfig.mainNavigation.length,
                (index) => _buildNavigationButton(context, ref, index),
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(navigationProvider.notifier).navigateBack(
                        context: context,
                      );
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dustyRose,
                      foregroundColor: AppColors.pearlWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppDimensions.spacingM),
                
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(navigationProvider.notifier).resetNavigation();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warmPeach,
                      foregroundColor: AppColors.softCharcoal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, WidgetRef ref, int index) {
    final item = NavigationConfig.mainNavigation[index];
    final isSelected = ref.watch(selectedIndexProvider) == index;
    
    return ElevatedButton.icon(
      onPressed: () {
        NavigationHelpers.smartNavigate(ref, index, context: context);
      },
      icon: Icon(
        isSelected ? item.activeIcon : item.icon,
        size: 16,
      ),
      label: Text(
        item.label.split(' ').first, // Short name
        style: const TextStyle(fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
          ? AppColors.sageGreen 
          : AppColors.whisperGray,
        foregroundColor: isSelected 
          ? AppColors.pearlWhite 
          : AppColors.softCharcoal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        elevation: isSelected ? 4 : 1,
      ),
    );
  }

  Widget _buildAnimationDemoCard() {
    return Card(
      elevation: 4,
      color: AppColors.pearlWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.animation_rounded,
                  color: AppColors.warmPeach,
                  size: AppDimensions.iconM,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Animation Features',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.softCharcoal,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            _buildFeatureRow('🌊', 'Liquid blob indicator with morphing animation'),
            _buildFeatureRow('✨', 'Floating particles with organic motion'),
            _buildFeatureRow('🏮', 'Glassmorphism with backdrop blur effects'),
            _buildFeatureRow('🎯', 'Smooth tab transitions with elastic curves'),
            _buildFeatureRow('💫', 'Ripple effects on tap with custom colors'),
            _buildFeatureRow('🎨', 'Icon morphing between active/inactive states'),
            _buildFeatureRow('📱', 'Responsive design for all screen sizes'),
            _buildFeatureRow('🔥', 'Premium shadow animations that follow movement'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String emoji, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationHistoryCard(NavigationState navigationState) {
    return Card(
      elevation: 4,
      color: AppColors.pearlWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: AppColors.cloudBlue,
                  size: AppDimensions.iconM,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Navigation History',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.softCharcoal,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            if (navigationState.navigationHistory.isEmpty) ...[
              Text(
                'No navigation history yet',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.softCharcoalLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ] else ...[
              ...navigationState.navigationHistory.asMap().entries.map(
                (entry) {
                  final index = entry.key;
                  final tabIndex = entry.value;
                  final item = NavigationConfig.getItemByIndex(tabIndex);
                  final isCurrent = index == navigationState.navigationHistory.length - 1;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    decoration: BoxDecoration(
                      color: isCurrent 
                        ? AppColors.sageGreen.withAlpha(26)
                        : AppColors.whisperGray,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      border: isCurrent ? Border.all(
                        color: AppColors.sageGreen.withAlpha(77),
                        width: 1,
                      ) : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item?.icon ?? Icons.help_outline,
                          size: AppDimensions.iconS,
                          color: isCurrent 
                            ? AppColors.sageGreen
                            : AppColors.softCharcoalLight,
                        ),
                        const SizedBox(width: AppDimensions.spacingS),
                        Expanded(
                          child: Text(
                            item?.label ?? 'Unknown',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isCurrent 
                                ? AppColors.sageGreen
                                : AppColors.softCharcoalLight,
                              fontWeight: isCurrent 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isCurrent) 
                          Icon(
                            Icons.star_rounded,
                            size: AppDimensions.iconXS,
                            color: AppColors.sageGreen,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}