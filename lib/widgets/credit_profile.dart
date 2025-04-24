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
                    'Kubaka Umwirondoro y’Inguzanyo', // Building Credit Profile
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
                'Komeza gukoresha BK Inkingi wongere amanota.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Amafaranga y\'inguzanyo ugezeho', // Credit Score
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '300,000 RWF',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 300,
                child: LinearProgressIndicator(
                  value: 0.25,
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
