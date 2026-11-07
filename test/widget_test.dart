// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bodima/main.dart';

void main() {
  testWidgets('BODIMA home page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const BodimaApp());

    expect(find.text('BODIMA'), findsOneWidget);
    expect(find.textContaining('Find your perfect'), findsOneWidget);
  });

  testWidgets('Explore navigation opens the Explore screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BodimaApp());

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    expect(find.text('Explore Boarding'), findsOneWidget);
    expect(find.text('Search location or boarding...'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Find your perfect'), findsOneWidget);
  });

  testWidgets('Home profile icon opens the Profile screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BodimaApp());

    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsWidgets);
    expect(find.text('Student User'), findsOneWidget);
  });

  testWidgets(
      'When logged out, profile icon opens login and create account flow',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BodimaApp());

    // Navigate to profile and log out
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Student User'), findsOneWidget);

    // Scroll down to find and tap Log out
    await tester.drag(find.byType(ListView).last, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Log out'), findsOneWidget);

    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();

    // Verify login & create account prompt is displayed
    expect(find.text('Login & Create Account'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Create New Account'), findsOneWidget);

    // Navigate back to Home
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    // Tap top profile icon while logged out
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();

    // Verify Auth screen opens with login & register options
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Create a new account'), findsOneWidget);
  });
}
