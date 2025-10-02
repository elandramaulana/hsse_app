import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hsse_app/app/controllers/bottom_nav_controller.dart';
import 'package:hsse_app/app/modules/home/home_page.dart';
import 'package:hsse_app/app/modules/notification/notification_page.dart';
import 'package:hsse_app/app/modules/profile/profile_page.dart';
import 'package:hsse_app/app/modules/task/task_page.dart';
import 'package:hsse_app/core/themes/app_colors.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

// Import controller

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return PersistentTabView(
      context,
      controller: controller.tabController,
      screens: _buildScreens(),
      items: _navBarItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.r),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style6,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const TaskPage(),
      const NotificationPage(),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home, size: 26.sp),
        title: "Home",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.third,
        textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.list_alt, size: 26.sp),
        title: "Task",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.third,
        textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications_outlined, size: 26.sp),
        title: "Notification",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.third,
        textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_outline_outlined, size: 26.sp),
        title: "Profile",
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: AppColors.third,
        textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
      ),
    ];
  }
}
