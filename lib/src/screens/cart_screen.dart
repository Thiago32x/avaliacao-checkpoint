import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/cart_service.dart';
import '../service/login_service.dart';
import 'login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final LoginService _loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_usedev.png',
          height: 40,
        ),
      ),
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, child) {
          final List<CartItem> cartItems = _cartService.items;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    'Seu carrinho está vazio',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.orbitron().fontFamily,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final CartItem cartItem = cartItems[index];
                    return _buildCartItem(cartItem);
                  },
                ),
              ),
              _buildSummary(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    final product = cartItem.product;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Image.network(
              product.image,
              height: 80,
              width: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.orbitron().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Un: R\$ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _cartService.removeFromCart(product),
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 20,
                      ),
                      Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => _cartService.addToCart(product),
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _cartService.removeEntireProduct(product),
                ),
                Text(
                  'R\$ ${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleFinalizePurchase() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Autenticação de Segurança',
          style: TextStyle(fontFamily: GoogleFonts.orbitron().fontFamily),
        ),
        content: const Text(
            'Para finalizar sua compra com segurança, você precisa confirmar seus dados realizando o login novamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Realiza logout forçado para exigir novos dados na tela de login
              await _loginService.logout();
              
              if (mounted) {
                Navigator.pop(context); // Fecha o diálogo
                // Vai para a tela de login passando o parâmetro para limpar o carrinho após sucesso
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(isFromCheckout: true),
                  ),
                );
              }
            },
            child: const Text('CONFIRMAR E LOGAR'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
              Text(
                'R\$ ${_cartService.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _handleFinalizePurchase,
              child: Text(
                'FINALIZAR COMPRA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
