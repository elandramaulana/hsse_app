import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Tasks',
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
            onPressed: () => Get.snackbar('Action', 'Add task clicked'),
            icon: Icon(Icons.add, color: const Color(0xFF6C63FF), size: 24.sp),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Tasks',
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
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '5 tasks',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final tasks = [
                    {
                      'title': 'Complete project documentation',
                      'time': '09:00 AM',
                      'priority': 'High',
                      'completed': false,
                    },
                    {
                      'title': 'Team meeting with designers',
                      'time': '11:30 AM',
                      'priority': 'Medium',
                      'completed': true,
                    },
                    {
                      'title': 'Code review session',
                      'time': '02:00 PM',
                      'priority': 'High',
                      'completed': false,
                    },
                    {
                      'title': 'Update project timeline',
                      'time': '03:30 PM',
                      'priority': 'Low',
                      'completed': false,
                    },
                    {
                      'title': 'Prepare presentation slides',
                      'time': '05:00 PM',
                      'priority': 'Medium',
                      'completed': false,
                    },
                  ];

                  final task = tasks[index];
                  return _buildTaskCard(
                    task['title'] as String,
                    task['time'] as String,
                    task['priority'] as String,
                    task['completed'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    String title,
    String time,
    String priority,
    bool completed,
  ) {
    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = const Color(0xFFE53E3E);
        break;
      case 'Medium':
        priorityColor = const Color(0xFFFF9800);
        break;
      case 'Low':
        priorityColor = const Color(0xFF4CAF50);
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          GestureDetector(
            onTap: () => Get.snackbar('Task', 'Task status toggled'),
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed
                      ? const Color(0xFF4CAF50)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: completed ? const Color(0xFF4CAF50) : Colors.transparent,
              ),
              child: completed
                  ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                  : null,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: completed ? Colors.grey : Colors.black87,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
