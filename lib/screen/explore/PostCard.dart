import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/color.dart';
import '../../models/food.dart';

class PostCard extends StatefulWidget {
  final Food food;

  const PostCard({
    required this.food,
    super.key,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final isLiked = widget.food.likedUsers.contains(uid);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: kbackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with author info
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.food.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(radius: 24, child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const CircleAvatar(radius: 24, child: Icon(Icons.person));
                    }
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    final avatarUrl = userData['avatarImage'] ?? '';
                    return CircleAvatar(
                      radius: 24,
                      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.author ?? 'Unknown Author',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "13/03/2024",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Food image with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: Image.network(
                  widget.food.image ?? 'https://via.placeholder.com/400x300',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error_outline, size: 50),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    widget.food.name ?? 'Untitled Recipe',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Engagement stats and action buttons
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () async {
                            final foodRef = FirebaseFirestore.instance.collection('foods').doc(widget.food.id);
                            List<String> likedUsers = List<String>.from(widget.food.likedUsers);
                            if (isLiked) {
                              likedUsers.remove(uid);
                            } else {
                              likedUsers.add(uid);
                            }
                            await foodRef.update({'likedUsers': likedUsers});
                            setState(() {
                              widget.food.likedUsers = likedUsers;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.food.likedUsers.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isLiked ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.food.cooking_time ?? 0} phút',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.rate_review,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.food.reviews ?? 0}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
