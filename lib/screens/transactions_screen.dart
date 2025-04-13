import 'package:flutter/material.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/screens/add_transaction.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/transaction_list.dart';

class TransactionsScreen extends StatefulWidget {
  static const String routeName = '/transactionsScreen';
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
          backgroundColor: AppColors.background,
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
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: TBottomNavBar(
            currentSelected: 1,
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
              ? AppColors.primaryColor
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
