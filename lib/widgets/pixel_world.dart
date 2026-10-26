import 'package:flutter/material.dart';

import 'pixel_theme.dart';

const _artRoot = 'assets/art/kenney_pixel_platformer/';

class PixelWorldBanner extends StatelessWidget {
  const PixelWorldBanner({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          final width = constraints.maxWidth;

          return Container(
            height: 350,
            decoration: pixelPanel(pixelSky),
            child: ClipRect(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: Color(0xFFDFF5F6)),
                  ),
                  Positioned(
                    top: compact ? 26 : 38,
                    left: compact ? width * 0.69 : width * 0.52,
                    child: _PixelCloud(tileSize: compact ? 26 : 34),
                  ),
                  if (!compact)
                    Positioned(
                      top: 82,
                      right: 45,
                      child: const _PixelCloud(tileSize: 25),
                    ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _GroundStrip(),
                  ),
                  Positioned(
                    right: compact ? -8 : width * 0.40,
                    bottom: 68,
                    child: _ArtSprite(
                      name: 'pine.png',
                      size: compact ? 112 : 122,
                    ),
                  ),
                  if (!compact)
                    Positioned(
                      right: 13,
                      bottom: 68,
                      child: const _ArtSprite(name: 'pine.png', size: 110),
                    ),
                  Positioned(
                    left: compact ? width * 0.52 : width * 0.67,
                    bottom: 68,
                    child: _ArtSprite(
                      name: 'defender_green.png',
                      size: compact ? 83 : 105,
                    ),
                  ),
                  if (!compact)
                    Positioned(
                      left: width * 0.80,
                      bottom: 68,
                      child: const _ArtSprite(
                        name: 'defender_orange.png',
                        size: 94,
                      ),
                    ),
                  if (!compact) ...[
                    Positioned(
                      left: width * 0.60,
                      bottom: 128,
                      child: const _ArtSprite(name: 'coin.png', size: 48),
                    ),
                    Positioned(
                      left: width * 0.79,
                      top: 55,
                      child: const _ArtSprite(
                        name: 'question_block.png',
                        size: 48,
                      ),
                    ),
                  ],
                  Positioned(
                    left: compact ? 18 : 32,
                    top: compact ? 23 : 28,
                    right: compact ? 18 : 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
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
                            horizontal: 8,
                            vertical: 4,
                          ),
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

class _GroundStrip extends StatelessWidget {
  const _GroundStrip();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final tileCount = (constraints.maxWidth / 38).ceil().clamp(1, 100);

          Widget tileRow(String name) => SizedBox(
                height: 38,
                child: Row(
                  children: [
                    for (var i = 0; i < tileCount; i++)
                      Expanded(
                        child: _ArtSprite(name: name, height: 38),
                      ),
                  ],
                ),
              );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tileRow('ground_top.png'),
              tileRow('dirt.png'),
            ],
          );
        },
      );
}

class _PixelCloud extends StatelessWidget {
  const _PixelCloud({required this.tileSize});

  final double tileSize;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ArtSprite(name: 'cloud_left.png', size: tileSize),
          _ArtSprite(name: 'cloud_middle.png', size: tileSize),
          _ArtSprite(name: 'cloud_right.png', size: tileSize),
        ],
      );
}

class _ArtSprite extends StatelessWidget {
  const _ArtSprite({required this.name, this.size, this.height});

  final String name;
  final double? size;
  final double? height;

  @override
  Widget build(BuildContext context) => Image.asset(
        _artRoot + name,
        width: size,
        height: height ?? size,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      );
}
