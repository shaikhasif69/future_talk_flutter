import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../ft_button.dart';
import '../animations/ft_stagger_animation.dart';

/// Reusable authentication scaffold widget
/// Provides consistent layout structure for auth screens
class FTAuthScaffold extends StatelessWidget {
  const FTAuthScaffold({
    super.key,
    required this.body,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor = AppColors.warmCream,
    this.padding,
    this.scrollable = true,
    this.scrollController,
  });

  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            if (showBackButton) _buildHeader(context),
            
            // Body content
            Expanded(
              child: scrollable ? _buildScrollableBody() : _buildStaticBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FTStaggerAnimation(
      slideDirection: FTStaggerSlideDirection.fromTop,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: AppDimensions.spacingM,
        ),
        child: Row(
          children: [
            FTButton.text(
              text: 'Back',
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              icon: Icons.arrow_back,
              size: FTButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableBody() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: padding ?? const EdgeInsets.all(AppDimensions.screenPadding),
      child: body,
    );
  }

  Widget _buildStaticBody() {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppDimensions.screenPadding),
      child: body,
    );
  }
}