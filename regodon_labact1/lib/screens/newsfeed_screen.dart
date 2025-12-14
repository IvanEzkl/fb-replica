import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  // General Enhancement: 8 Posts
  final List<Map<String, dynamic>> _placeholderPosts = [
    {
      'userName': 'Ivan Regodon',
      'postContent': 'Mic Test',
      'numOfLikes': 67,
      'date': 'October 11',
      'hasImage': false, 
    },
    {
      'userName': 'Ivan Regodon',
      'postContent': 'Ih ambang es',
      'numOfLikes': 619,
      'date': 'November 28',
      'hasImage': true, 
    },
    {
      'userName': 'Flutter Dev',
      'postContent': 'Another post to show the list is dynamic.',
      'numOfLikes': 5,
      'date': 'December 1',
      'hasImage': false,
    },
    {
      'userName': 'Code Master',
      'postContent': 'Debugging all night long. ☕ #DevelopersLife',
      'numOfLikes': 120,
      'date': 'December 2',
      'hasImage': false,
    },
    {
      'userName': 'Travel Buddy',
      'postContent': 'Missing the beach vibes! 🌊',
      'numOfLikes': 89,
      'date': 'December 3',
      'hasImage': false,
    },
    {
      'userName': 'Tech News',
      'postContent': 'The new gadget release is mind-blowing!',
      'numOfLikes': 230,
      'date': 'December 4',
      'hasImage': false,
    },
    {
      'userName': 'Daily Quotes',
      'postContent': 'Keep pushing forward. Consistency is key.',
      'numOfLikes': 45,
      'date': 'December 5',
      'hasImage': false,
    },
    {
      'userName': 'Foodie Corner',
      'postContent': 'Best ramen in town! 🍜',
      'numOfLikes': 312,
      'date': 'December 6',
      'hasImage': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _placeholderPosts.length, 
      itemBuilder: (context, index) {
        final post = _placeholderPosts[index];
        return NewsFeedCard(
          userName: post['userName'],
          postContent: post['postContent'],
          numOfLikes: post['numOfLikes'],
          date: post['date'], 
          hasImage: post['hasImage'], 
        );
      },
    );
  }
}