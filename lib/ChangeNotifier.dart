import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Apicall {
  String? image;
  String? name;
  double? price;
  int quantity;

  Apicall({
    this.image,
    this.name,
    this.price,
    this.quantity = 1,
  });

  factory Apicall.fromJson(Map<String, dynamic> json) {
    return Apicall(
      image: json['thumbnail'],
      name: json['title'],
      price: json['price'],
    );
  }
}

class ProductProvider extends ChangeNotifier {
  List<Apicall> _apiCall = [];
  List<Apicall> _cartItems = [];
  bool _isLoading = false;

  List<Apicall> get apiCall => _apiCall;
  List<Apicall> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item.price ?? 0) * item.quantity;
    }
    return total;
  }

  Future<void> getApiCall() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://dummyjson.com/carts'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['carts'] as List;
      _apiCall.clear();

      for (var cart in data) {
        var products = cart['products'] as List;
        for (var product in products) {
          _apiCall.add(Apicall.fromJson(product));
        }
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  void addToCart(Apicall product) {
    var existingProduct = _cartItems.firstWhere(
          (item) => item.name == product.name,
      orElse: () => Apicall(),
    );

    if (existingProduct.name != null) {
      existingProduct.quantity++;
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void increaseQuantity(Apicall product) {
    product.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(Apicall product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      _cartItems.remove(product);
    }
    notifyListeners();
  }

  void removeFromCart(Apicall product) {
    _cartItems.remove(product);
    notifyListeners();
  }
}
