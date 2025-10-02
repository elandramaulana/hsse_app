import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hsse_app/core/base/base_provider.dart';
import 'package:hsse_app/core/configs/app_config.dart';
import 'package:hsse_app/core/themes/app_theme.dart';
import 'package:hsse_app/routes/app_pages.dart';
import 'package:hsse_app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize(
    environment: Environment
        .development, // Change to Environment.production for production
  );

  // Validate configuration
  if (!AppConfig.isConfigValid) {
    throw Exception(
      'Invalid configuration. Please check your environment variables.',
    );
  }

  // Initialize services
  await _initializeServices();
  runApp(const MainApp());
}

Future<void> _initializeServices() async {
  // Register BaseProvider as a service
  Get.put(BaseProvider(), permanent: true);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: _getAdaptiveDesignSize(),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'PSM App',
          theme: AppTheme.light,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
          defaultTransition: Transition.cupertinoDialog,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  Size _getAdaptiveDesignSize() {
    final window = WidgetsBinding.instance.window;
    final physicalSize = window.physicalSize;
    final devicePixelRatio = window.devicePixelRatio;

    final screenWidth = physicalSize.width / devicePixelRatio;

    if (screenWidth >= 600) {
      return Size(screenWidth * 0.6, 812);
    } else {
      return const Size(375, 812);
    }
  }
}
