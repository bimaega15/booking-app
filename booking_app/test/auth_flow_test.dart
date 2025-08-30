import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:booking_app/controllers/auth_controller.dart';

void main() {
  group('Authentication Flow Tests', () {
    setUp(() {
      Get.reset();
      Get.put(AuthController());
    });

    test('AuthController should initialize with logged out state', () {
      final authController = Get.find<AuthController>();
      expect(authController.isLoggedIn, false);
      expect(authController.currentUser, null);
    });

    test('Login with valid credentials should succeed', () async {
      final authController = Get.find<AuthController>();
      
      final result = await authController.login('test@example.com', 'password123');
      
      expect(result, true);
      expect(authController.isLoggedIn, true);
      expect(authController.currentUser, isNotNull);
      expect(authController.currentUser!.email, 'test@example.com');
    });

    test('Login with invalid credentials should fail', () async {
      final authController = Get.find<AuthController>();
      
      final result = await authController.login('', '123');
      
      expect(result, false);
      expect(authController.isLoggedIn, false);
      expect(authController.currentUser, null);
    });

    test('Logout should clear user session', () async {
      final authController = Get.find<AuthController>();
      
      // First login
      await authController.login('test@example.com', 'password123');
      expect(authController.isLoggedIn, true);
      
      // Then logout
      await authController.logout();
      expect(authController.isLoggedIn, false);
      expect(authController.currentUser, null);
    });
  });
}