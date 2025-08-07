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
import '../../../shared/widgets/ft_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp/otp_input_widget.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String? message;
  final int? expiresInMinutes;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.message,
    this.expiresInMinutes,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isResendLoading = false;
  String? _errorMessage;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    setState(() => _resendCooldown = 60);
    Future.delayed(const Duration(seconds: 1), _countdown);
  }

  void _countdown() {
    if (_resendCooldown > 0 && mounted) {
      setState(() => _resendCooldown--);
      Future.delayed(const Duration(seconds: 1), _countdown);
    }
  }

  Future<void> _handleOtpVerification(String otp) async {
    if (otp.length != 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    HapticFeedback.mediumImpact();

    final result = await ref.read(authProvider.notifier).verifyOtp(
      email: widget.email,
      otp: otp,
    );

    if (mounted) {
      result.when(
        success: (authResponse) {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Welcome to Future Talk, ${authResponse.user.displayName ?? authResponse.user.username}! 🎉',
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
          context.goToDashboard();
        },
        failure: (error) {
          HapticFeedback.vibrate();
          setState(() => _errorMessage = error.message);
          _otpController.clear();
        },
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResendOtp() async {
    if (_resendCooldown > 0) return;

    setState(() {
      _isResendLoading = true;
      _errorMessage = null;
    });
    
    HapticFeedback.selectionClick();

    final result = await ref.read(authProvider.notifier).resendOtp(widget.email);

    if (mounted) {
      result.when(
        success: (resendResponse) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'New verification code sent to your email',
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
          _startResendCooldown();
        },
        failure: (error) {
          setState(() => _errorMessage = error.message);
        },
      );
    }

    if (mounted) {
      setState(() => _isResendLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTAuthScaffold(
      scrollController: _scrollController,
      onBackPressed: () => context.goToSignUp(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FTFormHeader(
            title: 'Verify Your Email',
            description: 'We\'ve sent a 6-digit verification code to\n${widget.email}',
            logoIcon: Icons.mark_email_read_outlined,
          ),
          
          const SizedBox(height: AppDimensions.spacingXXXL),
          
          _buildOtpSection(),
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          _buildVerifyButton(),
          
          const SizedBox(height: AppDimensions.spacingXL),
          
          _buildResendSection(),
          
          if (_errorMessage != null) ...[
            const SizedBox(height: AppDimensions.spacingL),
            _buildErrorMessage(),
          ],
          
          const SizedBox(height: AppDimensions.spacingXXL),
          
          _buildHelpSection(),
        ],
      ),
    );
  }

  Widget _buildOtpSection() {
    return Column(
      children: [
        Text(
          'Enter Verification Code',
          style: AppTextStyles.titleMedium,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppDimensions.spacingL),
        
        OtpInputWidget(
          controller: _otpController,
          onCompleted: _handleOtpVerification,
          onChanged: (_) {
            if (_errorMessage != null) {
              setState(() => _errorMessage = null);
            }
          },
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return FTButton.primary(
      text: 'Verify Email',
      onPressed: _otpController.text.length == 6 && !_isLoading 
          ? () => _handleOtpVerification(_otpController.text)
          : null,
      isLoading: _isLoading,
      size: FTButtonSize.large,
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        if (_resendCooldown > 0) ...[
          Text(
            'Didn\'t receive the code?',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          Text(
            'You can request a new code in ${_resendCooldown}s',
            style: AppTextStyles.labelMedium,
            textAlign: TextAlign.center,
          ),
        ] else ...[
          Text(
            'Didn\'t receive the code?',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          FTButton.text(
            text: 'Resend Code',
            onPressed: _isResendLoading ? null : _handleResendOtp,
            isLoading: _isResendLoading,
          ),
        ],
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.dustyRose.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.dustyRose.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.dustyRose,
            size: AppDimensions.iconM,
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.dustyRose,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.lavenderMist.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.sageGreen,
                size: AppDimensions.iconM,
              ),
              
              const SizedBox(width: AppDimensions.spacingM),
              
              Expanded(
                child: Text(
                  'Tips for receiving your code:',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.sageGreen,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          _buildHelpItem('Check your spam/junk folder'),
          _buildHelpItem('Make sure you entered the correct email'),
          _buildHelpItem('Code expires in ${widget.expiresInMinutes ?? 15} minutes'),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(
              top: AppDimensions.spacingXS + 2,
              right: AppDimensions.spacingM,
            ),
            decoration: BoxDecoration(
              color: AppColors.softCharcoalLight,
              shape: BoxShape.circle,
            ),
          ),
          
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}