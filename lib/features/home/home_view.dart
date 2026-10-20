import 'package:flutter/material.dart';

import '../../data/practice_messages.dart';
import '../../services/progress_store.dart';
import '../interface/brand.dart';
import '../interface/pixel_theme.dart';
import '../interface/pixel_world.dart';
import '../interface/quest_widgets.dart';
import '../learn/lesson_data.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.progress,
    required this.onLearn,
    required this.onOpenTexts,
    required this.onOpenLesson,
  });

  final AppProgress progress;
  final VoidCallback onLearn;
  final VoidCallback onOpenTexts;
  final VoidCallback onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final textMessages =
        practiceMessages.where((message) => message.channel == 'Text').toList();
    final textReviewed = textMessages
        .where((message) => progress.reviewedMessages.contains(message.id))
        .length;
    final textCorrect = textMessages
        .where((message) => progress.correctMessages.contains(message.id))
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (MediaQuery.sizeOf(context).width < 900) ...[
          const Brand(),
          const SizedBox(height: 30),
        ],
        const Text(
          'WELCOME, DEFENDER',
          style: TextStyle(
            color: pixelPurple,
            fontFamily: 'Silkscreen',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'YOUR QUEST BOARD',
          style: pixelHeading(MediaQuery.sizeOf(context).width < 600 ? 23 : 31),
        ),
        const SizedBox(height: 8),
        const Text(
          'Train your instincts with quick lessons and safe practice.',
          style: TextStyle(fontSize: 16, color: pixelMuted),
        ),
        const SizedBox(height: 26),
        PixelWorldBanner(onStart: onOpenLesson),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: pixelPanel(pixelCream),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 14,
                runSpacing: 10,
                children: [
                  const Icon(Icons.stars_rounded,
                      color: Color(0xFFE59A17), size: 32),
                  Text('LEVEL ${progress.level}', style: pixelHeading(21)),
                  Text(
                    '${progress.xp} XP  /  ${100 - progress.xp % 100} TO NEXT LEVEL',
                    style: const TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 12,
                      color: pixelPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              LinearProgressIndicator(
                value: progress.levelProgress,
                minHeight: 14,
                color: pixelGrass,
                backgroundColor: pixelMint,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth =
                constraints.maxWidth < 600 ? constraints.maxWidth : 190.0;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatCard(
                  width: cardWidth,
                  icon: Icons.bolt_rounded,
                  value: '${progress.xp}',
                  label: 'Total XP',
                ),
                _StatCard(
                  width: cardWidth,
                  icon: Icons.menu_book_rounded,
                  value:
                      '${progress.completedLessons.length}/${lessons.length}',
                  label: 'Lessons done',
                ),
                _StatCard(
                  width: cardWidth,
                  icon: Icons.mark_email_read_rounded,
                  value:
                      '${progress.reviewedMessages.length}/${practiceMessages.length}',
                  label: 'Messages reviewed',
                ),
                _StatCard(
                  width: cardWidth,
                  icon: Icons.sms_rounded,
                  value: '$textCorrect/${textMessages.length}',
                  label: 'Texts correct',
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: pixelPanel(pixelGold),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR SCOREBOARD', style: pixelHeading(17)),
                  const SizedBox(height: 5),
                  Text('$textCorrect of $textReviewed text checks correct'),
                ],
              ),
              Text('${progress.xp} XP', style: pixelHeading(22)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SectionHeading(
          title: 'Start here',
          subtitle: 'Just a few minutes can make a difference.',
        ),
        const SizedBox(height: 16),
        ActionCard(
          icon: Icons.auto_stories_rounded,
          title: progress.completedLessons.contains('basics')
              ? 'Keep learning'
              : 'Your first lesson',
          subtitle: 'Spot the warning signs in everyday messages.',
          button: 'Start lesson',
          onPressed: onOpenLesson,
        ),
        const SizedBox(height: 14),
        ActionCard(
          icon: Icons.sms_outlined,
          title: 'Test your instincts',
          subtitle: 'Sort simulated messages into scam or safe.',
          button: 'Try texts',
          onPressed: onOpenTexts,
        ),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: onLearn,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Browse all lessons'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
