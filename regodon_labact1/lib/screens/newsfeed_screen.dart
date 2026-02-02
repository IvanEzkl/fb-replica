import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/post_card.dart';
import '../widgets/custom_font.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  // General Enhancement: 8 Posts with Images
  final List<Map<String, dynamic>> _placeholderPosts = [
    {
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
      'userName': 'Ivan Regodon',
      'postContent': 'Ih ambang es',
      'numOfLikes': 619,
      'numOfComments': 45,
      'numOfShares': 23,
      'date': 'November 28',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Beach+Vibes',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=1',
    },
    {
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
      'userName': 'Code Master',
      'postContent': 'Debugging all night long. ☕ #DevelopersLife',
      'numOfLikes': 120,
      'numOfComments': 28,
      'numOfShares': 15,
      'date': 'December 2',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Coffee+Code',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=33',
    },
    {
      'userName': 'Travel Buddy',
      'postContent': 'Missing the beach vibes! 🌊',
      'numOfLikes': 89,
      'numOfComments': 18,
      'numOfShares': 7,
      'date': 'December 3',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Beach+Sunset',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=25',
    },
    {
      'userName': 'Tech News',
      'postContent': 'The new gadget release is mind-blowing!',
      'numOfLikes': 230,
      'numOfComments': 67,
      'numOfShares': 89,
      'date': 'December 4',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Tech+Gadget',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=48',
    },
    {
      'userName': 'Daily Quotes',
      'postContent': 'Keep pushing forward. Consistency is key.',
      'numOfLikes': 45,
      'numOfComments': 12,
      'numOfShares': 8,
      'date': 'December 5',
      'hasImage': false,
      'imageUrl': '',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=60',
    },
    {
      'userName': 'Foodie Corner',
      'postContent': 'Best ramen in town! 🍜',
      'numOfLikes': 312,
      'numOfComments': 56,
      'numOfShares': 42,
      'date': 'December 6',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Delicious+Ramen',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=16',
    },
  ];

  
  final List<Map<String, dynamic>> _advertisements = [
    {
      'userName': 'Sponsored',
      'postContent':
          'Summer Sale! Get up to 50% off on all summer collections. Limited time offer!',
      'numOfLikes': 234,
      'numOfComments': 45,
      'numOfShares': 67,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Summer+Sale',
      'profileImageUrl': 'https://via.placeholder.com/150?text=Ad',
    },
    {
      'userName': 'Sponsored',
      'postContent':
          'New Course Available: Learn Flutter development from scratch. Enroll today and get certified!',
      'numOfLikes': 156,
      'numOfComments': 23,
      'numOfShares': 34,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Flutter+Course',
      'profileImageUrl': 'https://via.placeholder.com/150?text=Ad',
    },
    {
      'userName': 'Sponsored',
      'postContent':
          'Weekend Getaway: Book your dream vacation with exclusive discounts. Travel the world!',
      'numOfLikes': 189,
      'numOfComments': 56,
      'numOfShares': 78,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Travel+Deals',
      'profileImageUrl': 'https://via.placeholder.com/150?text=Ad',
    },
    {
      'userName': 'Sponsored',
      'postContent':
          'Premium Membership: Upgrade to premium and unlock exclusive features and benefits!',
      'numOfLikes': 312,
      'numOfComments': 89,
      'numOfShares': 123,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Premium',
      'profileImageUrl': 'https://via.placeholder.com/150?text=Ad',
    },
    {
      'userName': 'Sponsored',
      'postContent':
          'Tech Gadgets: Latest smartphones and gadgets at best prices. Shop now!',
      'numOfLikes': 445,
      'numOfComments': 134,
      'numOfShares': 201,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Tech+Gadgets',
      'profileImageUrl': 'https://via.placeholder.com/150?text=Ad',
    },
    {
      'userName': 'Sponsored',
      'postContent':
          'Food Delivery: Order your favorite meals with free delivery! Fast and delicious.',
      'numOfLikes': 567,
      'numOfComments': 178,
      'numOfShares': 234,
      'date': 'Sponsored',
      'hasImage': true,
      'imageUrl': 'https://via.placeholder.com/400x300?text=Food+Delivery',
      'profileImageUrl': 'https://via.placeholder.com/150?text=Ad',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Enhancement 1: Alternate NewsFeed posts and Advertisement posts 3-4 times
    List<Widget> feedItems = [];
    int postIndex = 0;
    int adIndex = 0;

    // Alternate between posts and advertisements 4 times
    for (int i = 0; i < 4; i++) {
      // Add a post
      if (postIndex < _placeholderPosts.length) {
        final post = _placeholderPosts[postIndex];
        feedItems.add(
          NewsFeedCard(
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
        postIndex++;
      }

      // Add advertisement section with title
      if (adIndex < _advertisements.length) {
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
              color: Colors.grey[700]!,
            ),
          ),
        );

        // Add ads (showing 1-2 ads per section to reach 5-7 total)
        int adsToShow = (i < 2)
            ? 2
            : 1; // First two sections show 2 ads, others show 1
        for (
          int j = 0;
          j < adsToShow && adIndex < _advertisements.length;
          j++
        ) {
          final ad = _advertisements[adIndex];
          feedItems.add(
            NewsFeedCard(
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
          adIndex++;
        }
      }

      // Add another post after ads
      if (postIndex < _placeholderPosts.length) {
        final post = _placeholderPosts[postIndex];
        feedItems.add(
          NewsFeedCard(
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
        postIndex++;
      }
    }

    // Add remaining posts if any
    while (postIndex < _placeholderPosts.length) {
      final post = _placeholderPosts[postIndex];
      feedItems.add(
        NewsFeedCard(
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
      postIndex++;
    }

    return ListView.builder(
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        return feedItems[index];
      },
    );
  }
}
