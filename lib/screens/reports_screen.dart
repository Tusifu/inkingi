// lib/screens/reports_screen.dart
import 'package:flutter/material.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../providers/reports_provider.dart';

class ReportsScreen extends StatelessWidget {
  static const String routeName = '/reportsScreen';
  const ReportsScreen({super.key});

  // Translate report period keys to Kinyarwanda
  String _translatePeriod(String period) {
    // Translate months
    const months = {
      'January': 'Mutarama',
      'February': 'Gashyantare',
      'March': 'Werurwe',
      'April': 'Mata',
      'May': 'Gicurasi',
      'June': 'Kamena',
      'July': 'Nyakanga',
      'August': 'Kanama',
      'September': 'Nzeli',
      'October': 'Ukwakira',
      'November': 'Ugushyingo',
      'December': 'Ukuboza',
    };

    // Translate quarters
    if (period.startsWith('Q')) {
      final quarterNumber = period.substring(1);
      return 'Igice $quarterNumber';
    }

    // Translate weeks
    if (period.startsWith('Week')) {
      final weekNumber = period.split(' ')[1];
      return 'Icyumweru $weekNumber';
    }

    // Translate months
    return months[period] ?? period;
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ReportsProvider(dashboardProvider.transactions),
      child: Consumer<ReportsProvider>(
        builder: (context, provider, child) {
          final report = provider.generateReport();

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0, // Explicitly set to 0 for scrolling
              surfaceTintColor: AppColors.background, // Prevent tint changes
              title: const Text(
                'Raporo', // Reports
                style: TextStyle(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildModernFilter(context, provider),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: report.length,
                    itemBuilder: (context, index) {
                      final period = report.keys.elementAt(index);
                      final data = report[period]!;
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _translatePeriod(period),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ayinjiye: ${data['Income']!.toStringAsFixed(0)} RWF',
                                    style: const TextStyle(
                                      color: AppColors.lightGreen,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Ayasohowe: ${data['Expenses']!.toStringAsFixed(0)} RWF',
                                    style: const TextStyle(
                                      color: AppColors.secondaryOrange,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: TBottomNavBar(
              currentSelected: 3,
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernFilter(BuildContext context, ReportsProvider provider) {
    final filters = [
      'Buri Cyumweru', // Weekly
      'Buri Kwezi', // Monthly
      'Buri Gice', // Quarterly
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.greyColor50,
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
          final reportType = filter == 'Buri Cyumweru'
              ? 'Weekly'
              : filter == 'Buri Kwezi'
                  ? 'Monthly'
                  : 'Quarterly';
          final isSelected = provider.reportType == reportType;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                provider.setReportType(reportType);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.greyColor100, // Background for unselected
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
