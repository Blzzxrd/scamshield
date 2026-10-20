import 'package:flutter/material.dart';

import '../../services/progress_store.dart';
import '../interface/quest_widgets.dart';
import 'lesson_data.dart';

class LearnView extends StatelessWidget {
  const LearnView({super.key, required this.progress, required this.onOpen});
  final AppProgress progress;
  final ValueChanged<Lesson> onOpen;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Learn the patterns',
            subtitle: 'Short lessons. Clear examples. Better instincts.',
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < lessons.length; i++) ...[
            ActionCard(
              icon: i == 0
                  ? Icons.visibility_rounded
                  : Icons.mail_outline_rounded,
              title: lessons[i].title,
              subtitle:
                  '${lessons[i].eyebrow} · ${progress.completedLessons.contains(lessons[i].id) ? 'Completed' : 'Earn up to 50 XP'}',
              button: progress.completedLessons.contains(lessons[i].id)
                  ? 'Review'
                  : 'Begin',
              onPressed: () => onOpen(lessons[i]),
            ),
            const SizedBox(height: 14),
          ],
        ],
      );
}
