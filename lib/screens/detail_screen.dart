import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/custom_font.dart';
import '../constant.dart'; 

class DetailScreen extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int initialNumOfLikes;
  final String imageUrl;
  final String profileImageUrl;

  const DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    this.initialNumOfLikes = 0,
    required this.date,
    this.imageUrl = '',
    this.profileImageUrl = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int numOfLikes;
  late String finalPostImage;

  @override
  void initState() {
    super.initState();
    numOfLikes = widget.initialNumOfLikes;

    if (widget.imageUrl.isNotEmpty) {
      finalPostImage = widget.imageUrl;
    } else {
      finalPostImage = 'assets/images/waffle.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: CustomFont(
          text: widget.userName,
          fontSize: ScreenUtil().setSp(20),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SizedBox(
        height: ScreenUtil().screenHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(250),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: AssetImage(finalPostImage),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      print("Cannot find image: $finalPostImage");
                    },
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: ScreenUtil().setSp(20),
                      backgroundColor: Colors.grey[300],
                      backgroundImage: widget.profileImageUrl.isNotEmpty
                          ? AssetImage(widget.profileImageUrl)
                          : null,
                      child: widget.profileImageUrl.isEmpty
                          ? Icon(Icons.person, color: Colors.grey[600])
                          : null,
                    ),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: widget.userName,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            CustomFont(
                              text: widget.date,
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.grey,
                            ),
                            SizedBox(width: ScreenUtil().setWidth(5)),
                            Icon(Icons.public, size: ScreenUtil().setSp(12), color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.more_horiz),
                  ],
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(15)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: CustomFont(
                  text: widget.postContent,
                  fontSize: ScreenUtil().setSp(14),
                  color: Colors.black,
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(30)),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(Icons.thumb_up, (numOfLikes == 0) ? 'Like' : '$numOfLikes', () {
                      setState(() {
                        numOfLikes++;
                      });
                    }),
                    _buildActionButton(Icons.comment, 'Comment', () {}),
                    _buildActionButton(Icons.share, 'Share', () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: FB_DARK_PRIMARY, size: ScreenUtil().setSp(20)),
      label: CustomFont(
        text: label,
        fontSize: ScreenUtil().setSp(12),
        color: FB_DARK_PRIMARY,
      ),
    );
  }
}