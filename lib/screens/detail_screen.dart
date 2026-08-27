import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/comment_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_font.dart';

class DetailScreen extends StatefulWidget {
  final int postId;
  final String userName;
  final String postContent;
  final String date;
  final int initialNumOfLikes;
  final String imageUrl;
  final String profileImageUrl;
  final String? initialCommentAuthor;
  final String? initialCommentText;

  const DetailScreen({
    super.key,
    this.postId = 1,
    required this.userName,
    required this.postContent,
    this.initialNumOfLikes = 0,
    required this.date,
    this.imageUrl = '',
    this.profileImageUrl = '',
    this.initialCommentAuthor,
    this.initialCommentText,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CommentService _commentService = CommentService();
  final UserService _userService = UserService();
  final TextEditingController _commentController = TextEditingController();

  late int numOfLikes;
  bool isLiked = false;
  late String finalPostImage;

  List<Comment> _comments = [];
  bool _isLoadingComments = true;
  bool _isPostingComment = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    numOfLikes = widget.initialNumOfLikes;

    if (widget.imageUrl.isNotEmpty) {
      finalPostImage = widget.imageUrl;
    } else {
      finalPostImage = '';
    }

    _loadUserAndComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndComments() async {
    _currentUser = await _userService.getSavedUser();
    try {
      final comments = await _commentService.getCommentsByPostId(widget.postId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _insertInitialCommentIfNeeded();
          _isLoadingComments = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _insertInitialCommentIfNeeded();
          _isLoadingComments = false;
        });
      }
    }
  }

  void _insertInitialCommentIfNeeded() {
    if (widget.initialCommentAuthor != null &&
        widget.initialCommentAuthor!.isNotEmpty &&
        widget.initialCommentText != null &&
        widget.initialCommentText!.isNotEmpty) {
      // Check if already in the list
      final exists = _comments.any((c) =>
          c.user.fullName == widget.initialCommentAuthor &&
          c.body == widget.initialCommentText);
      if (!exists) {
        _comments.insert(
          0,
          Comment(
            id: DateTime.now().millisecondsSinceEpoch,
            body: widget.initialCommentText!,
            postId: widget.postId,
            likes: 1,
            user: CommentUser(
              id: 999,
              username: widget.initialCommentAuthor!
                  .toLowerCase()
                  .replaceAll(' ', '_'),
              fullName: widget.initialCommentAuthor!,
            ),
          ),
        );
      }
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isPostingComment = true;
    });

    final currentUserId = _currentUser?.id ?? 1;
    final currentUserName = _currentUser?.username ?? 'user';
    final currentFullName = _currentUser?.fullName ?? 'User';

    try {
      final newComment = await _commentService.addComment(
        postId: widget.postId,
        body: text,
        userId: currentUserId,
      );

      if (mounted) {
        setState(() {
          _comments.insert(0, newComment);
          _commentController.clear();
        });
      }
    } catch (_) {
      // Local optimistic fallback
      if (mounted) {
        setState(() {
          _comments.insert(
            0,
            Comment(
              id: DateTime.now().millisecondsSinceEpoch,
              body: text,
              postId: widget.postId,
              likes: 0,
              user: CommentUser(
                id: currentUserId,
                username: currentUserName,
                fullName: currentFullName,
              ),
            ),
          );
          _commentController.clear();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPostingComment = false;
        });
      }
    }
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        numOfLikes++;
      } else {
        if (numOfLikes > 0) numOfLikes--;
      }
    });
  }

  Widget _buildImageWidget(String path) {
    if (path.isEmpty) return const SizedBox.shrink();
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final bubbleBg = isDark ? const Color(0xFF252525) : Colors.grey[100];
    final inputFillBg = isDark ? const Color(0xFF2C2C2C) : Colors.grey[100];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomFont(
          text: widget.userName,
          fontSize: ScreenUtil().setSp(20),
        ),
        backgroundColor: navBg,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (finalPostImage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(250),
                      color: isDark ? Colors.grey[900] : Colors.grey[200],
                      child: _buildImageWidget(finalPostImage),
                    ),
                  SizedBox(height: ScreenUtil().setHeight(15)),

                  // Header / User Row
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: ScreenUtil().setSp(20),
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                          backgroundImage: widget.profileImageUrl.isNotEmpty &&
                                  widget.profileImageUrl.startsWith('http')
                              ? NetworkImage(widget.profileImageUrl)
                              : (widget.profileImageUrl.isNotEmpty
                                  ? AssetImage(widget.profileImageUrl)
                                      as ImageProvider
                                  : null),
                          child: widget.profileImageUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  color: isDark ? Colors.white70 : Colors.grey[600],
                                )
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
                            ),
                            Row(
                              children: [
                                CustomFont(
                                  text: widget.date,
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.grey,
                                ),
                                SizedBox(width: ScreenUtil().setWidth(5)),
                                Icon(
                                  Icons.public,
                                  size: ScreenUtil().setSp(12),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.more_horiz,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ScreenUtil().setHeight(12)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(16),
                    ),
                    child: CustomFont(
                      text: widget.postContent,
                      fontSize: ScreenUtil().setSp(14),
                    ),
                  ),

                  SizedBox(height: ScreenUtil().setHeight(15)),
                  const Divider(height: 1),

                  // Actions Row: Clickable Like Button, Comment, Share
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10),
                      vertical: ScreenUtil().setHeight(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          onPressed: _toggleLike,
                          icon: Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            color: isLiked ? FB_PRIMARY : FB_DARK_PRIMARY,
                            size: ScreenUtil().setSp(18),
                          ),
                          label: CustomFont(
                            text: numOfLikes == 0 ? 'Like' : '$numOfLikes Likes',
                            fontSize: ScreenUtil().setSp(13),
                            color: isLiked ? FB_PRIMARY : FB_DARK_PRIMARY,
                            fontWeight:
                                isLiked ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.comment_outlined,
                            color: FB_DARK_PRIMARY,
                          ),
                          label: CustomFont(
                            text: '${_comments.length} Comments',
                            fontSize: ScreenUtil().setSp(13),
                            color: FB_DARK_PRIMARY,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share_outlined,
                            color: FB_DARK_PRIMARY,
                          ),
                          label: const CustomFont(
                            text: 'Share',
                            fontSize: 13,
                            color: FB_DARK_PRIMARY,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),
                  SizedBox(height: ScreenUtil().setHeight(10)),

                  // Comments Section Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(16),
                    ),
                    child: CustomFont(
                      text: 'Comments',
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(8)),

                  // Comments List
                  if (_isLoadingComments)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: FB_PRIMARY),
                      ),
                    )
                  else if (_comments.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                      child: Center(
                        child: CustomFont(
                          text: 'No comments yet. Be the first to comment!',
                          fontSize: ScreenUtil().setSp(13),
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(16),
                            vertical: ScreenUtil().setHeight(6),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: ScreenUtil().setSp(16),
                                backgroundColor: FB_LIGHT_PRIMARY,
                                child: Text(
                                  comment.user.fullName.isNotEmpty
                                      ? comment.user.fullName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: FB_DARK_PRIMARY,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(10)),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setSp(10),
                                  ),
                                  decoration: BoxDecoration(
                                    color: bubbleBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomFont(
                                        text: comment.user.fullName,
                                        fontSize: ScreenUtil().setSp(13),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(3),
                                      ),
                                      CustomFont(
                                        text: comment.body,
                                        fontSize: ScreenUtil().setSp(13),
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                      if (comment.likes > 0) ...[
                                        SizedBox(
                                          height: ScreenUtil().setHeight(4),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.thumb_up,
                                              size: ScreenUtil().setSp(11),
                                              color: FB_PRIMARY,
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(4),
                                            ),
                                            CustomFont(
                                              text: '${comment.likes}',
                                              fontSize: ScreenUtil().setSp(11),
                                              color: isDark ? Colors.grey[400] : Colors.grey[700]!,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                ],
              ),
            ),
          ),

          // Add Comment Input Bar
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(12),
              vertical: ScreenUtil().setHeight(8),
            ),
            decoration: BoxDecoration(
              color: navBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(13),
                          color: isDark ? Colors.grey[500] : Colors.grey,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(14),
                          vertical: ScreenUtil().setHeight(8),
                        ),
                        filled: true,
                        fillColor: inputFillBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  _isPostingComment
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: FB_PRIMARY,
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: FB_PRIMARY),
                          onPressed: _addComment,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}