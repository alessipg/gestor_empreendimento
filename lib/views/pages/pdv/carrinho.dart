import 'package:flutter/material.dart';
import 'package:receitacerta/config/constants.dart';
import 'package:receitacerta/models/mercadoria.dart';
import 'package:receitacerta/views/pages/pdv/search_mercadoria_modal.dart';
import 'package:receitacerta/views/pages/pdv/qr_scanner_page.dart';

class _CartItem {
  final Mercadoria mercadoria;
  double quantity;

  _CartItem({required this.mercadoria, this.quantity = 1.0});
}

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<_CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _addToCart(Mercadoria mercadoria) {
    final index = _cartItems.indexWhere(
      (item) => item.mercadoria.id == mercadoria.id,
    );
    setState(() {
      if (index != -1) {
        _cartItems[index].quantity += 1;
      } else {
        _cartItems.add(_CartItem(mercadoria: mercadoria));
      }
    });
  }

  void _addToCartWithQuantity(Mercadoria mercadoria, double quantity) {
    final index = _cartItems.indexWhere(
      (item) => item.mercadoria.id == mercadoria.id,
    );
    setState(() {
      if (index != -1) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(_CartItem(mercadoria: mercadoria, quantity: quantity));
      }
    });
  }

  void _incrementQuantity(_CartItem item) {
    setState(() {
      item.quantity += 1;
    });
  }

  void _decrementQuantity(_CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity -= 1;
      } else {
        _cartItems.remove(item);
      }
    });
  }

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: UserColor.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SearchMercadoriaModal(onItemSelected: _addToCart);
      },
    );
  }

  void _openScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QRScannerPage(
          onItemConfirmed: (mercadoria, quantity) {
            _addToCartWithQuantity(mercadoria, quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${quantity.toInt()}x ${mercadoria.nome} adicionado',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Carrinho de compras",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: UserColor.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(child: Text("Seu carrinho está vazio"))
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            item.mercadoria.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Unit: R\$ ${item.mercadoria.venda.toStringAsFixed(2)} | Total: R\$ ${(item.mercadoria.venda * item.quantity).toStringAsFixed(2)}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.red,
                                onPressed: () => _decrementQuantity(item),
                              ),
                              Text(
                                "${item.quantity.toInt()}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.green,
                                onPressed: () => _incrementQuantity(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded || _animationController.isAnimating)
            ScaleTransition(
              scale: _animation,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'camera',
                    mini: true,
                    backgroundColor: UserColor.primary,
                    onPressed: _openScanner,
                    child: const Icon(
                      Icons.camera_alt,
                      color: UserColor.secondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'search',
                    mini: true,
                    backgroundColor: UserColor.primary,
                    onPressed: () {
                      _showSearchModal();
                    },
                    child: const Icon(
                      Icons.search,
                      color: UserColor.secondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            child: Badge(
              isLabelVisible: false,
              child: FloatingActionButton(
                heroTag: 'cart',
                backgroundColor: UserColor.primary,
                onPressed: _toggleExpanded,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(turns: animation, child: child);
                  },
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.add_shopping_cart,
                    key: ValueKey(_isExpanded),
                    color: UserColor.secondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
