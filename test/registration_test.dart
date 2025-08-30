import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:booking_app/controllers/auth_controller.dart';

void main() {
  group('Registration Tests', () {
    setUp(() {
      Get.reset();
      Get.put(AuthController());
    });

    test('Register with email should succeed', () async {
      final authController = Get.find<AuthController>();
      
      final result = await authController.register(
        name: 'John Doe',
        email: 'john@example.com',
        password: 'Password123',
        isPhoneRegistration: false,
      );
      
      expect(result, true);
      expect(authController.isLoggedIn, true);
      expect(authController.currentUser, isNotNull);
      expect(authController.currentUser!.name, 'John Doe');
      expect(authController.currentUser!.email, 'john@example.com');
    });

    test('Register with phone should succeed', () async {
      final authController = Get.find<AuthController>();
      
      final result = await authController.registerWithPhone(
        name: 'Jane Doe',
        phone: '+62 812 3456 7890',
        password: 'Password123',
      );
      
      expect(result, true);
      expect(authController.isLoggedIn, true);
      expect(authController.currentUser, isNotNull);
      expect(authController.currentUser!.name, 'Jane Doe');
      expect(authController.currentUser!.phone, '+62 812 3456 7890');
    });

    test('Register with invalid phone should fail', () async {
      final authController = Get.find<AuthController>();
      
      final result = await authController.registerWithPhone(
        name: 'Invalid User',
        phone: '123',
        password: 'Password123',
      );
      
      expect(result, false);
      expect(authController.isLoggedIn, false);
    });

    test('Social registration should work', () async {
      final authController = Get.find<AuthController>();
      
      final result = await authController.socialLogin('Google');
      
      expect(result, true);
      expect(authController.isLoggedIn, true);
      expect(authController.currentUser, isNotNull);
    });
  });
}