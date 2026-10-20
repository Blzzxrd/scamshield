import 'package:flutter/material.dart';
import '../data/content.dart';
import '../services/progress_store.dart';
import '../widgets/pixel_theme.dart';
import '../widgets/shared_cards.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.progress,
    required this.practiceMessages,
  });

  final AppProgress progress;
  final List<PracticeMessage> practiceMessages;

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
          BadgeWidget(
            title: 'First steps',
            subtitle: 'Complete your first lesson',
            unlocked: progress.completedLessons.isNotEmpty,
            icon: Icons.auto_stories,
          ),
          BadgeWidget(
            title: 'Sharp eye',
            subtitle: 'Review four messages',
            unlocked: progress.reviewedMessages.length == 2,
            icon: Icons.visibility,
          ),
          BadgeWidget(
            title: 'Calm under pressure',
            subtitle: 'Complete a phone simulation',
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
