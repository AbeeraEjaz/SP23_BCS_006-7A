import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';
import '../models/cart_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all food items
  Future<List<FoodModel>> getFoodItems() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('foods').get();
      return snapshot.docs
          .map((doc) => FoodModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      return _getDummyFoodItems();
    }
  }

  // Place order
  Future<bool> placeOrder({
    required List<CartItem> items,
    required String userEmail,
    required double totalPrice,
  }) async {
    try {
      for (var item in items) {
        await _firestore.collection('orders').add({
          'foodName': item.food.name,
          'price': item.food.price,
          'quantity': item.quantity,
          'userEmail': userEmail,
          'totalPrice': totalPrice,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Dummy food data (fallback if Firestore is empty)
  List<FoodModel> _getDummyFoodItems() {
    return [
      FoodModel(
        id: '1', name: 'Chicken Burger', category: 'Burgers',
        description: 'Juicy grilled chicken with lettuce, tomato & special sauce.',
        price: 350, imageUrl: 'https://via.placeholder.com/300',
        rating: 4.5, deliveryTime: 25,
      ),
      FoodModel(
        id: '2', name: 'Beef Pizza', category: 'Pizza',
        description: 'Wood-fired pizza with beef toppings and mozzarella.',
        price: 650, imageUrl: 'https://via.placeholder.com/300',
        rating: 4.7, deliveryTime: 35,
      ),
      FoodModel(
        id: '3', name: 'Chicken Shawarma', category: 'Shawarma',
        description: 'Classic shawarma with garlic sauce and fries.',
        price: 280, imageUrl: 'https://via.placeholder.com/300',
        rating: 4.3, deliveryTime: 20,
      ),
      FoodModel(
        id: '4', name: 'Biryani', category: 'Rice',
        description: 'Aromatic basmati rice with tender chicken pieces.',
        price: 450, imageUrl: 'https://via.placeholder.com/300',
        rating: 4.8, deliveryTime: 40,
      ),
      FoodModel(
        id: '5', name: 'Fries + Drink', category: 'Combo',
        description: 'Crispy golden fries with your choice of cold drink.',
        price: 200, imageUrl: 'https://via.placeholder.com/300',
        rating: 4.2, deliveryTime: 15,
      ),
      FoodModel(
        id: '6', name: 'Zinger Wrap', category: 'Wraps',
        description: 'Crispy zinger fillet wrapped in soft tortilla with coleslaw.',
        price: 320, imageUrl: 'https://via.placeholder.com/300',
        rating: 4.4, deliveryTime: 22,
      ),
    ];
  }
}
