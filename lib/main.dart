import 'package:flutter/material.dart';

import 'data/content.dart';
import 'screens/activity_pages.dart';
import 'services/progress_store.dart';

void main() => runApp(const ScamShieldApp());

const navy = Color(0xFF102B45);
const teal = Color(0xFF087F8C);
const mint = Color(0xFF5DE0BB);
const pale = Color(0xFFF4F8FA);

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
          seedColor: teal,
          primary: teal,
          secondary: mint,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: pale,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: navy,
              displayColor: navy,
            ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
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
              children: [
                if (wide)
                  _SideNavigation(
                    selected: _tab,
                    onSelect: (index) => setState(() => _tab = index),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
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
              : NavigationBar(
                  selectedIndex: _tab,
                  onDestinationSelected: (index) =>
                      setState(() => _tab = index),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: 'Learn',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.shield_outlined),
                      selectedIcon: Icon(Icons.shield),
                      label: 'Practice',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
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
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Brand(),
          const SizedBox(height: 56),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(items[i].$1),
                title: Text(items[i].$2),
                selected: selected == i,
                selectedTileColor: const Color(0xFFE5F5F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onTap: () => onSelect(i),
              ),
            ),
          const Spacer(),
          const Text(
            'Small steps. Safer choices.',
            style: TextStyle(color: Color(0xFF667A8C)),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: teal,
              borderRadius: BorderRadius.circular(13),
            ),
            child:
                const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          const Text(
            'ScamShield',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
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
          'WELCOME TO YOUR SAFER INTERNET',
          style: TextStyle(
            color: teal,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Learn to spot the signs.',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.2),
        ),
        const SizedBox(height: 8),
        const Text(
          'Build your scam spotting skills with quick lessons and safe practice.',
          style: TextStyle(fontSize: 16, color: Color(0xFF617587)),
        ),
        const SizedBox(height: 26),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [navy, Color(0xFF14596B)]),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              SizedBox(
                width: 390,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'YOUR LEARNING JOURNEY',
                      style: TextStyle(
                        color: mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Level ${progress.level} defender',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${progress.xp} XP earned · ${100 - progress.xp % 100} XP to next level',
                      style: const TextStyle(color: Color(0xFFD0E9EC)),
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: progress.levelProgress,
                      minHeight: 9,
                      borderRadius: BorderRadius.circular(10),
                      color: mint,
                      backgroundColor: const Color(0xFF427080),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.verified_user_rounded, size: 92, color: mint),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: teal),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            Text(label, style: const TextStyle(color: Color(0xFF617587))),
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
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF617587))),
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
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
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F5F4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: teal),
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Color(0xFF617587)),
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
            'Simulated inbox',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Open a message, make your call, and read the explanation.',
            style: TextStyle(color: Color(0xFF617587)),
          ),
          const SizedBox(height: 16),
          for (final message in practiceMessages) ...[
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE5F5F4),
                  child: Icon(
                    message.channel == 'Email'
                        ? Icons.mail_outline
                        : Icons.sms_outlined,
                    color: teal,
                  ),
                ),
                title: Text(
                  message.subject,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${message.channel} · ${message.sender}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: progress.reviewedMessages.contains(message.id)
                    ? const Icon(Icons.check_circle, color: teal)
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xFFE5F5F4),
                      child: Icon(Icons.shield, color: teal, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${progress.level} defender',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${progress.xp} XP earned',
                          style: const TextStyle(color: Color(0xFF617587)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                LinearProgressIndicator(
                  value: progress.levelProgress,
                  minHeight: 9,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 8),
                Text(
                  '${100 - progress.xp % 100} XP to level ${progress.level + 1}',
                  style: const TextStyle(color: Color(0xFF617587)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Achievements',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
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
            style: TextStyle(color: Color(0xFF617587)),
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
          leading: CircleAvatar(
            backgroundColor:
                unlocked ? const Color(0xFFE5F5F4) : const Color(0xFFF0F3F5),
            child: Icon(icon, color: unlocked ? teal : const Color(0xFF93A3AE)),
          ),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: Text(
            unlocked ? 'Unlocked' : 'Locked',
            style: TextStyle(
              color: unlocked ? teal : const Color(0xFF93A3AE),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
