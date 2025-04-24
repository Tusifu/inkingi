// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/components/TTransactionTile.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/screens/loans_screen.dart';
import 'package:inkingi/screens/transactions_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';
import 'package:inkingi/widgets/credit_profile.dart';
import 'package:inkingi/widgets/overview_card.dart';
import 'package:inkingi/widgets/profit_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboardScreen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        // Get the last 3 transactions, sorted by date (most recent first)
        final recentTransactions = provider.transactions
          ..sort((a, b) => b.date.compareTo(a.date)); // Sort descending
        final lastThreeTransactions = recentTransactions.take(3).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/svgs/bk_logo.svg"),
                          const SizedBox(width: 8),
                          Text(
                            "Incamake y'Imari", // Financial overview
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "24 Mata 2025",
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OverviewCard(
                          title: 'Amafaranga Yose Yinjiye', // Total Income
                          amount: provider.totalIncome,
                          percentageChange: 12,
                          isPositive: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OverviewCard(
                          title: 'Amafaranga Yose Yasohotse', // Total Expenses
                          amount: provider.totalExpenses,
                          percentageChange: 5,
                          isPositive: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ProfitChart(
                    profit: (provider.totalIncome - provider.totalExpenses),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        AppTransitions.fadeNamed(
                          LoansScreen.routeName,
                        ),
                      );
                    },
                    child: CreditProfile(),
                  ),
                  // const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Incamake', // Recent Transactions
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            AppTransitions.fadeNamed(
                                TransactionsScreen.routeName),
                          );
                        },
                        child: const Text(
                          'Reba Byose', // View All
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  // Use TransactionTile for the last 3 transactions
                  if (lastThreeTransactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Nta bikorwa bya vuba a vuba biracyari',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: lastThreeTransactions
                          .map((transaction) => TTransactionTile(
                                transaction: transaction,
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: TBottomNavBar(
            currentSelected: 0,
            isHome: true,
          ),
        );
      },
    );
  }
}
