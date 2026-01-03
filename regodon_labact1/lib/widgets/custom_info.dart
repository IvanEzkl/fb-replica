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
                  postContent: commentText.isNotEmpty
                      ? commentText
                      : (postContent.isNotEmpty ? postContent : description),
                  date: postDate.isNotEmpty ? postDate : date,
                  initialNumOfLikes: postLikes > 0 ? postLikes : numOfLikes,
                  imageUrl: imageUrl,
                  profileImageUrl: profileImageUrl,
                ),
              ),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE PICTURE LOGIC
            (profileImageUrl.isEmpty)
                ? icon
                : CircleAvatar(
                    radius: ScreenUtil().setSp(20),
                    backgroundColor: Colors.grey[200],
                    backgroundImage: AssetImage(profileImageUrl),
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
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Frutiger',
                      ),
                      children: [
                        TextSpan(
                          text: 'posted $post: ',
                          style: TextStyle(fontSize: ScreenUtil().setSp(13)),
                        ),
                        TextSpan(
                          text: description,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(13),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  CustomFont(
                    text: date,
                    fontSize: ScreenUtil().setSp(12),
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),

            const Icon(Icons.more_horiz),
          ],
        ),
      ),
    );
  }
}
