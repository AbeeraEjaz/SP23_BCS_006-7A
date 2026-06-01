import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_model.dart';
import '../models/cart_model.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/custom_button.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodModel food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(food.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Food Image
          Container(
            height: 220,
            width: double.infinity,
            color: AppColors.secondary.withOpacity(0.2),
            child: const Icon(Icons.fastfood, size: 100, color: AppColors.primary),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(food.name, style: AppStyles.heading1)),
                      Text('Rs. ${food.price.toInt()}', style: AppStyles.priceText),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.secondary, size: 18),
                      const SizedBox(width: 4),
                      Text('${food.rating}  •  ', style: AppStyles.greyText),
                      const Icon(Icons.access_time, size: 16, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text('${food.deliveryTime} min', style: AppStyles.greyText),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Description', style: AppStyles.heading2.copyWith(fontSize: 17)),
                  const SizedBox(height: 8),
                  Text(food.description, style: AppStyles.greyText.copyWith(height: 1.6)),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Add to Cart',
                    onPressed: () {
                      cart.addItem(food);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${food.name} added to cart!'),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
