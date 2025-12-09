import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant.dart';
import '../widgets/notification.dart' as notif;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // General Enhancement: 15 Notifications
  final List<Map<String, String>> _notifications = [
    {'name': 'Cyrus Robles', 'post': 'liked your post', 'description': '5 minutes ago'},
    {'name': 'Maria Santos', 'post': 'commented on your post', 'description': '"Great content!" • 15 minutes ago'},
    {'name': 'John Dela Cruz', 'post': 'shared your post', 'description': '32 minutes ago'},
    {'name': 'Anna Garcia', 'post': 'started following you', 'description': '1 hour ago'},
    {'name': 'Luis Fernandez', 'post': 'liked your post', 'description': '2 hours ago'},
    {'name': 'Sofia Martinez', 'post': 'commented on your post', 'description': '"Amazing!" • 3 hours ago'},
    {'name': 'Pedro Gonzales', 'post': 'liked your comment', 'description': '4 hours ago'},
    {'name': 'Elena Rodrigues', 'post': 'shared your post', 'description': '5 hours ago'},
    {'name': 'Carlos Mendoza', 'post': 'started following you', 'description': '6 hours ago'},
    {'name': 'Rosa Flores', 'post': 'liked your post', 'description': '1 day ago'},
    {'name': 'Miguel Torres', 'post': 'mentioned you in a comment', 'description': '1 day ago'},
    {'name': 'Isabella Cruz', 'post': 'reacted to your story', 'description': '2 days ago'},
    {'name': 'Gabriel Lim', 'post': 'sent you a friend request', 'description': '3 days ago'},
    {'name': 'Jasmine Lee', 'post': 'invited you to join a group', 'description': '4 days ago'},
    {'name': 'Rafael Santos', 'post': 'liked your cover photo', 'description': '1 week ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: 1.sw,
        child: ListView.separated(
          itemCount: _notifications.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final item = _notifications[index];
            return notif.NotificationItem(
              name: item['name']!,
              post: item['post']!,
              description: item['description']!,
            );
          },
        ),
      ),
    );
  }
}