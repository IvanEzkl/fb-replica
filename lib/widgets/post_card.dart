import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constant.dart';
import 'custom_font.dart';
import '../screens/detail_screen.dart';

class NewsFeedCard extends StatelessWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final int numOfComments;
  final int numOfShares;
  final bool hasImage;
  final String imageUrl;
  final String profileImageUrl;

  const NewsFeedCard({
    super.key,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    this.numOfComments = 0,
    this.numOfShares = 0,
    this.hasImage = false,
    this.imageUrl = '',
    this.profileImageUrl = '',
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              userName: userName,
              postContent: postContent,
              date: date,
              initialNumOfLikes: numOfLikes,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                  profileImageUrl.isNotEmpty &&
                          profileImageUrl.startsWith('http')
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: ScreenUtil().setSp(20),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profileImageUrl,
                              fit: BoxFit.cover,
                              width: ScreenUtil().setSp(40),
                              height: ScreenUtil().setSp(40),
                              placeholder: (context, url) => Icon(
                                Icons.person,
                                color: Colors.white,
                                size: ScreenUtil().setSp(25),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                color: Colors.white,
                                size: ScreenUtil().setSp(25),
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: ScreenUtil().setSp(20),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: ScreenUtil().setSp(25),
                          ),
                        ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: userName,
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomFont(
                            text: date,
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(3)),
                          Icon(
                            Icons.public,
                            color: Colors.grey,
                            size: ScreenUtil().setSp(15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              // Post Content
              CustomFont(
                text: postContent,
                fontSize: ScreenUtil().setSp(12),
                color: Colors.black,
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),

              hasImage == true
                  ? Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(200),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imageUrl.isNotEmpty
                          ? (imageUrl.startsWith('http')
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.image,
                                      color: Colors.grey[400],
                                      size: ScreenUtil().setSp(50),
                                    ),
                                  )
                                : Image.asset(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image,
                                        color: Colors.grey[400],
                                        size: ScreenUtil().setSp(50),
                                      );
                                    },
                                  ))
                          : Icon(
                              Icons.image,
                              color: Colors.grey[400],
                              size: ScreenUtil().setSp(50),
                            ),
                    )
                  : SizedBox(height: ScreenUtil().setHeight(1)),
              SizedBox(height: ScreenUtil().setHeight(10)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.thumb_up,
                          color: FB_DARK_PRIMARY,
                        ),
                      ),
                      CustomFont(
                        text: '$numOfLikes',
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.comment, color: FB_DARK_PRIMARY),
                      ),
                      CustomFont(
                        text: '$numOfComments',
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: FB_DARK_PRIMARY),
                      ),
                      CustomFont(
                        text: '$numOfShares',
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  
                  profileImageUrl.isNotEmpty &&
                          profileImageUrl.startsWith('http')
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: ScreenUtil().setSp(15),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profileImageUrl,
                              fit: BoxFit.cover,
                              width: ScreenUtil().setSp(30),
                              height: ScreenUtil().setSp(30),
                              placeholder: (context, url) => Icon(
                                Icons.person,
                                color: Colors.white,
                                size: ScreenUtil().setSp(20),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                color: Colors.white,
                                size: ScreenUtil().setSp(20),
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: ScreenUtil().setSp(15),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: ScreenUtil().setSp(20),
                          ),
                        ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setSp(10),
                      0,
                      0,
                      0,
                    ),
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setHeight(25),
                    width: ScreenUtil().setWidth(280),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setSp(10)),
                      ),
                    ),
                    child: CustomFont(
                      text: 'Write a comment...',
                      fontSize: ScreenUtil().setSp(11),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomFont(
                text: 'View comments',
                fontSize: ScreenUtil().setSp(12),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
