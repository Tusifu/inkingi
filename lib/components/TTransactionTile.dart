// lib/components/transaction_tile.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/transaction.dart';

class TTransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TTransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: transaction.isIncome
                ? AppColors.lightGreen
                : AppColors.secondaryOrange,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: transaction.isIncome
                ? AppColors.lightGreen
                : AppColors.secondaryOrange,
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
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('d MMM yyyy, hh:mm a').format(transaction.date)} • ${transaction.category}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.isIncome ? '+' : '-'}${NumberFormat.decimalPattern().format(transaction.amount)} RWF',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.isIncome
                  ? AppColors.lightGreen
                  : AppColors.secondaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}
