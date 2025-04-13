import 'package:flutter/material.dart';
import '../constants/colors.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final double amount;
  final double percentageChange;
  final bool isPositive;

  const OverviewCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentageChange,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color:
                isPositive ? AppColors.lightGreen : AppColors.secondaryOrange,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(0)} RWF',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: isPositive
                    ? AppColors.lightGreen
                    : AppColors.secondaryOrange,
                size: 16,
              ),
              const SizedBox(width: 2),
              Text(
                '$percentageChange% from last period',
                style: TextStyle(
                  color: isPositive
                      ? AppColors.lightGreen
                      : AppColors.secondaryOrange,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
