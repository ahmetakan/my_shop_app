import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/products_overview_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: const Text(
              "Shop",
              style: TextStyle(fontSize: 20),
            ),
            leading: const Icon(Icons.shop),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Orders",
              style: TextStyle(fontSize: 20),
            ),
            leading: const Icon(Icons.payment),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Manage Products",
              style: TextStyle(fontSize: 20),
            ),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 20),
            ),
            leading: const Icon(Icons.logout),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
