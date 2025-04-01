import 'dart:convert';
import 'package:inkingi/core/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _transactionKey = 'transactions';

  Future<void> initializeMockData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_transactionKey) != null) return;

    final mockTransactions = [
      Transaction(
        id: '1',
        description: 'Sold tomatoes',
        amount: 5000,
        isIncome: true,
        category: 'Sales',
        date: DateTime(2023, 7, 15, 10, 30),
      ),
      Transaction(
        id: '2',
        description: 'Bought inventory',
        amount: 8000,
        isIncome: false,
        category: 'Inventory',
        date: DateTime(2023, 7, 14, 14, 15),
      ),
      Transaction(
        id: '3',
        description: 'Sold vegetables',
        amount: 7500,
        isIncome: true,
        category: 'Sales',
        date: DateTime(2023, 7, 14, 9, 44),
      ),
      Transaction(
        id: '4',
        description: 'Paid electricity',
        amount: 3000,
        isIncome: false,
        category: 'Utilities',
        date: DateTime(2023, 7, 13, 11, 20),
      ),
      Transaction(
        id: '5',
        description: 'Sold fruits',
        amount: 9000,
        isIncome: true,
        category: 'Sales',
        date: DateTime(2023, 7, 12, 8, 15),
      ),
      Transaction(
        id: '6',
        description: 'Rent payment',
        amount: 15000,
        isIncome: false,
        category: 'Rent',
        date: DateTime(2023, 7, 10, 9, 0),
      ),
    ];

    await saveTransactions(mockTransactions);
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString(_transactionKey, data);
  }

  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_transactionKey);
    if (data == null) return [];
    final List<dynamic> json = jsonDecode(data);
    return json.map((e) => Transaction.fromJson(e)).toList();
  }
}
