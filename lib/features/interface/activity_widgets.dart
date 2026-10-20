import 'package:flutter/material.dart';

import 'pixel_theme.dart';

class ActivityScaffold extends StatelessWidget {
  const ActivityScaffold({super.key, required this.title, required this.child});
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

class ActivityEyebrow extends StatelessWidget {
  const ActivityEyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: pixelPurple,
          fontFamily: 'Silkscreen',
          fontSize: 12,
        ),
      );
}

class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
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

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
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
                Icon(icon, color: pixelPurple),
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
