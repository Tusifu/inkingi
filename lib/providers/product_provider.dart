import 'package:flutter/material.dart';
import 'package:inkingi/models/product.dart';
import 'package:inkingi/services/storage_service.dart';

class ProductProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Product> _products = [];

  List<Product> get products => _products;

  ProductProvider() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _products = await _storageService.getProducts();
    notifyListeners();
  }

  Future<void> addProduct(String name, double price, String category) async {
    final product = Product(
      id: DateTime.now().toString(),
      name: name,
      price: price,
      category: category,
    );
    await _storageService.insertProduct(product);
    await _loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _storageService.updateProduct(product);
    await _loadProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _storageService.deleteProduct(id);
    await _loadProducts();
  }
}
