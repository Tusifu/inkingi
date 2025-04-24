// lib/screens/transactions_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/transaction.dart';
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
  String _filter = 'Byose'; // Filter state
  String _searchQuery = ''; // Search query state
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to filter transactions based on search query
  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    if (_searchQuery.isEmpty) return transactions;

    return transactions.where((transaction) {
      final description = transaction.description.toLowerCase();
      final amount = transaction.amount.toString().toLowerCase();
      final query = _searchQuery.toLowerCase();

      return description.contains(query) || amount.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        // Filter transactions based on search query
        final searchFilteredTransactions =
            _filterTransactions(provider.transactions);
        // Apply category filter using isIncome
        final transactionsToShow =
            searchFilteredTransactions.where((transaction) {
          if (_filter == 'Byose') return true;
          return (_filter == 'Ayinjiye')
              ? transaction.isIncome
              : !transaction.isIncome;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Ibikorwa', // transactions
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.primaryColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.outfit(
                      color: Colors.white, // White text color
                    ),
                    cursorColor: Colors.white, // White cursor color
                    decoration: InputDecoration(
                      hintText: 'Shakisha ibikorwa',
                      hintStyle: GoogleFonts.outfit(
                        color: Colors
                            .white70, // Slightly translucent white for hint text
                      ),
                      filled: true,
                      fillColor: Colors.grey[900], // Search transactions...
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.greyColor50,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: _buildModernFilter(),
              ),
              Expanded(
                child: TransactionList(
                  transactions: transactionsToShow,
                  filter: 'All', // Pass 'All' to avoid double-filtering
                ),
              ),
            ],
          ),
          bottomNavigationBar: TBottomNavBar(
            currentSelected: 1,
          ),
        );
      },
    );
  }

  Widget _buildModernFilter() {
    final filters = [
      'Byose', // All
      'Ayinjiye', // Income
      'Ayasohowe', // Expenses
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _filter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _filter = filter;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey, // Background for unselected
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
