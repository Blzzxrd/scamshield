import 'package:flutter/material.dart';

import 'pixel_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: pixelPanel(pixelGold, shadow: false),
            child: const Icon(Icons.shield_rounded, color: pixelInk, size: 24),
          ),
          const SizedBox(width: 10),
          Text(
            'ScamShield',
            style: TextStyle(
              fontFamily: 'Silkscreen',
              color: onDark ? pixelCream : pixelInk,
              fontSize: 17,
            ),
          ),
        ],
      );
}
