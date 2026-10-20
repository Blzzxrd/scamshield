import 'package:flutter/material.dart';

import '../../data/practice_messages.dart';
import '../../models/practice_message.dart';
import '../../services/progress_store.dart';
import '../interface/pixel_theme.dart';
import '../interface/quest_widgets.dart';

class PracticeView extends StatelessWidget {
  const PracticeView({
    super.key,
    required this.progress,
    required this.onOpenMessage,
    required this.onOpenTextSimulation,
    required this.onOpenCall,
  });
  final AppProgress progress;
  final ValueChanged<PracticeMessage> onOpenMessage;
  final VoidCallback onOpenTextSimulation;
  final VoidCallback onOpenCall;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Practice safely',
            subtitle: 'Every message and call here is fictional.',
          ),
          const SizedBox(height: 24),
          ActionCard(
            icon: Icons.sms_rounded,
            title: 'Text imitation',
            subtitle: 'Watch simulated texts arrive on a phone.',
            button: 'Open phone',
            onPressed: onOpenTextSimulation,
          ),
          const SizedBox(height: 14),
          ActionCard(
            icon: Icons.call_rounded,
            title: 'Incoming call simulation',
            subtitle: progress.callCompleted
                ? 'Completed · Replay the scenario'
                : 'A “bank” caller asks you to act fast.',
            button: 'Answer call',
            onPressed: onOpenCall,
          ),
          const SizedBox(height: 30),
          const Text(
            'SIMULATED EMAIL INBOX',
            style: TextStyle(
                fontFamily: 'Silkscreen', fontSize: 22, color: pixelInk),
          ),
          const SizedBox(height: 4),
          const Text(
            'Open an email and decide whether it looks safe.',
            style: TextStyle(color: pixelMuted),
          ),
          const SizedBox(height: 16),
          for (final message in practiceMessages
              .where((message) => message.channel == 'Email')) ...[
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: pixelPanel(pixelMint, shadow: false),
                  child: const Icon(Icons.mail_outline, color: pixelPurple),
                ),
                title: Text(
                  message.subject,
                  style:
                      const TextStyle(fontFamily: 'Silkscreen', fontSize: 14),
                ),
                subtitle: Text(
                  '${message.channel} · ${message.sender}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: progress.reviewedMessages.contains(message.id)
                    ? const Icon(Icons.check_circle, color: pixelPurple)
                    : const Icon(Icons.chevron_right),
                onTap: () => onOpenMessage(message),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      );
}
