import 'package:flutter/material.dart';
import 'package:inkingi/components/TTransactionTile.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:inkingi/utils/date_utils.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final String filter;
  final Function(String)? onDelete; // Add onDelete callback

  const TransactionList({
    super.key,
    required this.transactions,
    required this.filter,
    this.onDelete,
  });

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
      final dateKey = DateUtilities.formatDateToKinyarwanda(
        transaction.date,
        includeDayOfWeek: true,
        abbreviatedDay: false,
        format: 'dayName, day month year',
      );
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    if (groupedTransactions.isEmpty) {
      return const Center(
        child: Text(
          'Nta bikorwa bihari. Andika ibikorwa bishya kugira ngo utangire!',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      );
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
                child: TTransactionTile(
                  transaction: transaction,
                  onDelete: onDelete != null
                      ? () => onDelete!(transaction.id)
                      : null, // Pass the onDelete callback
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
