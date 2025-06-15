// category_provider.dart
import 'package:flutter/material.dart';
import 'package:inkingi/models/category.dart';
import 'package:inkingi/services/storage_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  CategoryProvider() {
    _loadCategories();
  }

  List<Category> get categories => _categories;

  Future<void> _loadCategories() async {
    _categories = await StorageService().getCategories();
    notifyListeners();
  }

  Future<void> addCategory(String name, IconData icon) async {
    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
    );
    await StorageService().insertCategory(newCategory);
    _categories.add(newCategory);
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await StorageService().deleteCategory(id);
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }
}
