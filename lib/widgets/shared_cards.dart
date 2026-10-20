import 'package:flutter/material.dart';
import 'pixel_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.width,
    required this.icon,
    required this.value,
    required this.label,
  });
  final double width;
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: pixelPanel(pixelCream),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: pixelPurple),
            const SizedBox(height: 14),
            Text(
              value,
              style: pixelHeading(25),
            ),
            Text(label.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Silkscreen', fontSize: 11, color: pixelMuted)),
          ],
        ),
      );
}

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

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.unlocked,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final bool unlocked;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          leading: Container(
            width: 42,
            height: 42,
            decoration:
                pixelPanel(unlocked ? pixelGold : pixelMint, shadow: false),
            child: Icon(icon, color: unlocked ? pixelInk : pixelMuted),
          ),
          title: Text(title.toUpperCase(),
              style: const TextStyle(fontFamily: 'Silkscreen', fontSize: 14)),
          subtitle: Text(subtitle),
          trailing: Text(
            unlocked ? 'Unlocked' : 'Locked',
            style: TextStyle(
              color: unlocked ? pixelPurple : pixelMuted,
              fontFamily: 'Silkscreen',
              fontSize: 11,
            ),
          ),
        ),
      );
}
