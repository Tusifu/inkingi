import 'package:flutter/material.dart';
import 'package:inkingi/core/constants/colors.dart';
import 'package:inkingi/features/add_transaction/add_transaction.dart';
import 'package:inkingi/features/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/transaction_list.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: const Text(
              'Transactions',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildFilterButton('All', _filter == 'All'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Income', _filter == 'Income'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Expenses', _filter == 'Expenses'),
                  ],
                ),
              ),
              Expanded(
                child: TransactionList(
                  transactions: provider.transactions,
                  filter: _filter,
                ),
              ),
            ],
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: 'Reports'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance), label: 'Loans'),
            ],
            currentIndex: 2,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.textSecondary,
            onTap: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/dashboard');
              } else if (index == 3) {
                Navigator.pushNamed(context, '/reports');
              } else if (index == 4) {
                Navigator.pushNamed(context, '/loans');
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String label, bool isSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _filter = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? AppColors.primaryBlue
              : AppColors.textSecondary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
