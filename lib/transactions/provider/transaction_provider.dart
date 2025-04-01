import 'package:flutter/material.dart';
import 'package:inkingi/core/models/transaction.dart';
import 'package:inkingi/features/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class TransactionProvider with ChangeNotifier {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isIncome = true;

  void setTransactionType(bool isIncome) {
    this.isIncome = isIncome;
    notifyListeners();
  }

  void addTransaction(BuildContext context) {
    final description = descriptionController.text;
    final amount = double.tryParse(amountController.text) ?? 0.0;

    if (description.isEmpty || amount <= 0) return;

    final transaction = Transaction(
      id: DateTime.now().toString(),
      description: description,
      amount: amount,
      isIncome: isIncome,
      date: DateTime.now(),
      category: '',
    );

    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    dashboardProvider.addTransaction(transaction);

    descriptionController.clear();
    amountController.clear();
    notifyListeners();
  }
}
