import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/custom_info.dart';

class NotificationScreen extends StatefulWidget {
  final User? user;
  final ScrollController? scrollController;
  const NotificationScreen({super.key, this.user, this.scrollController});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final UserService _userService = UserService();
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

  List<Map<String, dynamic>> _getNotificationsForUser(User? user) {
    final username = user?.username.toLowerCase() ?? 'user';

    if (username == 'emilys') {
      return [
        {
          'name': 'Michael Williams',
          'post': 'liked your post',
          'description': '3 minutes ago',
          'postContent': 'Product sprint complete! So excited for next launch 🚀',
          'postDate': '1 hour ago',
          'postLikes': 88,
          'postComments': 14,
          'postShares': 5,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=11',
        },
        {
          'name': 'Sophia Brown',
          'post': 'commented on your post',
          'description': '"Congratulations Emily! Proud of your hard work!" • 12 minutes ago',
          'commentText': 'Congratulations Emily! Proud of your hard work!',
          'postContent': 'Product sprint complete! So excited for next launch 🚀',
          'postDate': '1 hour ago',
          'postLikes': 88,
          'postComments': 14,
          'postShares': 5,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=11',
        },
        {
          'name': 'James Smith',
          'post': 'shared your post',
          'description': '25 minutes ago',
          'postContent': 'Product sprint complete! So excited for next launch 🚀',
          'postDate': '1 hour ago',
          'postLikes': 88,
          'postComments': 14,
          'postShares': 5,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=11',
        },
        {
          'name': 'Olivia Davis',
          'post': 'commented on your post',
          'description': '"Inspiring milestone, let\'s celebrate soon!" • 45 minutes ago',
          'commentText': 'Inspiring milestone, let\'s celebrate soon!',
          'postContent': 'Loving Flutter & mobile development!',
          'postDate': 'Yesterday',
          'postLikes': 54,
          'postComments': 7,
          'postShares': 2,
          'hasImage': false,
          'imageUrl': '',
        },
        {
          'name': 'Liam Wilson',
          'post': 'started following you',
          'description': '2 hours ago',
          'postContent': 'Loving Flutter & mobile development!',
          'postDate': 'Yesterday',
          'postLikes': 54,
          'postComments': 7,
          'postShares': 2,
          'hasImage': false,
          'imageUrl': '',
        },
        {
          'name': 'Emma Martinez',
          'post': 'liked your post',
          'description': '3 hours ago',
          'postContent': 'Loving Flutter & mobile development!',
          'postDate': 'Yesterday',
          'postLikes': 54,
          'postComments': 7,
          'postShares': 2,
          'hasImage': false,
          'imageUrl': '',
        },
        {
          'name': 'Noah Taylor',
          'post': 'mentioned you in a comment',
          'description': '"@emilys you should definitely review this PR" • 5 hours ago',
          'commentText': '@emilys you should definitely review this PR',
          'postContent': 'Product sprint complete! So excited for next launch 🚀',
          'postDate': '1 hour ago',
          'postLikes': 88,
          'postComments': 14,
          'postShares': 5,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=11',
        },
      ];
    } else if (username == 'michaelw') {
      return [
        {
          'name': 'Emily Johnson',
          'post': 'liked your post',
          'description': '5 minutes ago',
          'postContent': 'Morning workout session crushed 💪 #HealthyHabits',
          'postDate': '2 hours ago',
          'postLikes': 65,
          'postComments': 10,
          'postShares': 4,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=12',
        },
        {
          'name': 'David Miller',
          'post': 'commented on your post',
          'description': '"Keep up the grind Mike!" • 20 minutes ago',
          'commentText': 'Keep up the grind Mike!',
          'postContent': 'Morning workout session crushed 💪 #HealthyHabits',
          'postDate': '2 hours ago',
          'postLikes': 65,
          'postComments': 10,
          'postShares': 4,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=12',
        },
        {
          'name': 'Sophia Brown',
          'post': 'shared your post',
          'description': '1 hour ago',
          'postContent': 'Morning workout session crushed 💪 #HealthyHabits',
          'postDate': '2 hours ago',
          'postLikes': 65,
          'postComments': 10,
          'postShares': 4,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=12',
        },
        {
          'name': 'Lucas Garcia',
          'post': 'started following you',
          'description': '3 hours ago',
          'postContent': 'Morning workout session crushed 💪 #HealthyHabits',
          'postDate': '2 hours ago',
          'postLikes': 65,
          'postComments': 10,
          'postShares': 4,
          'hasImage': true,
          'imageUrl': 'https://picsum.photos/400/300?random=12',
        },
      ];
    }

    // Default / Ivan Ezekiel Regodon account notifications
    return [
      {
        'name': 'Cyrus Robles',
        'post': 'liked your post',
        'description': '5 minutes ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Maria Santos',
        'post': 'commented on your post',
        'description': '"Great content!" • 15 minutes ago',
        'commentText': 'Great content!',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'John Dela Cruz',
        'post': 'shared your post',
        'description': '32 minutes ago',
        'postContent': 'First day sa gym, nabawasan ako ng 80 pesos!',
        'postDate': '1 day ago',
        'postLikes': 32,
        'postComments': 8,
        'postShares': 2,
        'hasImage': false,
        'imageUrl': '',
      },
      {
        'name': 'Anna Garcia',
        'post': 'started following you',
        'description': '1 hour ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Luis Fernandez',
        'post': 'liked your post',
        'description': '2 hours ago',
        'postContent': 'First day sa gym, nabawasan ako ng 80 pesos!',
        'postDate': '1 day ago',
        'postLikes': 32,
        'postComments': 8,
        'postShares': 2,
        'hasImage': false,
        'imageUrl': '',
      },
      {
        'name': 'Sofia Martinez',
        'post': 'commented on your post',
        'description': '"Amazing!" • 3 hours ago',
        'commentText': 'Amazing!',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Pedro Gonzales',
        'post': 'liked your post',
        'description': '4 hours ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Elena Rodrigues',
        'post': 'shared your post',
        'description': '5 hours ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Carlos Mendoza',
        'post': 'started following you',
        'description': '6 hours ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Rosa Flores',
        'post': 'liked your post',
        'description': '1 day ago',
        'postContent': 'First day sa gym, nabawasan ako ng 80 pesos!',
        'postDate': '1 day ago',
        'postLikes': 32,
        'postComments': 8,
        'postShares': 2,
        'hasImage': false,
        'imageUrl': '',
      },
      {
        'name': 'Miguel Torres',
        'post': 'mentioned you in a comment',
        'description': '"Hey, check this out!" • 1 day ago',
        'commentText': 'Hey, check this out!',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Isabella Cruz',
        'post': 'liked your post',
        'description': '2 days ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Gabriel Lim',
        'post': 'sent you a friend request',
        'description': '3 days ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
      {
        'name': 'Jasmine Lee',
        'post': 'liked your post',
        'description': '4 days ago',
        'postContent': 'First day sa gym, nabawasan ako ng 80 pesos!',
        'postDate': '1 day ago',
        'postLikes': 32,
        'postComments': 8,
        'postShares': 2,
        'hasImage': false,
        'imageUrl': '',
      },
      {
        'name': 'Rafael Santos',
        'post': 'liked your post',
        'description': '1 week ago',
        'postContent': 'We cute',
        'postDate': '2 hours ago',
        'postLikes': 45,
        'postComments': 12,
        'postShares': 3,
        'hasImage': true,
        'imageUrl': 'assets/images/bebi.jpg',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotificationsForUser(_currentUser);
    final currentUserName = _currentUser?.fullName ?? 'Ivan Ezekiel Regodon';
    final currentUserImage = _currentUser?.image ?? 'assets/icons/superpogi.jpg';

    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        child: ListView.separated(
          controller: widget.scrollController,
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return CustomInformation(
              name: item['name']!,
              post: item['post']!,
              description: item['description']!,
              date: '',
              numOfLikes: 0,
              postContent: item['postContent'] ?? '',
              postDate: item['postDate'] ?? '',
              postLikes: item['postLikes'] ?? 0,
              postComments: item['postComments'] ?? 0,
              postShares: item['postShares'] ?? 0,
              imageUrl: item['imageUrl'] ?? '',
              hasImage: item['hasImage'] ?? false,
              userName: currentUserName,
              profileImageUrl: currentUserImage,
              commentText: item['commentText'] ?? '',
            );
          },
        ),
      ),
    );
  }
}
