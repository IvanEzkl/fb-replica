import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/custom_dialogs.dart';
import 'home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    final username = usernameController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    try {
      User user;

      // Local accounts (case-insensitive & offline-friendly)
      if (username == 'user' ||
          username == 'ivan' ||
          username == 'van' ||
          username == 'ivanezkl' ||
          username.contains('regodon') ||
          username.contains('ezekiel')) {
        user = User(
          id: 100,
          username: 'ivan',
          firstName: 'Ivan Ezekiel',
          lastName: 'Regodon',
          email: 'ivan@national-u.edu.ph',
          image: 'assets/icons/superpogi.jpg',
        );
        await _userService.saveUserSession(user);
      } else if (username == 'admin') {
        user = User(
          id: 99,
          username: 'admin',
          firstName: 'System',
          lastName: 'Administrator',
          email: 'admin@facebook.com',
          image: 'https://i.pravatar.cc/150?img=68',
        );
        await _userService.saveUserSession(user);
      } else if (username == 'test') {
        user = User(
          id: 88,
          username: 'test',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@facebook.com',
          image: 'https://i.pravatar.cc/150?img=12',
        );
        await _userService.saveUserSession(user);
      } else {
        // Attempt DummyJSON API login
        try {
          user = await _userService.login(username, password);
        } catch (apiError) {
          // Fallback mock accounts for known dummyjson usernames in case of offline/network issues
          if (username == 'emilys') {
            user = User(
              id: 1,
              username: 'emilys',
              firstName: 'Emily',
              lastName: 'Johnson',
              email: 'emily.johnson@x.dummyjson.com',
              image: 'https://dummyjson.com/icon/emilys/128',
            );
            await _userService.saveUserSession(user);
          } else if (username == 'michaelw') {
            user = User(
              id: 2,
              username: 'michaelw',
              firstName: 'Michael',
              lastName: 'Williams',
              email: 'michael.williams@x.dummyjson.com',
              image: 'https://dummyjson.com/icon/michaelw/128',
            );
            await _userService.saveUserSession(user);
          } else if (username == 'sophiab') {
            user = User(
              id: 3,
              username: 'sophiab',
              firstName: 'Sophia',
              lastName: 'Brown',
              email: 'sophia.brown@x.dummyjson.com',
              image: 'https://dummyjson.com/icon/sophiab/128',
            );
            await _userService.saveUserSession(user);
          } else {
            rethrow;
          }
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user, username: user.fullName),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      customDialog(
        context,
        title: 'Authentication Failed',
        content: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: ScreenUtil().setHeight(20)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: ScreenUtil().setHeight(200),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: usernameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your username' : null,
                        onSaved: (value) => usernameController.text = value!,
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: isDark ? Colors.white : FB_PRIMARY,
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Username (e.g. ivan / emilys / user)',
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: passwordController,
                        isObscure: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                        onSaved: (value) => passwordController.text = value!,
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: isDark ? Colors.white : FB_PRIMARY,
                        hintTextSize: ScreenUtil().setSp(15),
                        hintText: 'Password',
                      ),
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: FB_PRIMARY,
                              ),
                            )
                          : CustomInkWellButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  login();
                                }
                              },
                              height: ScreenUtil().setHeight(40),
                              width: ScreenUtil().screenWidth,
                              buttonName: 'Login',
                              fontSize: ScreenUtil().setSp(15),
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You do not have an account? ',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          'Register here',
                          style: TextStyle(
                            color: FB_PRIMARY,
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
