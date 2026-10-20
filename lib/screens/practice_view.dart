import 'package:flutter/material.dart';
import '../data/content.dart';
import '../services/progress_store.dart';
import '../widgets/pixel_theme.dart';
import '../widgets/shared_cards.dart';

class PracticeView extends StatefulWidget {
  const PracticeView({
    super.key,
    required this.progress,
    required this.practiceMessages,
    required this.onOpenMessage,
    required this.onOpenTextSimulation,
    required this.onOpenCall,
  });

  final AppProgress progress;
  final List<PracticeMessage> practiceMessages;
  final ValueChanged<PracticeMessage> onOpenMessage;
  final VoidCallback onOpenTextSimulation;
  final VoidCallback onOpenCall;

  @override
  State<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<PracticeView> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    // Filter email messages
    final emailMessages = widget.practiceMessages
        .where((message) => message.channel == 'Email')
        .toList();

    final inboxMessages = emailMessages
        .where(
            (message) => !widget.progress.reviewedMessages.contains(message.id))
        .toList();

    final completedMessages = emailMessages
        .where(
            (message) => widget.progress.reviewedMessages.contains(message.id))
        .toList();

    final currentList = _showCompleted ? completedMessages : inboxMessages;

    return Column(
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
          onPressed: widget.onOpenTextSimulation,
        ),
        const SizedBox(height: 14),
        ActionCard(
          icon: Icons.call_rounded,
          title: 'Incoming call simulation',
          subtitle: widget.progress.callCompleted
              ? 'Completed · Replay the scenario'
              : 'A “bank” caller asks you to act fast.',
          button: 'Answer call',
          onPressed: widget.onOpenCall,
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
        // Toggle Switcher for Inbox / Completed Tabs
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showCompleted = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: pixelPanel(
                    !_showCompleted ? pixelGold : pixelCream,
                    shadow: false,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'INBOX (${inboxMessages.length})',
                    style: const TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 12,
                      color: pixelInk,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showCompleted = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: pixelPanel(
                    _showCompleted ? pixelGold : pixelCream,
                    shadow: false,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'COMPLETED (${completedMessages.length})',
                    style: const TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 12,
                      color: pixelInk,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (currentList.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: pixelPanel(pixelCream),
            alignment: Alignment.center,
            child: Text(
              _showCompleted
                  ? 'No completed emails yet.'
                  : 'All caught up! No pending emails.',
              style: const TextStyle(
                color: pixelMuted,
                fontFamily: 'Silkscreen',
                fontSize: 13,
              ),
            ),
          )
        else
          for (final message in currentList) ...[
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
                trailing: widget.progress.reviewedMessages.contains(message.id)
                    ? const Icon(Icons.check_circle, color: pixelPurple)
                    : const Icon(Icons.chevron_right),
                onTap: () => widget.onOpenMessage(message),
              ),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}
