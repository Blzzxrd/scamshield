import 'package:flutter/material.dart';

import 'data/content.dart';
import 'screens/activity_pages.dart';
import 'screens/text_simulation_page.dart';
import 'services/progress_store.dart';
import 'widgets/pixel_theme.dart';
import 'widgets/pixel_world.dart';

import 'screens/home_view.dart';
import 'screens/learn_view.dart';
import 'screens/practice_view.dart';
import 'screens/profile_view.dart';
import 'widgets/side_navigation.dart';

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
        cardTheme: const CardThemeData(
          elevation: 0,
          color: pixelCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: pixelInk, width: 2),
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
  List<Lesson>? _lessons;
  List<PracticeMessage>? _practiceMessages;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final progress = await _store.load();
    final lessons = await ContentLoader.loadLessons();
    final practiceMessages = await ContentLoader.loadPracticeMessages();

    if (mounted) {
      setState(() {
        _progress = progress;
        _lessons = lessons;
        _practiceMessages = practiceMessages;
      });
    }
  }

  void _completeLesson(String id, int correctCount) {
    final progress = _progress!;
    if (progress.completedLessons.add(id)) {
      progress.xp += 20 + correctCount * 10;
      setState(() {});
      _store.save(progress);
    }
  }

  int _reviewMessage(String id, bool correct) {
    final progress = _progress!;
    if (progress.reviewedMessages.contains(id)) return 0;
    final earnedXp = progress.recordMessageResult(id, correct);
    setState(() {});
    _store.save(progress);
    return earnedXp;
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
          onAnswered: (correct) {
            _reviewMessage(message.id, correct);
          },
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

  void _openTextSimulation() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TextSimulationPage(
          reviewedMessages: _progress!.reviewedMessages,
          onAnswered: (message, correct) => _reviewMessage(message.id, correct),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    final lessons = _lessons;
    final practiceMessages = _practiceMessages;

    // Show a loading indicator until user progress and JSON assets are loaded
    if (progress == null || lessons == null || practiceMessages == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final content = switch (_tab) {
          0 => HomeView(
              progress: progress,
              lessons: lessons,
              practiceMessages: practiceMessages,
              onLearn: () => setState(() => _tab = 1),
              onOpenTexts: _openTextSimulation,
              onOpenLesson: _openLesson,
            ),
          1 => LearnView(
              progress: progress,
              lessons: lessons,
              onOpen: _openLesson,
            ),
          2 => PracticeView(
              progress: progress,
              practiceMessages: practiceMessages,
              onOpenMessage: _openMessage,
              onOpenTextSimulation: _openTextSimulation,
              onOpenCall: _openCall,
            ),
          _ => ProfileView(
              progress: progress,
              practiceMessages: practiceMessages,
            ),
        };
        return Scaffold(
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (wide)
                  SideNavigation(
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
