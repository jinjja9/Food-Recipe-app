import 'package:flutter/material.dart';

import '../../core/color.dart';

class Comment {
  final String userName;
  final String userAvatar;
  final String text;
  final DateTime date;
  final int likes;

  Comment({
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.date,
    required this.likes,
  });
}

class CommentsSection extends StatefulWidget {
  final String foodName;

  const CommentsSection({
    super.key,
    required this.foodName,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  // Mock data - in a real app, this would come from a database
  final List<Comment> _comments = [
    Comment(
      userName: 'Nguyễn Văn A',
      userAvatar: 'assets/images/avatar1.png',
      text: 'Món này rất ngon! Tôi đã làm theo công thức và cả nhà đều thích.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      likes: 12,
    ),
    Comment(
      userName: 'Trần Thị B',
      userAvatar: 'assets/images/avatar2.png',
      text:
          'Tôi thay thịt bò bằng thịt gà và vẫn rất ngon. Cảm ơn vì công thức!',
      date: DateTime.now().subtract(const Duration(days: 1)),
      likes: 8,
    ),
    Comment(
      userName: 'Lê Văn C',
      userAvatar: 'assets/images/avatar3.png',
      text: 'Có thể cho tôi biết loại phô mai nào phù hợp nhất không?',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 3,
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatTimeAgo(DateTime date) {
    final Duration difference = DateTime.now().difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _commentController.clear();
    setState(() {
      _isComposing = false;
      // In a real app, you would send this to a database
      _comments.insert(
        0,
        Comment(
          userName: 'Bạn',
          userAvatar: 'assets/images/avatar_user.png',
          text: text,
          date: DateTime.now(),
          likes: 0,
        ),
      );
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Bình luận (${_comments.length})'),
        const SizedBox(height: 16),

        // Comment input field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/avatar_user.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Thêm bình luận...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.trim().isNotEmpty;
                    });
                  },
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: _isComposing ? kprimaryColor : Colors.grey.shade400,
                ),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_commentController.text)
                    : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Comments list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(comment.userAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _formatTimeAgo(comment.date),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Show options menu (report, delete, etc.)
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    comment.text,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Like functionality
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up_outlined,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              comment.likes.toString(),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          // Reply functionality
                        },
                        child: Text(
                          'Trả lời',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
