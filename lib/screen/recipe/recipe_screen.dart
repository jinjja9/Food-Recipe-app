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
  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
  int currentNumber = 1;
  String? categoryName;
  bool isFavorite = false;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 2, vsync: this);
    categoryName = widget.food.category.isNotEmpty ? widget.food.category : 'Chưa có thể loại';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: RecipeHeader(
        food: widget.food,
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
            child: RecipeImage(imageUrl: widget.food.image),
          ),

          // Recipe content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecipeContent(food: widget.food),
                  const SizedBox(height: 24),
                  RecipeStats(food: widget.food),
                  const SizedBox(height: 24),
                  AuthorInfo(authorId: widget.food.uid),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
