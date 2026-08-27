import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/post_service.dart';
import '../services/user_service.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_font.dart';
import '../constants.dart';

class NewsFeedScreen extends StatefulWidget {
  final User? user;
  final ScrollController? scrollController;
  const NewsFeedScreen({super.key, this.user, this.scrollController});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  List<Post> _apiPosts = [];
  bool _isLoading = true;
  User? _currentUser;

  // Real user pool for dynamic feed attribution
  static const List<Map<String, String>> _usersPool = [
    {
      'name': 'Emily Johnson',
      'image': 'https://dummyjson.com/icon/emilys/128',
    },
    {
      'name': 'Michael Williams',
      'image': 'https://dummyjson.com/icon/michaelw/128',
    },
    {
      'name': 'Sophia Brown',
      'image': 'https://dummyjson.com/icon/sophiab/128',
    },
    {
      'name': 'James Smith',
      'image': 'https://dummyjson.com/icon/james/128',
    },
    {
      'name': 'Emma Martinez',
      'image': 'https://dummyjson.com/icon/emma/128',
    },
    {
      'name': 'Olivia Davis',
      'image': 'https://dummyjson.com/icon/olivia/128',
    },
    {
      'name': 'Alexander Jones',
      'image': 'https://dummyjson.com/icon/alexander/128',
    },
    {
      'name': 'Liam Wilson',
      'image': 'https://dummyjson.com/icon/liam/128',
    },
    {
      'name': 'Noah Taylor',
      'image': 'https://dummyjson.com/icon/noah/128',
    },
    {
      'name': 'Isabella Cruz',
      'image': 'https://dummyjson.com/icon/isabella/128',
    },
    {
      'name': 'Cyrus Robles',
      'image': 'https://i.pravatar.cc/150?img=11',
    },
    {
      'name': 'Maria Santos',
      'image': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'name': 'John Dela Cruz',
      'image': 'https://i.pravatar.cc/150?img=13',
    },
    {
      'name': 'Anna Garcia',
      'image': 'https://i.pravatar.cc/150?img=9',
    },
    {
      'name': 'Luis Fernandez',
      'image': 'https://i.pravatar.cc/150?img=14',
    },
  ];

  final List<Map<String, dynamic>> _placeholderPosts = [
    {
      'postId': 1,
      'userName': 'Cyrus Robles',
      'postContent': 'Just wrapped up an incredible hackathon with the dev team! 💻🔥',
      'numOfLikes': 67,
      'numOfComments': 12,
      'numOfShares': 5,
      'date': '2 hours ago',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=1',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=11',
    },
    {
      'postId': 2,
      'userName': 'Maria Santos',
      'postContent': 'Serene sunset walk by the coastline. Nothing beats this tranquility 🌅',
      'numOfLikes': 619,
      'numOfComments': 45,
      'numOfShares': 23,
      'date': 'Yesterday',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=2',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'postId': 3,
      'userName': 'John Dela Cruz',
      'postContent': 'Building cross-platform apps with Flutter is pure joy. Fast, fluid, and scalable!',
      'numOfLikes': 42,
      'numOfComments': 9,
      'numOfShares': 4,
      'date': '2 days ago',
      'hasImage': false,
      'imageUrl': '',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=13',
    },
    {
      'postId': 4,
      'userName': 'Anna Garcia',
      'postContent': 'Coffee brewed, playlist on, debugging mode activated ☕🎧 #DevLife',
      'numOfLikes': 120,
      'numOfComments': 28,
      'numOfShares': 15,
      'date': '3 days ago',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=3',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=9',
    },
    {
      'postId': 5,
      'userName': 'Luis Fernandez',
      'postContent': 'Weekend mountain hike! Recharging for the upcoming sprint ⛰️🌲',
      'numOfLikes': 89,
      'numOfComments': 18,
      'numOfShares': 7,
      'date': '4 days ago',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=4',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=14',
    },
  ];

  final List<Map<String, dynamic>> _advertisements = [
    {
      'postId': 999,
      'userName': 'Google Developers',
      'postContent':
          'Supercharge your apps with Flutter 3. Modern UI, hot reload, and cross-platform native speed!',
      'numOfLikes': 432,
      'numOfComments': 56,
      'numOfShares': 89,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=6',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=60',
    },
    {
      'postId': 998,
      'userName': 'Tech Gear Weekly',
      'postContent':
          'Discover top developer mechanical keyboards and ergonomic desk setups. Exclusive 20% discount!',
      'numOfLikes': 210,
      'numOfComments': 31,
      'numOfShares': 42,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=7',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=68',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _loadUser();
    _fetchPosts();
  }

  Future<void> _loadUser() async {
    if (_currentUser == null) {
      final user = await _userService.getSavedUser();
      if (mounted && user != null) {
        setState(() {
          _currentUser = user;
        });
      }
    }
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await _postService.getPosts(limit: 20);
      if (mounted) {
        setState(() {
          _apiPosts = posts;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, String> _getUserInfoForPost(int userId) {
    final index = (userId - 1) % _usersPool.length;
    return _usersPool[index >= 0 ? index : 0];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: FB_PRIMARY),
      );
    }

    final currentUserAvatar = _currentUser?.image ?? 'assets/icons/superpogi.jpg';
    List<Widget> feedItems = [];

    if (_apiPosts.isNotEmpty) {
      int adIdx = 0;
      for (int i = 0; i < _apiPosts.length; i++) {
        final post = _apiPosts[i];
        final author = _getUserInfoForPost(post.userId);
        final hasImg = i % 2 == 1; // Give alternating posts an image
        final imgUrl = hasImg ? 'https://picsum.photos/400/300?random=${100 + post.id}' : '';

        feedItems.add(
          NewsFeedCard(
            postId: post.id,
            userName: author['name']!,
            postContent: post.body,
            numOfLikes: post.likes,
            numOfComments: 5 + (post.id % 10),
            numOfShares: 2 + (post.id % 5),
            date: '${(i % 5) + 1} hours ago',
            hasImage: hasImg,
            imageUrl: imgUrl,
            profileImageUrl: author['image']!,
            currentUserImageUrl: currentUserAvatar,
          ),
        );

        // Interleave ads every 3 posts
        if ((i + 1) % 3 == 0 && adIdx < _advertisements.length) {
          final ad = _advertisements[adIdx % _advertisements.length];
          feedItems.add(
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setSp(15),
                top: ScreenUtil().setSp(10),
                bottom: ScreenUtil().setSp(5),
              ),
              child: CustomFont(
                text: 'Advertisement/Promotion',
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[700],
              ),
            ),
          );
          feedItems.add(
            NewsFeedCard(
              postId: ad['postId'],
              userName: ad['userName'],
              postContent: ad['postContent'],
              numOfLikes: ad['numOfLikes'],
              numOfComments: ad['numOfComments'] ?? 0,
              numOfShares: ad['numOfShares'] ?? 0,
              date: ad['date'],
              hasImage: ad['hasImage'],
              imageUrl: ad['imageUrl'] ?? '',
              profileImageUrl: ad['profileImageUrl'] ?? '',
              currentUserImageUrl: currentUserAvatar,
            ),
          );
          adIdx++;
        }
      }
    } else {
      // Fallback placeholder posts with distinct authors
      for (final post in _placeholderPosts) {
        feedItems.add(
          NewsFeedCard(
            postId: post['postId'] ?? 1,
            userName: post['userName'],
            postContent: post['postContent'],
            numOfLikes: post['numOfLikes'],
            numOfComments: post['numOfComments'] ?? 0,
            numOfShares: post['numOfShares'] ?? 0,
            date: post['date'],
            hasImage: post['hasImage'],
            imageUrl: post['imageUrl'] ?? '',
            profileImageUrl: post['profileImageUrl'] ?? '',
            currentUserImageUrl: currentUserAvatar,
          ),
        );
      }
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      color: FB_PRIMARY,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: feedItems.length,
        itemBuilder: (context, index) => feedItems[index],
      ),
    );
  }
}
