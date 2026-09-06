import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymcoach/features/coach/coach_screen.dart';

import 'test_l10n.dart';

void main() {
  testWidgets('Coach screen shows presets, input, and send', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: testApp(const CoachScreen()),
      ),
    );

    expect(find.text('Am I progressing?'), findsOneWidget);
    expect(find.text("Why is today's weight recommended?"), findsOneWidget);
    expect(find.text('Do I need a deload?'), findsOneWidget);
    expect(find.text('Should I change my program?'), findsOneWidget);
    expect(find.text('What improved recently?'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
    expect(find.textContaining('grounded in your logged training data'), findsOneWidget);
  });

  testWidgets('Coach screen Arabic locale shows Arabic chrome', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: testApp(const CoachScreen(), locale: const Locale('ar')),
      ),
    );

    expect(find.text('هل أتقدّم؟'), findsOneWidget);
    expect(find.text('اسأل المدرّب…'), findsOneWidget);
  });
}
