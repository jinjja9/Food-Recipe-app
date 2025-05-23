import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String id;
  String name;
  String image;
  int calories;
  int cooking_time;
  String description;
  String category;
  List<String> ingredients;
  List<String> steps;
  String uid;
  bool isLiked;
  int likes;
  List<String> likedUsers;
  //List<String> follower;
  final Timestamp? createdAt;

  Food({
    required this.id,
    required this.name,
    required this.image,
    this.calories = 0,
    this.cooking_time = 0,
    this.description = '',
    this.category = '',
    this.uid = '',
    this.ingredients = const [],
    this.steps = const [],
    this.isLiked = false,
    this.likes = 0,
    this.likedUsers = const [],
    //this.follower = const [],
    this.createdAt,
  });

  factory Food.fromFirestore(Map<String, dynamic> data, String docId) {
    return Food(
      id: docId,
      name: (data['name'] is String && data['name'] != null) ? data['name'] : 'Không rõ',
      image: (data['image'] is String && data['image'] != null) ? data['image'] : 'https://res.cloudinary.com/dpv1ucjbh/image/upload/v1746786015/c_vjlm25.jpg',
      calories: (data['calories'] is int) ? data['calories'] : 0,
      cooking_time: (data['cooking_time'] is int) ? data['cooking_time'] : 0,
      description: (data['description'] is String && data['description'] != null) ? data['description'] : '',
      category: (data['category'] is String && data['category'] != null) ? data['category'] : '',
      ingredients: (data['ingredients'] is List)
        ? (data['ingredients'] as List).map((e) => e.toString()).toList()
        : <String>[],
      steps: (data['steps'] is List)
        ? (data['steps'] as List).map((e) => e.toString()).toList()
        : <String>[],
      likes: (data['likes'] is int) ? data['likes'] : 0,
      uid: (data['uid'] is String && data['uid'] != null) ? data['uid'] : '',
      likedUsers: (data['likedUsers'] is List)
        ? (data['likedUsers'] as List).map((e) => e.toString()).toList()
        : <String>[],
      // follower: (data['follower'] is List)
      //     ? (data['follower'] as List).map((e) => e.toString()).toList()
      //     : <String>[],
      // createdAt: data['createdAt'] is Timestamp ? data['createdAt'] : null,
    );
  }
}
