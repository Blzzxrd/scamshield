import 'package:flutter/material.dart';

import '../../models/practice_message.dart';
import '../interface/activity_widgets.dart';
import '../interface/pixel_theme.dart';

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
    return ActivityScaffold(
      title: 'Message check',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActivityEyebrow('SIMULATED ${widget.message.channel.toUpperCase()}'),
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
            NoteCard(
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
