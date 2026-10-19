import 'package:shared_preferences/shared_preferences.dart';

class AppProgress {
  AppProgress({
    this.xp = 0,
    Set<String>? completedLessons,
    Set<String>? reviewedMessages,
    Set<String>? correctMessages,
    this.callCompleted = false,
  })  : completedLessons = completedLessons ?? <String>{},
        reviewedMessages = reviewedMessages ?? <String>{},
        correctMessages = correctMessages ?? <String>{};

  int xp;
  final Set<String> completedLessons;
  final Set<String> reviewedMessages;
  final Set<String> correctMessages;
  bool callCompleted;

  int get level => (xp ~/ 100) + 1;
  double get levelProgress => (xp % 100) / 100;

  int recordMessageResult(String id, bool correct) {
    if (!reviewedMessages.add(id)) return 0;
    if (correct) {
      correctMessages.add(id);
      xp += 15;
      return 15;
    }
    return 0;
  }
}

class ProgressStore {
  static const _xpKey = 'xp';
  static const _lessonsKey = 'completed_lessons';
  static const _messagesKey = 'reviewed_messages';
  static const _correctMessagesKey = 'correct_messages';
  static const _callKey = 'call_completed';

  Future<AppProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppProgress(
      xp: prefs.getInt(_xpKey) ?? 0,
      completedLessons:
          (prefs.getStringList(_lessonsKey) ?? <String>[]).toSet(),
      reviewedMessages:
          (prefs.getStringList(_messagesKey) ?? <String>[]).toSet(),
      correctMessages:
          (prefs.getStringList(_correctMessagesKey) ?? <String>[]).toSet(),
      callCompleted: prefs.getBool(_callKey) ?? false,
    );
  }

  Future<void> save(AppProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_xpKey, progress.xp),
      prefs.setStringList(_lessonsKey, progress.completedLessons.toList()),
      prefs.setStringList(_messagesKey, progress.reviewedMessages.toList()),
      prefs.setStringList(
          _correctMessagesKey, progress.correctMessages.toList()),
      prefs.setBool(_callKey, progress.callCompleted),
    ]);
  }
}
