import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.snackbar('Action', 'Mark all as read'),
            icon: Icon(
              Icons.done_all,
              color: const Color(0xFF6C63FF),
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Notifications',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53E3E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '3 unread',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE53E3E),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  final notifications = [
                    {
                      'title': 'New task assigned',
                      'message':
                          'You have been assigned to "Complete project documentation"',
                      'time': '5 min ago',
                      'type': 'task',
                      'isRead': false,
                    },
                    {
                      'title': 'Meeting reminder',
                      'message': 'Team meeting starts in 15 minutes',
                      'time': '10 min ago',
                      'type': 'reminder',
                      'isRead': false,
                    },
                    {
                      'title': 'Task completed',
                      'message': 'John completed "Design review" task',
                      'time': '1 hour ago',
                      'type': 'update',
                      'isRead': false,
                    },
                    {
                      'title': 'New comment',
                      'message': 'Sarah commented on your task',
                      'time': '2 hours ago',
                      'type': 'comment',
                      'isRead': true,
                    },
                    {
                      'title': 'Deadline approaching',
                      'message': 'Project deadline is tomorrow',
                      'time': '1 day ago',
                      'type': 'reminder',
                      'isRead': true,
                    },
                    {
                      'title': 'Weekly report ready',
                      'message': 'Your weekly performance report is available',
                      'time': '2 days ago',
                      'type': 'report',
                      'isRead': true,
                    },
                  ];

                  final notification = notifications[index];
                  return _buildNotificationCard(
                    notification['title'] as String,
                    notification['message'] as String,
                    notification['time'] as String,
                    notification['type'] as String,
                    notification['isRead'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    String title,
    String message,
    String time,
    String type,
    bool isRead,
  ) {
    IconData icon;
    Color iconColor;

    switch (type) {
      case 'task':
        icon = Icons.assignment;
        iconColor = const Color(0xFF6C63FF);
        break;
      case 'reminder':
        icon = Icons.access_time;
        iconColor = const Color(0xFFFF9800);
        break;
      case 'update':
        icon = Icons.update;
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'comment':
        icon = Icons.comment;
        iconColor = const Color(0xFF2196F3);
        break;
      case 'report':
        icon = Icons.assessment;
        iconColor = const Color(0xFF9C27B0);
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () => Get.snackbar('Notification', 'Notification tapped'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: !isRead
              ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53E3E),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
