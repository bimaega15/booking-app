import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:booking_app/views/field_detail_screen.dart';
import 'package:booking_app/controllers/fields_controller.dart';
import 'package:booking_app/controllers/sports_controller.dart';
import 'package:booking_app/controllers/booking_controller.dart';
import 'package:booking_app/core/theme.dart';

void main() {
  group('FieldDetailScreen Tests', () {
    setUp(() {
      Get.reset();
      Get.put(SportsController());
      Get.put(FieldsController());
      Get.put(BookingController());
    });

    testWidgets('Field detail screen should render without type errors', (WidgetTester tester) async {
      final fieldsController = Get.find<FieldsController>();
      
      // Wait for fields to load
      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 1));
      });
      
      // Select a field
      if (fieldsController.fields.isNotEmpty) {
        fieldsController.selectField(fieldsController.fields.first.id);
      }

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return GetMaterialApp(
              theme: AppTheme.lightTheme,
              home: const FieldDetailScreen(),
            );
          },
        ),
      );

      // Wait for the UI to settle
      await tester.pumpAndSettle();

      // The test passes if no type errors are thrown
      // We don't need to verify specific UI elements since the main goal
      // is to ensure no type casting errors occur
      expect(tester.takeException(), isNull);
    });
  });
}