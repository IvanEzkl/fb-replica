import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/custom_font.dart';

class HomeScreen extends StatefulWidget {
  final String? username;
  final User? user;

  const HomeScreen({super.key, this.username, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final UserService _userService = UserService();
  User? _currentUser;

  late List<String> _titles;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _updateTitles();
    if (_currentUser == null) {
      _loadUser();
    }
  }

  void _updateTitles() {
    final name = _currentUser?.fullName ?? widget.username ?? 'Profile';
    _titles = [
      'Facebook',
      'Notifications',
      name,
      'Settings',
    ];
  }

  Future<void> _loadUser() async {
    final user = await _userService.getSavedUser();
    if (mounted && user != null) {
      setState(() {
        _currentUser = user;
        _updateTitles();
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: navBarBg,
        title: CustomFont(
          text: _titles[_selectedIndex],
          fontSize: ScreenUtil().setSp(22),
          color: FB_PRIMARY,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          NewsFeedScreen(user: _currentUser),
          NotificationScreen(user: _currentUser),
          ProfileScreen(
            user: _currentUser,
            username: _currentUser?.fullName ?? widget.username,
          ),
          SettingsScreen(user: _currentUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: navBarBg,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTappedBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: FB_PRIMARY,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
