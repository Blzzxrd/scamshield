import 'package:flutter/material.dart';

import 'pixel_theme.dart';

/// A small version of the text-practice phone with a pixel shield in front.
class PhoneShieldMark extends StatelessWidget {
  const PhoneShieldMark({super.key, this.width = 64});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        height: width * 70 / 64,
        child: const CustomPaint(painter: _PhoneShieldPainter()),
      );
}

class _PhoneShieldPainter extends CustomPainter {
  const _PhoneShieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 64, size.height / 70);

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

    const shield = [
      ' KKKKKKK ',
      ' KYYYYYK ',
      ' KYYYYYK ',
      ' KYYYYYK ',
      '  KYYYK  ',
      '  KYYYK  ',
      '   KYK   ',
      '    K    ',
    ];
    for (var row = 0; row < shield.length; row++) {
      for (var column = 0; column < shield[row].length; column++) {
        final pixel = shield[row][column];
        if (pixel == ' ') continue;
        block(
          36 + column * 3,
          42 + row * 3,
          3,
          3,
          pixel == 'K' ? pixelInk : pixelGold,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
