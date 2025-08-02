import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_card.dart';
import '../models/notification_model.dart';

/// Premium notification card with rich animations and interactions
class NotificationCard extends StatefulWidget {
  /// The notification to display
  final FTNotification notification;
  
  /// Callback when notification is tapped
  final VoidCallback? onTap;
  
  /// Callback when action button is tapped
  final Function(NotificationAction action)? onActionTap;
  
  /// Whether this notification has focus for accessibility
  final bool hasFocus;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onActionTap,
    this.hasFocus = false,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _rippleController;
  late Animation<double> _slideAnimation;
  late Animation<double> _rippleAnimation;
  

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
    
    // Start entrance animation
    Future.delayed(Duration(milliseconds: 50 * (widget.notification.hashCode % 5)), () {
      if (mounted) {
        _slideController.forward();
      }
    });
    
    // Start ripple animation for connection stones
    if (widget.notification.type == NotificationType.connectionStone && !widget.notification.isRead) {
      _startRippleAnimation();
    }
  }

  void _startRippleAnimation() async {
    while (mounted && !widget.notification.isRead) {
      await _rippleController.forward();
      await Future.delayed(const Duration(milliseconds: 1000));
      _rippleController.reset();
      await Future.delayed(const Duration(milliseconds: 2000));
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  Color _getTypeColor() {
    switch (widget.notification.type) {
      case NotificationType.timeCapsule:
        return AppColors.lavenderMist;
      case NotificationType.connectionStone:
        return AppColors.dustyRose;
      case NotificationType.reading:
        return AppColors.warmPeach;
      case NotificationType.social:
        return AppColors.cloudBlue;
      case NotificationType.system:
        return AppColors.sageGreen;
      case NotificationType.friend:
        return AppColors.sageGreen;
    }
  }

  String _getNotificationIcon() {
    return widget.notification.icon ?? widget.notification.type.icon;
  }

  String _formatTimestamp() {
    final now = DateTime.now();
    final difference = now.difference(widget.notification.timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${difference.inDays ~/ 7}w ago';
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  void _handleActionTap(NotificationAction action) {
    HapticFeedback.selectionClick();
    widget.onActionTap?.call(action);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(
            opacity: (_slideAnimation.value + 50) / 50,
            child: _buildCard(),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return Stack(
      children: [
        // Ripple effect for connection stones
        if (widget.notification.type == NotificationType.connectionStone && !widget.notification.isRead)
          _buildRippleEffect(),
        
        // Main card
        FTCard(
          onTap: _handleTap,
          margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          backgroundColor: widget.notification.isRead 
              ? AppColors.pearlWhite 
              : _getTypeColor().withValues(alpha: 0.03),
          child: _buildCardContent(),
        ),
        
        // Unread indicator
        if (!widget.notification.isRead)
          Positioned(
            top: AppDimensions.spacingM,
            right: AppDimensions.spacingM,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _getTypeColor(),
                shape: BoxShape.circle,
              ),
            ),
          ),
        
        // Left accent border
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 4,
            decoration: BoxDecoration(
              color: widget.notification.isRead 
                  ? Colors.transparent 
                  : _getTypeColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusL),
                bottomLeft: Radius.circular(AppDimensions.radiusL),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRippleEffect() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _rippleAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: CustomPaint(
              painter: RipplePainter(
                progress: _rippleAnimation.value,
                color: _getTypeColor().withValues(alpha: 0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppDimensions.spacingS),
        _buildMessage(),
        if (widget.notification.previewText != null) ...[
          const SizedBox(height: AppDimensions.spacingS),
          _buildPreview(),
        ],
        const SizedBox(height: AppDimensions.spacingM),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Icon or avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getTypeColor(),
                _getTypeColor().withValues(alpha: 0.7),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: widget.notification.fromUserName != null
                ? Text(
                    widget.notification.fromUserName![0].toUpperCase(),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.pearlWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    _getNotificationIcon(),
                    style: const TextStyle(fontSize: 18),
                  ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        
        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.notification.title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: widget.notification.isRead ? FontWeight.w400 : FontWeight.w600,
                  color: widget.notification.isRead 
                      ? AppColors.softCharcoalLight 
                      : AppColors.softCharcoal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    return Text(
      widget.notification.message,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.softCharcoalLight,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border(
          left: BorderSide(
            color: _getTypeColor(),
            width: 2,
          ),
        ),
      ),
      child: Text(
        widget.notification.previewText!,
        style: AppTextStyles.personalContent.copyWith(
          fontSize: 12,
          color: AppColors.softCharcoal,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Timestamp
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 12,
              color: AppColors.softCharcoalLight,
            ),
            const SizedBox(width: 4),
            Text(
              _formatTimestamp(),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.softCharcoalLight,
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // Action buttons
        if (widget.notification.actions.isNotEmpty) ...[
          ..._buildActionButtons(),
        ],
      ],
    );
  }

  List<Widget> _buildActionButtons() {
    return widget.notification.actions.map((action) {
      final isPrimary = action.type == NotificationActionType.primary;
      
      return Padding(
        padding: const EdgeInsets.only(left: AppDimensions.spacingS),
        child: InkWell(
          onTap: () => _handleActionTap(action),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingXS,
            ),
            decoration: BoxDecoration(
              color: isPrimary 
                  ? _getTypeColor().withValues(alpha: 0.1)
                  : AppColors.whisperGray,
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Text(
              action.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isPrimary ? _getTypeColor() : AppColors.softCharcoalLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

/// Custom painter for ripple effect on connection stone notifications
class RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  RipplePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.4;
    final radius = maxRadius * progress;
    
    final paint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * 0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}