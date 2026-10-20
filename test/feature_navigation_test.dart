import 'package:flutter_test/flutter_test.dart';
import 'package:scamshield/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('text practice updates the Home scoreboard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ScamShieldApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Try texts'));
    await tester.tap(find.text('Try texts'));
    await tester.pumpAndSettle();
    expect(find.text('TEXT MESSAGE SIMULATOR'), findsOneWidget);

    await tester.ensureVisible(find.text('This is a scam'));
    await tester.tap(find.text('This is a scam'));
    await tester.pumpAndSettle();
    expect(find.text('+15 XP'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('YOUR SCOREBOARD'), findsOneWidget);
    expect(find.text('1 of 1 text checks correct'), findsOneWidget);
    expect(find.text('15 XP'), findsOneWidget);
  });
}
