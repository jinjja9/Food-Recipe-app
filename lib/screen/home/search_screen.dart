import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/food.dart';
import '../../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchFoods(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance.collection('foods').get();
      final allFoods = snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
      
      // Tìm kiếm không phân biệt chữ hoa/thường
      final lowercaseQuery = query.toLowerCase();
      
      final results = allFoods.where((food) {
        // Tìm kiếm theo tên
        if (food.name.toLowerCase().contains(lowercaseQuery)) return true;
        
        // Tìm kiếm theo mô tả
        if (food.description.toLowerCase().contains(lowercaseQuery)) return true;
        
        // Tìm kiếm theo thành phần
        if (food.ingredients.any((ingredient) => 
            ingredient.toLowerCase().contains(lowercaseQuery))) return true;
        
        return false;
      }).toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error searching foods: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm món ăn...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: _searchFoods,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Text(
                    _searchController.text.isEmpty
                        ? 'Nhập từ khóa để tìm kiếm'
                        : 'Không tìm thấy kết quả',
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return SearchResultCard(food: _searchResults[index]);
                  },
                ),
    );
  }
} 