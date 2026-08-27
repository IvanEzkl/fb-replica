import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_button.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_dialogs.dart';
import '../constants.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;
  final User? user;

  const ProfileScreen({super.key, this.username, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  int followers = 1250;
  int following = 342;
  User? _currentUser;
  List<Post> _userApiPosts = [];
  bool _isLoadingPosts = true;

  late List<Map<String, dynamic>> profilePosts;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    final userName = widget.user?.fullName ?? widget.username ?? 'Ivan Ezekiel Regodon';

    profilePosts = [
      {
        'postId': 1,
        'userName': userName,
        'postContent': 'We cute',
        'date': '2 hours ago',
        'likes': 45,
        'comments': 12,
        'shares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'postId': 2,
        'userName': userName,
        'postContent': 'First day sa gym, nabawasan ako ng 80 pesos!',
        'date': '1 day ago',
        'likes': 32,
        'comments': 8,
        'shares': 2,
        'hasImage': false,
        'imageUrl': '',
      },
    ];

    _initUserDataAndPosts();
  }

  Future<void> _initUserDataAndPosts() async {
    if (_currentUser == null) {
      _currentUser = await _userService.getSavedUser();
    }

    final userId = _currentUser?.id ?? 1;

    try {
      final posts = await _postService.getPostsByUserId(userId);
      if (mounted) {
        setState(() {
          _userApiPosts = posts;
          _isLoadingPosts = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingPosts = false;
        });
      }
    }
  }

  final List<String> profilePhotos = [
    'assets/images/Image.jpg',
    'assets/images/Image1.jpg',
    'assets/images/Image2.jpg',
    'assets/images/Image3.jpg',
  ];

  Widget _photos() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        _buildPhotoCard('assets/images/Image.jpg'),
        _buildPhotoCard('assets/images/Image1.jpg'),
        _buildPhotoCard('assets/images/Image2.jpg'),
        _buildPhotoCard('assets/images/Image3.jpg'),
      ],
    );
  }

  Widget _buildPhotoCard(String imagePath, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => customShowImageDialog(context, imageUrl: imagePath),
      child: Container(
        padding: color != null ? const EdgeInsets.all(8) : null,
        color: color,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  Text(
                    'Image not found',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    if (_isLoadingPosts) {
      return const Center(
        child: CircularProgressIndicator(color: FB_PRIMARY),
      );
    }

    if (_userApiPosts.isNotEmpty) {
      final displayName = _currentUser?.fullName ?? widget.username ?? 'Ivan Ezekiel Regodon';
      final profilePic = _currentUser?.image ?? 'assets/icons/superpogi.jpg';

      return ListView.builder(
        itemCount: _userApiPosts.length,
        itemBuilder: (context, index) {
          final post = _userApiPosts[index];
          return NewsFeedCard(
            postId: post.id,
            userName: displayName,
            postContent: post.body,
            date: 'Recently',
            numOfLikes: post.likes,
            numOfComments: 3,
            numOfShares: 1,
            hasImage: false,
            imageUrl: '',
            profileImageUrl: profilePic,
          );
        },
      );
    }

    // Fallback posts if API list is empty or offline
    return ListView.builder(
      itemCount: profilePosts.length,
      itemBuilder: (context, index) {
        final post = profilePosts[index];
        return NewsFeedCard(
          postId: post['postId'] ?? (index + 1),
          userName: post['userName'],
          postContent: post['postContent'],
          date: post['date'],
          numOfLikes: post['likes'],
          numOfComments: post['comments'],
          numOfShares: post['shares'],
          hasImage: post['hasImage'],
          imageUrl: post['imageUrl'] ?? '',
          profileImageUrl: _currentUser?.image ?? 'assets/icons/superpogi.jpg',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = _currentUser?.fullName ?? widget.username ?? 'Ivan Ezekiel Regodon';
    final userImage = _currentUser?.image ?? '';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                            image: const DecorationImage(
                              image: AssetImage("assets/images/pogi.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Settings Shortcut Button on Cover
                        Positioned(
                          top: ScreenUtil().setHeight(40),
                          right: ScreenUtil().setWidth(16),
                          child: CircleAvatar(
                            backgroundColor: isDark
                                ? const Color(0xFF1E1E1E).withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.8),
                            child: IconButton(
                              icon: const Icon(Icons.settings, color: FB_PRIMARY),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsScreen(user: _currentUser),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: ScreenUtil().setWidth(20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: FB_LIGHT_PRIMARY,
                                backgroundImage: userImage.isNotEmpty &&
                                        userImage.startsWith('http')
                                    ? NetworkImage(userImage)
                                    : const AssetImage(
                                            "assets/icons/superpogi.jpg")
                                        as ImageProvider,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      isDark ? Colors.grey[700] : Colors.grey[300],
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(55)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFont(
                            text: displayName,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(5)),
                          CustomFont(
                            text: _currentUser?.email.isNotEmpty == true
                                ? _currentUser!.email
                                : 'National University - Manila',
                            fontSize: ScreenUtil().setSp(14),
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomFont(
                            text: 'Passionate about coding and innovation',
                            fontSize: ScreenUtil().setSp(14),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                CustomFont(
                                  text: followers.toString(),
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomFont(
                                  text: 'Followers',
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                CustomFont(
                                  text: following.toString(),
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomFont(
                                  text: 'Following',
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    // Action Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonName: 'Follow',
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Expanded(
                            child: CustomButton(
                              buttonName: 'Settings',
                              buttonType: 'outlined',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsScreen(user: _currentUser),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              TabBar(
                indicatorColor: FB_DARK_PRIMARY,
                labelColor: FB_PRIMARY,
                unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[700],
                tabs: [
                  Tab(
                    child: CustomFont(
                      text: 'Posts',
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'About',
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  Tab(
                    child: CustomFont(
                      text: 'Photos',
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPostsTab(),

                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Details Section
                            CustomFont(
                              text: 'Details',
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),

                            // Profile/Profession
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.work,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  CustomFont(
                                    text: 'Junior Developer • Tech Enthusiast',
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ],
                              ),
                            ),

                            // Location
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  CustomFont(
                                    text: 'Manila, Philippines',
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ],
                              ),
                            ),

                            // Education
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    size: ScreenUtil().setSp(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  Expanded(
                                    child: CustomFont(
                                      text:
                                          'National University - Manila, 2023-2027',
                                      fontSize: ScreenUtil().setSp(14),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

                            // Skills Section
                            CustomFont(
                              text: 'Skills',
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            Wrap(
                              spacing: ScreenUtil().setWidth(8),
                              runSpacing: ScreenUtil().setHeight(8),
                              children: [
                                _buildSkillChip('Flutter'),
                                _buildSkillChip('Dart'),
                                _buildSkillChip('FrontEnd'),
                                _buildSkillChip('REST API'),
                              ],
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),

                            // Bio/Description Section
                            CustomFont(
                              text: 'Description',
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10)),
                            CustomFont(
                              text:
                                  'Hi! I\'m $displayName, a junior developer and tech enthusiast. I love creating beautiful and functional apps that make a difference.',
                              fontSize: ScreenUtil().setSp(14),
                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(15)),
                            CustomButton(
                              buttonName: 'Edit public details',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    _photos(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(12),
        vertical: ScreenUtil().setHeight(6),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? FB_PRIMARY.withValues(alpha: 0.2)
            : FB_DARK_PRIMARY.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? FB_LIGHT_PRIMARY : FB_DARK_PRIMARY,
        ),
      ),
      child: CustomFont(
        text: skill,
        fontSize: ScreenUtil().setSp(12),
        color: isDark ? FB_LIGHT_PRIMARY : FB_DARK_PRIMARY,
      ),
    );
  }
}
