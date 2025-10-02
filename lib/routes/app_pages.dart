import 'package:get/get.dart';
import 'package:hsse_app/app/bindings/login_binding.dart';
import 'package:hsse_app/app/bindings/home_binding.dart';
import 'package:hsse_app/app/bindings/task_binding.dart';
import 'package:hsse_app/app/bindings/notification_binding.dart';
import 'package:hsse_app/app/bindings/profile_binding.dart';
import 'package:hsse_app/app/bindings/bottom_nav_binding.dart';
import 'package:hsse_app/app/controllers/splash_controller.dart';
import 'package:hsse_app/app/modules/auth/login_page.dart';
import 'package:hsse_app/app/modules/auth/otp_page.dart';
import 'package:hsse_app/app/modules/splash/splash_page.dart';
import 'package:hsse_app/app/modules/home/home_page.dart';
import 'package:hsse_app/app/modules/task/task_page.dart';
import 'package:hsse_app/app/modules/notification/notification_page.dart';
import 'package:hsse_app/app/modules/profile/profile_page.dart';
import 'package:hsse_app/app/modules/widgets/bottom_nav.dart';
import 'package:hsse_app/routes/app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
        // Get.put(LoginService());
      }),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.otpPage,
      page: () => const OtpPage(),
      binding: LoginBinding(),
    ),

    // Bottom Navigation as main container
    GetPage(
      name: AppRoutes.bottomNav,
      page: () => const BottomNavWidget(),
      binding: BottomNavBinding(),
    ),

    // Individual pages for bottom navigation
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.task,
      page: () => const TaskPage(),
      binding: TaskBinding(),
    ),

    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationPage(),
      binding: NotificationBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}
