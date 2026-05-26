import 'package:flutter/material.dart';
import '../model/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);

  bool isInCart(ProductModel product) {
    return _items.indexWhere((item) => item.id == product.id) != -1;
  }

  void addToCart(ProductModel product) {
    // Agora permite adicionar múltiplas unidades do mesmo produto
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    int index = _items.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (total, current) => total + current.price);
  }

  int get itemCount => _items.length;
}
