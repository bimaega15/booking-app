import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final Rx<User?> _currentUser = Rx<User?>(null);

  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  User? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      _isLoading.value = true;
      
      // Simulate checking stored auth token/session
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // For demo purposes, we'll start with logged out state
      _isLoggedIn.value = false;
      _currentUser.value = null;
    } catch (e) {
      _isLoggedIn.value = false;
      _currentUser.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;
      
      // Simulate API login call
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // For demo purposes, accept any email/password combination
      if (email.isNotEmpty && password.length >= 6) {
        final user = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: _getNameFromEmail(email),
          email: email,
          phone: '+62 812 3456 7890',
          createdAt: DateTime.now(),
        );
        
        _currentUser.value = user;
        _isLoggedIn.value = true;
        
        if (Get.context != null) {
          Get.snackbar(
            'Success',
            'Welcome back, ${user.name}!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
        
        return true;
      } else {
        if (Get.context != null) {
          Get.snackbar(
            'Error',
            'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          );
        }
        return false;
      }
    } catch (e) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    bool isPhoneRegistration = false,
  }) async {
    try {
      _isLoading.value = true;
      
      // Simulate API registration call
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // For phone registration, generate a temporary email
      String finalEmail = email;
      if (isPhoneRegistration && phone != null) {
        final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
        finalEmail = 'user_$cleanPhone@phone.temp';
      }
      
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: finalEmail,
        phone: phone,
        createdAt: DateTime.now(),
      );
      
      _currentUser.value = user;
      _isLoggedIn.value = true;
      
      if (Get.context != null) {
        Get.snackbar(
          'Success',
          'Account created successfully! Welcome, $name!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      
      return true;
    } catch (e) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Registration failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> registerWithPhone({
    required String name,
    required String phone,
    required String password,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length < 10) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Please enter a valid phone number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      return false;
    }

    return register(
      name: name,
      email: 'user_$cleanPhone@phone.temp',
      password: password,
      phone: phone,
      isPhoneRegistration: true,
    );
  }

  Future<void> logout() async {
    try {
      _isLoading.value = true;
      
      // Simulate API logout call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      _currentUser.value = null;
      _isLoggedIn.value = false;
      
      Get.offAllNamed('/login');
      
      if (Get.context != null) {
        Get.snackbar(
          'Success',
          'You have been signed out successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          'Logout failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  String _getNameFromEmail(String email) {
    final namePart = email.split('@').first;
    return namePart.split('.').map((part) => 
        part.isEmpty ? '' : part[0].toUpperCase() + part.substring(1)
    ).join(' ');
  }

  Future<bool> socialLogin(String provider) async {
    try {
      _isLoading.value = true;
      
      // Simulate social login
      await Future.delayed(const Duration(milliseconds: 1500));
      
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Social User',
        email: 'user@${provider.toLowerCase()}.com',
        phone: '+62 812 3456 7890',
        createdAt: DateTime.now(),
      );
      
      _currentUser.value = user;
      _isLoggedIn.value = true;
      
      if (Get.context != null) {
        Get.snackbar(
          'Success',
          'Signed in with $provider successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      
      return true;
    } catch (e) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          '$provider login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void updateUserProfile({
    String? name,
    String? phone,
    String? avatar,
  }) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(
        name: name,
        phone: phone,
        avatar: avatar,
        updatedAt: DateTime.now(),
      );
    }
  }
}