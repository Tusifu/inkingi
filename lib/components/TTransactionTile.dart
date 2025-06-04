import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/transaction.dart';
import 'package:intl/intl.dart';

class TTransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onDelete;

  const TTransactionTile({
    super.key,
    required this.transaction,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: transaction.isIncome
              ? [
                  const Color(0xFF1C2526), // Dark gray for income
                  const Color(0xFF2A3435), // Slightly lighter gray
                ]
              : [
                  const Color(0xFF261C1C), // Dark reddish-gray for expense
                  const Color(0xFF352A2A), // Slightly lighter reddish-gray
                ],
        ),
        border: Border(
          left: BorderSide(
            color: transaction.isIncome
                ? AppColors.incomeColor
                : AppColors.expensesColor,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: transaction.isIncome
                ? AppColors.incomeColor
                : AppColors.expensesColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('d MMM yyyy, hh:mm a').format(transaction.date)} • ${transaction.category}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isIncome ? '+' : '-'}${NumberFormat.decimalPattern().format(transaction.amount)} RWF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.isIncome
                      ? AppColors.incomeColor
                      : AppColors.expensesColor,
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
