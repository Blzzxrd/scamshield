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
    required this.scenario,
    required this.alreadyCompleted,
    required this.onFinished,
  });

  final PracticeCall scenario;
  final bool alreadyCompleted;
  final ValueChanged<bool> onFinished;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late String _nodeId;
  CallChoice? _selected;
  bool _finished = false;
  bool _answered = false;
  bool _isSpeaking = false;
  double _speechRate = 0.75;
  final FlutterTts _tts = FlutterTts();
  late final Future<void> _ttsReady;

  @override
  void initState() {
    super.initState();
    _nodeId = widget.scenario.startNode;
    _ttsReady = _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setSpeechRate(_speechRate);
    await _tts.setPitch(1.65);
    await _tts.awaitSpeakCompletion(true);
    _tts.setStartHandler(() {
      if (mounted) setState(() => _isSpeaking = true);
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _answerCall() async {
    final node = widget.scenario.nodes[_nodeId]!;
    setState(() => _answered = true);
    await _speak(node.callerLine);
  }

  Future<void> _choose(CallChoice choice) async {
    if (_selected != null || _finished || _isSpeaking) return;
    setState(() => _selected = choice);
    await _speak(choice.response);
  }

  Future<void> _continue() async {
    final choice = _selected;
    if (choice == null || _finished || _isSpeaking) return;

    final nextNode = choice.nextNode;
    if (nextNode != null) {
      final nextLine = widget.scenario.nodes[nextNode]!.callerLine;
      setState(() {
        _nodeId = nextNode;
        _selected = null;
      });
      await _speak(nextLine);
      return;
    }

    setState(() => _finished = true);
    widget.onFinished(choice.safeEnding);
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;
    setState(() => _isSpeaking = true);
    try {
      await _ttsReady;
      if (!mounted) return;
      await _tts.setSpeechRate(_speechRate);
      await _tts.speak(text);
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.scenario.nodes[_nodeId]!;
    final selected = _selected;

    return _ActivityScaffold(
      title: widget.scenario.caller,
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
                Text(
                  widget.scenario.caller.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                    onPressed: _isSpeaking ? null : _answerCall,
                    icon: const Icon(Icons.call),
                    label: const Text('Answer call'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            decoration: pixelPanel(pixelCream),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.record_voice_over_outlined,
                        color: pixelInk, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('VOICE SPEED', style: pixelHeading(16)),
                    ),
                    Text('${_speechRate.toStringAsFixed(2)}×',
                        style: pixelHeading(15)),
                  ],
                ),
                Slider(
                  value: _speechRate,
                  min: 0.5,
                  max: 1.5,
                  divisions: 20,
                  label: '${_speechRate.toStringAsFixed(2)}×',
                  activeColor: pixelPurple,
                  inactiveColor: pixelMint,
                  semanticFormatterCallback: (value) =>
                      'Voice speed ${value.toStringAsFixed(2)} times normal',
                  onChanged: (value) => setState(() => _speechRate = value),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SLOWER',
                        style: TextStyle(
                          fontFamily: 'Silkscreen',
                          fontSize: 11,
                          color: pixelMuted,
                        )),
                    Text('FASTER',
                        style: TextStyle(
                          fontFamily: 'Silkscreen',
                          fontSize: 11,
                          color: pixelMuted,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Applies to the next spoken line.',
                    style: TextStyle(color: pixelMuted, fontSize: 13)),
                if (_answered) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed:
                        _isSpeaking ? null : () => _speak(node.callerLine),
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Replay caller line'),
                  ),
                ],
              ],
            ),
          ),
          if (_answered) ...[
            const SizedBox(height: 24),
            _NoteCard(
              icon: Icons.record_voice_over_outlined,
              title: widget.scenario.caller,
              text: '“${node.callerLine}”',
            ),
            if (_finished && selected != null) ...[
              const SizedBox(height: 24),
              _NoteCard(
                icon: selected.safeEnding
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
                title:
                    selected.safeEnding ? 'Safe choice' : 'Try a safer route',
                text: '${selected.explanation ?? ''}'
                    '${selected.safeEnding && !widget.alreadyCompleted ? ' +20 XP' : ''}',
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Finish simulation'),
              ),
            ] else if (selected != null) ...[
              const SizedBox(height: 16),
              _NoteCard(
                icon: Icons.chat_bubble_outline,
                title: 'You ask',
                text: selected.question,
              ),
              const SizedBox(height: 12),
              _NoteCard(
                icon: Icons.record_voice_over_outlined,
                title: 'Caller replies',
                text: selected.response,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isSpeaking ? null : _continue,
                child: const Text('Continue'),
              ),
            ] else ...[
              const SizedBox(height: 25),
              Text('CHOOSE A QUESTION', style: pixelHeading(21)),
              const SizedBox(height: 14),
              for (final choice in node.choices) ...[
                _ChoiceButton(
                  text: choice.question,
                  selected: false,
                  disabled: false,
                  onPressed: () => _choose(choice),
                ),
                const SizedBox(height: 10),
              ],
            ]
          ],
        ],
      ),
    );
  }
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
