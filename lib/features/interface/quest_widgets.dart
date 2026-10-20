import 'package:flutter/material.dart';

import 'pixel_theme.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: pixelHeading(22),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: pixelMuted)),
        ],
      );
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String button;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: pixelPanel(pixelCream),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: pixelPanel(pixelGold, shadow: false),
                  child: Icon(icon, color: pixelInk),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Silkscreen',
                          fontSize: 16,
                          color: pixelInk,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(color: pixelMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FilledButton(onPressed: onPressed, child: Text(button)),
          ],
        ),
      );
}
