import 'package:flutter/material.dart';
import '../models/transaction.dart';

class ReportsProvider with ChangeNotifier {
  final List<Transaction> transactions;
  String reportType = 'Weekly';
  String reportMode = 'Time'; // New: 'Time', 'Product', or 'Category'

  ReportsProvider(this.transactions);

  void setReportType(String type) {
    reportType = type;
    notifyListeners();
  }

  void setReportMode(String mode) {
    reportMode = mode;
    notifyListeners();
  }

  Map<String, Map<String, double>> generateTimeReport() {
    final Map<String, Map<String, double>> report = {};

    for (var transaction in transactions) {
      String key;
      if (reportType == 'Weekly') {
        final weekNumber = (transaction.date.day / 7).ceil();
        key =
            'Week $weekNumber, ${transaction.date.month}/${transaction.date.year}';
      } else if (reportType == 'Monthly') {
        key = '${transaction.date.month}/${transaction.date.year}';
      } else {
        final quarter = (transaction.date.month / 3).ceil();
        key = 'Q$quarter ${transaction.date.year}';
      }

      if (!report.containsKey(key)) {
        report[key] = {'Income': 0.0, 'Expenses': 0.0};
      }

      if (transaction.isIncome) {
        report[key]!['Income'] = report[key]!['Income']! + transaction.amount;
      } else {
        report[key]!['Expenses'] =
            report[key]!['Expenses']! + transaction.amount;
      }
    }

    return report;
  }

  Map<String, Map<String, double>> generateProductReport() {
    final Map<String, Map<String, double>> report = {};

    for (var transaction in transactions) {
      if (transaction.productName != null) {
        if (!report.containsKey(transaction.productName!)) {
          report[transaction.productName!] = {'Income': 0.0, 'Expenses': 0.0};
        }

        if (transaction.isIncome) {
          report[transaction.productName!]!['Income'] =
              report[transaction.productName!]!['Income']! + transaction.amount;
        } else {
          report[transaction.productName!]!['Expenses'] =
              report[transaction.productName!]!['Expenses']! +
                  transaction.amount;
        }
      }
    }

    final sortedReport = report.entries.toList()
      ..sort((a, b) {
        final profitA = (a.value['Income'] ?? 0) - (a.value['Expenses'] ?? 0);
        final profitB = (b.value['Income'] ?? 0) - (b.value['Expenses'] ?? 0);
        return profitB.compareTo(profitA); // Descending order
      });

    return Map.fromEntries(sortedReport);
  }

  Map<String, Map<String, double>> generateCategoryReport() {
    final Map<String, Map<String, double>> report = {};

    for (var transaction in transactions) {
      if (!report.containsKey(transaction.category)) {
        report[transaction.category] = {'Income': 0.0, 'Expenses': 0.0};
      }

      if (transaction.isIncome) {
        report[transaction.category]!['Income'] =
            report[transaction.category]!['Income']! + transaction.amount;
      } else {
        report[transaction.category]!['Expenses'] =
            report[transaction.category]!['Expenses']! + transaction.amount;
      }
    }

    final sortedReport = report.entries.toList()
      ..sort((a, b) {
        final profitA = (a.value['Income'] ?? 0) - (a.value['Expenses'] ?? 0);
        final profitB = (b.value['Income'] ?? 0) - (b.value['Expenses'] ?? 0);
        return profitB.compareTo(profitA); // Descending order
      });

    return Map.fromEntries(sortedReport);
  }
}
