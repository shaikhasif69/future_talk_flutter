import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/ft_button.dart';
import '../../../shared/widgets/ft_input.dart';
import '../../../shared/widgets/ft_card.dart';
import '../../../routing/app_router.dart';

/// Future Talk's Premium Sign In Screen
/// Features secure authentication with elegant validation and smooth animations
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Focus nodes
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  
  // Form state
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Add listeners for real-time validation
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _scrollController.dispose();
    
    _emailController.dispose();
    _passwordController.dispose();
    
    _emailFocus.dispose();
    _passwordFocus.dispose();
    
    _fadeController.dispose();
    _slideController.dispose();
    
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
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back! Navigating to your sanctuary...',
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
        
        // Navigate to dashboard
        context.goToDashboard();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid credentials. Please check your email and password.',
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
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();
    
    // Show forgot password dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              hint: 'Enter your email',
              label: 'Email Address',
            ),
          ],
        ),
        actions: [
          FTButton.text(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          FTButton.primary(
            text: 'Send Reset Link',
            onPressed: () {
              Navigator.of(context).pop();
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            _buildHeader(),
            
            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppDimensions.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome section
                    _buildWelcomeSection(),
                    
                    const SizedBox(height: AppDimensions.spacingXXXL),
                    
                    // Sign in form
                    _buildSignInForm(),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                    
                    // Social login section
                    _buildSocialLoginSection(),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                    
                    // Sign up link
                    _buildSignUpLink(),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      child: Row(
        children: [
          FTButton.text(
            text: 'Back',
            onPressed: () => Navigator.of(context).pop(),
            icon: Icons.arrow_back,
            size: FTButtonSize.small,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.medium)
        .slideY(
          begin: -0.2,
          end: 0.0,
          duration: AppDurations.medium,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        // Logo
        Container(
          width: AppDimensions.logoMedium,
          height: AppDimensions.logoMedium,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 12.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.message_rounded,
            color: AppColors.pearlWhite,
            size: 40.0,
          ),
        )
            .animate()
            .scale(
              duration: AppDurations.slow,
              curve: Curves.elasticOut,
            )
            .shimmer(
              duration: Duration(milliseconds: 1500),
              color: AppColors.pearlWhite.withValues(alpha: 0.3),
            ),
        
        const SizedBox(height: AppDimensions.spacingXL),
        
        Text(
          'Welcome Back',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(
              duration: AppDurations.medium,
              delay: Duration(milliseconds: 200),
            )
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: AppDurations.medium,
              delay: Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
            ),
        
        const SizedBox(height: AppDimensions.spacingM),
        
        Text(
          'Sign in to continue your mindful communication journey',
          style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(
              duration: AppDurations.medium,
              delay: Duration(milliseconds: 400),
            )
            .slideY(
              begin: 0.3,
              end: 0.0,
              duration: AppDurations.medium,
              delay: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }

  Widget _buildSignInForm() {
    return FTCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email/Username field
            FTInput(
              label: 'Email or Username',
              hint: 'Enter your email or username',
              controller: _emailController,
              focusNode: _emailFocus,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              errorText: _emailError,
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 600),
                )
                .slideX(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                ),
            
            const SizedBox(height: AppDimensions.formFieldSpacing),
            
            // Password field
            FTInput.password(
              controller: _passwordController,
              focusNode: _passwordFocus,
              errorText: _passwordError,
              onSubmitted: (_) => _handleSignIn(),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 700),
                )
                .slideX(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Remember me and forgot password row
            Row(
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
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 800),
                )
                .slideY(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                ),
            
            const SizedBox(height: AppDimensions.spacingXXL),
            
            // Sign In button
            FTButton.primary(
              text: 'Sign In',
              onPressed: _isFormValid ? _handleSignIn : null,
              isLoading: _isLoading,
              icon: Icons.login,
              iconPosition: FTButtonIconPosition.right,
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 900),
                )
                .slideY(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: AppDurations.slow,
          delay: Duration(milliseconds: 500),
        )
        .slideY(
          begin: 0.1,
          end: 0.0,
          duration: AppDurations.slow,
          delay: Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        // Divider with "or"
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.whisperGray)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
              child: Text(
                'or continue with',
                style: AppTextStyles.labelMedium,
              ),
            ),
            const Expanded(child: Divider(color: AppColors.whisperGray)),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingXL),
        
        // Social login buttons
        Row(
          children: [
            Expanded(
              child: FTButton.outlined(
                text: 'Google',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  // TODO: Implement Google login
                },
                icon: Icons.g_mobiledata,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: FTButton.outlined(
                text: 'Apple',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  // TODO: Implement Apple login
                },
                icon: Icons.apple,
              ),
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1000),
        )
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
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
    )
        .animate()
        .fadeIn(
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1100),
        )
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
        );
  }
}