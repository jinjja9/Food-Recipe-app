import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  void initState() {
    super.initState();
    _foodStream = FirebaseFirestore.instance
        .collection('foods')
        .doc(widget.food.id)
        .snapshots();
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