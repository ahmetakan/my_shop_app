import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(this._showFavoritesOnly);
  final _showFavoritesOnly;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        _showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
