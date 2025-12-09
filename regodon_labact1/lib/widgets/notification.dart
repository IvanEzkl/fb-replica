import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_font.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.name,
    required this.post,
    required this.description,
  });

  final String name;
  final String post;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.sp),
      child: Row(
        children: [
          // Placeholder Photo
          CircleAvatar(
            radius: 25.sp,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFont(
                  text: name,
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13.sp, color: Colors.black, fontFamily: 'Fruitger'),
                    children: [
                      const TextSpan(text: 'Posted: '),
                      TextSpan(
                        text: post, 
                        style: const TextStyle(fontWeight: FontWeight.normal)
                      ),
                    ],
                  ),
                ),
                CustomFont(
                  text: description,
                  fontSize: 12.sp,
                  color: Colors.grey[600]!, // Slightly lighter for description
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
          ),
          Icon(Icons.more_horiz, size: 24.sp),
        ],
      ),
    );
  }
}