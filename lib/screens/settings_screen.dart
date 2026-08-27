import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/user.dart';
import '../providers/theme_provider.dart';
import '../services/user_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_font.dart';

class SettingsScreen extends StatefulWidget {
  final User? user;
  final ScrollController? scrollController;
  const SettingsScreen({super.key, this.user, this.scrollController});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  bool _pushNotifications = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    if (_currentUser == null) {
      _loadUser();
    }
  }

  Future<void> _loadUser() async {
    final user = await _userService.getSavedUser();
    if (mounted && user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _signOut() async {
    await _userService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 1,
        title: CustomFont(
          text: 'Settings & Preferences',
          fontSize: ScreenUtil().setSp(20),
          color: FB_PRIMARY,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Account Header
              if (_currentUser != null)
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(14)),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : FB_LIGHT_PRIMARY.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.grey[800]! : FB_LIGHT_PRIMARY,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: ScreenUtil().setSp(26),
                        backgroundColor: FB_PRIMARY,
                        backgroundImage: _currentUser!.image.isNotEmpty &&
                                _currentUser!.image.startsWith('http')
                            ? NetworkImage(_currentUser!.image)
                            : null,
                        child: _currentUser!.image.isEmpty ||
                                !_currentUser!.image.startsWith('http')
                            ? Icon(
                                Icons.person,
                                color: Colors.white,
                                size: ScreenUtil().setSp(26),
                              )
                            : null,
                      ),
                      SizedBox(width: ScreenUtil().setWidth(12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomFont(
                              text: _currentUser!.fullName,
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(3)),
                            CustomFont(
                              text: '@${_currentUser!.username}',
                              fontSize: ScreenUtil().setSp(13),
                              color: isDark ? Colors.grey[400] : Colors.grey[700],
                            ),
                            if (_currentUser!.email.isNotEmpty) ...[
                              SizedBox(height: ScreenUtil().setHeight(2)),
                              CustomFont(
                                text: _currentUser!.email,
                                fontSize: ScreenUtil().setSp(12),
                                color: isDark ? Colors.grey[500] : Colors.grey[600],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: ScreenUtil().setHeight(20)),

              // Preferences Section
              CustomFont(
                text: 'User Preferences',
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),

              Card(
                color: cardBg,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeThumbColor: FB_PRIMARY,
                      activeTrackColor: FB_LIGHT_PRIMARY,
                      title: CustomFont(
                        text: 'Dark Mode',
                        fontSize: ScreenUtil().setSp(14),
                      ),
                      subtitle: CustomFont(
                        text: 'Toggle application dark theme',
                        fontSize: ScreenUtil().setSp(11),
                        color: Colors.grey,
                      ),
                      secondary: const Icon(Icons.dark_mode, color: FB_DARK_PRIMARY),
                      value: themeProvider.isDarkMode,
                      onChanged: (val) {
                        themeProvider.toggleTheme(val);
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      activeThumbColor: FB_PRIMARY,
                      activeTrackColor: FB_LIGHT_PRIMARY,
                      title: CustomFont(
                        text: 'Push Notifications',
                        fontSize: ScreenUtil().setSp(14),
                      ),
                      subtitle: CustomFont(
                        text: 'Receive alerts on likes and comments',
                        fontSize: ScreenUtil().setSp(11),
                        color: Colors.grey,
                      ),
                      secondary: const Icon(Icons.notifications_active,
                          color: FB_DARK_PRIMARY),
                      value: _pushNotifications,
                      onChanged: (val) {
                        setState(() {
                          _pushNotifications = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(30)),

              // Sign Out Section
              CustomButton(
                buttonName: 'Sign Out',
                buttonType: 'filled',
                onPressed: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
