import 'package:flutter/material.dart';
import 'package:inkingi/models/product.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/providers/product_provider.dart';
import 'package:inkingi/services/categorization_service.dart';
import 'package:provider/provider.dart';

class AddTransactionProvider with ChangeNotifier {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  bool isIncome = true;
  String selectedCategory = 'Kugurisha'; // Updated default to match new values
  DateTime? selectedDate;
  bool useManualEntry = true;
  Product? selectedProduct;
  int quantity = 1;

  AddTransactionProvider() {
    quantityController.text = '1'; // Default quantity
  }

  void setTransactionType(bool isIncome) {
    this.isIncome = isIncome;
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setUseManualEntry(bool value) {
    useManualEntry = value;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    dateController.text = "${date.day}/${date.month}/${date.year}";
    notifyListeners();
  }

  void setSelectedProduct(Product? product) {
    selectedProduct = product;
    if (product != null) {
      amountController.text =
          (product.price * quantity).toStringAsFixed(0); // Remove decimals
      // Map the product's category to the full text value
      final mappedCategory = _mapCategoryToFullText(product.category);
      if (selectedCategory != mappedCategory) {
        selectedCategory = mappedCategory;
      }
    }
    notifyListeners();
  }

  void setQuantity(int value) {
    quantity = value > 0 ? value : 1;
    quantityController.text = quantity.toString();
    updateAmountBasedOnQuantity();
    notifyListeners();
  }

  void updateAmountBasedOnQuantity() {
    if (selectedProduct != null) {
      final newAmount =
          (selectedProduct!.price * quantity).toInt(); // Convert to integer
      amountController.text = newAmount.toString(); // Remove decimals
    }
  }

  void addTransaction(BuildContext context) {
    if (useManualEntry) {
      _addManualTransaction(context);
    } else {
      _addDescriptionBasedTransaction(context);
    }
  }

  void _addManualTransaction(BuildContext context) {
    final description = descriptionController.text.trim();
    final amountText = amountController.text.trim();
    final date = selectedDate;

    if (description.isEmpty) {
      _showError(context, 'Injiza ibisobanuro by\'ibikorwa');
      return;
    }

    double amount;
    try {
      amount = double.parse(amountText);
    } catch (e) {
      _showError(context, 'Injiza umubare w\'amafaranga ushoboka');
      return;
    }

    if (amount <= 0) {
      _showError(context, 'Injiza umubare w\'amafaranga ushoboka (> 0)');
      return;
    }

    if (date == null) {
      _showError(context, 'Hitamo itariki y\'ibikorwa');
      return;
    }

    final transaction = Transaction(
      id: DateTime.now().toString(),
      description: description,
      amount:
          amount, // Will be an integer when parsed from text without decimals
      isIncome: isIncome,
      category: selectedCategory,
      date: date,
      productName: selectedProduct?.name, // Set product name if selected
    );

    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    dashboardProvider.addTransaction(transaction);

    _resetForm();
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Igikorwa cyagenze neza'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addDescriptionBasedTransaction(BuildContext context) {
    final description = descriptionController.text.trim();

    if (description.isEmpty) {
      _showError(context, 'Injiza ibisobanuro by\'ibikorwa');
      return;
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    String? matchedProductName =
        _matchProductName(description, productProvider.products);
    double? extractedAmount = _extractAmount(description); // Changed to double?

    // Use product price if no amount is extracted and a product is matched
    double amount;
    if (extractedAmount == null && matchedProductName != null) {
      final matchedProduct = productProvider.products.firstWhere(
        (product) => product.name == matchedProductName,
        orElse: () => productProvider
            .products.first, // Default to first product if not found
      );
      amount =
          matchedProduct.price * quantity; // Use product price with quantity
    } else if (extractedAmount != null && extractedAmount <= 0) {
      _showError(context, 'Injiza umubare w\'amafaranga ushoboka (> 0)');
      return;
    } else if (extractedAmount == null) {
      _showError(context, 'Injiza umubare w\'amafaranga ushoboka (> 0)');
      return;
    } else {
      amount = extractedAmount; // Use the extracted amount
    }

    final categorizationResult =
        CategorizationService.categorizeTransaction(description, isIncome);
    bool determinedIsIncome = categorizationResult['isIncome'];
    String category = categorizationResult['category'];

    this.isIncome = determinedIsIncome;
    selectedCategory = _mapCategoryToFullText(category); // Map to full text

    final transaction = Transaction(
      id: DateTime.now().toString(),
      description: description,
      amount:
          amount, // Will be an integer when parsed from text or product price
      isIncome: determinedIsIncome,
      category: selectedCategory,
      date: DateTime.now(),
      productName: matchedProductName, // Set matched product name
    );

    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    dashboardProvider.addTransaction(transaction);

    _resetForm();
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Igikorwa cyagenze neza'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  double? _extractAmount(String description) {
    final RegExp amountRegExp = RegExp(
      r'(?:for|at|ya|y|amafranga|francs|rwf)?\s*(\d+\.?\d*)\s*(?:francs|rwf|amafranga)?',
      caseSensitive: false,
    );

    final matches = amountRegExp.allMatches(description.toLowerCase());
    if (matches.isNotEmpty) {
      final match = matches.last;
      try {
        return double.parse(match.group(1)!)
            .toInt()
            .toDouble(); // Convert to integer
      } catch (e) {
        print('Error parsing amount: $e');
        return null;
      }
    }

    final RegExp fallbackRegExp = RegExp(r'\d+\.?\d*', caseSensitive: false);
    final fallbackMatch = fallbackRegExp.firstMatch(description.toLowerCase());
    if (fallbackMatch != null) {
      try {
        return double.parse(fallbackMatch.group(0)!)
            .toInt()
            .toDouble(); // Convert to integer
      } catch (e) {
        return null;
      }
    }

    return null; // Return null if no amount is found
  }

  String? _matchProductName(String description, List<Product> products) {
    final words = description.toLowerCase().split(RegExp(r'\s+'));
    for (var word in words) {
      for (var product in products) {
        if (product.name.toLowerCase().contains(word) ||
            word.contains(product.name.toLowerCase())) {
          return product.name; // Return the first matching product name
        }
      }
    }
    return null; // No match found
  }

  void _resetForm() {
    descriptionController.clear();
    amountController.clear();
    dateController.clear();
    quantityController.text = '1';
    selectedDate = null;
    isIncome = true;
    selectedCategory = 'Kugurisha'; // Updated default to match new values
    selectedProduct = null;
    quantity = 1;
    useManualEntry = false;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper function to map old category values to new full text values
  String _mapCategoryToFullText(String category) {
    const categoryMap = {
      'Sales': 'Kugurisha',
      'Salary': 'Umushahara',
      'Rent Income': 'Kodesha Yinjiye',
      'Dividend': 'Umugabane',
      'Interest': 'Intere',
      'Royalty': 'Royalty',
      'Commission': 'Komisiyo',
      'Bonus': 'Bonuse',
      'Income': 'Amafaranga Yinjiye',
      'Inventory': 'Ibicuruzwa',
      'Utilities': 'Ibikoresho',
      'Rent': 'Kukodesha',
      'Payroll': 'Umushahara Wabakozi',
      'Loan': 'Inguzanyo',
      'Insurance': 'Ubwishingizi',
      'Tax': 'Umutego',
      'Fine': 'Fine',
      'Marketing': 'Kwamamaza',
      'Training': 'Amasomo',
      'Expense': 'Amafaranga Yasohotse',
    };
    return categoryMap[category] ??
        category; // Return mapped value or original if not found
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
