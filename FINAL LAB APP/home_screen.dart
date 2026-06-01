import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../models/cart_model.dart';
import '../services/firebase_service.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/food_card.dart';
import 'cart_screen.dart';
import 'food_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FoodModel> allFoods = [];
  List<FoodModel> filteredFoods = [];
  String selectedCategory = 'All';
  bool isLoading = true;

  final List<String> categories = ['All', 'Burgers', 'Pizza', 'Shawarma', 'Rice', 'Wraps', 'Combo'];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  void _loadFoods() async {
    final foods = await FirebaseService().getFoodItems();
    setState(() {
      allFoods = foods;
      filteredFoods = foods;
      isLoading = false;
    });
  }

  void _filterCategory(String cat) {
    setState(() {
      selectedCategory = cat;
      filteredFoods = cat == 'All'
          ? allFoods
          : allFoods.where((f) => f.category == cat).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QuickBite', style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            Text('Delivery in 30 min', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8, top: 8,
                  child: CircleAvatar(
                    radius: 9, backgroundColor: AppColors.secondary,
                    child: Text('${cart.itemCount}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Category chips
                SizedBox(
                  height: 56,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: categories.length,
                    itemBuilder: (_, i) {
                      final cat = categories[i];
                      final selected = cat == selectedCategory;
                      return GestureDetector(
                        onTap: () => _filterCategory(cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)
                            ],
                          ),
                          child: Text(cat, style: AppStyles.bodyText.copyWith(
                            color: selected ? Colors.white : AppColors.textDark,
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          )),
                        ),
                      );
                    },
                  ),
                ),
                // Food list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFoods.length,
                    itemBuilder: (_, i) => FoodCard(
                      food: filteredFoods[i],
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => FoodDetailScreen(food: filteredFoods[i]))),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
