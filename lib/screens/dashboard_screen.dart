import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/screens/add_transaction.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/overview_card.dart';
import '../widgets/profit_chart.dart';
import '../widgets/credit_profile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
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
                      Text(
                        "Financial overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "April 1, 2025",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
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
                      Text(
                        'Profit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '+${provider.profit.toStringAsFixed(0)} RWF',
                        style: TextStyle(
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
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/transactions');
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: 'Reports'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance), label: 'Loans'),
            ],
            currentIndex: 1,
            useLegacyColorScheme: false,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.textSecondary,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/transactions');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/reports');
              } else if (index == 3) {
                Navigator.pushNamed(context, '/loans');
              }
            },
          ),
        );
      },
    );
  }
}
