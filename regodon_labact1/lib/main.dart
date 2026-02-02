import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/screens/newsfeed_screen.dart';
import '/screens/login_screen.dart';
import '/screens/register_screen.dart';

void main() => runApp(const RegodonFacebook());

class RegodonFacebook extends StatelessWidget {
  const RegodonFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          title: 'Facebook Replication',
          initialRoute: '/login', 
          routes: {
            '/login': (context) => const LogInScreen(),
            '/register': (context) => const RegisterScreen(),
            '/newsfeed': (context) => const NewsFeedScreen(),

          
          },
        );
      },
    );
  }
}