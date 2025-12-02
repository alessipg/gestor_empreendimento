import 'package:flutter/material.dart';
import 'package:receitacerta/models/mercadoria.dart';

class CartItem {
  final Mercadoria mercadoria;
  double quantity;

  CartItem({required this.mercadoria, this.quantity = 1.0});
}

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get itemCount => _items.length;

  double get total {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.mercadoria.venda * item.quantity),
    );
  }

  void addItem(Mercadoria mercadoria, {double quantity = 1.0}) {
    final index = _items.indexWhere(
      (item) => item.mercadoria.id == mercadoria.id,
    );

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(mercadoria: mercadoria, quantity: quantity));
    }
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
