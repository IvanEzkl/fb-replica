import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/screens/login_screen.dart';
import '/screens/register_screen.dart';
import '/screens/splash_screen.dart';
import '/screens/home_screen.dart';

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
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          initialRoute: '/splash',
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LogInScreen(),
            '/register': (context) => const RegisterScreen(),
            '/splash': (context) => const SplashScreen(),
          },
        );
      },
    );
  }
}
