import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/theme.dart';
import '../controllers/auth_controller.dart';

enum RegisterMode { email, phone }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late TabController _tabController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.onBackground,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48.w,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        _buildHeader(),

                        SizedBox(height: 20.h),

                        // Registration method tabs
                        _buildRegistrationTabs(),

                        SizedBox(height: 16.h),

                        // Registration form
                        _buildRegistrationForm(),

                        SizedBox(height: 12.h),

                        // Terms and conditions
                        _buildTermsAgreement(),

                        SizedBox(height: 16.h),

                        // Register button
                        _buildRegisterButton(),

                        SizedBox(height: 16.h),

                        // Divider
                        _buildDivider(),

                        SizedBox(height: 16.h),

                        // Social registration
                        _buildSocialRegistration(),

                        SizedBox(height: 20.h),

                        // Login link
                        _buildLoginLink(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Account 🚀',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Join us and start booking your favorite sports fields!',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppTheme.onBackground.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        labelColor: AppTheme.onPrimary,
        unselectedLabelColor: AppTheme.onBackground.withOpacity(0.6),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, size: 16.sp),
                SizedBox(width: 8.w),
                const Text('Email'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, size: 16.sp),
                SizedBox(width: 8.w),
                const Text('Phone'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return SizedBox(
      height: 380.h,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildEmailRegistrationForm(),
          _buildPhoneRegistrationForm(),
        ],
      ),
    );
  }

  Widget _buildEmailRegistrationForm() {
    return Column(
      children: [
        _buildNameField(),
        SizedBox(height: 4.h),
        _buildEmailField(),
        SizedBox(height: 4.h),
        _buildPasswordField(),
        SizedBox(height: 4.h),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildPhoneRegistrationForm() {
    return Column(
      children: [
        _buildNameField(),
        SizedBox(height: 4.h),
        _buildPhoneField(),
        SizedBox(height: 4.h),
        _buildPasswordField(),
        SizedBox(height: 4.h),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(
              Icons.person_outlined,
              color: AppTheme.onBackground.withOpacity(0.5),
              size: 20.sp,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppTheme.onBackground.withOpacity(0.5),
              size: 20.sp,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(13),
            _PhoneNumberFormatter(),
          ],
          decoration: InputDecoration(
            hintText: '+62 812 3456 7890',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppTheme.onBackground.withOpacity(0.5),
              size: 20.sp,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
            if (cleanPhone.length < 10 || cleanPhone.length > 13) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: AppTheme.onBackground.withOpacity(0.5),
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.onBackground.withOpacity(0.5),
                size: 20.sp,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'Password must contain uppercase, lowercase, and number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: AppTheme.onBackground.withOpacity(0.5),
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppTheme.onBackground.withOpacity(0.5),
                size: 20.sp,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsAgreement() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
          activeColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.onBackground.withOpacity(0.7),
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _showTermsDialog(),
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _showPrivacyDialog(),
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        final authController = Get.find<AuthController>();
        return ElevatedButton(
          onPressed: (_agreeToTerms && !authController.isLoading)
              ? _handleRegister
              : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: _agreeToTerms
                ? AppTheme.primaryColor
                : AppTheme.onBackground.withOpacity(0.3),
          ),
          child: authController.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.onPrimary),
                  ),
                )
              : Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppTheme.onBackground.withOpacity(0.2),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'OR SIGN UP WITH',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.onBackground.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppTheme.onBackground.withOpacity(0.2),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRegistration() {
    return Column(
      children: [
        _buildSocialButton(
          'Continue with Google',
          'G',
          Colors.red,
          () => _handleSocialRegister('Google'),
        ),
        SizedBox(height: 12.h),
        _buildSocialButton(
          'Continue with Facebook',
          'f',
          Colors.blue,
          () => _handleSocialRegister('Facebook'),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      String text, String icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(
            color: AppTheme.onBackground.withOpacity(0.2),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.onBackground.withOpacity(0.6),
          ),
          children: [
            const TextSpan(text: 'Already have an account? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final authController = Get.find<AuthController>();

      final isEmailMode = _tabController.index == 0;
      bool success = false;

      if (isEmailMode) {
        // Email registration
        success = await authController.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          isPhoneRegistration: false,
        );
      } else {
        // Phone registration
        success = await authController.registerWithPhone(
          name: _nameController.text.trim(),
          phone: _phoneController.text,
          password: _passwordController.text,
        );
      }

      if (success) {
        Get.offAllNamed('/main');
      }
    } else if (!_agreeToTerms) {
      Get.snackbar(
        'Required',
        'Please agree to the Terms of Service and Privacy Policy',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
    }
  }

  void _handleSocialRegister(String provider) async {
    final authController = Get.find<AuthController>();
    final success = await authController.socialLogin(provider);

    if (success) {
      Get.offAllNamed('/main');
    }
  }

  void _showTermsDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Terms of Service',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackground,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'By using SportBook, you agree to these terms and conditions.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                '2. Booking Terms',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackground,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'All bookings are subject to field availability. Cancellations must be made at least 2 hours before the scheduled time.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                '3. Payment Policy',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackground,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Payment is required at the time of booking. Refunds are available for cancellations made within the allowed timeframe.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data Collection',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackground,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'We collect only necessary information to provide our booking services.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Data Security',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onBackground,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Your personal information is encrypted and stored securely. We never share your data with third parties without consent.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.onBackground.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    String formatted = '';
    final digits = text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.startsWith('0')) {
      formatted = '+62 ${digits.substring(1)}';
    } else if (digits.startsWith('62')) {
      formatted = '+$digits';
    } else {
      formatted = '+62 $digits';
    }

    // Format as: +62 812 3456 7890
    if (formatted.length > 4) {
      final countryCode = formatted.substring(0, 3);
      final remainingDigits = formatted.substring(3).replaceAll(' ', '');

      if (remainingDigits.length <= 3) {
        formatted = '$countryCode $remainingDigits';
      } else if (remainingDigits.length <= 7) {
        formatted =
            '$countryCode ${remainingDigits.substring(0, 3)} ${remainingDigits.substring(3)}';
      } else {
        formatted =
            '$countryCode ${remainingDigits.substring(0, 3)} ${remainingDigits.substring(3, 7)} ${remainingDigits.substring(7)}';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
