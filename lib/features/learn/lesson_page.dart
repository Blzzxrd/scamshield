import 'package:flutter/material.dart';

import 'lesson_data.dart';
import '../interface/activity_widgets.dart';
import '../interface/pixel_theme.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({
    super.key,
    required this.lesson,
    required this.alreadyCompleted,
    required this.onFinished,
  });

  final Lesson lesson;
  final bool alreadyCompleted;
  final ValueChanged<int> onFinished;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int _questionIndex = -1;
  int? _selected;
  int _correctCount = 0;

  void _next() {
    setState(() {
      _questionIndex++;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final finished = _questionIndex >= widget.lesson.questions.length;
    return ActivityScaffold(
      title: widget.lesson.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_questionIndex < 0) ...[
            ActivityEyebrow(widget.lesson.eyebrow),
            const SizedBox(height: 13),
            Text('THE IDEA', style: pixelHeading(25)),
            const SizedBox(height: 15),
            Text(
              widget.lesson.description,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 24),
            NoteCard(
              icon: Icons.lightbulb_outline,
              title: 'Example',
              text: widget.lesson.example,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Try the quiz'),
            ),
          ] else if (finished) ...[
            const Icon(Icons.verified_rounded, color: pixelPurple, size: 68),
            const SizedBox(height: 18),
            Text('LESSON COMPLETE!', style: pixelHeading(26)),
            const SizedBox(height: 10),
            Text(
              'You got $_correctCount of ${widget.lesson.questions.length} right.',
            ),
            const SizedBox(height: 10),
            Text(
              widget.alreadyCompleted
                  ? 'Great review. XP is awarded the first time you complete a lesson.'
                  : 'You earned ${20 + _correctCount * 10} XP.',
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () {
                widget.onFinished(_correctCount);
                Navigator.pop(context);
              },
              child: const Text('Back to lessons'),
            ),
          ] else ...[
            ActivityEyebrow(
              'QUESTION ${_questionIndex + 1} OF ${widget.lesson.questions.length}',
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: (_questionIndex + 1) / widget.lesson.questions.length,
              minHeight: 12,
              color: pixelGrass,
              backgroundColor: pixelMint,
            ),
            const SizedBox(height: 26),
            Text(widget.lesson.questions[_questionIndex].prompt,
                style: pixelHeading(22)),
            const SizedBox(height: 24),
            for (var i = 0;
                i < widget.lesson.questions[_questionIndex].answers.length;
                i++) ...[
              ChoiceButton(
                text: widget.lesson.questions[_questionIndex].answers[i],
                selected: _selected == i,
                disabled: _selected != null,
                onPressed: () => setState(() {
                  _selected = i;
                  if (i ==
                      widget.lesson.questions[_questionIndex].correctIndex) {
                    _correctCount++;
                  }
                }),
              ),
              const SizedBox(height: 10),
            ],
            if (_selected != null) ...[
              const SizedBox(height: 12),
              NoteCard(
                icon: _selected ==
                        widget.lesson.questions[_questionIndex].correctIndex
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
                title: _selected ==
                        widget.lesson.questions[_questionIndex].correctIndex
                    ? 'That’s right'
                    : 'Good try',
                text: widget.lesson.questions[_questionIndex].explanation,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _next,
                child: Text(
                  _questionIndex == widget.lesson.questions.length - 1
                      ? 'See results'
                      : 'Continue',
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
