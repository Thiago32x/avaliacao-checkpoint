import 'package:flutter/material.dart';
import '../model/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final Map<int, CartItem> _cartItems = {};

  List<CartItem> get items => _cartItems.values.toList();

  void addToCart(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
    } else {
      _cartItems[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    if (_cartItems.containsKey(product.id)) {
      if (_cartItems[product.id]!.quantity > 1) {
        _cartItems[product.id]!.quantity--;
      } else {
        _cartItems.remove(product.id);
      }
      notifyListeners();
    }
  }

  void removeEntireProduct(ProductModel product) {
    _cartItems.remove(product.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.values.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  int get itemCount {
    return _cartItems.values.fold(0, (total, item) => total + item.quantity);
  }
}
