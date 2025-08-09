import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
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
  int _totalResendAttempts = 0;

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
    // First resend: 30 seconds, subsequent resends: 60 seconds
    final cooldownTime = _totalResendAttempts == 0 ? 30 : 60;
    setState(() => _resendCooldown = cooldownTime);
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
      _totalResendAttempts++;
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
          setState(() {
            _errorMessage = error.message;
            _totalResendAttempts--; // Don't count failed attempts
          });
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


  Widget _buildResendSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.whisperGray.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.whisperGray.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Didn\'t receive the code?',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          if (_resendCooldown > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingM,
              ),
              decoration: BoxDecoration(
                color: AppColors.dustyRose.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.dustyRose.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule,
                    color: AppColors.dustyRose,
                    size: AppDimensions.iconS,
                  ),
                  
                  const SizedBox(width: AppDimensions.spacingS),
                  
                  Text(
                    'Resend available in ${_formatTime(_resendCooldown)}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.dustyRose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            // Progress bar showing countdown
            LinearProgressIndicator(
              value: 1.0 - (_resendCooldown / (_totalResendAttempts == 0 ? 30.0 : 60.0)),
              backgroundColor: AppColors.whisperGray,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.dustyRose),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ] else ...[
            FTButton.primary(
              text: 'Resend Verification Code',
              onPressed: _isResendLoading ? null : _handleResendOtp,
              isLoading: _isResendLoading,
              icon: Icons.refresh,
              size: FTButtonSize.medium,
            ),
            
            if (_totalResendAttempts > 0) ...[
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Code resent ${_totalResendAttempts} time${_totalResendAttempts > 1 ? 's' : ''}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.sageGreen,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ],
      ),
    );
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds.toString().padLeft(2, '0')}s';
    }
    return '${remainingSeconds}s';
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.dustyRose.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.dustyRose.withValues(alpha: 0.3),
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
        color: AppColors.lavenderMist.withValues(alpha: 0.3),
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