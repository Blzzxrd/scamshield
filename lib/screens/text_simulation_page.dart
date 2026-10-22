import 'dart:async';

import 'package:flutter/material.dart';

import '../data/content.dart';
import '../widgets/pixel_theme.dart';

/// A phone-shaped preview for the text practice scenarios.
class TextSimulationPage extends StatefulWidget {
  const TextSimulationPage({
    super.key,
    required this.reviewedMessages,
    required this.onAnswered,
    required this.replayCompleted,
  });

  final Set<String> reviewedMessages;
  final int Function(PracticeMessage message, bool correct) onAnswered;
  final bool replayCompleted; //whether to include completed or not completed

  @override
  State<TextSimulationPage> createState() => _TextSimulationPageState();
}

class _TextSimulationPageState extends State<TextSimulationPage> {
  late Future<List<PracticeMessage>> _messagesFuture;

  List<PracticeMessage>? _texts;
  int _index = 0;
  bool _arriving = false;
  bool? _answer;
  int _earnedXp = 0;
  bool _replayed = false;
  Timer? _arrivalTimer;

  @override
  void initState() {
    super.initState();
    _messagesFuture = ContentLoader.loadPracticeMessages().then((messages) {
      final filtered = messages
          .where((message) => message.channel == 'Text' &&
        (widget.reviewedMessages.contains(message.id) == widget.replayCompleted)) //prevent old messages from recurring
          .toList()
          .reversed
          .toList();
      setState(() {
        _texts = filtered;
      });
      return filtered;
    });
  }

  @override
  void dispose() {
    _arrivalTimer?.cancel();
    super.dispose();
  }

  void _showNextText() {
    if (_arriving || _texts == null || _texts!.isEmpty) return;
    setState(() => _arriving = true);
    _arrivalTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _index = (_index + 1) % _texts!.length;
        _arriving = false;
        _answer = null;
        _earnedXp = 0;
        _replayed = false;
      });
    });
  }

  void _answerText(PracticeMessage message, bool isScam) {
    if (_answer != null || _arriving) return;
    final replayed = widget.reviewedMessages.contains(message.id);
    final earnedXp = widget.onAnswered(message, isScam == message.isScam);
    setState(() {
      _answer = isScam;
      _earnedXp = earnedXp;
      _replayed = replayed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(title: const Text('Text imitation')),
      body: SafeArea(
        child: FutureBuilder<List<PracticeMessage>>(
          future: _messagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading messages: ${snapshot.error}'),
              );
            } else if (_texts == null || _texts!.isEmpty) {
              return const Center(child: Text('No text messages available.'));
            }

            final message = _texts![_index];
            final correct = _answer == message.isScam;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                    child: Column(
                      children: [
                        Text(
                          'TEXT MESSAGE SIMULATOR',
                          textAlign: TextAlign.center,
                          style: pixelHeading(width < 520 ? 22 : 29),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'A safe preview of how suspicious and everyday texts can appear.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: pixelMuted, fontSize: 15),
                        ),
                        const SizedBox(height: 24),
                        _PhonePreview(
                          message: message,
                          arriving: _arriving,
                          number: _index + 1,
                          total: _texts!.length,
                        ),
                        const SizedBox(height: 25),
                        Text('SCAM OR SAFE?', style: pixelHeading(19)),
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: _arriving || _answer != null
                                  ? null
                                  : () => _answerText(message, true),
                              icon: const Icon(Icons.warning_amber_rounded),
                              label: const Text('This is a scam'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _arriving || _answer != null
                                  ? null
                                  : () => _answerText(message, false),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text('This looks safe'),
                            ),
                          ],
                        ),
                        if (_answer != null) ...[
                          const SizedBox(height: 18),
                          Container(
                            width: 390,
                            padding: const EdgeInsets.all(17),
                            decoration:
                                pixelPanel(correct ? pixelMint : pixelGold),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  correct
                                      ? 'NICE CATCH!'
                                      : 'GOOD TRY — KEEP GOING!',
                                  style: pixelHeading(16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  correct
                                      ? message.explanation
                                      : 'This one is ${message.isScam ? 'a scam' : 'legitimate'}. ${message.explanation} You can use that clue on the next text.',
                                  style: const TextStyle(
                                      fontSize: 15, height: 1.4),
                                ),
                                if (_earnedXp > 0) ...[
                                  const SizedBox(height: 10),
                                  Text('+$_earnedXp XP',
                                      style: pixelHeading(13)),
                                ] else if (_replayed) ...[
                                  const SizedBox(height: 10),
                                  const Text(
                                      'This text was already counted on Home.'),
                                ],
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        OutlinedButton.icon(
                          onPressed: _arriving ? null : _showNextText,
                          icon: const Icon(Icons.sms_outlined),
                          label: const Text('Send next text'),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'These messages are fictional. Nothing is sent to a real phone.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: pixelMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PhonePreview extends StatelessWidget {
  const _PhonePreview({
    required this.message,
    required this.arriving,
    required this.number,
    required this.total,
  });

  final PracticeMessage message;
  final bool arriving;
  final int number;
  final int total;

  @override
  Widget build(BuildContext context) => Container(
        width: 390,
        height: 500,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: pixelInk,
          border: Border.all(color: pixelInk, width: 3),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [BoxShadow(color: pixelInk, offset: Offset(7, 7))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: ColoredBox(
            color: pixelCream,
            child: Column(
              children: [
                Container(
                  height: 37,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: pixelSky,
                  child: const Row(
                    children: [
                      Text('9:41',
                          style: TextStyle(
                              fontFamily: 'Silkscreen', fontSize: 11)),
                      Spacer(),
                      Icon(Icons.signal_cellular_alt, size: 16),
                      SizedBox(width: 6),
                      Icon(Icons.wifi, size: 16),
                      SizedBox(width: 6),
                      Icon(Icons.battery_full, size: 18),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                  decoration: const BoxDecoration(
                    color: pixelCream,
                    border: Border(
                      bottom: BorderSide(color: pixelInk, width: 2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: pixelPanel(pixelGold, shadow: false),
                        child:
                            const Icon(Icons.person, color: pixelInk, size: 25),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.sender,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Silkscreen',
                                fontSize: 12,
                                color: pixelInk,
                              ),
                            ),
                            const Text('Text message',
                                style:
                                    TextStyle(color: pixelMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: pixelInk),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: pixelSky,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            'TODAY  ·  TEXT $number OF $total',
                            style: const TextStyle(
                              fontFamily: 'Silkscreen',
                              fontSize: 10,
                              color: pixelMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: arriving
                                ? const Center(
                                    key: ValueKey('arriving'),
                                    child: Text(
                                      'INCOMING TEXT...',
                                      style: TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 13,
                                        color: pixelPurple,
                                      ),
                                    ),
                                  )
                                : Align(
                                    key: ValueKey(message.id),
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 32, 42, 16),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: pixelPanel(pixelMint),
                                        child: SelectableText(
                                          message.body,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            height: 1.4,
                                            color: pixelInk,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    color: pixelCream,
                    border: Border(top: BorderSide(color: pixelInk, width: 2)),
                  ),
                  child: const Text(
                    'SIMULATION ONLY  ·  REPLIES DISABLED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 10,
                      color: pixelMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
