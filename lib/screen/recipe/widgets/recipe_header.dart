import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user.dart' as app_user;

import '../../../models/food.dart';

class RecipeHeader extends StatefulWidget implements PreferredSizeWidget {
  final Food food;
  final bool showTitle;
  final Function(bool) onFavoriteChanged;

  const RecipeHeader({
    super.key,
    required this.food,
    required this.showTitle,
    required this.onFavoriteChanged,
  });

  @override
  State<RecipeHeader> createState() => _RecipeHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _RecipeHeaderState extends State<RecipeHeader> {
  late Stream<DocumentSnapshot> _foodStream;
  String? _currentRole;
  String? _currentUid;

  @override
  void initState() {
    super.initState();
    _foodStream = FirebaseFirestore.instance
        .collection('foods')
        .doc(widget.food.id)
        .snapshots();
    _currentUid = FirebaseAuth.instance.currentUser?.uid;
    _fetchCurrentUserRole();
  }

  Future<void> _fetchCurrentUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        _currentRole = (doc.data() as Map<String, dynamic>)['role'] ?? 'user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.showTitle ? Colors.white : Colors.transparent,
      elevation: widget.showTitle ? 2 : 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: widget.showTitle ? Colors.black : Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: widget.showTitle
          ? Text(
              widget.food.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      actions: [
        StreamBuilder<DocumentSnapshot>(
          stream: _foodStream,
          builder: (context, snapshot) {
            // Use the original food object as a fallback if stream data is not available yet
            final currentFood = snapshot.data != null && snapshot.data!.exists
                ? Food.fromFirestore(snapshot.data!.data() as Map<String, dynamic>, snapshot.data!.id)
                : widget.food;

            final user = FirebaseAuth.instance.currentUser;
            final uid = user?.uid ?? '';
            final isFavorite = currentFood.likedUsers.contains(uid);

            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.showTitle ? Colors.red : Colors.white,
              ),
              onPressed: () async {
                // Use the food ID from the original widget for the update
                final foodRef = FirebaseFirestore.instance.collection('foods').doc(widget.food.id);
                List<String> likedUsers = List<String>.from(currentFood.likedUsers);
                if (isFavorite) {
                  likedUsers.remove(uid);
                } else {
                  likedUsers.add(uid);
                }
                await foodRef.update({'likedUsers': likedUsers});
                // The stream listener will handle the UI update, no need to call onFavoriteChanged here
                // widget.onFavoriteChanged(!isFavorite);
              },
            );
          },
        ),
        if (_currentUid != null && (_currentUid == widget.food.uid || _currentRole == 'admin'))
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: widget.showTitle ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xóa món ăn'), content: const Text('Bạn có chắc chắn muốn xóa món ăn này không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Xóa'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await FirebaseFirestore.instance.collection('foods').doc(widget.food.id).delete();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa món ăn!')),
                  );
                }
              }
            },
          ),
        IconButton(
          icon: Icon(
            Icons.share_rounded,
            color: widget.showTitle ? Colors.black : Colors.white,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}