import 'package:flutter_test/flutter_test.dart';
import 'package:scamshield/services/progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('message results persist and award XP only once', () async {
    SharedPreferences.setMockInitialValues({});
    final progress = AppProgress();

    expect(progress.recordMessageResult('bank', false), 0);
    expect(progress.reviewedMessages, contains('bank'));
    expect(progress.correctMessages, isNot(contains('bank')));

    expect(progress.recordMessageResult('bank', true), 0);
    expect(progress.recordMessageResult('library', true), 15);
    expect(progress.xp, 15);

    final store = ProgressStore();
    await store.save(progress);
    final loaded = await store.load();

    expect(loaded.xp, 15);
    expect(loaded.reviewedMessages, containsAll(['bank', 'library']));
    expect(loaded.correctMessages, contains('library'));
    expect(loaded.correctMessages, isNot(contains('bank')));
  });
}
