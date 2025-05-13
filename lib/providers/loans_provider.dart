import 'package:flutter/material.dart';
import 'package:inkingi/models/loan.dart';
import 'package:inkingi/models/transaction.dart';

class LoansProvider with ChangeNotifier {
  double _creditScore = 0.0; // Will be calculated dynamically
  List<Loan> _availableLoans = [
    Loan(
      title: 'Overdraft',
      description: 'Inguzanyo nziza yo kuzamura ubucuruzi',
      amount: 50000,
      apr: 12.5,
      duration: 'Umwaka',
      isEligible: false,
    ),
    Loan(
      title: 'Stock Loan',
      description: 'Inguzanyo nziza yo kuzamura stock ya Business',
      amount: 100000,
      apr: 15.0,
      duration: 'imyaka 3',
      isEligible: false,
    ),
  ];

  LoansProvider(List<Transaction> transactions) {
    calculateCreditScore(transactions);
    checkEligibility();
  }

  double get creditScore => _creditScore;
  List<Loan> get availableLoans => _availableLoans;

  // Calculate credit score based on transaction data
  void calculateCreditScore(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      _creditScore = 0.0; // Default to 0 if no transactions
      return;
    }

    // 1. Transaction Frequency (20% weight)
    final daysWithTransactions = transactions
        .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
        .toSet()
        .length;
    final maxDays =
        DateTime.now().difference(transactions.first.date).inDays + 1;
    final frequencyScore =
        (daysWithTransactions / maxDays.clamp(1, double.infinity)) * 100 * 0.2;

    // 2. Profit Margin (50% weight)
    final totalIncome = transactions
        .where((t) => t.isIncome)
        .map((t) => t.amount)
        .fold(0.0, (a, b) => a + b);
    final totalExpenses = transactions
        .where((t) => !t.isIncome)
        .map((t) => t.amount)
        .fold(0.0, (a, b) => a + b);
    final profitMargin = totalIncome > totalExpenses
        ? ((totalIncome - totalExpenses) / totalIncome) * 100
        : 0;
    final profitScore = (profitMargin.clamp(0, 100) * 0.5).toDouble();

    // 3. Income Consistency (30% weight)
    final incomeTransactions = transactions.where((t) => t.isIncome).toList();
    final avgIncome = incomeTransactions.isNotEmpty
        ? incomeTransactions.map((t) => t.amount).reduce((a, b) => a + b) /
            incomeTransactions.length
        : 0;
    final incomeStdDev = incomeTransactions.isNotEmpty
        ? (incomeTransactions
                    .map((t) => (t.amount - avgIncome).abs())
                    .reduce((a, b) => a + b) /
                incomeTransactions.length)
            .clamp(0, 100)
        : 0;
    final consistencyScore = ((100 - incomeStdDev) * 0.3).clamp(0, 30);

    _creditScore =
        (frequencyScore + profitScore + consistencyScore).clamp(0, 100);
  }

  void checkEligibility() {
    // Update eligibility based on credit score (threshold of 70)
    for (var loan in _availableLoans) {
      loan.isEligible = _creditScore >= 70;
    }
    notifyListeners();
  }
}
