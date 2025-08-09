import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../routing/app_router.dart';
import '../../../shared/widgets/layouts/ft_auth_scaffold.dart';
import '../../../shared/widgets/forms/ft_form_header.dart';
import '../../../shared/widgets/forms/ft_social_login_section.dart';
import '../../../shared/widgets/ft_button.dart';
import '../../../shared/widgets/ft_input.dart';
import '../../../shared/widgets/ft_card.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../providers/auth_provider.dart';

/// Future Talk's Premium Sign In Screen
/// Features secure authentication with elegant validation and smooth animations
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Focus nodes
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  // Form state
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    
    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Validation methods
  void _validateEmail() {
    final value = _emailController.text;
    setState(() {
      if (value.isEmpty) {
        _emailError = null;
      } else {
        // More lenient validation for sign in (accept username or email)
        if (value.contains('@')) {
          _emailError = FTInputValidators.email(value);
        } else if (value.length < 3) {
          _emailError = 'Username must be at least 3 characters';
        } else {
          _emailError = null;
        }
      }
    });
  }

  void _validatePassword() {
    setState(() {
      // For sign in, we don't need complex password validation
      _passwordError = null;
    });
  }

  bool get _isFormValid {
    return _emailError == null &&
           _passwordError == null &&
           _emailController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty;
  }

  Future<void> _handleSignIn() async {
    if (!_isFormValid) return;
    
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();
    
    final result = await ref.read(authProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      result.when(
        success: (authResponse) {
          final userName = authResponse.user.displayName ?? 
                          authResponse.user.firstName ?? 
                          authResponse.user.username;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Welcome back, $userName! Navigating to your sanctuary...',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
              ),
              backgroundColor: AppColors.sageGreen,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          );
          
          context.goToDashboard();
        },
        failure: (error) {
          String errorMessage = 'Invalid credentials. Please check your email and password.';
          
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
              duration: const Duration(seconds: 3),
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

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();
    
    final emailController = TextEditingController();
    bool isLoading = false;
    
    // Show forgot password dialog
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.warmCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          title: Text(
            'Reset Password',
            style: AppTextStyles.headlineMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              FTInput.email(
                controller: emailController,
                hint: 'Enter your email',
                label: 'Email Address',
              ),
            ],
          ),
          actions: [
            FTButton.text(
              text: 'Cancel',
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
            ),
            FTButton.primary(
              text: 'Send Reset Link',
              isLoading: isLoading,
              onPressed: isLoading ? null : () async {
                if (emailController.text.trim().isEmpty) return;
                
                setDialogState(() => isLoading = true);
                
                final result = await ref.read(authProvider.notifier)
                    .requestPasswordReset(emailController.text.trim());
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  
                  result.when(
                    success: (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password reset link sent to your email!',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
                          ),
                          backgroundColor: AppColors.sageGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                        ),
                      );
                    },
                    failure: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.message,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
                          ),
                          backgroundColor: AppColors.dustyRose,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FTAuthScaffold(
      scrollController: _scrollController,
      onBackPressed: () => context.goToOnboarding(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome section
          FTFormHeader(
            title: 'Welcome Back',
            description: 'Sign in to continue your mindful communication journey',
          ),
          
          const SizedBox(height: AppDimensions.spacingXXXL),
          
          // Sign in form
          _buildSignInForm(),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          // Social login section
          FTSocialLoginSection(
            animationDelay: const Duration(milliseconds: 1000),
          ),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          // Sign up link
          _buildSignUpLink(),
          
          const SizedBox(height: AppDimensions.spacingXXL),
        ],
      ),
    );
  }


  Widget _buildSignInForm() {
    return FTStaggerAnimation(
      delay: const Duration(milliseconds: 500),
      child: FTCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email/Username field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 600),
                child: FTInput(
                  label: 'Email or Username',
                  hint: 'Enter your email or username',
                  controller: _emailController,
                  focusNode: _emailFocus,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  errorText: _emailError,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
              ),
              
              const SizedBox(height: AppDimensions.formFieldSpacing),
              
              // Password field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 700),
                child: FTInput.password(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  errorText: _passwordError,
                  onSubmitted: (_) => _handleSignIn(),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingL),
              
              // Remember me and forgot password row
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 800),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() => _rememberMe = value ?? false);
                            HapticFeedback.selectionClick();
                          },
                          activeColor: AppColors.sageGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => _rememberMe = !_rememberMe);
                            HapticFeedback.selectionClick();
                          },
                          child: Text(
                            'Remember me',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    
                    // Forgot password link
                    GestureDetector(
                      onTap: _handleForgotPassword,
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.link,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingXXL),
              
              // Sign In button
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 900),
                child: FTButton.primary(
                  text: 'Sign In',
                  onPressed: _isFormValid ? _handleSignIn : null,
                  isLoading: _isLoading,
                  icon: Icons.login,
                  iconPosition: FTButtonIconPosition.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSignUpLink() {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Don\'t have an account? ',
          style: AppTextStyles.bodyMedium,
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.goToSignUp();
                },
                child: Text(
                  'Sign Up',
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