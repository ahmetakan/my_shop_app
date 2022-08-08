import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String authToken = '';
  String _userId = '';

  List<OrderItem> get orders {
    return [..._orders];
  }

  void updateAuth(String token, String userId) {
    authToken = token;
    _userId = userId;
  }

  Future<void> selectAll() async {
    try {
      final url = Uri.parse(
          "https://flutter-update-75a1b-default-rtdb.firebaseio.com/userOrders/$_userId.json?auth=$authToken");

      final responseOrders = await http.get(url);
      final extractedOrders = json.decode(responseOrders.body);

      List<OrderItem> loadedOrders = [];

      extractedOrders != null
          ? extractedOrders.forEach(
              (orderId, order) {
                loadedOrders.add(OrderItem(
                  id: orderId,
                  amount: order["amount"],
                  products: order["products"].map<CartItem>((cart) {
                    return CartItem(
                        id: cart["id"],
                        title: cart["title"],
                        quantity: cart["quantity"],
                        price: cart["price"]);
                  }).toList() as List<CartItem>,
                  dateTime: DateTime.parse(order["dateTime"]),
                ));
              },
            )
          : {};

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://flutter-update-75a1b-default-rtdb.firebaseio.com/userOrders/$_userId.json?auth=$authToken");

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "amount": total,
            "products": cartProducts.map((prod) {
              return {
                "id": prod.id,
                "title": prod.title,
                "quantity": prod.quantity,
                "price": prod.price,
              };
            }).toList(),
            "dateTime": DateTime.now().toString(),
          },
        ),
      );

      final addedOrderId = json.decode(response.body)["name"];
      _orders.insert(
        0,
        OrderItem(
          id: addedOrderId,
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
