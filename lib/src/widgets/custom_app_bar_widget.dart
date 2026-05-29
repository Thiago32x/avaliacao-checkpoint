import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/login_screen.dart';
import '../service/cart_service.dart';
import '../service/login_service.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final loginService = LoginService();

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
        ListenableBuilder(
          listenable: loginService,
          builder: (context, child) {
            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: Icon(
                loginService.isLoggedIn ? Icons.person : Icons.person_outline,
                size: 40,
                color: loginService.isLoggedIn ? Colors.blueAccent : null,
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        ListenableBuilder(
          listenable: cartService,
          builder: (context, child) {
            return Badge(
              label: Text(cartService.itemCount.toString()),
              isLabelVisible: cartService.itemCount > 0,
              offset: const Offset(-5, 5),
              child: IconButton(
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
            );
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
