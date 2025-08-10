import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../routing/app_router.dart';
import '../screens/book_library_screen.dart';

/// Demo screen showcasing the Book Library feature
/// Shows how to navigate to the library and highlights key features
class BookLibraryDemo extends StatelessWidget {
  const BookLibraryDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      appBar: AppBar(
        title: Text(
          'Book Library Demo',
          style: AppTextStyles.headlineMedium,
        ),
        backgroundColor: AppColors.sageGreen,
        foregroundColor: AppColors.pearlWhite,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature highlights
            _buildFeatureCard(
              title: 'Premium Book Library',
              description: 'Discover your perfect reading sanctuary with AI-powered recommendations, social reading features, and mood-based book selection.',
              features: [
                '🤖 AI-powered personalized recommendations',
                '📊 Reading statistics and progress tracking',
                '👥 Social reading with friends',
                '😌 Mood-based book suggestions',
                '📚 Premium and free book collections',
                '🎨 Beautiful magazine-style layout',
              ],
            ),

            const SizedBox(height: AppDimensions.spacingXXL),

            // Navigation buttons
            _buildNavigationSection(context),

            const Spacer(),

            // Quick preview
            _buildPreviewSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required List<String> features,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.featureHeading.copyWith(
              fontFamily: AppTextStyles.headingFont,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
            child: Text(
              feature,
              style: AppTextStyles.bodyMedium,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try it out',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        
        // Primary navigation button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate using the router
              context.goToBooks();
            },
            icon: const Text('📚', style: TextStyle(fontSize: 20)),
            label: const Text('Open Book Library'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sageGreen,
              foregroundColor: AppColors.pearlWhite,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingL,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // Direct widget demo button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BookLibraryScreen(),
                ),
              );
            },
            icon: const Text('🎨', style: TextStyle(fontSize: 16)),
            label: const Text('View Widget Demo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.sageGreen,
              side: const BorderSide(color: AppColors.sageGreen),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingL,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Text(
            '✨ Premium Reading Experience',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.pearlWhite,
              fontFamily: AppTextStyles.headingFont,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Built with Flutter\'s premium animation system, responsive design patterns, and introvert-friendly user experience principles.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.pearlWhite.withAlpha(230),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// How to use the Book Library in your app:
/// 
/// 1. Navigate using the router:
///    ```dart
///    context.goToBooks(); // Using the extension method
///    context.go('/books'); // Direct route
///    ```
/// 
/// 2. Use the widget directly:
///    ```dart
///    Navigator.push(context, MaterialPageRoute(
///      builder: (context) => const BookLibraryScreen(),
///    ));
///    ```
/// 
/// 3. Integration with Riverpod:
///    The BookLibraryProvider automatically manages state and can be 
///    used across multiple screens for consistent book data.
/// 
/// 4. Customization:
///    - Modify book data in BookLibraryProvider
///    - Adjust animations in individual widget files
///    - Update color scheme in app_colors.dart
///    - Change fonts in app_text_styles.dart