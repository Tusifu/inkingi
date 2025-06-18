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

  String _translatePeriod(String period) {
    if (period.startsWith('Q')) {
      return DateUtilities.translateQuarter(period);
    }
    if (period.startsWith('Week')) {
      final parts = period.split(', ');
      final weekNumber = parts[0].replaceFirst('Week ', 'Icyumweru cya ');
      final dateParts = parts[1].split('/');
      final month = int.parse(dateParts[0]);
      final monthName = DateUtilities.translateMonth(month.toString());
      return '$weekNumber mukwa $monthName'; // e.g., "Icyumweru cya 3 mukwa 5"
    }
    return DateUtilities.translateMonth(period);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ReportsProvider(dashboardProvider.transactions),
      child: Consumer<ReportsProvider>(
        builder: (context, provider, child) {
          final timeReport = provider.generateTimeReport();
          final productReport = provider.generateProductReport();
          final categoryReport = provider.generateCategoryReport();

          return DefaultTabController(
            length: 3,
            child: Scaffold(
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
                  TabBar(
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textPrimary,
                    indicatorColor: AppColors.primaryColorBlue,
                    tabs: const [
                      Tab(
                        text: 'Igihe',
                      ),
                      Tab(text: 'Igicuruzwa'),
                      Tab(text: 'Ikiciro'),
                    ],
                    onTap: (index) {
                      provider.setReportMode(
                        index == 0
                            ? 'Time'
                            : index == 1
                                ? 'Product'
                                : 'Category',
                      );
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildReportGrid(timeReport, _translatePeriod, context),
                        _buildReportGrid(
                            productReport, (name) => name, context),
                        _buildReportGrid(
                            categoryReport, (name) => name, context),
                      ],
                    ),
                  ),
                  // Color Key
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildColorKey(
                          color: AppColors.incomeColor,
                          label: 'Ayinjiye',
                        ),
                        _buildColorKey(
                          color: AppColors.expensesColor,
                          label: 'Ayasohotse',
                        ),
                        _buildColorKey(
                          color: Colors.orange,
                          label: 'Inyungu',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: TBottomNavBar(
                currentSelected: 3,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernFilter(BuildContext context, ReportsProvider provider) {
    final filters = [
      'Ku Cyumweru',
      'Ku Kwezi',
      'Ku Gihembwe',
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
          final reportType = filter == 'Ku Cyumweru'
              ? 'Weekly'
              : filter == 'Ku Kwezi'
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

  Widget _buildReportGrid(Map<String, Map<String, double>> report,
      String Function(String) labelFormatter, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0, // Keeps cards taller
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: report.length,
        itemBuilder: (context, index) {
          final key = report.keys.elementAt(index);
          final data = report[key]!;
          final income = data['Income'] ?? 0.0;
          final expenses = data['Expenses'] ?? 0.0;
          final total = income + expenses;
          final profit = income - expenses;

          // Calculate percentages
          double incomePercentage = total > 0 ? (income / total) : 0.0;
          double expensesPercentage = total > 0 ? (expenses / total) : 0.0;
          double profitPercentage = total > 0 ? (profit.abs() / total) : 0.0;

          // Normalize to sum to 1.0
          double sum = incomePercentage + expensesPercentage + profitPercentage;
          if (sum > 0) {
            incomePercentage /= sum;
            expensesPercentage /= sum;
            profitPercentage /= sum;
          }

          // Clamp to ensure valid proportions and adjust profit to fit
          incomePercentage = incomePercentage.clamp(0.0, 1.0);
          expensesPercentage = expensesPercentage.clamp(0.0, 1.0);
          profitPercentage =
              (1.0 - incomePercentage - expensesPercentage).clamp(0.0, 1.0);

          return Card(
            color: AppColors.cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(
                        children: [
                          // Income (Green) with gradient
                          FractionallySizedBox(
                            widthFactor: incomePercentage,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.incomeColor.withOpacity(0.7),
                                    AppColors.incomeColor,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          // Expenses (Red) with gradient
                          FractionallySizedBox(
                            widthFactor: expensesPercentage,
                            alignment: Alignment.centerRight,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.expensesColor.withOpacity(0.7),
                                      AppColors.expensesColor,
                                    ],
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Profit (Orange) with gradient
                          if (profit != 0)
                            FractionallySizedBox(
                              widthFactor: profitPercentage,
                              alignment: Alignment.center,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.withOpacity(0.7),
                                        Colors.orange,
                                      ],
                                      begin: Alignment.center,
                                      end: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labelFormatter(key),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inyungu: ${NumberFormat.decimalPattern().format(profit)} RWF',
                    style: TextStyle(
                      color: profit >= 0
                          ? AppColors.profitColor
                          : AppColors.expensesColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ayinjiye: ${NumberFormat.decimalPattern().format(income)} RWF',
                    style: const TextStyle(
                      color: AppColors.incomeColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ayasohotse: ${NumberFormat.decimalPattern().format(expenses)} RWF',
                    style: const TextStyle(
                      color: AppColors.expensesColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorKey({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
