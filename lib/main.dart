import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const RegodonFacebook(),
    ),
  );
}

class RegodonFacebook extends StatelessWidget {
  const RegodonFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          title: 'Facebook Replication',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: FB_PRIMARY,
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            dividerColor: Colors.grey[200],
            colorScheme: const ColorScheme.light(
              primary: FB_PRIMARY,
              secondary: FB_SECONDARY,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: FB_DARK_PRIMARY,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF1E1E1E)),
            dividerColor: const Color(0xFF2C2C2C),
            colorScheme: const ColorScheme.dark(
              primary: FB_PRIMARY,
              secondary: FB_SECONDARY,
              surface: Color(0xFF1E1E1E),
            ),
          ),
          initialRoute: '/splash',
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LogInScreen(),
            '/signin': (context) => const LogInScreen(),
            '/register': (context) => const RegisterScreen(),
            '/splash': (context) => const SplashScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
