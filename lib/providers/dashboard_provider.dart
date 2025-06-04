import 'package:flutter/material.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:inkingi/services/storage_service.dart';

class DashboardProvider with ChangeNotifier {
  final StorageService _storageService;
  List<Transaction> _transactions = [];
  String? _error;
  bool _isLoading = true;
  String _filter = 'Daily'; // Default filter

  DashboardProvider(this._storageService) {
    _loadTransactions();
  }

  List<Transaction> get transactions => _transactions;
  String? get error => _error;
  bool get isLoading => _isLoading;
  String get filter => _filter;

  double get totalIncome {
    final filteredTransactions = _filterTransactions();
    return filteredTransactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    final filteredTransactions = _filterTransactions();
    return filteredTransactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  List<Transaction> _filterTransactions() {
    final now = DateTime.now();
    DateTime startDate;

    switch (_filter) {
      case 'Weekly':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Monthly':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'Daily':
      default:
        startDate = DateTime(now.year, now.month, now.day);
        break;
    }

    return _transactions.where((t) {
      final transactionDate = t.date;
      return transactionDate.isAfter(startDate) ||
          transactionDate.isAtSameMomentAs(startDate);
    }).toList();
  }

  void setFilter(String newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  Future<void> _loadTransactions() async {
    try {
      _isLoading = true;
      notifyListeners();
      _transactions = await _storageService.getTransactions();
      _error = null;
    } catch (e) {
      _error = 'Failed to load transactions: $e';
      print('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _storageService.insertTransaction(transaction);
      _transactions.add(transaction);
      _error = null;
    } catch (e) {
      _error = 'Failed to add transaction: $e';
    }
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _storageService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete transaction: $e';
    }
    notifyListeners();
  }

  Future<void> deleteAllTransactions() async {
    try {
      await _storageService.deleteAllTransactions();
      _transactions.clear();
      _error = null;
    } catch (e) {
      _error = 'Failed to delete all transactions: $e';
    }
    notifyListeners();
  }
}
