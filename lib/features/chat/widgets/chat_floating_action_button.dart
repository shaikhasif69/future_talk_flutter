import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';

/// Premium floating action button for starting new conversations
/// Features smooth animations and gentle interactions perfect for introverts
class ChatFloatingActionButton extends StatefulWidget {
  const ChatFloatingActionButton({
    super.key,
    required this.onPressed,
    this.isExpanded = false,
    this.onNewIndividualChat,
    this.onNewGroupChat,
  });

  final VoidCallback onPressed;
  final bool isExpanded;
  final VoidCallback? onNewIndividualChat;
  final VoidCallback? onNewGroupChat;

  @override
  State<ChatFloatingActionButton> createState() =>
      _ChatFloatingActionButtonState();
}

class _ChatFloatingActionButtonState extends State<ChatFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25, // 45 degrees
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatFloatingActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    HapticFeedback.mediumImpact();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.sageGreen,
                    AppColors.sageGreenHover,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withOpacity( 0.4),
                    blurRadius: _isPressed ? 8.0 : 16.0,
                    spreadRadius: _isPressed ? 0.0 : 2.0,
                    offset: Offset(0, _isPressed ? 2.0 : 4.0),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(28.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(28.0),
                  onTap: null, // Handled by gesture detector
                  child: Center(
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159 * 2,
                      child: Icon(
                        widget.isExpanded ? Icons.close : Icons.add,
                        size: 24.0,
                        color: AppColors.pearlWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Expandable FAB with multiple action options
class ExpandableChatFAB extends StatefulWidget {
  const ExpandableChatFAB({
    super.key,
    this.onNewIndividualChat,
    this.onNewGroupChat,
    this.onScanQR,
  });

  final VoidCallback? onNewIndividualChat;
  final VoidCallback? onNewGroupChat;
  final VoidCallback? onScanQR;

  @override
  State<ExpandableChatFAB> createState() => _ExpandableChatFABState();
}

class _ExpandableChatFABState extends State<ExpandableChatFAB>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  bool _isExpanded = false;

  final List<_FABAction> _actions = [];

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutBack,
    );

    // Initialize actions
    _initializeActions();
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _initializeActions() {
    _actions.clear();

    if (widget.onNewIndividualChat != null) {
      _actions.add(_FABAction(
        icon: Icons.person_add_outlined,
        label: 'New Chat',
        onTap: () {
          _toggleExpanded();
          widget.onNewIndividualChat!();
        },
      ));
    }

    if (widget.onNewGroupChat != null) {
      _actions.add(_FABAction(
        icon: Icons.group_add_outlined,
        label: 'New Group',
        onTap: () {
          _toggleExpanded();
          widget.onNewGroupChat!();
        },
      ));
    }

    if (widget.onScanQR != null) {
      _actions.add(_FABAction(
        icon: Icons.qr_code_scanner,
        label: 'Scan QR',
        onTap: () {
          _toggleExpanded();
          widget.onScanQR!();
        },
      ));
    }
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Action buttons
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _actions.asMap().entries.map((entry) {
                final index = entry.key;
                final action = entry.value;
                final delay = index * 50.0;

                return Transform.scale(
                  scale: _expandAnimation.value,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildActionButton(action),
                    ),
                  ),
                ).animate().slideY(
                  begin: 0.5,
                  duration: Duration(milliseconds: 200 + delay.toInt()),
                  curve: Curves.easeOutBack,
                );
              }).toList(),
            );
          },
        ),

        // Main FAB
        ChatFloatingActionButton(
          onPressed: _toggleExpanded,
          isExpanded: _isExpanded,
        ),
      ],
    );
  }

  Widget _buildActionButton(_FABAction action) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.pearlWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            boxShadow: [
              BoxShadow(
                color: AppColors.softCharcoal.withOpacity( 0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            action.label,
            style: const TextStyle(
              color: AppColors.softCharcoal,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: AppDimensions.spacingM),

        // Action button
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(24.0),
            onTap: action.onTap,
            child: Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: AppColors.sageGreenLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sageGreen.withOpacity( 0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                action.icon,
                size: 20.0,
                color: AppColors.pearlWhite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Speed dial FAB for quick actions
class ChatSpeedDialFAB extends StatefulWidget {
  const ChatSpeedDialFAB({
    super.key,
    required this.actions,
  });

  final List<SpeedDialAction> actions;

  @override
  State<ChatSpeedDialFAB> createState() => _ChatSpeedDialFABState();
}

class _ChatSpeedDialFABState extends State<ChatSpeedDialFAB>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                color: AppColors.softCharcoal.withOpacity( 0.1),
              ),
            ),
          ).animate().fadeIn(),

        // Actions
        ...widget.actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          final offset = (index + 1) * 70.0;

          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -offset * _animation.value),
                child: Transform.scale(
                  scale: _animation.value,
                  child: Opacity(
                    opacity: _animation.value,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        _toggle();
                        action.onTap();
                      },
                      backgroundColor: action.backgroundColor ?? AppColors.sageGreenLight,
                      child: Icon(
                        action.icon,
                        color: AppColors.pearlWhite,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),

        // Main FAB
        ChatFloatingActionButton(
          onPressed: _toggle,
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}

/// Internal action model
class _FABAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FABAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Speed dial action model
class SpeedDialAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const SpeedDialAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
  });
}