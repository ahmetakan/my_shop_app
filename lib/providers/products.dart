import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  String authToken = '';
  String userId = '';

  void updateToken(String token, String id) {
    authToken = token;
    userId = id;
    // _items = items;
  }

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) {
      return product.isFavorite;
    }).toList();
  }

  Future<void> selectAll([bool filterByUser = false]) async {
    String filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-update-75a1b-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString');
    // final url = Uri.https('flutter-update-75a1b-default-rtdb.firebaseio.com',
    //     '/products.json', {'auth': authToken});
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      url = Uri.parse(
          "https://flutter-update-75a1b-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken");
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData["title"],
              description: prodData["description"],
              price: prodData["price"],
              imageUrl: prodData["imageUrl"],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false),
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product selectById(String id) {
    return items.firstWhere((product) {
      return product.id == id;
    });
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-update-75a1b-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "creatorId": userId,
            // "isFavorite": product.isFavorite,
          },
        ),
      );
      final productId = json.decode(response.body)["name"];
      final newProduct = Product(
        id: productId,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String prodId, Product product) async {
    final url = Uri.parse(
        "https://flutter-update-75a1b-default-rtdb.firebaseio.com/products/$prodId.json?auth=$authToken");

    final index = _items.indexWhere(
      (prod) {
        return prod.id == product.id;
      },
    );

    Product? existingProduct = _items[index];

    _items[index] = product;

    notifyListeners();

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          "description": product.description,
          "title": product.title,
          "price": product.price,
          "isFavorite": product.isFavorite,
          "imageUrl": product.imageUrl,
        }),
      );

      if (response.statusCode >= 400) {
        _items[index] = existingProduct;
        notifyListeners();
        throw HttpException("Updating failed!");
      }
    } catch (error) {
      throw error;
    }
    existingProduct = null;
  }

  Future<void> deleteProduct(String prodId) async {
    final url = Uri.parse(
        "https://flutter-update-75a1b-default-rtdb.firebaseio.com/products/$prodId.json?auth=$authToken");

    final existingProductIndex = _items.indexWhere((prod) {
      return prod.id == prodId;
    });

    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Deleting failed!");
    }

    existingProduct = null;
  }
}
