import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final VoidCallback onTap;

  const FoodCard({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 110,
                height: 100,
                color: AppColors.secondary.withOpacity(0.2),
                child: const Icon(Icons.fastfood, size: 50, color: AppColors.primary),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(food.name, style: AppStyles.heading2.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(food.category, style: AppStyles.greyText),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rs. ${food.price.toInt()}', style: AppStyles.priceText),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.secondary, size: 16),
                            const SizedBox(width: 2),
                            Text('${food.rating}', style: AppStyles.greyText),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
