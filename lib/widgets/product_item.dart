import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  // const ProductItem({
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  //   Key? key,
  // }) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context);
    final authData = Provider.of<Auth>(context, listen: false);

    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: product.isFavorite
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            onPressed: () async {
              try {
                await product.toggleFavorite(authData.token!, authData.userId!);
              } catch (error) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text("Toggle failed!"),
                  ),
                );
              }
            },
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Ürün sepete eklendi."),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.route,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
