import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as oi;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).selectAll();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text("An error occured."),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, ordersData, child) {
                  return ListView.builder(
                    itemBuilder: (ctx, index) {
                      return oi.OrderItem(
                        order: ordersData.orders[index],
                      );
                    },
                    itemCount: ordersData.orders.length,
                  );
                },
              );
            }
          }
        },
      ),
      drawer: const MyDrawer(),
    );
  }
}
