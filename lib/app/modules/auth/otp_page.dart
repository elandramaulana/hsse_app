// Update LoginController untuk menambahkan OTP functionality
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:hsse_app/app/controllers/login_controller.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use existing controller instead of creating new one
    final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_btn.png',
                  width: 130.w,
                  height: 130.w,
                ),

                // OTP Description
                _buildOtpDescription(controller),

                SizedBox(height: 30.h),

                // OTP Field
                _buildOtpField(controller),

                SizedBox(height: 20.h),

                // Timer Display
                _buildTimerDisplay(controller),

                SizedBox(height: 30.h),

                // Verification Button
                _buildVerificationButton(controller),

                SizedBox(height: 20.h),

                // Resend OTP Button
                _buildResendButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDescription(LoginController controller) {
    return Column(
      children: [
        Text(
          'Kode OTP telah dikirimkan ke',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Obx(
          () => RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: controller.userEmail.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      ', mohon masukkan kode yang diterima pada kolom di bawah.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpField(LoginController controller) {
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
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: 'Kode OTP',
              hintStyle: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              counterText: '', // Hide character counter
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 16.h,
              ),
            ),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 4.w, // Space between digits
            ),
            onChanged: (value) {
              // Clear error when user starts typing
              if (controller.otpError.value.isNotEmpty) {
                controller.otpError.value = '';
              }
            },
          ),
        ),
        // Error message
        Obx(
          () => controller.otpError.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 24.w, top: 8.h),
                  child: Text(
                    controller.otpError.value,
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay(LoginController controller) {
    return Obx(
      () => Column(
        children: [
          Text(
            'Kode OTP akan kadaluwarsa dalam',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            controller.formattedTimer,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationButton(LoginController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.verifyOtp,
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
                  'VERIFIKASI OTP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildResendButton(LoginController controller) {
    return Obx(
      () => TextButton(
        onPressed:
            !controller.isTimerActive.value && !controller.isLoading.value
            ? controller.resendOtp
            : null,
        child: Text(
          controller.isTimerActive.value
              ? 'Tunggu ${controller.otpTimer.value} detik untuk mengirim ulang OTP'
              : 'Kirim Ulang OTP',
          style: TextStyle(
            color: controller.isTimerActive.value
                ? Colors.grey
                : const Color(0xFF125EFA),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
