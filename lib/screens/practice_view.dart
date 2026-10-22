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
  final ValueChanged<bool> onOpenTextSimulation;
  final VoidCallback onOpenCall;

  @override
  State<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends State<PracticeView> {
  // Tab states: false = Inbox / Pending, true = Completed
  bool _showCompletedTexts = false;
  bool _showCompletedCalls = false;
  bool _showCompletedEmails = false;

  @override
  Widget build(BuildContext context) {
    // Categorize Messages by Channel
    final textMessages = widget.practiceMessages
        .where((message) => message.channel == 'Text')
        .toList();

    final pendingTexts = textMessages
        .where((m) => !widget.progress.reviewedMessages.contains(m.id))
        .toList();
    final completedTexts = textMessages
        .where((m) => widget.progress.reviewedMessages.contains(m.id))
        .toList();

    final emailMessages = widget.practiceMessages
        .where((message) => message.channel == 'Email')
        .toList();

    final pendingEmails = emailMessages
        .where((m) => !widget.progress.reviewedMessages.contains(m.id))
        .toList();
    final completedEmails = emailMessages
        .where((m) => widget.progress.reviewedMessages.contains(m.id))
        .toList();

    final currentEmails =
        _showCompletedEmails ? completedEmails : pendingEmails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          title: 'Practice safely',
          subtitle: 'Every message and call here is fictional.',
        ),
        const SizedBox(height: 24),

        // ---------------------------------------------------------------------
        // SECTION 1: TEXT SIMULATION
        // ---------------------------------------------------------------------
        const Text(
          'TEXT MESSAGE SIMULATION',
          style: TextStyle(
              fontFamily: 'Silkscreen', fontSize: 20, color: pixelInk),
        ),
        const SizedBox(height: 10),
        _buildToggleBar(
          leftLabel: 'PENDING (${pendingTexts.length})',
          rightLabel: 'COMPLETED (${completedTexts.length})',
          showRight: _showCompletedTexts,
          onToggle: (showRight) =>
              setState(() => _showCompletedTexts = showRight),
        ),
        const SizedBox(height: 14),
        if (!_showCompletedTexts) ...[
          if (pendingTexts.isNotEmpty)
            ActionCard(
              icon: Icons.sms_rounded,
              title: 'Text imitation',
              subtitle:
                  '${pendingTexts.length} new text scenario(s) waiting for review.',
              button: 'Open phone',
              onPressed: () => widget.onOpenTextSimulation(false),
            )
          else
            _buildEmptyState('All texts completed! Check the completed tab.'),
        ] else ...[
          if (completedTexts.isNotEmpty)
            ActionCard(
              icon: Icons.sms_rounded,
              title: 'Replay texts',
              subtitle:
                  'You have reviewed ${completedTexts.length} text message(s).',
              button: 'Replay phone',
              onPressed: () => widget.onOpenTextSimulation(true),
            )
          else
            _buildEmptyState('No completed text scenarios yet.'),
        ],

        const SizedBox(height: 32),

        // ---------------------------------------------------------------------
        // SECTION 2: PHONE CALL SIMULATION
        // ---------------------------------------------------------------------
        const Text(
          'PHONE CALL SIMULATION',
          style: TextStyle(
              fontFamily: 'Silkscreen', fontSize: 20, color: pixelInk),
        ),
        const SizedBox(height: 10),
        _buildToggleBar(
          leftLabel: 'PENDING (${widget.progress.callCompleted ? 0 : 1})',
          rightLabel: 'COMPLETED (${widget.progress.callCompleted ? 1 : 0})',
          showRight: _showCompletedCalls,
          onToggle: (showRight) =>
              setState(() => _showCompletedCalls = showRight),
        ),
        const SizedBox(height: 14),
        if (!_showCompletedCalls) ...[
          if (!widget.progress.callCompleted)
            ActionCard(
              icon: Icons.call_rounded,
              title: 'Incoming call simulation',
              subtitle: 'A “bank” caller asks you to act fast.',
              button: 'Answer call',
              onPressed: widget.onOpenCall,
            )
          else
            _buildEmptyState(
                'Call scenario completed! Check the completed tab.'),
        ] else ...[
          if (widget.progress.callCompleted)
            ActionCard(
              icon: Icons.call_rounded,
              title: 'Incoming call simulation',
              subtitle: 'Completed · Replay the scenario anytime.',
              button: 'Replay call',
              onPressed: widget.onOpenCall,
            )
          else
            _buildEmptyState('No completed call scenarios yet.'),
        ],

        const SizedBox(height: 32),

        // ---------------------------------------------------------------------
        // SECTION 3: EMAIL INBOX
        // ---------------------------------------------------------------------
        const Text(
          'SIMULATED EMAIL INBOX',
          style: TextStyle(
              fontFamily: 'Silkscreen', fontSize: 20, color: pixelInk),
        ),
        const SizedBox(height: 4),
        const Text(
          'Open an email and decide whether it looks safe.',
          style: TextStyle(color: pixelMuted),
        ),
        const SizedBox(height: 10),
        _buildToggleBar(
          leftLabel: 'INBOX (${pendingEmails.length})',
          rightLabel: 'COMPLETED (${completedEmails.length})',
          showRight: _showCompletedEmails,
          onToggle: (showRight) =>
              setState(() => _showCompletedEmails = showRight),
        ),
        const SizedBox(height: 16),
        if (currentEmails.isEmpty)
          _buildEmptyState(
            _showCompletedEmails
                ? 'No completed emails yet.'
                : 'All caught up! No pending emails.',
          )
        else
          for (final message in currentEmails) ...[
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

  /// Helper widget to render pixel-styled tab toggles.
  Widget _buildToggleBar({
    required String leftLabel,
    required String rightLabel,
    required bool showRight,
    required ValueChanged<bool> onToggle,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: pixelPanel(
                !showRight ? pixelGold : pixelCream,
                shadow: false,
              ),
              alignment: Alignment.center,
              child: Text(
                leftLabel,
                style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 11,
                  color: pixelInk,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: pixelPanel(
                showRight ? pixelGold : pixelCream,
                shadow: false,
              ),
              alignment: Alignment.center,
              child: Text(
                rightLabel,
                style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 11,
                  color: pixelInk,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper widget for rendering empty state cards.
  Widget _buildEmptyState(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: pixelPanel(pixelCream),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: pixelMuted,
          fontFamily: 'Silkscreen',
          fontSize: 12,
        ),
      ),
    );
  }
}
