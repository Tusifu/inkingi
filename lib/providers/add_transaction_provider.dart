// lib/providers/add_transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:inkingi/services/categorization_service.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionProvider with ChangeNotifier {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  bool isIncome = true;
  String selectedCategory = 'Sales';
  DateTime? selectedDate;
  bool useManualEntry = false;

  void setTransactionType(bool isIncome) {
    this.isIncome = isIncome;
    selectedCategory = isIncome ? 'Sales' : 'Expense';
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
      amount: amount,
      isIncome: isIncome,
      category: selectedCategory,
      date: date,
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

    double amount = _extractAmount(description);
    if (amount <= 0) {
      _showError(context, 'Injiza umubare w\'amafaranga ushoboka (> 0)');
      return;
    }

    final categorizationResult =
        CategorizationService.categorizeTransaction(description, isIncome);
    bool determinedIsIncome = categorizationResult['isIncome'];
    String category = categorizationResult['category'];

    this.isIncome = determinedIsIncome;
    selectedCategory = category;

    final transaction = Transaction(
      id: DateTime.now().toString(),
      description: description,
      amount: amount,
      isIncome: determinedIsIncome,
      category: category,
      date: DateTime.now(),
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

  double _extractAmount(String description) {
    final RegExp amountRegExp = RegExp(
      r'(?:for|at|ya|y|amafranga|francs|rwf)?\s*(\d+\.?\d*)\s*(?:francs|rwf|amafranga)?',
      caseSensitive: false,
    );

    final matches = amountRegExp.allMatches(description.toLowerCase());
    if (matches.isNotEmpty) {
      final match = matches.last;
      try {
        return double.parse(match.group(1)!);
      } catch (e) {
        print('Error parsing amount: $e');
        return 0.0;
      }
    }

    final RegExp fallbackRegExp = RegExp(r'\d+\.?\d*', caseSensitive: false);
    final fallbackMatch = fallbackRegExp.firstMatch(description.toLowerCase());
    if (fallbackMatch != null) {
      try {
        return double.parse(fallbackMatch.group(0)!);
      } catch (e) {
        print('Error parsing fallback amount: $e');
        return 0.0;
      }
    }

    return 0.0;
  }

  void _resetForm() {
    descriptionController.clear();
    amountController.clear();
    dateController.clear();
    selectedDate = null;
    isIncome = true;
    selectedCategory = 'Sales';
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

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
