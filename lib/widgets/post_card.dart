import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';
import 'custom_font.dart';
import '../screens/detail_screen.dart';

class NewsFeedCard extends StatefulWidget {
  final int postId;
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
    this.postId = 1,
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
  State<NewsFeedCard> createState() => _NewsFeedCardState();
}

class _NewsFeedCardState extends State<NewsFeedCard> {
  late int _likes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.numOfLikes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likes++;
      } else {
        if (_likes > 0) _likes--;
      }
    });
  }

  void _navigateToDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          postId: widget.postId,
          userName: widget.userName,
          postContent: widget.postContent,
          date: widget.date,
          initialNumOfLikes: _likes,
          imageUrl: widget.imageUrl,
          profileImageUrl: widget.profileImageUrl,
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    if (!widget.hasImage || widget.imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(200),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.imageUrl.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: widget.imageUrl,
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
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  color: Colors.grey[400],
                  size: ScreenUtil().setSp(50),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _navigateToDetail,
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
                  widget.profileImageUrl.isNotEmpty &&
                          widget.profileImageUrl.startsWith('http')
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: ScreenUtil().setSp(20),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.profileImageUrl,
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
                          backgroundImage: widget.profileImageUrl.isNotEmpty
                              ? AssetImage(widget.profileImageUrl)
                                  as ImageProvider
                              : null,
                          child: widget.profileImageUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(25),
                                )
                              : null,
                        ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomFont(
                            text: widget.date,
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
              SizedBox(height: ScreenUtil().setHeight(8)),
              CustomFont(
                text: widget.postContent,
                fontSize: ScreenUtil().setSp(13),
                color: Colors.black,
              ),
              SizedBox(height: ScreenUtil().setHeight(8)),
              _buildPostImage(),
              SizedBox(height: ScreenUtil().setHeight(10)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _toggleLike,
                        icon: Icon(
                          _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: _isLiked ? FB_PRIMARY : FB_DARK_PRIMARY,
                        ),
                      ),
                      CustomFont(
                        text: '$_likes',
                        fontSize: ScreenUtil().setSp(12),
                        color: _isLiked ? FB_PRIMARY : Colors.grey,
                        fontWeight:
                            _isLiked ? FontWeight.bold : FontWeight.normal,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _navigateToDetail,
                        icon: const Icon(Icons.comment, color: FB_DARK_PRIMARY),
                      ),
                      CustomFont(
                        text: '${widget.numOfComments}',
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
                        text: '${widget.numOfShares}',
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  widget.profileImageUrl.isNotEmpty &&
                          widget.profileImageUrl.startsWith('http')
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: ScreenUtil().setSp(15),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.profileImageUrl,
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
                          backgroundImage: widget.profileImageUrl.isNotEmpty
                              ? AssetImage(widget.profileImageUrl)
                                  as ImageProvider
                              : null,
                          child: widget.profileImageUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: ScreenUtil().setSp(20),
                                )
                              : null,
                        ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Expanded(
                    child: GestureDetector(
                      onTap: _navigateToDetail,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(12),
                          vertical: ScreenUtil().setHeight(6),
                        ),
                        alignment: Alignment.centerLeft,
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
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(8)),
              GestureDetector(
                onTap: _navigateToDetail,
                child: CustomFont(
                  text: 'View comments',
                  fontSize: ScreenUtil().setSp(12),
                  fontWeight: FontWeight.bold,
                  color: FB_DARK_PRIMARY,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
