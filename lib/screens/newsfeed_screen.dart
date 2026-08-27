import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_font.dart';
import '../constants.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PostService _postService = PostService();
  List<Post> _apiPosts = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _placeholderPosts = [
    {
      'postId': 1,
      'userName': 'Ivan Regodon',
      'postContent': 'Mic Test',
      'numOfLikes': 67,
      'numOfComments': 12,
      'numOfShares': 5,
      'date': 'October 11',
      'hasImage': false,
      'imageUrl': '',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'postId': 2,
      'userName': 'Ivan Regodon',
      'postContent': 'Ih ambang es',
      'numOfLikes': 619,
      'numOfComments': 45,
      'numOfShares': 23,
      'date': 'November 28',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=1',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'postId': 3,
      'userName': 'Flutter Dev',
      'postContent': 'Another post to show the list is dynamic.',
      'numOfLikes': 5,
      'numOfComments': 2,
      'numOfShares': 1,
      'date': 'December 1',
      'hasImage': false,
      'imageUrl': '',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=12',
    },
    {
      'postId': 4,
      'userName': 'Code Master',
      'postContent': 'Debugging all night long. ☕ #DevelopersLife',
      'numOfLikes': 120,
      'numOfComments': 28,
      'numOfShares': 15,
      'date': 'December 2',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=2',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=33',
    },
    {
      'postId': 5,
      'userName': 'Travel Buddy',
      'postContent': 'Missing the beach vibes! 🌊',
      'numOfLikes': 89,
      'numOfComments': 18,
      'numOfShares': 7,
      'date': 'December 3',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=3',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=25',
    },
  ];

  final List<Map<String, dynamic>> _advertisements = [
    {
      'postId': 999,
      'userName': 'Sponsored',
      'postContent':
          'Summer Sale! Get up to 50% off on all summer collections. Limited time offer!',
      'numOfLikes': 234,
      'numOfComments': 45,
      'numOfShares': 67,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=4',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=68',
    },
    {
      'postId': 998,
      'userName': 'Sponsored',
      'postContent':
          'New Course Available: Learn Flutter development from scratch. Enroll today and get certified!',
      'numOfLikes': 156,
      'numOfComments': 23,
      'numOfShares': 34,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://picsum.photos/400/300?random=5',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=68',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: FB_PRIMARY),
      );
    }

    List<Widget> feedItems = [];

    if (_apiPosts.isNotEmpty) {
      int adIdx = 0;
      for (int i = 0; i < _apiPosts.length; i++) {
        final post = _apiPosts[i];
        feedItems.add(
          NewsFeedCard(
            postId: post.id,
            userName: 'User #${post.userId}',
            postContent: post.body,
            numOfLikes: post.likes,
            numOfComments: 5,
            numOfShares: 2,
            date: 'Recently',
            hasImage: false,
            imageUrl: '',
            profileImageUrl: 'https://i.pravatar.cc/150?img=${(post.userId % 70) + 1}',
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
            ),
          );
          adIdx++;
        }
      }
    } else {
      // Fallback placeholder posts
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
          ),
        );
      }
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      color: FB_PRIMARY,
      child: ListView.builder(
        itemCount: feedItems.length,
        itemBuilder: (context, index) => feedItems[index],
      ),
    );
  }
}
