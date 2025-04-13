import 'package:flutter/material.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../providers/reports_provider.dart';

class ReportsScreen extends StatelessWidget {
  static const String routeName = '/reportsScreen';
  const ReportsScreen({super.key});

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
              title: const Text(
                'Reports',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildReportTypeButton(context, provider, 'Weekly'),
                      const SizedBox(width: 8),
                      _buildReportTypeButton(context, provider, 'Monthly'),
                      const SizedBox(width: 8),
                      _buildReportTypeButton(context, provider, 'Quarterly'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: report.length,
                    itemBuilder: (context, index) {
                      final period = report.keys.elementAt(index);
                      final data = report[period]!;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                period,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Income: ${data['Income']!.toStringAsFixed(0)} RWF',
                                    style: const TextStyle(
                                      color: AppColors.lightGreen,
                                    ),
                                  ),
                                  Text(
                                    'Expenses: ${data['Expenses']!.toStringAsFixed(0)} RWF',
                                    style: const TextStyle(
                                      color: AppColors.secondaryOrange,
                                    ),
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
              currentSelected: 2,
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportTypeButton(
      BuildContext context, ReportsProvider provider, String type) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => provider.setReportType(type),
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.reportType == type
              ? AppColors.primaryColor
              : AppColors.textSecondary.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: provider.reportType == type
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
