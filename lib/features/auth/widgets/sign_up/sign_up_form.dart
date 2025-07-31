import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/ft_button.dart';
import '../../../../shared/widgets/ft_input.dart';
import '../../../../shared/widgets/ft_card.dart';
import '../../../../shared/widgets/forms/ft_password_strength.dart';
import '../../../../shared/widgets/animations/ft_stagger_animation.dart';

/// Sign up form component with validation and password strength
class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  final Future<void> Function({
    required String fullName,
    required String email,
    required String username,
    required String password,
    required bool acceptTerms,
    required bool acceptPrivacy,
  }) onSubmit;
  final bool isLoading;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  
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
  
  // Form state
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  String? _fullNameError;
  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    
    // Add listeners for real-time validation
    _fullNameController.addListener(_validateFullName);
    _emailController.addListener(_validateEmail);
    _usernameController.addListener(_validateUsername);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
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
      } else {
        _passwordError = FTInputValidators.password(value);
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

  Future<void> _handleSubmit() async {
    if (!_isFormValid) return;
    
    await widget.onSubmit(
      fullName: _fullNameController.text,
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      acceptTerms: _acceptTerms,
      acceptPrivacy: _acceptPrivacy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FTStaggerAnimation(
      delay: const Duration(milliseconds: 500),
      child: FTCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 600),
                child: FTInput(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _fullNameController,
                  focusNode: _fullNameFocus,
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  errorText: _fullNameError,
                  onSubmitted: (_) => _emailFocus.requestFocus(),
                ),
              ),
              
              const SizedBox(height: AppDimensions.formFieldSpacing),
              
              // Email field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 700),
                child: FTInput.email(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  errorText: _emailError,
                  onSubmitted: (_) => _usernameFocus.requestFocus(),
                ),
              ),
              
              const SizedBox(height: AppDimensions.formFieldSpacing),
              
              // Username field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 800),
                child: FTInput(
                  label: 'Username',
                  hint: 'Choose a unique username',
                  controller: _usernameController,
                  focusNode: _usernameFocus,
                  prefixIcon: Icons.alternate_email,
                  textInputAction: TextInputAction.next,
                  errorText: _usernameError,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
              ),
              
              const SizedBox(height: AppDimensions.formFieldSpacing),
              
              // Password field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 900),
                child: FTInput.password(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  errorText: _passwordError,
                  onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                ),
              ),
              
              // Password strength indicator
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.spacingS),
                FTPasswordStrength(password: _passwordController.text),
              ],
              
              const SizedBox(height: AppDimensions.formFieldSpacing),
              
              // Confirm Password field
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 1000),
                child: FTInput(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  errorText: _confirmPasswordError,
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
              
              const SizedBox(height: AppDimensions.spacingXL),
              
              // Terms and Privacy checkboxes
              _buildAgreementSection(),
              
              const SizedBox(height: AppDimensions.spacingXXL),
              
              // Sign Up button
              FTStaggerAnimation(
                delay: const Duration(milliseconds: 1200),
                child: FTButton.primary(
                  text: 'Create Account',
                  onPressed: _isFormValid ? _handleSubmit : null,
                  isLoading: widget.isLoading,
                  icon: Icons.person_add,
                  iconPosition: FTButtonIconPosition.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementSection() {
    return FTStaggerAnimation(
      delay: const Duration(milliseconds: 1100),
      child: Column(
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
      ),
    );
  }
}