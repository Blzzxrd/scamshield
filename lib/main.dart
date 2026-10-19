import 'package:flutter/material.dart';

import 'data/content.dart';
import 'screens/activity_pages.dart';
import 'services/progress_store.dart';
import 'widgets/pixel_theme.dart';
import 'widgets/pixel_world.dart';

void main() => runApp(const ScamShieldApp());

const navy = pixelInk;
const teal = pixelPurple;
const mint = pixelGrass;
const pale = pixelSky;

class ScamShieldApp extends StatelessWidget {
  const ScamShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScamShield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: pixelPurple,
          primary: pixelPurple,
          secondary: pixelGrass,
          surface: pixelCream,
        ),
        scaffoldBackgroundColor: pale,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: navy,
              displayColor: navy,
            ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: pixelCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: const BorderSide(color: pixelInk, width: 2),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: pixelPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
            textStyle: const TextStyle(fontFamily: 'Silkscreen', fontSize: 12),
            side: const BorderSide(color: pixelInk, width: 2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: pixelInk,
            backgroundColor: pixelCream,
            textStyle: const TextStyle(fontFamily: 'Silkscreen', fontSize: 12),
            side: const BorderSide(color: pixelInk, width: 2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: pixelSky,
          foregroundColor: pixelInk,
          titleTextStyle: TextStyle(
            fontFamily: 'Silkscreen',
            fontSize: 18,
            color: pixelInk,
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _store = ProgressStore();
  AppProgress? _progress;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final progress = await _store.load();
    if (mounted) setState(() => _progress = progress);
  }

  void _completeLesson(String id, int correctCount) {
    final progress = _progress!;
    if (progress.completedLessons.add(id)) {
      progress.xp += 20 + correctCount * 10;
      setState(() {});
      _store.save(progress);
    }
  }

  void _reviewMessage(String id, bool correct) {
    final progress = _progress!;
    if (progress.reviewedMessages.add(id)) {
      if (correct) progress.xp += 15;
      setState(() {});
      _store.save(progress);
    }
  }

  void _finishCall(bool safeChoice) {
    final progress = _progress!;
    if (!progress.callCompleted) {
      progress.callCompleted = true;
      if (safeChoice) progress.xp += 20;
      setState(() {});
      _store.save(progress);
    }
  }

  void _openLesson(Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => LessonPage(
          lesson: lesson,
          alreadyCompleted: _progress!.completedLessons.contains(lesson.id),
          onFinished: (count) => _completeLesson(lesson.id, count),
        ),
      ),
    );
  }

  void _openMessage(PracticeMessage message) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MessagePage(
          message: message,
          alreadyReviewed: _progress!.reviewedMessages.contains(message.id),
          onAnswered: (correct) => _reviewMessage(message.id, correct),
        ),
      ),
    );
  }

  void _openCall() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CallPage(
          alreadyCompleted: _progress!.callCompleted,
          onFinished: _finishCall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    if (progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final content = switch (_tab) {
          0 => _HomeView(
              progress: progress,
              onLearn: () => setState(() => _tab = 1),
              onPractice: () => setState(() => _tab = 2),
              onOpenLesson: () => _openLesson(lessons.first),
            ),
          1 => _LearnView(progress: progress, onOpen: _openLesson),
          2 => _PracticeView(
              progress: progress,
              onOpenMessage: _openMessage,
              onOpenCall: _openCall,
            ),
          _ => _ProfileView(progress: progress),
        };
        return Scaffold(
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (wide)
                  _SideNavigation(
                    selected: _tab,
                    onSelect: (index) => setState(() => _tab = index),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            wide ? 44 : 20,
                            30,
                            wide ? 44 : 20,
                            48,
                          ),
                          child: content,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBarTheme(
                  data: NavigationBarThemeData(
                    indicatorShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: pixelInk, width: 2),
                    ),
                    iconTheme: WidgetStateProperty.resolveWith(
                      (states) => IconThemeData(
                        color: states.contains(WidgetState.selected)
                            ? pixelInk
                            : pixelCream,
                      ),
                    ),
                    labelTextStyle: WidgetStateProperty.resolveWith(
                      (states) => TextStyle(
                        fontFamily: 'Silkscreen',
                        fontSize: 10,
                        color: states.contains(WidgetState.selected)
                            ? pixelGold
                            : pixelCream,
                      ),
                    ),
                  ),
                  child: NavigationBar(
                    backgroundColor: pixelInk,
                    indicatorColor: pixelGold,
                    selectedIndex: _tab,
                    onDestinationSelected: (index) =>
                        setState(() => _tab = index),
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: 'Home'),
                      NavigationDestination(
                          icon: Icon(Icons.menu_book_outlined),
                          selectedIcon: Icon(Icons.menu_book),
                          label: 'Learn'),
                      NavigationDestination(
                          icon: Icon(Icons.shield_outlined),
                          selectedIcon: Icon(Icons.shield),
                          label: 'Practice'),
                      NavigationDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: 'Profile'),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.menu_book_rounded, 'Learn'),
      (Icons.shield_rounded, 'Practice'),
      (Icons.person_rounded, 'Profile'),
    ];
    return Container(
      width: 240,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
      decoration: const BoxDecoration(
        color: pixelInk,
        border: Border(right: BorderSide(color: pixelGold, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Brand(onDark: true),
          const SizedBox(height: 56),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration:
                    selected == i ? pixelPanel(pixelGold, shadow: false) : null,
                child: ListTile(
                  leading: Icon(
                    items[i].$1,
                    color: selected == i ? pixelInk : pixelCream,
                  ),
                  title: Text(
                    items[i].$2.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 13,
                      color: selected == i ? pixelInk : pixelCream,
                    ),
                  ),
                  onTap: () => onSelect(i),
                ),
              ),
            ),
          const Spacer(),
          const Text(
            'PRESS START. STAY SAFE.',
            style: TextStyle(
              color: pixelGold,
              fontFamily: 'Silkscreen',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: pixelPanel(pixelGold, shadow: false),
            child: const Icon(Icons.shield_rounded, color: pixelInk, size: 24),
          ),
          const SizedBox(width: 10),
          Text(
            'ScamShield',
            style: TextStyle(
              fontFamily: 'Silkscreen',
              color: onDark ? pixelCream : pixelInk,
              fontSize: 17,
            ),
          ),
        ],
      );
}

class _HomeView extends StatelessWidget {
  const _HomeView({
    required this.progress,
    required this.onLearn,
    required this.onPractice,
    required this.onOpenLesson,
  });

  final AppProgress progress;
  final VoidCallback onLearn;
  final VoidCallback onPractice;
  final VoidCallback onOpenLesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (MediaQuery.sizeOf(context).width < 900) ...[
          const _Brand(),
          const SizedBox(height: 30),
        ],
        const Text(
          'WELCOME, DEFENDER',
          style: TextStyle(
            color: pixelPurple,
            fontFamily: 'Silkscreen',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'YOUR QUEST BOARD',
          style: pixelHeading(MediaQuery.sizeOf(context).width < 600 ? 23 : 31),
        ),
        const SizedBox(height: 8),
        const Text(
          'Train your instincts with quick lessons and safe practice.',
          style: TextStyle(fontSize: 16, color: pixelMuted),
        ),
        const SizedBox(height: 26),
        PixelWorldBanner(onStart: onOpenLesson),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: pixelPanel(pixelCream),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 14,
                runSpacing: 10,
                children: [
                  const Icon(Icons.stars_rounded,
                      color: Color(0xFFE59A17), size: 32),
                  Text('LEVEL ${progress.level}', style: pixelHeading(21)),
                  Text(
                    '${progress.xp} XP  /  ${100 - progress.xp % 100} TO NEXT LEVEL',
                    style: const TextStyle(
                      fontFamily: 'Silkscreen',
                      fontSize: 12,
                      color: pixelPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              LinearProgressIndicator(
                value: progress.levelProgress,
                minHeight: 14,
                color: pixelGrass,
                backgroundColor: pixelMint,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth =
                constraints.maxWidth < 600 ? constraints.maxWidth : 190.0;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatCard(
                  width: cardWidth,
                  icon: Icons.bolt_rounded,
                  value: '${progress.xp}',
                  label: 'Total XP',
                ),
                _StatCard(
                  width: cardWidth,
                  icon: Icons.menu_book_rounded,
                  value:
                      '${progress.completedLessons.length}/${lessons.length}',
                  label: 'Lessons done',
                ),
                _StatCard(
                  width: cardWidth,
                  icon: Icons.mark_email_read_rounded,
                  value:
                      '${progress.reviewedMessages.length}/${practiceMessages.length}',
                  label: 'Messages reviewed',
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),
        _SectionHeading(
          title: 'Start here',
          subtitle: 'Just a few minutes can make a difference.',
        ),
        const SizedBox(height: 16),
        _ActionCard(
          icon: Icons.auto_stories_rounded,
          title: progress.completedLessons.contains('basics')
              ? 'Keep learning'
              : 'Your first lesson',
          subtitle: 'Spot the warning signs in everyday messages.',
          button: 'Start lesson',
          onPressed: onOpenLesson,
        ),
        const SizedBox(height: 14),
        _ActionCard(
          icon: Icons.sms_outlined,
          title: 'Test your instincts',
          subtitle: 'Sort simulated messages into scam or safe.',
          button: 'Try practice',
          onPressed: onPractice,
        ),
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: onLearn,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Browse all lessons'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.width,
    required this.icon,
    required this.value,
    required this.label,
  });
  final double width;
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: pixelPanel(pixelCream),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: pixelPurple),
            const SizedBox(height: 14),
            Text(
              value,
              style: pixelHeading(25),
            ),
            Text(label.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Silkscreen', fontSize: 11, color: pixelMuted)),
          ],
        ),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: pixelHeading(22),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: pixelMuted)),
        ],
      );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String button;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: pixelPanel(pixelCream),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: pixelPanel(pixelGold, shadow: false),
                  child: Icon(icon, color: pixelInk),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Silkscreen',
                          fontSize: 16,
                          color: pixelInk,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(color: pixelMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            FilledButton(onPressed: onPressed, child: Text(button)),
          ],
        ),
      );
}

class _LearnView extends StatelessWidget {
  const _LearnView({required this.progress, required this.onOpen});
  final AppProgress progress;
  final ValueChanged<Lesson> onOpen;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Learn the patterns',
            subtitle: 'Short lessons. Clear examples. Better instincts.',
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < lessons.length; i++) ...[
            _ActionCard(
              icon: i == 0
                  ? Icons.visibility_rounded
                  : Icons.mail_outline_rounded,
              title: lessons[i].title,
              subtitle:
                  '${lessons[i].eyebrow} · ${progress.completedLessons.contains(lessons[i].id) ? 'Completed' : 'Earn up to 50 XP'}',
              button: progress.completedLessons.contains(lessons[i].id)
                  ? 'Review'
                  : 'Begin',
              onPressed: () => onOpen(lessons[i]),
            ),
            const SizedBox(height: 14),
          ],
        ],
      );
}

class _PracticeView extends StatelessWidget {
  const _PracticeView({
    required this.progress,
    required this.onOpenMessage,
    required this.onOpenCall,
  });
  final AppProgress progress;
  final ValueChanged<PracticeMessage> onOpenMessage;
  final VoidCallback onOpenCall;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Practice safely',
            subtitle: 'Every message and call here is fictional.',
          ),
          const SizedBox(height: 24),
          _ActionCard(
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
            'SIMULATED INBOX',
            style: TextStyle(
                fontFamily: 'Silkscreen', fontSize: 22, color: pixelInk),
          ),
          const SizedBox(height: 4),
          const Text(
            'Open a message, make your call, and read the explanation.',
            style: TextStyle(color: pixelMuted),
          ),
          const SizedBox(height: 16),
          for (final message in practiceMessages) ...[
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
                  child: Icon(
                    message.channel == 'Email'
                        ? Icons.mail_outline
                        : Icons.sms_outlined,
                    color: pixelPurple,
                  ),
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

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.progress});
  final AppProgress progress;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Your progress',
            subtitle: 'Every safe decision strengthens your instincts.',
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: pixelPanel(pixelCream),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: pixelPanel(pixelGold, shadow: false),
                      child:
                          const Icon(Icons.shield, color: pixelInk, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${progress.level} defender',
                          style: pixelHeading(19),
                        ),
                        Text(
                          '${progress.xp} XP earned',
                          style: const TextStyle(color: pixelMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                LinearProgressIndicator(
                  value: progress.levelProgress,
                  minHeight: 12,
                  color: pixelGrass,
                  backgroundColor: pixelMint,
                ),
                const SizedBox(height: 8),
                Text(
                  '${100 - progress.xp % 100} XP to level ${progress.level + 1}',
                  style: const TextStyle(color: pixelMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'ACHIEVEMENTS',
            style: TextStyle(
                fontFamily: 'Silkscreen', fontSize: 22, color: pixelInk),
          ),
          const SizedBox(height: 14),
          _Badge(
            title: 'First steps',
            subtitle: 'Complete your first lesson',
            unlocked: progress.completedLessons.isNotEmpty,
            icon: Icons.auto_stories,
          ),
          _Badge(
            title: 'Sharp eye',
            subtitle: 'Review all four messages',
            unlocked:
                progress.reviewedMessages.length == practiceMessages.length,
            icon: Icons.visibility,
          ),
          _Badge(
            title: 'Calm under pressure',
            subtitle: 'Complete the phone simulation',
            unlocked: progress.callCompleted,
            icon: Icons.call,
          ),
          const SizedBox(height: 24),
          const Text(
            'Progress is saved in this browser.',
            style: TextStyle(color: pixelMuted),
          ),
        ],
      );
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.title,
    required this.subtitle,
    required this.unlocked,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final bool unlocked;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          leading: Container(
            width: 42,
            height: 42,
            decoration:
                pixelPanel(unlocked ? pixelGold : pixelMint, shadow: false),
            child: Icon(icon, color: unlocked ? pixelInk : pixelMuted),
          ),
          title: Text(title.toUpperCase(),
              style: const TextStyle(fontFamily: 'Silkscreen', fontSize: 14)),
          subtitle: Text(subtitle),
          trailing: Text(
            unlocked ? 'Unlocked' : 'Locked',
            style: TextStyle(
              color: unlocked ? pixelPurple : pixelMuted,
              fontFamily: 'Silkscreen',
              fontSize: 11,
            ),
          ),
        ),
      );
}
