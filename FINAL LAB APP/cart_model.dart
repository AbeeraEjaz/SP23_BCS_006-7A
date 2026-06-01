import 'package:flutter/material.dart';
import 'food_model.dart';

class CartItem {
  final FoodModel food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.food.price * item.quantity);

  void addItem(FoodModel food) {
    final index = _items.indexWhere((item) => item.food.id == food.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(food: food));
    }
    notifyListeners();
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.food.id == foodId);
    notifyListeners();
  }

  void decreaseQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.food.id == foodId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
