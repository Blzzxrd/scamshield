import 'package:flutter/material.dart';

import 'pixel_theme.dart';

class PixelWorldBanner extends StatelessWidget {
  const PixelWorldBanner({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          return Container(
            height: 350,
            decoration: pixelPanel(pixelSky),
            child: ClipRect(
              child: Stack(
                children: [
                  const Positioned.fill(
                      child: CustomPaint(painter: _PixelWorldPainter())),
                  Positioned(
                    left: compact ? 18 : 32,
                    top: compact ? 23 : 28,
                    right: compact ? 18 : 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: pixelPanel(pixelGold, shadow: false),
                          child: const Text(
                            'WORLD 01  /  SAFETY QUEST',
                            style: TextStyle(
                              fontFamily: 'Silkscreen',
                              color: pixelInk,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          compact ? 'SPOT THE\nSCAM' : 'SPOT THE SCAM',
                          style: pixelHeading(compact ? 29 : 42),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: pixelSky,
                          child: Text(
                            'Learn the clues. Earn XP. Stay safe.',
                            style: TextStyle(
                              fontSize: compact ? 13 : 16,
                              fontWeight: FontWeight.w700,
                              color: pixelInk,
                            ),
                          ),
                        ),
                        const SizedBox(height: 17),
                        FilledButton.icon(
                          onPressed: onStart,
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('START QUEST'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class _PixelWorldPainter extends CustomPainter {
  const _PixelWorldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final u = (w / 125).clamp(3.0, 8.0);
    final ground = h - u * 9;

    void block(double x, double y, double width, double height, Color color) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        Paint()..color = color,
      );
    }

    void cloud(double x, double y) {
      const outline = Color(0xFF8DA5D9);
      const fill = Color(0xFFF8FDFF);
      block(x + 2 * u, y, 7 * u, u, outline);
      block(x + u, y + u, 10 * u, u, outline);
      block(x, y + 2 * u, 13 * u, 3 * u, outline);
      block(x + u, y + 2 * u, 11 * u, 2 * u, fill);
      block(x + 3 * u, y + u, 6 * u, u, fill);
      block(x + 2 * u, y + 5 * u, 9 * u, u, const Color(0xFFC1D5EE));
    }

    void coin(double x, double y) {
      block(x + u, y, 2 * u, u, const Color(0xFFE78817));
      block(x, y + u, 4 * u, 3 * u, const Color(0xFFE78817));
      block(x + u, y + u, 2 * u, 3 * u, pixelGold);
      block(x + u, y + 4 * u, 2 * u, u, const Color(0xFFE78817));
      block(x + 2 * u, y + 2 * u, u, u, const Color(0xFFFFF3A0));
    }

    void tree(double x) {
      block(x + 3 * u, ground - 8 * u, 2 * u, 8 * u, const Color(0xFF844522));
      block(x + 2 * u, ground - 12 * u, 4 * u, 3 * u, const Color(0xFF157D40));
      block(x + u, ground - 10 * u, 6 * u, 3 * u, const Color(0xFF1F9C43));
      block(x, ground - 8 * u, 8 * u, 3 * u, const Color(0xFF13783C));
      block(x + 3 * u, ground - 15 * u, 2 * u, 3 * u, const Color(0xFF41CF56));
      block(x + 3 * u, ground - 11 * u, u, 2 * u, const Color(0xFF9EF458));
    }

    void shieldHero(double x) {
      final y = ground - 13 * u;
      block(x + 2 * u, y, 5 * u, u, pixelInk); // hair
      block(x + u, y + u, 7 * u, u, const Color(0xFF693B77));
      block(x + 2 * u, y + 2 * u, 5 * u, 4 * u, const Color(0xFFFFCA98));
      block(x + 3 * u, y + 3 * u, u, u, pixelInk);
      block(x + 6 * u, y + 3 * u, u, u, pixelInk);
      block(x + u, y + 6 * u, 7 * u, 5 * u, pixelPurple);
      block(x + 3 * u, y + 7 * u, 3 * u, 4 * u, const Color(0xFF8876D7));
      block(x, y + 6 * u, u, 5 * u, const Color(0xFFFFCA98));
      block(x + 8 * u, y + 6 * u, u, 5 * u, const Color(0xFFFFCA98));
      block(x + 2 * u, y + 11 * u, 2 * u, 2 * u, pixelInk);
      block(x + 6 * u, y + 11 * u, 2 * u, 2 * u, pixelInk);
      // A tiny shield gives the character a ScamShield identity.
      block(x - 2 * u, y + 8 * u, 4 * u, 4 * u, pixelInk);
      block(x - u, y + 8 * u, 2 * u, 3 * u, const Color(0xFF5DE0BB));
      block(x, y + 9 * u, u, u, pixelCream);
    }

    void hut(double x) {
      final y = ground - 10 * u;
      block(x + 2 * u, y, 10 * u, u, const Color(0xFF9B551D));
      block(x + u, y + u, 12 * u, 2 * u, const Color(0xFFE8A735));
      block(x, y + 3 * u, 14 * u, 2 * u, const Color(0xFFB96F22));
      block(x + u, y + 5 * u, 12 * u, 5 * u, const Color(0xFF9C5938));
      block(x + 5 * u, y + 6 * u, 4 * u, 4 * u, pixelInk);
      block(x + 6 * u, y + 7 * u, 2 * u, 3 * u, const Color(0xFF654060));
      block(x + 3 * u, y + 7 * u, u, u, pixelGold);
      block(x + 10 * u, y + 7 * u, u, u, pixelGold);
    }

    // Sky and distant geometric hills.
    block(0, 0, w, h, pixelSky);
    block(0, h * 0.47, w * 0.30, h * 0.28, const Color(0xFFD6F0EA));
    block(w * 0.68, h * 0.10, w * 0.32, h * 0.55, const Color(0xFFDDF1F5));
    cloud(w * 0.03, u * 2);
    cloud(w * 0.70, u * 3);

    // Small floating platforms echo the reference artwork.
    block(0, ground - 12 * u, 9 * u, u, pixelGrass);
    block(0, ground - 11 * u, 9 * u, 3 * u, const Color(0xFFA85B26));
    block(w - 11 * u, ground - 19 * u, 11 * u, u, pixelGrass);
    block(w - 11 * u, ground - 18 * u, 11 * u, 3 * u, const Color(0xFFA85B26));

    // Grassy game platform.
    block(0, ground, w, h - ground, pixelInk);
    block(0, ground + u, w, h - ground, const Color(0xFF9A4E25));
    block(0, ground - u, w, 2 * u, pixelGrass);
    block(0, ground + u, w, u, const Color(0xFF3B9C2F));
    for (var i = 0; i < w / (4 * u); i++) {
      final x = i * 4 * u;
      block(x, ground - 2 * u, 2 * u, u, const Color(0xFF82EC4C));
      block(x + 2 * u, ground + 3 * u, u, u, const Color(0xFF6B341E));
      block(x, ground + 5 * u, 2 * u, u, const Color(0xFFCA7531));
    }

    tree(w * 0.11);
    hut(w - 16 * u);
    shieldHero(w * 0.57);
    coin(w * 0.31, ground - 8 * u);
    coin(w * 0.75, ground - 11 * u);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
