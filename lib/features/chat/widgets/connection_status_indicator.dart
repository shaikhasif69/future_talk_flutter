import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../services/websocket_service.dart';

/// Connection status indicator widget that shows WebSocket connection state
/// Displays different states with appropriate colors and animations
class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({
    super.key,
    required this.connectionState,
    this.showLabel = true,
    this.size = 8.0,
  });

  final WebSocketConnectionState connectionState;
  final bool showLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusDot(),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            _getStatusText(),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusDot() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        shape: BoxShape.circle,
      ),
      child: connectionState == WebSocketConnectionState.connecting ||
              connectionState == WebSocketConnectionState.reconnecting
          ? _buildPulsingAnimation()
          : null,
    );
  }

  Widget _buildPulsingAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color: _getStatusColor().withAlpha((value * 255).round()),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        // This creates the pulsing effect by restarting the animation
      },
    );
  }

  Color _getStatusColor() {
    switch (connectionState) {
      case WebSocketConnectionState.connected:
        return AppColors.success;
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warning;
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight;
      case WebSocketConnectionState.error:
        return AppColors.error;
    }
  }

  String _getStatusText() {
    switch (connectionState) {
      case WebSocketConnectionState.connected:
        return 'Connected';
      case WebSocketConnectionState.connecting:
        return 'Connecting...';
      case WebSocketConnectionState.reconnecting:
        return 'Reconnecting...';
      case WebSocketConnectionState.disconnected:
        return 'Offline';
      case WebSocketConnectionState.error:
        return 'Connection Error';
    }
  }
}

/// Full connection status banner for showing detailed connection info
class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({
    super.key,
    required this.connectionState,
    this.lastError,
    this.onRetry,
  });

  final WebSocketConnectionState connectionState;
  final String? lastError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (connectionState == WebSocketConnectionState.connected) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Row(
        children: [
          ConnectionStatusIndicator(
            connectionState: connectionState,
            showLabel: false,
            size: 12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getBannerTitle(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _getTextColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (lastError != null && connectionState == WebSocketConnectionState.error) ...[
                  const SizedBox(height: 2),
                  Text(
                    lastError!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getTextColor().withAlpha(204),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRetry != null && 
              (connectionState == WebSocketConnectionState.error || 
               connectionState == WebSocketConnectionState.disconnected)) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: _getTextColor(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.labelSmall.copyWith(
                  color: _getTextColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warning.withAlpha(26);
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight.withAlpha(26);
      case WebSocketConnectionState.error:
        return AppColors.error.withAlpha(26);
      case WebSocketConnectionState.connected:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warning;
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight;
      case WebSocketConnectionState.error:
        return AppColors.error;
      case WebSocketConnectionState.connected:
        return AppColors.success;
    }
  }

  String _getBannerTitle() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
        return 'Connecting to chat...';
      case WebSocketConnectionState.reconnecting:
        return 'Reconnecting to chat...';
      case WebSocketConnectionState.disconnected:
        return 'Chat offline - messages may not send';
      case WebSocketConnectionState.error:
        return 'Connection error - chat unavailable';
      case WebSocketConnectionState.connected:
        return 'Chat connected';
    }
  }
}

/// Compact connection status chip for headers
class ConnectionStatusChip extends StatelessWidget {
  const ConnectionStatusChip({
    super.key,
    required this.connectionState,
    this.onTap,
  });

  final WebSocketConnectionState connectionState;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (connectionState == WebSocketConnectionState.connected) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getBorderColor(), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConnectionStatusIndicator(
              connectionState: connectionState,
              showLabel: false,
              size: 6,
            ),
            const SizedBox(width: 4),
            Text(
              _getChipText(),
              style: AppTextStyles.labelSmall.copyWith(
                color: _getTextColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warning.withAlpha(20);
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight.withAlpha(20);
      case WebSocketConnectionState.error:
        return AppColors.error.withAlpha(20);
      case WebSocketConnectionState.connected:
        return Colors.transparent;
    }
  }

  Color _getBorderColor() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warning.withAlpha(51);
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight.withAlpha(51);
      case WebSocketConnectionState.error:
        return AppColors.error.withAlpha(51);
      case WebSocketConnectionState.connected:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
      case WebSocketConnectionState.reconnecting:
        return AppColors.warning;
      case WebSocketConnectionState.disconnected:
        return AppColors.softCharcoalLight;
      case WebSocketConnectionState.error:
        return AppColors.error;
      case WebSocketConnectionState.connected:
        return AppColors.success;
    }
  }

  String _getChipText() {
    switch (connectionState) {
      case WebSocketConnectionState.connecting:
        return 'Connecting';
      case WebSocketConnectionState.reconnecting:
        return 'Reconnecting';
      case WebSocketConnectionState.disconnected:
        return 'Offline';
      case WebSocketConnectionState.error:
        return 'Error';
      case WebSocketConnectionState.connected:
        return 'Online';
    }
  }
}