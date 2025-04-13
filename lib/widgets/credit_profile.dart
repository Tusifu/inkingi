// lib/widgets/credit_profile.dart
import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';

class CreditProfile extends StatelessWidget {
  const CreditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: AppColors.secondaryOrange, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  const Text(
                    'Kubaka Profayili y’Inguzanyo', // Building Credit Profile
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Komeza gukoresha Inkingi wongere amanota.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Amanota y’Inguzanyo', // Credit Score
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  const Text(
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
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          // Icon(Icons.arrow_forward, color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
