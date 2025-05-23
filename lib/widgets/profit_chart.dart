import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfitChart extends StatelessWidget {
  const ProfitChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        Widget chartContainer({required Widget child}) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          );
        }

        if (dashboardProvider.isLoading) {
          return chartContainer(
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (dashboardProvider.error != null) {
          return chartContainer(
            child: Center(
              child: Text(
                'Error: ${dashboardProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final now = DateTime.now();
        final last7Days =
            List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
        final transactions = dashboardProvider.transactions;

        if (transactions.isEmpty) {
          return chartContainer(
            child: _buildEmptyChart(),
          );
        }

        // Group data by day
        final Map<DateTime, Map<String, double>> dailyData = {};
        for (var transaction in transactions) {
          final day = DateTime(transaction.date.year, transaction.date.month,
              transaction.date.day);
          DateTime? matchingDay;
          try {
            matchingDay = last7Days.firstWhere(
              (d) =>
                  d.year == day.year &&
                  d.month == day.month &&
                  d.day == day.day,
            );
          } catch (_) {}
          if (matchingDay != null) {
            dailyData.putIfAbsent(
                matchingDay,
                () => {
                      'income': 0.0,
                      'expenses': 0.0,
                    });
            if (transaction.isIncome) {
              dailyData[matchingDay]!['income'] =
                  (dailyData[matchingDay]!['income'] ?? 0) + transaction.amount;
            } else {
              dailyData[matchingDay]!['expenses'] =
                  (dailyData[matchingDay]!['expenses'] ?? 0) +
                      transaction.amount;
            }
          }
        }

        final incomeSpots = last7Days
            .asMap()
            .entries
            .map((entry) => FlSpot(
                  entry.key.toDouble(),
                  (dailyData[entry.value]?['income'] ?? 0) / 1000,
                ))
            .toList();

        final expenseSpots = last7Days
            .asMap()
            .entries
            .map((entry) => FlSpot(
                  entry.key.toDouble(),
                  (dailyData[entry.value]?['expenses'] ?? 0) / 1000,
                ))
            .toList();

        final profitSpots = last7Days
            .asMap()
            .entries
            .map((entry) => FlSpot(
                  entry.key.toDouble(),
                  ((dailyData[entry.value]?['income'] ?? 0) -
                          (dailyData[entry.value]?['expenses'] ?? 0)) /
                      1000,
                ))
            .toList();

        final totalProfit = transactions
            .where((t) => last7Days.any((d) =>
                d.year == t.date.year &&
                d.month == t.date.month &&
                d.day == t.date.day))
            .map((t) => t.isIncome ? t.amount : -t.amount)
            .fold(0.0, (a, b) => a + b);

        final maxY = [
              incomeSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b),
              expenseSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b),
              profitSpots.map((e) => e.y.abs()).reduce((a, b) => a > b ? a : b),
              30.0
            ].reduce((a, b) => a > b ? a : b) *
            1.2;

        return chartContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Inyungu',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${totalProfit >= 0 ? '+' : ''}${NumberFormat.decimalPattern().format(totalProfit)} RWF',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color:
                          totalProfit >= 0 ? AppColors.lightGreen : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: maxY / 4,
                          getTitlesWidget: (value, _) {
                            return Text(
                              '${value.toInt()}k',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final days =
                                DateUtilities.getDaysOfWeek(abbreviated: true);
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: 0,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: incomeSpots,
                        isCurved: true,
                        color: AppColors.lightGreen,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.lightGreen.withOpacity(0.2),
                        ),
                      ),
                      LineChartBarData(
                        spots: expenseSpots,
                        isCurved: true,
                        color: AppColors.secondaryOrange,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.secondaryOrange.withOpacity(0.2),
                        ),
                      ),
                      LineChartBarData(
                        spots: profitSpots,
                        isCurved: true,
                        color: AppColors.primaryColor,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primaryColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Inyungu',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '+0 RWF',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.lightGreen,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'No data',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
