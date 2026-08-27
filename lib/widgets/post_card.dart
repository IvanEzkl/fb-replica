import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';
import '../services/user_service.dart';
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
  final String? currentUserImageUrl;

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
    this.currentUserImageUrl,
    required this.date,
  });

  @override
  State<NewsFeedCard> createState() => _NewsFeedCardState();
}

class _NewsFeedCardState extends State<NewsFeedCard> {
  late int _likes;
  bool _isLiked = false;
  String _effectiveUserAvatar = '';

  @override
  void initState() {
    super.initState();
    _likes = widget.numOfLikes;
    _loadCurrentUserAvatar();
  }

  Future<void> _loadCurrentUserAvatar() async {
    if (widget.currentUserImageUrl != null &&
        widget.currentUserImageUrl!.isNotEmpty) {
      setState(() {
        _effectiveUserAvatar = widget.currentUserImageUrl!;
      });
    } else {
      final user = await UserService().getSavedUser();
      if (mounted && user != null && user.image.isNotEmpty) {
        setState(() {
          _effectiveUserAvatar = user.image;
        });
      }
    }
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

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(200),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
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

  Widget _buildAvatar(String url, double radius, bool isDark) {
    if (url.isNotEmpty && url.startsWith('http')) {
      return CircleAvatar(
        backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
        radius: ScreenUtil().setSp(radius),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: ScreenUtil().setSp(radius * 2),
            height: ScreenUtil().setSp(radius * 2),
            placeholder: (context, url) => Icon(
              Icons.person,
              color: Colors.white,
              size: ScreenUtil().setSp(radius * 1.2),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              color: Colors.white,
              size: ScreenUtil().setSp(radius * 1.2),
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
      radius: ScreenUtil().setSp(radius),
      backgroundImage: url.isNotEmpty ? AssetImage(url) as ImageProvider : null,
      child: url.isEmpty
          ? Icon(
              Icons.person,
              color: isDark ? Colors.white70 : Colors.white,
              size: ScreenUtil().setSp(radius * 1.2),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final commentBarBg = isDark ? const Color(0xFF2A2A2A) : Colors.grey[200];

    return InkWell(
      onTap: _navigateToDetail,
      child: Card(
        color: cardBg,
        elevation: isDark ? 0.5 : 1,
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildAvatar(widget.profileImageUrl, 20, isDark),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: ScreenUtil().setSp(15),
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
              ),
              SizedBox(height: ScreenUtil().setHeight(8)),
              _buildPostImage(),
              SizedBox(height: ScreenUtil().setHeight(10)),

              // Likes, Comments, Shares counts
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

              // Comment Input Preview Row with Logged-in User's Avatar
              Row(
                children: [
                  _buildAvatar(_effectiveUserAvatar, 15, isDark),
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
                          color: commentBarBg,
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
