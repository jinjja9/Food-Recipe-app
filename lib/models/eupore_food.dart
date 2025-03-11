import 'food.dart';

class EuporeFood extends Food {
  EuporeFood({
    required super.name,
    required super.image,
    required super.cal,
    required super.time,
    required super.rate,
    required super.reviews,
    required super.isLiked,
  });
}

final List<EuporeFood> foodsEupore = [
  EuporeFood(
    name: "French Toast",
    image: "assets/images/french-toast.jpg",
    cal: 110,
    time: 16,
    rate: 4.6,
    reviews: 90,
    isLiked: true,
  ),
  EuporeFood(
    name: "Dumplings",
    image: "assets/images/dumplings.jpg",
    cal: 150,
    time: 30,
    rate: 4.0,
    reviews: 76,
    isLiked: false,
  ),
  EuporeFood(
    name: "Mexican Pizza",
    image: "assets/images/mexican-pizza.jpg",
    cal: 140,
    time: 25,
    rate: 4.4,
    reviews: 23,
    isLiked: false,
  ),
  EuporeFood(
    name: "French Toast",
    image: "assets/images/french-toast.jpg",
    cal: 110,
    time: 16,
    rate: 4.6,
    reviews: 90,
    isLiked: true,
  ),
];
