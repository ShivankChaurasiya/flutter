// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:airbnb_guest_clone_flutter/main.dart';

void main() {
  testWidgets('App launches and shows login screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AirbnbGuestCloneApp());

    // Verify that the login screen is shown initially
    expect(find.text('Welcome to Staybnb'), findsOneWidget);
    expect(find.text('Enter Your Phone number'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
