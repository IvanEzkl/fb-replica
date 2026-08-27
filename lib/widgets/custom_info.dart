import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_font.dart';
import '../screens/detail_screen.dart';

class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    this.icon = const Icon(Icons.person),
    required this.date,
    required this.numOfLikes,
    this.atProfile = false,
    this.profileImageUrl = '',
    this.imageUrl = '',
    this.postContent = '',
    this.postDate = '',
    this.postLikes = 0,
    this.postComments = 0,
    this.postShares = 0,
    this.hasImage = false,
    this.userName = '',
    this.commentText = '',
  });

  final String name;
  final String post;
  final String description;
  final Icon icon;
  final String date;
  final int numOfLikes;
  final bool atProfile;
  final String profileImageUrl;
  final String imageUrl;
  final String postContent;
  final String postDate;
  final int postLikes;
  final int postComments;
  final int postShares;
  final bool hasImage;
  final String userName;
  final String commentText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: InkWell(
        onTap: () {
          if (atProfile) {
            print('Clicked at profile, no action.');
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  userName: userName.isNotEmpty ? userName : name,
                  postContent: postContent.isNotEmpty
                      ? postContent
                      : (commentText.isNotEmpty ? 'Check out my latest post!' : description),
                  date: postDate.isNotEmpty ? postDate : (date.isNotEmpty ? date : '2 hours ago'),
                  initialNumOfLikes: postLikes > 0 ? postLikes : (numOfLikes > 0 ? numOfLikes : 45),
                  imageUrl: imageUrl,
                  profileImageUrl: profileImageUrl,
                  initialCommentAuthor: commentText.isNotEmpty ? name : null,
                  initialCommentText: commentText.isNotEmpty ? commentText : null,
                ),
              ),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileImageUrl.isEmpty
                ? CircleAvatar(
                    radius: ScreenUtil().setSp(20),
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      size: ScreenUtil().setSp(22),
                    ),
                  )
                : CircleAvatar(
                    radius: ScreenUtil().setSp(20),
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    backgroundImage: profileImageUrl.startsWith('http')
                        ? NetworkImage(profileImageUrl)
                        : AssetImage(profileImageUrl) as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print("Error loading profile image: $profileImageUrl");
                    },
                  ),
            SizedBox(width: ScreenUtil().setWidth(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFont(
                    text: name,
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w800,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(3)),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontFamily: 'Frutiger',
                      ),
                      children: [
                        TextSpan(
                          text: '$post: ',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            color: primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: description,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (date.isNotEmpty) ...[
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    CustomFont(
                      text: date,
                      fontSize: ScreenUtil().setSp(12),
                      color: Colors.grey.shade500,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.more_horiz,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
