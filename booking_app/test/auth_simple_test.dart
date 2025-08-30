import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:booking_app/controllers/auth_controller.dart';

void main() {
  group('Simple Auth Tests', () {
    setUp(() {
      Get.reset();
    });

    test('AuthController should initialize correctly', () {
      final authController = AuthController();
      expect(authController.isLoggedIn, false);
      expect(authController.currentUser, null);
      expect(authController.isLoading, false);
    });
  });
}