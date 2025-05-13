import 'package:flutter/material.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/loan.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/providers/loans_provider.dart';
import 'package:inkingi/widgets/credit_profile.dart';
import 'package:provider/provider.dart';

class LoansScreen extends StatelessWidget {
  static const String routeName = '/loansScreen';
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) =>
          LoansProvider(dashboardProvider.transactions)..checkEligibility(),
      child: Consumer<LoansProvider>(
        builder: (context, provider, child) {
          // Ensure availableLoans is not empty (though it should be initialized)
          final loans = provider.availableLoans.isEmpty
              ? [
                  Loan(
                    title: 'No Loans Available',
                    description: 'No loan offers are currently available.',
                    amount: 0,
                    apr: 0.0,
                    duration: 'N/A',
                    isEligible: false,
                  )
                ]
              : provider.availableLoans;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppBar(
              title: 'Inguzanyo',
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreditProfile(),
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
                      'Gumana amafaranga yinjiye atari uko', // Maintain consistent income
                      'Amafranga yinjiye atari uko agaragaza...'), // Steady income streams show business stability
                  const SizedBox(height: 16),
                  const Text(
                    'Inguzanyo wabona', // Available Loan Offers
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  ...loans.map((loan) {
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
                                      ? 'Saba Nonaha'
                                      : 'Nturemererwa',
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
                                        'Ongera amanota yawe kugira ngo uhabwe iyi nguzanyo.', // Improve your score to qualify
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 11,
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
            Icon(
              Icons.trending_up,
              color: AppColors.textColor,
            ),
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
                      color: AppColors.textColor,
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
