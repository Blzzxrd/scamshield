import 'package:flutter/material.dart';
import 'pixel_theme.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation(
      {super.key, required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.menu_book_rounded, 'Learn'),
      (Icons.shield_rounded, 'Practice'),
      (Icons.person_rounded, 'Profile'),
    ];
    return Container(
      width: 240,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
      decoration: const BoxDecoration(
        color: pixelInk,
        border: Border(right: BorderSide(color: pixelGold, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Brand(onDark: true),
          const SizedBox(height: 56),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration:
                    selected == i ? pixelPanel(pixelGold, shadow: false) : null,
                child: ListTile(
                  leading: Icon(
                    items[i].$1,
                    color: selected == i ? pixelInk : pixelCream,
                  ),
                  title: Text(
                    items[i].$2.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 13,
                      color: selected == i ? pixelInk : pixelCream,
                    ),
                  ),
                  onTap: () => onSelect(i),
                ),
              ),
            ),
          const Spacer(),
          const Text(
            'PRESS START. STAY SAFE.',
            style: TextStyle(
              color: pixelGold,
              fontFamily: 'Silkscreen',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

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
