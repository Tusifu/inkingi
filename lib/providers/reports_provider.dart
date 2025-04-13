import 'package:flutter/material.dart';
import '../models/transaction.dart';

class ReportsProvider with ChangeNotifier {
  final List<Transaction> transactions;
  String reportType = 'Weekly';

  ReportsProvider(this.transactions);

  void setReportType(String type) {
    reportType = type;
    notifyListeners();
  }

  Map<String, Map<String, double>> generateReport() {
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
}
