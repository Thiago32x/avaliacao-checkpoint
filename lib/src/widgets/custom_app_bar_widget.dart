import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(
        Icons.menu,
      ),
      centerTitle: true,
      title: Image.asset(
        'assets/images/logo_usedev.png',
        height: 40,
      ),
      actions: [
        const Icon(
          Icons.person_outline,
          size: 40,
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
          icon: const Icon(
            Icons.shopping_cart_outlined,
            size: 40,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
