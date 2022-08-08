import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final url = Uri.parse(
        "https://flutter-update-75a1b-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token");

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
        throw HttpException("Toggle failed");
      }
    } catch (error) {
      throw error;
    }
  }
}
