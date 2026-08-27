import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      final user = await _userService.getSavedUser();
      if (mounted && user != null) {
        setState(() {
          _currentUser = user;
        });
      }
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

  Map<String, dynamic> _getProfileDetailsForUser(User? user) {
    final username = user?.username.toLowerCase() ?? 'user';
    final fullName = user?.fullName ?? widget.username ?? 'Ivan Ezekiel Regodon';

    if (username == 'emilys') {
      return {
        'coverPhoto': 'https://picsum.photos/800/400?random=20',
        'avatar': user?.image.isNotEmpty == true
            ? user!.image
            : 'https://dummyjson.com/icon/emilys/128',
        'subHeadline': 'University of Oxford • Senior Tech Lead',
        'bio': 'Passionate product manager & developer. Love building impactful experiences!',
        'followers': 3420,
        'following': 512,
        'profession': 'Senior Product Lead • Mobile Engineer',
        'location': 'London, United Kingdom',
        'education': 'University of Oxford, 2018-2022',
        'skills': ['Product Design', 'Flutter', 'Agile', 'System Architecture'],
        'description':
            "Hi! I'm Emily, a Senior Tech Lead at tech ventures. I focus on building intuitive mobile applications and leading dynamic engineering teams.",
        'photos': [
          'https://picsum.photos/400/400?random=31',
          'https://picsum.photos/400/400?random=32',
          'https://picsum.photos/400/400?random=33',
          'https://picsum.photos/400/400?random=34',
        ],
      };
    } else if (username == 'michaelw') {
      return {
        'coverPhoto': 'https://picsum.photos/800/400?random=21',
        'avatar': user?.image.isNotEmpty == true
            ? user!.image
            : 'https://dummyjson.com/icon/michaelw/128',
        'subHeadline': 'Stanford University • Fitness & Tech Specialist',
        'bio': 'Fitness coach and software enthusiast. Staying active and writing clean code.',
        'followers': 2150,
        'following': 420,
        'profession': 'Fitness Specialist • Flutter Enthusiast',
        'location': 'California, USA',
        'education': 'Stanford University, 2019-2023',
        'skills': ['Health Tech', 'Dart', 'UI/UX', 'Cross-Platform'],
        'description':
            "Hi! I'm Michael. I bridge fitness and technology through software development, active living, and high-performance engineering.",
        'photos': [
          'https://picsum.photos/400/400?random=41',
          'https://picsum.photos/400/400?random=42',
          'https://picsum.photos/400/400?random=43',
          'https://picsum.photos/400/400?random=44',
        ],
      };
    }

    // Default / Ivan Ezekiel Regodon
    return {
      'coverPhoto': 'assets/images/pogi.jpg',
      'avatar': user?.image.isNotEmpty == true
          ? user!.image
          : 'assets/icons/superpogi.jpg',
      'subHeadline': user?.email.isNotEmpty == true
          ? user!.email
          : 'National University - Manila',
      'bio': 'Passionate about coding and innovation',
      'followers': 1250,
      'following': 342,
      'profession': 'Junior Developer • Tech Enthusiast',
      'location': 'Manila, Philippines',
      'education': 'National University - Manila, 2023-2027',
      'skills': ['Flutter', 'Dart', 'FrontEnd', 'REST API'],
      'description':
          "Hi! I'm $fullName, a junior developer and tech enthusiast. I love creating beautiful and functional apps that make a difference.",
      'photos': [
        'assets/images/Image.jpg',
        'assets/images/Image1.jpg',
        'assets/images/Image2.jpg',
        'assets/images/Image3.jpg',
      ],
    };
  }

  Widget _photos(List<dynamic> photos) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: photos.map((p) => _buildPhotoCard(p.toString())).toList(),
    );
  }

  Widget _buildPhotoCard(String imagePath, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => customShowImageDialog(context, imageUrl: imagePath),
      child: Container(
        padding: color != null ? const EdgeInsets.all(8) : null,
        color: color,
        child: imagePath.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              )
            : Image.asset(
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

  Widget _buildPostsTab(String displayName, String profilePic) {
    if (_isLoadingPosts) {
      return const Center(
        child: CircularProgressIndicator(color: FB_PRIMARY),
      );
    }

    if (_userApiPosts.isNotEmpty) {
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
          userName: displayName,
          postContent: post['postContent'],
          date: post['date'],
          numOfLikes: post['likes'],
          numOfComments: post['comments'],
          numOfShares: post['shares'],
          hasImage: post['hasImage'],
          imageUrl: post['imageUrl'] ?? '',
          profileImageUrl: profilePic,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = _currentUser?.fullName ?? widget.username ?? 'Ivan Ezekiel Regodon';
    final profile = _getProfileDetailsForUser(_currentUser);
    final String coverPhoto = profile['coverPhoto'];
    final String avatarUrl = profile['avatar'];
    final String subHeadline = profile['subHeadline'];
    final String bio = profile['bio'];
    final int followersCount = profile['followers'];
    final int followingCount = profile['following'];
    final String profession = profile['profession'];
    final String location = profile['location'];
    final String education = profile['education'];
    final List<dynamic> skills = profile['skills'];
    final String description = profile['description'];
    final List<dynamic> photos = profile['photos'];

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
                            image: coverPhoto.startsWith('http')
                                ? DecorationImage(
                                    image: NetworkImage(coverPhoto),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage(coverPhoto),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        // Settings Shortcut Button on Cover Photo
                        Positioned(
                          top: ScreenUtil().setHeight(40),
                          right: ScreenUtil().setWidth(16),
                          child: CircleAvatar(
                            backgroundColor: isDark
                                ? const Color(0xFF1E1E1E).withValues(alpha: 0.85)
                                : Colors.white.withValues(alpha: 0.85),
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
                                backgroundImage: avatarUrl.startsWith('http')
                                    ? NetworkImage(avatarUrl)
                                    : AssetImage(avatarUrl) as ImageProvider,
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
                            text: subHeadline,
                            fontSize: ScreenUtil().setSp(14),
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          CustomFont(
                            text: bio,
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
                                  text: followersCount.toString(),
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
                                  text: followingCount.toString(),
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
                    _buildPostsTab(displayName, avatarUrl),

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
                                    text: profession,
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
                                    text: location,
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
                                      text: education,
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
                              children: skills
                                  .map((s) => _buildSkillChip(s.toString()))
                                  .toList(),
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
                              text: description,
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

                    _photos(photos),
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
