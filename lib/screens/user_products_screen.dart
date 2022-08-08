import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/user_product_item.dart';
import "../providers/products.dart";
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).selectAll(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (_, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              onRefresh: () {
                return _refreshProducts(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<Products>(
                  builder: (context, productsData, _) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            UserProductItem(
                              id: productsData.items[index].id,
                              title: productsData.items[index].title,
                              imageUrl: productsData.items[index].imageUrl,
                            ),
                            const Divider(),
                          ],
                        );
                      },
                      itemCount: productsData.items.length,
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
      drawer: const MyDrawer(),
    );
  }
}
