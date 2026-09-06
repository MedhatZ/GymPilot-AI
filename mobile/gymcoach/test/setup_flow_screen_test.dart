import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymcoach/features/onboarding/setup_flow_screen.dart';

import 'test_l10n.dart';

void main() {
  Future<void> pumpSetup(
    WidgetTester tester, {
    Size size = const Size(360, 640),
    double viewPaddingBottom = 48,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        child: MediaQuery(
          data: MediaQueryData(
            size: size,
            padding: EdgeInsets.only(bottom: viewPaddingBottom),
            viewPadding: EdgeInsets.only(bottom: viewPaddingBottom),
          ),
          child: testApp(const SetupFlowScreen()),
        ),
      ),
    );
  }

  testWidgets('Profile step shows full-width Next above system inset', (tester) async {
    await pumpSetup(tester, size: const Size(360, 640), viewPaddingBottom: 48);

    expect(find.text('Next'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final next = tester.getRect(find.widgetWithText(FilledButton, 'Next'));
    expect(next.width, greaterThan(200));
    expect(next.bottom, lessThanOrEqualTo(640));
    // Must sit above the simulated system nav inset.
    expect(next.bottom, lessThanOrEqualTo(640 - 40));
  });

  testWidgets('All setup steps keep nav reachable without overflow', (tester) async {
    await pumpSetup(tester, size: const Size(320, 568), viewPaddingBottom: 48);

    for (var i = 0; i < 4; i++) {
      expect(find.text('Next'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Generate program'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Form content is scrollable on short screens', (tester) async {
    await pumpSetup(tester, size: const Size(360, 480), viewPaddingBottom: 48);

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Drag the form; Next stays pinned in bottomNavigationBar.
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -120));
    await tester.pump();
    expect(find.text('Next'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
