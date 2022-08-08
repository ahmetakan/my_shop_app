import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/main_drawer.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  static const routeName = "/products";
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;

      Provider.of<Products>(context).selectAll().then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(
    //   context,
    //   listen: false,
    // );
    // Provider.of<Products>(context).selectAll();

    return Scaffold(
      appBar: AppBar(title: const Text("MyShop"), actions: [
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              if (selectedValue == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          itemBuilder: (ctx) {
            return [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text("Only Favorites"),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text("Show All"),
              ),
            ];
          },
          icon: const Icon(
            Icons.more_vert,
          ),
        ),
        Consumer<Cart>(
          builder: (_, cart, ch) {
            return Badge(
              value: cart.itemsCount.toString(),
              child: ch!,
            );
          },
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
      ]),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: const MyDrawer(),
    );
  }
}
