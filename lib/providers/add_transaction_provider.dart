import 'package:flutter/material.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:inkingi/services/categorization_service.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

class AddTransactionProvider with ChangeNotifier {
  final TextEditingController descriptionController = TextEditingController();
  bool isIncome = true;
  String selectedCategory = 'Sales';

  void setTransactionType(bool isIncome) {
    this.isIncome = isIncome;
    selectedCategory = isIncome ? 'Sales' : 'Expense';
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void addTransaction(BuildContext context) {
    final description = descriptionController.text;
    if (description.isEmpty) return;

    // Extract amount from description (e.g., "Sold tomatoes for 5000 francs")
    double amount = 0.0;
    final RegExp amountRegExp = RegExp(r'\d+');
    final match = amountRegExp.firstMatch(description);
    if (match != null) {
      amount = double.parse(match.group(0)!);
    }

    if (amount <= 0) return;

    final category =
        CategorizationService.categorizeTransaction(description, isIncome);

    final transaction = Transaction(
      id: DateTime.now().toString(),
      description: description,
      amount: amount,
      isIncome: isIncome,
      category: category,
      date: DateTime.now(),
    );

    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    dashboardProvider.addTransaction(transaction);

    descriptionController.clear();
    notifyListeners();
  }
}
