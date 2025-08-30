// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:booking_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BookingApp());

    // Verify that the app loads with the splash screen
    expect(find.text('SportBook'), findsOneWidget);
    expect(find.text('Book Your Perfect Sports Field'), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
    
    // Clean up GetX controllers to avoid timer issues
    Get.reset();
  });
}
