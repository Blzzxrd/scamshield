import 'package:flutter/material.dart';

import '../../data/practice_messages.dart';
import '../../services/progress_store.dart';
import '../interface/pixel_theme.dart';
import '../interface/quest_widgets.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.progress});
  final AppProgress progress;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Your progress',
            subtitle: 'Every safe decision strengthens your instincts.',
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: pixelPanel(pixelCream),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: pixelPanel(pixelGold, shadow: false),
                      child:
                          const Icon(Icons.shield, color: pixelInk, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${progress.level} defender',
                          style: pixelHeading(19),
                        ),
                        Text(
                          '${progress.xp} XP earned',
                          style: const TextStyle(color: pixelMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                LinearProgressIndicator(
                  value: progress.levelProgress,
                  minHeight: 12,
                  color: pixelGrass,
                  backgroundColor: pixelMint,
                ),
                const SizedBox(height: 8),
                Text(
                  '${100 - progress.xp % 100} XP to level ${progress.level + 1}',
                  style: const TextStyle(color: pixelMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'ACHIEVEMENTS',
            style: TextStyle(
                fontFamily: 'Silkscreen', fontSize: 22, color: pixelInk),
          ),
          const SizedBox(height: 14),
          _Badge(
            title: 'First steps',
            subtitle: 'Complete your first lesson',
            unlocked: progress.completedLessons.isNotEmpty,
            icon: Icons.auto_stories,
          ),
          _Badge(
            title: 'Sharp eye',
            subtitle: 'Review all four messages',
            unlocked:
                progress.reviewedMessages.length == practiceMessages.length,
            icon: Icons.visibility,
          ),
          _Badge(
            title: 'Calm under pressure',
            subtitle: 'Complete the phone simulation',
            unlocked: progress.callCompleted,
            icon: Icons.call,
          ),
          const SizedBox(height: 24),
          const Text(
            'Progress is saved in this browser.',
            style: TextStyle(color: pixelMuted),
          ),
        ],
      );
}

class _Badge extends StatelessWidget {
  const _Badge({
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
