// lib/widgets/transaction_list.dart
import 'package:flutter/material.dart';
import 'package:inkingi/components/TTransactionTile.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final String filter;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.filter,
  });

  // Custom date formatter for Kinyarwanda
  String _formatDateToKinyarwanda(DateTime date) {
    const daysOfWeek = [
      'Ku Cyumweru', // Sunday
      'Kuwa Mbere', // Monday
      'Kuwa Kabiri', // Tuesday
      'Kuwa Gatatu', // Wednesday
      'Kuwa Kane', // Thursday
      'Kuwa Gatanu', // Friday
      'Kuwa Gatandatu', // Saturday
    ];

    const months = [
      '', // Index 0 (not used)
      'Mutarama', // January
      'Gashyantare', // February
      'Werurwe', // March
      'Mata', // April
      'Gicurasi', // May
      'Kamena', // June
      'Nyakanga', // July
      'Kanama', // August
      'Nzeli', // September
      'Ukwakira', // October
      'Ugushyingo', // November
      'Ukuboza', // December
    ];

    final dayName = daysOfWeek[date.weekday % 7];
    final day = date.day;
    final monthName = months[date.month];
    final year = date.year;

    return '$dayName, $day $monthName $year';
  }

  @override
  Widget build(BuildContext context) {
    // Only apply filter if filter is not 'All'
    final transactionsToShow = filter == 'All'
        ? transactions
        : transactions.where((t) {
            if (filter == 'Income') return t.isIncome;
            if (filter == 'Expenses') return !t.isIncome;
            return true;
          }).toList();

    // Group transactions by date
    final Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in transactionsToShow) {
      final dateKey = _formatDateToKinyarwanda(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return ListView.builder(
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final date = groupedTransactions.keys.elementAt(index);
        final transactionsForDate = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            ...transactionsForDate.map((transaction) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TTransactionTile(transaction: transaction),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
