import 'package:flutter/material.dart';
import 'package:inkingi/components/TTransactionTile.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/screens/add_transaction.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/screens/transactions_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';
import 'package:provider/provider.dart';
import '../widgets/overview_card.dart';
import '../widgets/profit_chart.dart';
import '../widgets/credit_profile.dart';

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Financial overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "April 1, 2025",
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OverviewCard(
                          title: 'Total Income',
                          amount: provider.totalIncome,
                          percentageChange: 12,
                          isPositive: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OverviewCard(
                          title: 'Total Expenses',
                          amount: provider.totalExpenses,
                          percentageChange: 5,
                          isPositive: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Profit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '+${provider.profit.toStringAsFixed(0)} RWF',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  const ProfitChart(),
                  const SizedBox(height: 16),
                  const CreditProfile(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
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
                          'View All',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Use TransactionTile for the last 3 transactions
                  if (lastThreeTransactions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'No recent transactions',
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTransactionScreen(),
              );
            },
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.add),
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
