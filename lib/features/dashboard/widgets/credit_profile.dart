import 'package:flutter/material.dart';
import 'package:inkingi/core/constants/colors.dart';

class CreditProfile extends StatelessWidget {
  const CreditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.secondaryOrange, width: 4),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: AppColors.secondaryOrange),
                  const SizedBox(width: 8),
                  Text(
                    'Building Credit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Keep using Inkingi to improve your score',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Credit Score',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '68%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: 200,
                child: LinearProgressIndicator(
                  value: 0.68,
                  backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(AppColors.secondaryOrange),
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward, color: AppColors.primaryBlue),
        ],
      ),
    );
  }
}
