import 'package:flutter/material.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:inkingi/services/storage_service.dart';

class DashboardProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  double profit = 0.0;
  double creditScore = 68.0; // Simulated for MVP

  List<Transaction> get transactions => _transactions;

  DashboardProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    _transactions = await StorageService().getTransactions();
    _calculateMetrics();
    notifyListeners();
  }

  void _calculateMetrics() {
    totalIncome = _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    totalExpenses = _transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    profit = totalIncome - totalExpenses;
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _calculateMetrics();
    StorageService().saveTransactions(_transactions);
    notifyListeners();
  }
}
