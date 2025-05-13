import 'package:flutter/material.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/providers/reports_provider.dart';
import 'package:inkingi/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatelessWidget {
  static const String routeName = '/reportsScreen';
  const ReportsScreen({super.key});

  // Translate report period keys to Kinyarwanda using DateUtils
  String _translatePeriod(String period) {
    // Translate quarters
    if (period.startsWith('Q')) {
      return DateUtilities.translateQuarter(period);
    }

    // Translate weeks
    if (period.startsWith('Week')) {
      return DateUtilities.translateWeek(period);
    }

    // Translate months
    return DateUtilities.translateMonth(period);
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
            appBar: CustomAppBar(
              title: 'Raporo',
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: _buildModernFilter(context, provider),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: report.length,
                    itemBuilder: (context, index) {
                      final period = report.keys.elementAt(index);
                      final data = report[period]!;
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
                                    'Ayinjiye ${NumberFormat.decimalPattern().format(data['Income']!)} RWF',
                                    style: const TextStyle(
                                      color: AppColors.lightGreen,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Ayasohotse: ${NumberFormat.decimalPattern().format(data['Expenses']!)} RWF',
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
        color: Colors.black,
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
                      ? AppColors.primaryColorBlue
                      : AppColors.greyColor700,
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
