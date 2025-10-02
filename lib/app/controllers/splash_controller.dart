import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsse_app/routes/app_routes.dart';

class SplashController extends GetxController {
  final _initialized = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      _checkAuthentication();
      _initialized.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed Initialize Service: $e');
    }
  }

  Future<void> _checkAuthentication() async {
    try {
      Get.offAllNamed(AppRoutes.login);
      //   if (token != null && token.isNotEmpty) {
      //     Get.offAllNamed(AppRoutes.home);
      //   } else {
      //     Get.offAllNamed(AppRoutes.login);
      //   }
      // } catch (e) {
      //   Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  bool get isInitialized => _initialized.value;
}
