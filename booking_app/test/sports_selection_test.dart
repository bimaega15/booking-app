import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:booking_app/views/sports_selection_screen.dart';
import 'package:booking_app/controllers/sports_controller.dart';
import 'package:booking_app/controllers/fields_controller.dart';
import 'package:booking_app/core/theme.dart';

void main() {
  group('SportsSelectionScreen Tests', () {
    setUp(() {
      Get.reset();
      Get.put(SportsController());
      Get.put(FieldsController());
    });

    testWidgets('Sports selection screen should render without type errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return GetMaterialApp(
              theme: AppTheme.lightTheme,
              home: const SportsSelectionScreen(),
            );
          },
        ),
      );

      // Wait for the loading to finish
      await tester.pumpAndSettle();

      // Verify the screen loads without errors
      expect(find.text('Choose Your Sport'), findsOneWidget);
      expect(find.text('What sport would you like to play today?'), findsOneWidget);
      expect(find.text('Show All Fields'), findsOneWidget);
    });
  });
}