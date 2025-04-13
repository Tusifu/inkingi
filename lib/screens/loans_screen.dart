// lib/screens/loans_screen.dart
import 'package:flutter/material.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/loans_provider.dart';

class LoansScreen extends StatelessWidget {
  static const String routeName = '/loansScreen';
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoansProvider()..checkEligibility(),
      child: Consumer<LoansProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0, // Explicitly set to 0 for scrolling
              surfaceTintColor: AppColors.background, // Prevent tint changes
              title: const Text(
                'Inguzanyo', // Loan Eligibility
                style: TextStyle(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(
                            color: AppColors.secondaryOrange, width: 4),
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
                                Icon(Icons.trending_up,
                                    color: AppColors.secondaryOrange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Kubaka Profayili y’Inguzanyo', // Building Credit Profile
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Komeza gukoresha Inkingi wongere amanota.', // Keep using Inkingi to improve your score (shortened)
                              style: TextStyle(color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Amanota y’Inguzanyo', // Credit Score
                                  style:
                                      TextStyle(color: AppColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${provider.creditScore.toStringAsFixed(0)}%',
                                  style: const TextStyle(
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
                                value: provider.creditScore / 100,
                                backgroundColor:
                                    AppColors.textSecondary.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation(
                                    AppColors.secondaryOrange),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward,
                            color: AppColors.primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Uko wongera amanota yawe', // How to improve your score
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildTip(
                      'Andika ibikorwa byinshi', // Record more transactions
                      'Kwiyandikisha ibikorwa buri gihe bigaragaza...'), // Regular transaction recording shows consistent business activity
                  _buildTip(
                      'Ongera inyungu yawe', // Increase your profit margin
                      'Inyungu ziri hejuru zigaragaza imikorere...'), // Higher profits indicate stronger business performance
                  _buildTip(
                      'Gumana amafranga yinjiye atari uko', // Maintain consistent income
                      'Amafranga yinjiye atari uko agaragaza...'), // Steady income streams show business stability
                  const SizedBox(height: 16),
                  const Text(
                    'Amaturo ya Inguzanyo Ariho', // Available Loan Offers
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  ...provider.availableLoans.map((loan) {
                    return Card(
                      color: AppColors.cardBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    loan.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${loan.apr}% APR',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loan.description,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Amafaranga ya Inguzanyo', // Loan Amount
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${loan.amount.toStringAsFixed(0)} RWF',
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Igihe', // Duration
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        loan.duration,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: loan.isEligible ? () {} : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: loan.isEligible
                                      ? AppColors.primaryColor
                                      : AppColors.textSecondary
                                          .withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  loan.isEligible
                                      ? 'Saba Nonaha' // Apply Now
                                      : 'Ntugishoboye', // Not Eligible
                                  style: TextStyle(
                                    color: loan.isEligible
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (!loan.isEligible)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.orange,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    const Expanded(
                                      child: Text(
                                        'Ongera amanota yawe kugira ngo...', // Improve your score to qualify
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            bottomNavigationBar: TBottomNavBar(
              currentSelected: 4,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Card(
      color: AppColors.cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.trending_up, color: AppColors.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
