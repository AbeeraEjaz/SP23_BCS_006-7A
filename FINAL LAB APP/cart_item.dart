import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fastfood, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.food.name, style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.w600)),
                Text('Rs. ${item.food.price.toInt()} x ${item.quantity}', style: AppStyles.greyText),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => cart.decreaseQuantity(item.food.id),
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
              ),
              Text('${item.quantity}', style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => cart.addItem(item.food),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
