import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "/cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  const SizedBox(width: 10),
                  const Spacer(),
                  Chip(
                    label: Text(
                      cart.totalAmount.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(
                    cart: cart,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return ci.CartItem(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                );
              },
              itemCount: cart.itemsCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({required this.cart, Key? key}) : super(key: key);

  final Cart cart;
  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isOrdering = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (_isOrdering == true || widget.cart.itemsCount <= 0)
          ? null
          : (() async {
              setState(() {
                _isOrdering = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );

              setState(() {
                _isOrdering = false;
              });

              widget.cart.clear();
            }),
      child: _isOrdering == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircularProgressIndicator(),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text("ORDERING"))
              ],
            )
          : const Text("ORDER NOW"),
    );
  }
}
