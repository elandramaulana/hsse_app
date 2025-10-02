import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsse_app/core/utils/snackbar_util.dart';
import 'package:hsse_app/routes/app_routes.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var userEmail = ''.obs;

  // Form validation
  var usernameError = ''.obs;
  var passwordError = ''.obs;
  var otpError = ''.obs;

  var otpTimer = 359.obs;
  var isTimerActive = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void startOtpTimer() {
    otpTimer.value = 359;
    isTimerActive.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) {
        otpTimer.value--;
      } else {
        timer.cancel();
        isTimerActive.value = false;
      }
    });
  }

  String get formattedTimer {
    int minutes = otpTimer.value ~/ 60;
    int seconds = otpTimer.value % 60;
    return '$minutes menit ${seconds.toString().padLeft(2, '0')} detik';
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  bool validateLoginForm() {
    bool isValid = true;
    usernameError.value = '';
    passwordError.value = '';

    if (usernameController.text.trim().isEmpty) {
      usernameError.value = 'Username cannot be empty';
      isValid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Password cannot be empty';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  bool validateOtpForm() {
    otpError.value = '';

    if (otpController.text.trim().isEmpty) {
      otpError.value = 'Kode OTP tidak boleh kosong';
      return false;
    }

    if (otpController.text.length < 4) {
      otpError.value = 'Kode OTP harus 4-6 digit';
      return false;
    }

    return true;
  }

  Future<void> login() async {
    if (!validateLoginForm()) return;

    try {
      Get.toNamed(AppRoutes.otpPage);
      startOtpTimer();
      // isLoading.value = true;

      // // Simulate API call
      // await Future.delayed(const Duration(seconds: 2));

      // String username = usernameController.text.trim();

      // // Extract and mask email for display
      // if (username.contains('@')) {
      //   userEmail.value = _maskEmail(username);
      // } else {
      //   userEmail.value = '****@example.com';
      // }

      // // Navigate to OTP page and start timer
      // Get.toNamed('/otp');
      // startOtpTimer();

      // Get.snackbar(
      //   'OTP Terkirim',
      //   'Kode OTP telah dikirimkan ke ${userEmail.value}',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
    } catch (e) {
      SnackBarUtils.showError('Login gagal $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!validateOtpForm()) return;

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // String otpCode = otpController.text.trim();
      // print('Verifying OTP: $otpCode');

      // // Stop timer on successful verification
      // _timer?.cancel();
      // isTimerActive.value = false;

      // Navigate to home page
      Get.offAllNamed(AppRoutes.bottomNav);

      SnackBarUtils.showSuccess('Verifikasi OTP berhasil');
    } catch (e) {
      SnackBarUtils.showError('Verifikasi OTP Gagal');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Restart timer
      startOtpTimer();
      SnackBarUtils.showInfo(
        'Kode OTP baru telah dikirimkan ke ${userEmail.value}',
      );
    } catch (e) {
      SnackBarUtils.showError('Gagal megirim ulang OTP ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;

    List<String> parts = email.split('@');
    String username = parts[0];
    String domain = parts[1];

    if (username.length <= 2) return email;

    String maskedUsername =
        username.substring(0, 2) + '*' * (username.length - 2);

    return '$maskedUsername@$domain';
  }

  void clearLoginForm() {
    usernameController.clear();
    passwordController.clear();
    usernameError.value = '';
    passwordError.value = '';
  }

  void clearOtpForm() {
    otpController.clear();
    otpError.value = '';
  }
}
