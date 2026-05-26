import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/product_model.dart';
import '../screens/product_detail_screen.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              product.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                product.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'R\$ ${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
