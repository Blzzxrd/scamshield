import 'package:flutter/material.dart';

import '../interface/activity_widgets.dart';
import '../interface/pixel_theme.dart';

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
  bool _answered = false;
  int? _choice;

  void _choose(int choice) {
    if (_choice != null) return;
    setState(() => _choice = choice);
    widget.onFinished(choice == 2);
  }

  @override
  Widget build(BuildContext context) => ActivityScaffold(
        title: 'Incoming call',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: pixelPanel(pixelInk),
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
                      onPressed: () => setState(() => _answered = true),
                      icon: const Icon(Icons.call),
                      label: const Text('Answer call'),
                    ),
                  ],
                ],
              ),
            ),
            if (_answered) ...[
              const SizedBox(height: 24),
              NoteCard(
                icon: Icons.record_voice_over_outlined,
                title: 'Caller says',
                text:
                    '“I’m with your bank’s fraud team. There is a charge on your account. Read me the six-digit code we just sent so I can stop it.”',
              ),
              const SizedBox(height: 25),
              Text('CHOOSE YOUR RESPONSE', style: pixelHeading(21)),
              const SizedBox(height: 14),
              ChoiceButton(
                text: 'Read the code so the charge can be stopped',
                selected: _choice == 0,
                disabled: _choice != null,
                onPressed: () => _choose(0),
              ),
              const SizedBox(height: 10),
              ChoiceButton(
                text: 'Ask the caller for their employee ID',
                selected: _choice == 1,
                disabled: _choice != null,
                onPressed: () => _choose(1),
              ),
              const SizedBox(height: 10),
              ChoiceButton(
                text: 'Hang up and call the number on my card',
                selected: _choice == 2,
                disabled: _choice != null,
                onPressed: () => _choose(2),
              ),
              if (_choice != null) ...[
                const SizedBox(height: 24),
                NoteCard(
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
