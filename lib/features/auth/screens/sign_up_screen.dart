import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/network/api_result.dart';
import '../../../routing/app_router.dart';
import '../../../shared/widgets/layouts/ft_auth_scaffold.dart';
import '../../../shared/widgets/forms/ft_form_header.dart';
import '../../../shared/widgets/forms/ft_social_login_section.dart';
import '../widgets/sign_up/sign_up_form.dart';
import '../providers/auth_provider.dart';

/// Future Talk's Premium Sign Up Screen
/// Features comprehensive form validation, social login, and smooth animations
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> _handleSignUp({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required bool acceptTerms,
    required bool acceptPrivacy,
  }) async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();
    
    final result = await ref.read(authProvider.notifier).register(
      email: email.trim(),
      password: password,
      username: username.trim(),
      displayName: fullName.trim(),
    );

    if (mounted) {
      result.when(
        success: (registerResponse) {
          HapticFeedback.lightImpact();
          
          // Navigate to OTP verification screen
          context.goToVerifyOtp(
            email.trim(),
            message: registerResponse.message,
            expiresInMinutes: registerResponse.expiresInMinutes,
          );
        },
        failure: (error) {
          HapticFeedback.vibrate();
          String errorMessage = 'Something went wrong. Please try again.';
          
          if (error.details != null && error.details!.isNotEmpty) {
            final allErrors = error.details!.values
                .expand((list) => list)
                .join(', ');
            errorMessage = allErrors;
          } else if (error.message.isNotEmpty) {
            errorMessage = error.message;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
              ),
              backgroundColor: AppColors.dustyRose,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          );
        },
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTAuthScaffold(
      scrollController: _scrollController,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome section
          FTFormHeader(
            title: 'Join Future Talk',
            description: 'Create your account and start building meaningful connections',
          ),
          
          const SizedBox(height: AppDimensions.spacingXXXL),
          
          // Sign up form
          SignUpForm(
            onSubmit: _handleSignUp,
            isLoading: _isLoading,
          ),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          // Social login section
          FTSocialLoginSection(
            animationDelay: const Duration(milliseconds: 1300),
          ),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          // Sign in link
          _buildSignInLink(),
          
          const SizedBox(height: AppDimensions.spacingXXL),
        ],
      ),
    );
  }





  Widget _buildSignInLink() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Already have an account? ',
          style: AppTextStyles.bodyMedium,
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.goToSignIn();
                },
                child: Text(
                  'Sign In',
                  style: AppTextStyles.link,
                ),
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}