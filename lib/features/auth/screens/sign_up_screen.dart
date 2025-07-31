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

/// Future Talk's Premium Sign Up Screen
/// Features comprehensive form validation, social login, and smooth animations
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Focus nodes
  final _fullNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  
  // Form state
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  String? _fullNameError;
  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  
  // Password strength
  int _passwordStrength = 0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = AppColors.stoneGray;

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
    _fullNameController.addListener(_validateFullName);
    _emailController.addListener(_validateEmail);
    _usernameController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _scrollController.dispose();
    
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    
    _fadeController.dispose();
    _slideController.dispose();
    
    super.dispose();
  }

  // Validation methods
  void _validateFullName() {
    final value = _fullNameController.text;
    setState(() {
      if (value.isEmpty) {
        _fullNameError = null;
      } else if (value.length < 2) {
        _fullNameError = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _fullNameError = 'Name can only contain letters and spaces';
      } else {
        _fullNameError = null;
      }
    });
  }

  void _validateEmail() {
    final value = _emailController.text;
    setState(() {
      if (value.isEmpty) {
        _emailError = null;
      } else {
        _emailError = FTInputValidators.email(value);
      }
    });
  }

  void _validateUsername() {
    final value = _usernameController.text;
    setState(() {
      if (value.isEmpty) {
        _usernameError = null;
      } else if (value.length < 3) {
        _usernameError = 'Username must be at least 3 characters';
      } else if (value.length > 20) {
        _usernameError = 'Username cannot exceed 20 characters';
      } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
        _usernameError = 'Username can only contain letters, numbers, and underscores';
      } else {
        _usernameError = null;
      }
    });
  }

  void _validatePassword() {
    final value = _passwordController.text;
    setState(() {
      if (value.isEmpty) {
        _passwordError = null;
        _passwordStrength = 0;
        _passwordStrengthText = '';
        _passwordStrengthColor = AppColors.stoneGray;
      } else {
        _passwordError = FTInputValidators.password(value);
        _updatePasswordStrength(value);
      }
    });
  }

  void _validateConfirmPassword() {
    final value = _confirmPasswordController.text;
    final password = _passwordController.text;
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = null;
      } else if (value != password) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _updatePasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    
    _passwordStrength = strength;
    
    switch (strength) {
      case 0:
      case 1:
        _passwordStrengthText = 'Very Weak';
        _passwordStrengthColor = AppColors.dustyRose;
        break;
      case 2:
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = AppColors.dustyRose;
        break;
      case 3:
        _passwordStrengthText = 'Fair';
        _passwordStrengthColor = AppColors.warmPeach;
        break;
      case 4:
        _passwordStrengthText = 'Good';
        _passwordStrengthColor = AppColors.cloudBlue;
        break;
      case 5:
        _passwordStrengthText = 'Strong';
        _passwordStrengthColor = AppColors.sageGreen;
        break;
    }
  }

  bool get _isFormValid {
    return _fullNameError == null &&
           _emailError == null &&
           _usernameError == null &&
           _passwordError == null &&
           _confirmPasswordError == null &&
           _fullNameController.text.isNotEmpty &&
           _emailController.text.isNotEmpty &&
           _usernameController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty &&
           _confirmPasswordController.text.isNotEmpty &&
           _acceptTerms &&
           _acceptPrivacy;
  }

  Future<void> _handleSignUp() async {
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
              'Welcome to Future Talk! Check your email to verify your account.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pearlWhite),
            ),
            backgroundColor: AppColors.sageGreen,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
        
        // Navigate to sign in
        context.goToSignIn();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Something went wrong. Please try again.',
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
                    
                    // Sign up form
                    _buildSignUpForm(),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                    
                    // Social login section
                    _buildSocialLoginSection(),
                    
                    const SizedBox(height: AppDimensions.spacingXXL),
                    
                    // Sign in link
                    _buildSignInLink(),
                    
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
          'Join Future Talk',
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
          'Create your account and start building meaningful connections',
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

  Widget _buildSignUpForm() {
    return FTCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name field
            FTInput(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _fullNameController,
              focusNode: _fullNameFocus,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              errorText: _fullNameError,
              onSubmitted: (_) => _emailFocus.requestFocus(),
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
            
            // Email field
            FTInput.email(
              controller: _emailController,
              focusNode: _emailFocus,
              errorText: _emailError,
              onSubmitted: (_) => _usernameFocus.requestFocus(),
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
            
            const SizedBox(height: AppDimensions.formFieldSpacing),
            
            // Username field
            FTInput(
              label: 'Username',
              hint: 'Choose a unique username',
              controller: _usernameController,
              focusNode: _usernameFocus,
              prefixIcon: Icons.alternate_email,
              textInputAction: TextInputAction.next,
              errorText: _usernameError,
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 800),
                )
                .slideX(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                ),
            
            const SizedBox(height: AppDimensions.formFieldSpacing),
            
            // Password field
            FTInput.password(
              controller: _passwordController,
              focusNode: _passwordFocus,
              errorText: _passwordError,
              onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 900),
                )
                .slideX(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                ),
            
            // Password strength indicator
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingS),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: AppColors.whisperGray,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _passwordStrength / 5.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _passwordStrengthColor,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    _passwordStrengthText,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _passwordStrengthColor,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: AppDimensions.formFieldSpacing),
            
            // Confirm Password field
            FTInput(
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              errorText: _confirmPasswordError,
              onSubmitted: (_) => _handleSignUp(),
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1000),
                )
                .slideX(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                ),
            
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Terms and Privacy checkboxes
            _buildAgreementSection(),
            
            const SizedBox(height: AppDimensions.spacingXXL),
            
            // Sign Up button
            FTButton.primary(
              text: 'Create Account',
              onPressed: _isFormValid ? _handleSignUp : null,
              isLoading: _isLoading,
              icon: Icons.person_add,
              iconPosition: FTButtonIconPosition.right,
            )
                .animate()
                .fadeIn(
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1200),
                )
                .slideY(
                  begin: 0.2,
                  end: 0.0,
                  duration: AppDurations.medium,
                  delay: Duration(milliseconds: 1200),
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

  Widget _buildAgreementSection() {
    return Column(
      children: [
        // Terms checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() => _acceptTerms = value ?? false);
                HapticFeedback.selectionClick();
              },
              activeColor: AppColors.sageGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _acceptTerms = !_acceptTerms);
                  HapticFeedback.selectionClick();
                },
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: AppTextStyles.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: AppTextStyles.link,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Privacy checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptPrivacy,
              onChanged: (value) {
                setState(() => _acceptPrivacy = value ?? false);
                HapticFeedback.selectionClick();
              },
              activeColor: AppColors.sageGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => _acceptPrivacy = !_acceptPrivacy);
                  HapticFeedback.selectionClick();
                },
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: AppTextStyles.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.link,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
          delay: Duration(milliseconds: 1300),
        )
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1300),
          curve: Curves.easeOutCubic,
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
    )
        .animate()
        .fadeIn(
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1400),
        )
        .slideY(
          begin: 0.2,
          end: 0.0,
          duration: AppDurations.medium,
          delay: Duration(milliseconds: 1400),
          curve: Curves.easeOutCubic,
        );
  }
}