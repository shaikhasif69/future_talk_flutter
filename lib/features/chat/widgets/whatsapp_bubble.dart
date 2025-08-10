import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// WhatsApp-style message bubble with tail pointer
class WhatsAppBubble extends StatelessWidget {
  const WhatsAppBubble({
    super.key,
    required this.child,
    required this.isFromMe,
    this.color,
    this.gradient,
  });

  final Widget child;
  final bool isFromMe;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        isFromMe: isFromMe,
        color: color ?? (isFromMe ? AppColors.sageGreen : AppColors.pearlWhite),
        gradient: gradient,
      ),
      child: Container(
        margin: EdgeInsets.only(
          left: isFromMe ? 0 : 0,
          right: isFromMe ? 8 : 0, // Space for tail
          bottom: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: child,
      ),
    );
  }
}

/// Custom painter for WhatsApp-style bubble with tail
class BubblePainter extends CustomPainter {
  final bool isFromMe;
  final Color color;
  final Gradient? gradient;

  BubblePainter({
    required this.isFromMe,
    required this.color,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final path = Path();
    const radius = 18.0;
    const tailSize = 8.0;

    if (isFromMe) {
      // Sent message - tail on bottom right
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius - tailSize);
      path.quadraticBezierTo(size.width, size.height - tailSize, size.width - radius, size.height - tailSize);
      
      // Create the tail
      path.lineTo(size.width - radius + tailSize, size.height - tailSize);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - tailSize, size.height - tailSize);
      
      path.lineTo(radius, size.height - tailSize);
      path.quadraticBezierTo(0, size.height - tailSize, 0, size.height - radius - tailSize);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
    } else {
      // Received message - tail on bottom left
      path.moveTo(radius, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, size.height - radius);
      path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
      
      // Create the tail
      path.lineTo(tailSize, size.height);
      path.lineTo(0, size.height - tailSize/2);
      path.lineTo(tailSize, size.height - tailSize);
      
      path.lineTo(radius, size.height - tailSize);
      path.quadraticBezierTo(0, size.height - tailSize, 0, size.height - radius - tailSize);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
    }

    // Apply gradient if provided
    if (gradient != null) {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      paint.shader = gradient!.createShader(rect);
    }

    // Draw shadow first
    final shadowPath = path.shift(const Offset(0, 2));
    final shadowPaint = Paint()
      ..color = AppColors.cardShadow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw the bubble
    canvas.drawPath(path, paint);

    // Draw border for received messages
    if (!isFromMe) {
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = AppColors.sageGreenWithOpacity(0.1)
        ..strokeWidth = 1.0;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}