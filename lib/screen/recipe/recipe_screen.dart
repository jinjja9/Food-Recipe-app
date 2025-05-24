import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/color.dart';
import '../../models/food.dart';
import '../../widgets/liked_users_dialog.dart';
import 'widgets/recipe_header.dart';
import 'widgets/recipe_image.dart';
import 'widgets/recipe_stats.dart';
import 'widgets/author_info.dart';
import 'widgets/recipe_content.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;
  final Function()? onFoodUpdated;

  const RecipeScreen({
    super.key, 
    required this.food,
    this.onFoodUpdated,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
  late Food _food;
  int currentNumber = 1;
  String? categoryName;
  bool _isLiked = false;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 2, vsync: this);
    _food = widget.food;
    _isLiked = _food.likedUsers.contains(FirebaseAuth.instance.currentUser?.uid);
    categoryName = _food.category.isNotEmpty ? _food.category : 'Chưa có thể loại';
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;
      final foodRef = FirebaseFirestore.instance.collection('foods').doc(_food.id);
      
      List<String> likedUsers = List<String>.from(_food.likedUsers);
      if (_isLiked) {
        likedUsers.remove(uid);
      } else {
        likedUsers.add(uid);
      }

      await foodRef.update({'likedUsers': likedUsers});
      
      setState(() {
        _food.likedUsers = likedUsers;
        _isLiked = !_isLiked;
      });

      // Gọi callback khi trạng thái like thay đổi
      if (widget.onFoodUpdated != null) {
        widget.onFoodUpdated!();
      }
    } catch (e) {
      print('Error toggling like: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: RecipeHeader(
        food: _food,
        showTitle: _showTitle,
        onFavoriteChanged: (isFavorite) {
          setState(() {});
        },
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero image
          SliverToBoxAdapter(
            child: RecipeImage(imageUrl: _food.image),
          ),

          // Recipe content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecipeContent(food: _food),
                  const SizedBox(height: 24),
                  RecipeStats(food: _food),
                  const SizedBox(height: 24),
                  AuthorInfo(authorId: _food.uid),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
