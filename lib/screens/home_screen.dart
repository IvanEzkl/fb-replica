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

  // Individual scroll controllers for each navigation tab
  final ScrollController _feedScrollController = ScrollController();
  final ScrollController _notificationsScrollController = ScrollController();
  final ScrollController _profileScrollController = ScrollController();
  final ScrollController _settingsScrollController = ScrollController();

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
    _feedScrollController.dispose();
    _notificationsScrollController.dispose();
    _profileScrollController.dispose();
    _settingsScrollController.dispose();
    super.dispose();
  }

  ScrollController _getScrollControllerForIndex(int index) {
    switch (index) {
      case 0:
        return _feedScrollController;
      case 1:
        return _notificationsScrollController;
      case 2:
        return _profileScrollController;
      case 3:
        return _settingsScrollController;
      default:
        return _feedScrollController;
    }
  }

  void _onTappedBar(int value) {
    if (_selectedIndex == value) {
      // Tapped active tab again -> scroll up to top if scrolled down
      final controller = _getScrollControllerForIndex(value);
      if (controller.hasClients && controller.offset > 0) {
        controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      setState(() {
        _selectedIndex = value;
      });
      _pageController.jumpToPage(value);
    }
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
        actions: [
          if (_selectedIndex == 2)
            IconButton(
              icon: const Icon(Icons.settings, color: FB_PRIMARY),
              tooltip: 'Settings',
              onPressed: () {
                _onTappedBar(3);
              },
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          NewsFeedScreen(
            user: _currentUser,
            scrollController: _feedScrollController,
          ),
          NotificationScreen(
            user: _currentUser,
            scrollController: _notificationsScrollController,
          ),
          ProfileScreen(
            user: _currentUser,
            username: _currentUser?.fullName ?? widget.username,
            scrollController: _profileScrollController,
          ),
          SettingsScreen(
            user: _currentUser,
            scrollController: _settingsScrollController,
          ),
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
}
