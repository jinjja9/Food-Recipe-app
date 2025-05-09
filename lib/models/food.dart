class Food {
  String name;
  String image;
  int calories;
  int cooking_time;
  String description;
  String categoryId;
  List<String> ingredients;
  List<String> steps;
  String author;
  String avatarImage;
  bool isLiked;
  double rate;
  int reviews;
  int likes;

  Food({
    required this.name,
    required this.image,
    this.calories = 0,
    this.cooking_time = 0,
    this.description = '',
    this.categoryId = '',
    this.ingredients = const [],
    this.steps = const [],
    this.author = '',
    this.avatarImage = '',
    this.isLiked = false,
    this.rate = 0.0,
    this.reviews = 0,
    this.likes = 0,
  });

  factory Food.fromFirestore(Map<String, dynamic> data) {
    return Food(
      name: (data['name'] is String && data['name'] != null) ? data['name'] : 'Không rõ',
      image: (data['image'] is String && data['image'] != null) ? data['image'] : 'https://res.cloudinary.com/dpv1ucjbh/image/upload/v1746786015/c_vjlm25.jpg',
      calories: (data['calories'] is int) ? data['calories'] : 0,
      cooking_time: (data['cooking_time'] is int) ? data['cooking_time'] : 0,
      description: (data['description'] is String && data['description'] != null) ? data['description'] : '',
      categoryId: (data['categoryId'] is String && data['categoryId'] != null) ? data['categoryId'] : '',
      ingredients: (data['ingredients'] is List)
        ? (data['ingredients'] as List).map((e) => e.toString()).toList()
        : <String>[],
      steps: (data['steps'] is List)
        ? (data['steps'] as List).map((e) => e.toString()).toList()
        : <String>[],
      author: (data['author'] is String && data['author'] != null) ? data['author'] : '',
      avatarImage: (data['avatarImage'] is String && data['avatarImage'] != null) ? data['avatarImage'] : '',
      isLiked: (data['isLiked'] is bool) ? data['isLiked'] : false,
      rate: (data['rate'] is num) ? (data['rate'] as num).toDouble() : 0.0,
      reviews: (data['reviews'] is int) ? data['reviews'] : 0,
      likes: (data['likes'] is int) ? data['likes'] : 0,
    );
  }
}
