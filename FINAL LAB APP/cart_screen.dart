import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_model.dart';
import '../services/firebase_service.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../widgets/cart_item.dart';
import '../widgets/custom_button.dart';
import 'success_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isOrdering = false;

  void _placeOrder(CartModel cart) async {
    setState(() => isOrdering = true);
    final user = FirebaseAuth.instance.currentUser;
    final success = await FirebaseService().placeOrder(
      items: cart.items,
      userEmail: user?.email ?? 'guest',
      totalPrice: cart.totalPrice,
    );
    setState(() => isOrdering = false);
    if (!mounted) return;
    if (success) {
      cart.clearCart();
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const SuccessScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order failed, try again'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: const Text('My Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textGrey),
                  const SizedBox(height: 16),
                  Text('Cart is empty', style: AppStyles.greyText.copyWith(fontSize: 18)),
                ],
              ))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) => CartItemWidget(item: cart.items[i]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total:', style: AppStyles.heading2),
                          Text('Rs. ${cart.totalPrice.toInt()}', style: AppStyles.priceText),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Place Order',
                        onPressed: () => _placeOrder(cart),
                        isLoading: isOrdering,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
