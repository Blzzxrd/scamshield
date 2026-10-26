import 'package:flutter/material.dart';

import 'pixel_theme.dart';

/// A small version of the text-practice phone.
class PhoneMark extends StatelessWidget {
  const PhoneMark({super.key, this.width = 54});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: width * 68 / 54,
        child: const CustomPaint(painter: _PhonePainter()),
      );
}

class _PhonePainter extends CustomPainter {
  const _PhonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 54, size.height / 68);

    void block(double x, double y, double width, double height, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        Paint()
          ..color = color
          ..isAntiAlias = false,
      );
    }

    void rounded(
      double x,
      double y,
      double width,
      double height,
      double radius,
      Color color,
    ) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, width, height),
          Radius.circular(radius),
        ),
        Paint()..color = color,
      );
    }

    // The frame, status bar, contact row, and message bubble echo Text imitation.
    rounded(5, 5, 46, 62, 11, pixelInk);
    rounded(2, 1, 46, 62, 11, pixelInk);
    rounded(6, 5, 38, 54, 7, pixelCream);
    block(6, 11, 38, 7, pixelSky);
    block(6, 18, 38, 2, pixelInk);
    block(10, 8, 7, 2, pixelInk);
    block(33, 8, 3, 2, pixelInk);
    block(38, 8, 3, 2, pixelInk);
    block(6, 20, 38, 13, pixelCream);
    block(9, 23, 8, 8, pixelInk);
    block(11, 25, 4, 4, pixelGold);
    block(21, 24, 17, 2, pixelInk);
    block(21, 28, 12, 2, pixelMuted);
    block(6, 33, 38, 2, pixelInk);
    block(6, 35, 38, 24, pixelSky);
    block(10, 40, 28, 15, pixelInk);
    block(12, 42, 24, 11, pixelMint);
    block(15, 45, 17, 2, pixelInk);
    block(15, 49, 12, 2, pixelMuted);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
