import 'package:flutter/material.dart';
import '../models/connection_stone_model.dart';
import '../models/stone_type.dart';

/// Premium visual widget for rendering connection stones with animations
class StoneVisualWidget extends StatefulWidget {
  final ConnectionStone stone;
  final double size;
  final bool enableAnimations;
  final bool showConnectionStrength;

  const StoneVisualWidget({
    super.key,
    required this.stone,
    this.size = 80.0,
    this.enableAnimations = true,
    this.showConnectionStrength = false,
  });

  @override
  State<StoneVisualWidget> createState() => _StoneVisualWidgetState();
}

class _StoneVisualWidgetState extends State<StoneVisualWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _receivingController;
  late AnimationController _sendingController;
  late AnimationController _connectionController;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _receivingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _sendingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _connectionController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    if (widget.enableAnimations) {
      _startAppropriateAnimation();
    }
  }

  @override
  void didUpdateWidget(StoneVisualWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.stone.id == oldWidget.stone.id &&
        widget.stone.animationState != oldWidget.stone.animationState) {
      _startAppropriateAnimation();
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _receivingController.dispose();
    _sendingController.dispose();
    _connectionController.dispose();
    super.dispose();
  }

  void _startAppropriateAnimation() {
    // Stop all animations first
    _breathingController.stop();
    _receivingController.stop();
    _sendingController.stop();
    
    switch (widget.stone.animationState) {
      case StoneAnimationState.breathing:
        _breathingController.repeat();
        break;
      case StoneAnimationState.receiving:
        _receivingController.repeat();
        break;
      case StoneAnimationState.sending:
        _sendingController.repeat();
        break;
      case StoneAnimationState.idle:
        // No animation
        break;
    }
    
    if (widget.showConnectionStrength) {
      _connectionController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Connection strength indicator (background)
          if (widget.showConnectionStrength) _buildConnectionStrengthRing(),
          
          // Receiving glow effect
          if (widget.stone.isReceivingComfort) _buildReceivingGlow(),
          
          // Sending pulse effect
          if (widget.stone.isSendingComfort) _buildSendingPulse(),
          
          // Main stone visual
          _buildMainStone(),
          
          // Stone emoji
          _buildStoneEmoji(),
        ],
      ),
    );
  }

  Widget _buildMainStone() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingController,
        _receivingController,
        _sendingController,
      ]),
      builder: (context, child) {
        double scale = 1.0;
        
        if (widget.stone.shouldBreathe && widget.enableAnimations) {
          // Gentle breathing animation
          scale = 1.0 + (0.03 * (1 + _breathingController.value) / 2);
        }
        
        if (widget.stone.shouldGlow && widget.enableAnimations) {
          // Receiving glow scale
          scale = 1.0 + (0.08 * (1 + _receivingController.value) / 2);
        }
        
        if (widget.stone.shouldPulse && widget.enableAnimations) {
          // Sending pulse scale
          scale = 1.0 + (0.05 * (1 + _sendingController.value) / 2);
        }
        
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              gradient: widget.stone.stoneType.gradient,
              shape: BoxShape.circle,
              boxShadow: _buildStoneShadows(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoneEmoji() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingController,
        _receivingController,
        _sendingController,
      ]),
      builder: (context, child) {
        double rotation = 0.0;
        
        if (widget.stone.shouldBreathe && widget.enableAnimations) {
          rotation = 0.02 * _breathingController.value;
        }
        
        if (widget.stone.shouldPulse && widget.enableAnimations) {
          rotation = 0.05 * _sendingController.value;
        }
        
        return Transform.rotate(
          angle: rotation,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: Text(
              widget.stone.stoneType.emoji,
              key: ValueKey('${widget.stone.id}_${widget.stone.stoneType.emoji}'),
              style: TextStyle(
                fontSize: widget.size * 0.4,
                height: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceivingGlow() {
    return AnimatedBuilder(
      animation: _receivingController,
      builder: (context, child) {
        final glowIntensity = (1 + _receivingController.value) / 2;
        
        return Container(
          width: widget.size * (1.0 + 0.3 * glowIntensity),
          height: widget.size * (1.0 + 0.3 * glowIntensity),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.stone.stoneType.glowColor.withOpacity(0.0),
                widget.stone.stoneType.glowColor.withOpacity(0.3 * glowIntensity),
                widget.stone.stoneType.glowColor.withOpacity(0.1 * glowIntensity),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 0.8, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSendingPulse() {
    return AnimatedBuilder(
      animation: _sendingController,
      builder: (context, child) {
        return Container(
          width: widget.size * (1.0 + 0.5 * _sendingController.value),
          height: widget.size * (1.0 + 0.5 * _sendingController.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.stone.stoneType.primaryColor.withOpacity(
                0.6 * (1 - _sendingController.value),
              ),
              width: 2.0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionStrengthRing() {
    return AnimatedBuilder(
      animation: _connectionController,
      builder: (context, child) {
        final strength = widget.stone.calculatedConnectionStrength;
        final ringOpacity = 0.2 + (0.3 * (1 + _connectionController.value) / 2);
        
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getConnectionStrengthColor(strength).withOpacity(ringOpacity),
              width: 3.0,
            ),
          ),
        );
      },
    );
  }

  List<BoxShadow> _buildStoneShadows() {
    final baseShadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
    
    if (widget.stone.isReceivingComfort) {
      baseShadows.add(
        BoxShadow(
          color: widget.stone.stoneType.glowColor.withOpacity(0.4),
          blurRadius: 16,
          spreadRadius: 2,
        ),
      );
    }
    
    if (widget.stone.isSendingComfort) {
      baseShadows.add(
        BoxShadow(
          color: widget.stone.stoneType.primaryColor.withOpacity(0.3),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      );
    }
    
    return baseShadows;
  }

  Color _getConnectionStrengthColor(double strength) {
    if (strength >= 0.8) {
      return Colors.yellow;
    } else if (strength >= 0.6) {
      return Colors.green;
    } else if (strength >= 0.4) {
      return Colors.blue;
    } else if (strength >= 0.2) {
      return Colors.orange;
    } else {
      return Colors.grey;
    }
  }
}

/// Specialized stone visual for the quick touch bar
class QuickStoneVisual extends StatelessWidget {
  final ConnectionStone stone;
  final double size;

  const QuickStoneVisual({
    super.key,
    required this.stone,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return StoneVisualWidget(
      stone: stone,
      size: size,
      enableAnimations: true,
      showConnectionStrength: false,
    );
  }
}

/// Large stone visual for modals and detail views
class LargeStoneVisual extends StatelessWidget {
  final ConnectionStone stone;
  final double size;

  const LargeStoneVisual({
    super.key,
    required this.stone,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return StoneVisualWidget(
      stone: stone,
      size: size,
      enableAnimations: true,
      showConnectionStrength: true,
    );
  }
}

/// Animated stone creation visual
class StoneCreationVisual extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final String emoji;

  const StoneCreationVisual({
    super.key,
    this.size = 100.0,
    required this.primaryColor,
    required this.secondaryColor,
    required this.emoji,
  });

  @override
  State<StoneCreationVisual> createState() => _StoneCreationVisualState();
}

class _StoneCreationVisualState extends State<StoneCreationVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                Container(
                  width: widget.size * (1.0 + 0.3 * _glowAnimation.value),
                  height: widget.size * (1.0 + 0.3 * _glowAnimation.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.primaryColor.withOpacity(0.0),
                        widget.primaryColor.withOpacity(0.3 * _glowAnimation.value),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
                
                // Main stone
                Container(
                  width: widget.size * 0.8,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [widget.primaryColor, widget.secondaryColor],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        widget.emoji,
                        key: ValueKey(widget.emoji),
                        style: TextStyle(
                          fontSize: widget.size * 0.4,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}