// Future Talk App Widget Tests
// Tests for authentication flow and core functionality

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:future_talk_frontend/app.dart';

void main() {
  testWidgets('App loads with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FutureTalkApp(),
      ),
    );

    // Verify that splash screen loads
    expect(find.text('Future Talk'), findsOneWidget);
    expect(find.text('Thoughtful connections across time'), findsOneWidget);
  });

  testWidgets('Navigation to onboarding works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FutureTalkApp(),
      ),
    );

    // Wait for splash screen animations to complete
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify onboarding screen appears
    expect(find.text('Welcome to Future Talk'), findsOneWidget);
  });
}
