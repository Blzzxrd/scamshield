import 'package:flutter/material.dart';
import 'brand_mark.dart';
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
          const SizedBox(height: 34),
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
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The gap between SCAM and SHIELD is 54 px from the wordmark's left edge.
          const Padding(
            padding: EdgeInsets.only(left: 24),
            child: PhoneMark(width: 60),
          ),
          const SizedBox(height: 6),
          Text(
            'SCAM SHIELD',
            style: TextStyle(
              fontFamily: 'Silkscreen',
              color: onDark ? pixelCream : pixelInk,
              fontSize: 16,
            ),
          ),
        ],
      );
}
