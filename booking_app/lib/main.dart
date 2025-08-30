import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/theme.dart';
import 'controllers/sports_controller.dart';
import 'controllers/fields_controller.dart';
import 'controllers/booking_controller.dart';
import 'views/main_screen.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Sports Booking',
          theme: AppTheme.lightTheme,
          home: const MainScreen(),
          debugShowCheckedModeBanner: false,
          initialBinding: BindingsBuilder(() {
            Get.put(SportsController());
            Get.put(FieldsController());
            Get.put(BookingController());
          }),
        );
      },
    );
  }
}
