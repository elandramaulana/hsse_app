import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hsse_app/app/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo_btn.png',
                  width: 130.w,
                  height: 130.w,
                ),

                SizedBox(height: 30.h),

                // Username Field
                _buildUsernameField(controller),

                SizedBox(height: 16.h),

                // Password Field
                _buildPasswordField(controller),

                SizedBox(height: 32.h),

                // Login Button
                _buildLoginButton(controller),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: TextField(
            controller: controller.usernameController,
            decoration: InputDecoration(
              hintText: 'USERNAME',
              hintStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 16.h,
              ),
            ),
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            onChanged: (value) {
              // Clear error when user starts typing
              if (controller.usernameError.value.isNotEmpty) {
                controller.usernameError.value = '';
              }
            },
          ),
        ),
        // Error message
        Obx(
          () => controller.usernameError.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 4.h),
                  child: Text(
                    controller.usernameError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPasswordField(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Obx(
            () => TextField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              decoration: InputDecoration(
                hintText: 'PASSWORD',
                hintStyle: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 16.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF9E9E9E),
                    size: 20.sp,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              onChanged: (value) {
                // Clear error when user starts typing
                if (controller.passwordError.value.isNotEmpty) {
                  controller.passwordError.value = '';
                }
              },
            ),
          ),
        ),
        // Error message
        Obx(
          () => controller.passwordError.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 4.h),
                  child: Text(
                    controller.passwordError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF125EFA),
            disabledBackgroundColor: const Color(0xFF125EFA).withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
        ),
      ),
    );
  }
}
