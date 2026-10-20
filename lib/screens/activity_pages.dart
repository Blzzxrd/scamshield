import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/content.dart';
import '../widgets/pixel_theme.dart';

const _navy = pixelInk;
const _teal = pixelPurple;

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
    return _ActivityScaffold(
      title: widget.lesson.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_questionIndex < 0) ...[
            _Eyebrow(widget.lesson.eyebrow),
            const SizedBox(height: 13),
            Text('THE IDEA', style: pixelHeading(25)),
            const SizedBox(height: 15),
            Text(
              widget.lesson.description,
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 24),
            _NoteCard(
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
            const Icon(Icons.verified_rounded, color: _teal, size: 68),
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
            _Eyebrow(
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
              _ChoiceButton(
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
              _NoteCard(
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

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
    required this.message,
    required this.alreadyReviewed,
    required this.onAnswered,
  });
  final PracticeMessage message;
  final bool alreadyReviewed;
  final ValueChanged<bool> onAnswered;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool? _answer;

  void _choose(bool isScam) {
    if (_answer != null) return;
    setState(() => _answer = isScam);
    widget.onAnswered(isScam == widget.message.isScam);
  }

  @override
  Widget build(BuildContext context) {
    final correct = _answer == widget.message.isScam;
    return _ActivityScaffold(
      title: 'Message check',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Eyebrow('SIMULATED ${widget.message.channel.toUpperCase()}'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: pixelPanel(pixelCream),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.subject,
                  style: pixelHeading(20),
                ),
                const SizedBox(height: 14),
                Text(
                  'From: ${widget.message.sender}',
                  style: const TextStyle(color: pixelMuted),
                ),
                const Divider(height: 32),
                SelectableText(
                  widget.message.body,
                  style: const TextStyle(fontSize: 18, height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text('SCAM OR SAFE?', style: pixelHeading(22)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: _answer == null ? () => _choose(true) : null,
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('This is a scam'),
              ),
              OutlinedButton.icon(
                onPressed: _answer == null ? () => _choose(false) : null,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('This looks legitimate'),
              ),
            ],
          ),
          if (_answer != null) ...[
            const SizedBox(height: 24),
            _NoteCard(
              icon: correct ? Icons.check_circle_outline : Icons.info_outline,
              title: correct ? 'Nice catch!' : 'Good try!',
              text: correct
                  ? '${widget.message.explanation}${!widget.alreadyReviewed ? ' +15 XP' : ''}'
                  : 'This one is ${widget.message.isScam ? 'a scam' : 'legitimate'}. ${widget.message.explanation} Use that clue next time.',
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to inbox'),
            ),
          ],
        ],
      ),
    );
  }
}

class CallPage extends StatefulWidget {
  const CallPage({
    super.key,
    required this.alreadyCompleted,
    required this.onFinished,
  });
  final bool alreadyCompleted;
  final ValueChanged<bool> onFinished;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static const _script =
      'I’m with your bank’s fraud team. There is a charge on your account. '
      'Read me the six-digit code we just sent so I can stop it.';

  bool _answered = false;
  int? _choice;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();

    _initTts();

  }

  Future<void> _initTts() async {
    //funky ehh

    // final voices = await _tts.getVoices as List?;
    // debugPrint('Voices: $voices');
    // final english = voices?.cast<Map>().firstWhere(
    //       (v) => (v['locale'] as String).toLowerCase().startsWith('en'),
    //   orElse: () => {},
    // );
    // if (english != null && english.isNotEmpty) {
    //   debugPrint("using ${english['name']} and ${english['locale']} for TTS");
    //   await _tts.setVoice({
    //     'name': english['name'] as String,
    //     'locale': english['locale'] as String,
    //   });
    // }
    _tts.setSpeechRate(0.72);
    _tts.setPitch(1.65);
  }

  void _callerAnswer() {
    setState(() => _answered = true);
    _tts.speak(_script);
  }

  void _choose(int choice) {
    _tts.stop();
    if (_choice != null) return;
    setState(() => _choice = choice);
    widget.onFinished(choice == 2);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ActivityScaffold(
        title: 'Incoming call',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: pixelPanel(_navy),
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: pixelPanel(pixelGold, shadow: false),
                    child: const Icon(Icons.call, color: pixelInk, size: 34),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'UNKNOWN CALLER',
                    style: TextStyle(
                      color: pixelCream,
                      fontFamily: 'Silkscreen',
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _answered
                        ? 'Connected · Simulation'
                        : 'Incoming call · Simulation',
                    style: const TextStyle(color: pixelMint),
                  ),
                  if (!_answered) ...[
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => _callerAnswer(),
                      icon: const Icon(Icons.call),
                      label: const Text('Answer call'),
                    ),
                  ],
                ],
              ),
            ),
            if (_answered) ...[
              const SizedBox(height: 24),
              _NoteCard(
                icon: Icons.record_voice_over_outlined,
                title: 'Caller says',
                text:
                    '“$_script”',
              ),
              const SizedBox(height: 25),
              Text('CHOOSE YOUR RESPONSE', style: pixelHeading(21)),
              const SizedBox(height: 14),
              _ChoiceButton(
                text: 'Read the code so the charge can be stopped',
                selected: _choice == 0,
                disabled: _choice != null,
                onPressed: () => _choose(0),
              ),
              const SizedBox(height: 10),
              _ChoiceButton(
                text: 'Ask the caller for their employee ID',
                selected: _choice == 1,
                disabled: _choice != null,
                onPressed: () => _choose(1),
              ),
              const SizedBox(height: 10),
              _ChoiceButton(
                text: 'Hang up and call the number on my card',
                selected: _choice == 2,
                disabled: _choice != null,
                onPressed: () => _choose(2),
              ),
              if (_choice != null) ...[
                const SizedBox(height: 24),
                _NoteCard(
                  icon: _choice == 2
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  title: _choice == 2 ? 'Safe choice' : 'Try a safer route',
                  text:
                      'A caller can spoof a bank number and invent an employee ID. Never read a one-time code aloud. Hang up, then contact your bank using the number printed on your card.${_choice == 2 && !widget.alreadyCompleted ? ' +20 XP' : ''}',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Finish simulation'),
                ),
              ],
            ],
          ],
        ),
      );
}

class _ActivityScaffold extends StatelessWidget {
  const _ActivityScaffold({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: pixelSky,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 60),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: _teal,
          fontFamily: 'Silkscreen',
          fontSize: 12,
        ),
      );
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.text,
    required this.selected,
    required this.disabled,
    required this.onPressed,
  });
  final String text;
  final bool selected;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            backgroundColor: selected ? pixelMint : pixelCream,
            disabledBackgroundColor: selected ? pixelMint : pixelCream,
            disabledForegroundColor: selected ? pixelInk : pixelMuted,
            side: const BorderSide(color: pixelInk, width: 2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
      );
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.icon,
    required this.title,
    required this.text,
  });
  final IconData icon;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: pixelPanel(pixelMint),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: _teal),
                const SizedBox(width: 9),
                Text(
                  title.toUpperCase(),
                  style:
                      const TextStyle(fontFamily: 'Silkscreen', fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(text, style: const TextStyle(height: 1.45, fontSize: 15)),
          ],
        ),
      );
}
