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
        if (dashboardProvider.isLoading) {
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
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (dashboardProvider.error != null) {
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
            child: Center(
              child: Text(
                'Error: ${dashboardProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (dashboardProvider.transactions.isEmpty) {
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
                    const Text(
                      '+0 RWF',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGreen,
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
                            interval: 7.5,
                            getTitlesWidget: (value, meta) {
                              if (value % 7.5 != 0)
                                return const SizedBox.shrink();
                              return Text(
                                '${value.toInt()}k',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = DateUtilities.getDaysOfWeek(
                                  abbreviated: true);
                              return Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: 30,
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                              7, (index) => FlSpot(index.toDouble(), 0)),
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
                          spots: List.generate(
                              7, (index) => FlSpot(index.toDouble(), 0)),
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
                          spots: List.generate(
                              7, (index) => FlSpot(index.toDouble(), 0)),
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
        }

        final now = DateTime.now();
        final last7Days =
            List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
        final transactions = dashboardProvider.transactions;

        // Debug: Log transactions for verification
        print('Transactions: ${transactions.length}');
        for (var t in transactions) {
          print(
              'Date: ${t.date}, Amount: ${t.amount}, IsIncome: ${t.isIncome}');
        }

        // Aggregate income, expenses, and profit per day
        final Map<DateTime, Map<String, double>> dailyData = {};
        for (var transaction in transactions) {
          final day = DateTime(transaction.date.year, transaction.date.month,
              transaction.date.day);
          DateTime? matchingDay; // Make it nullable
          try {
            matchingDay = last7Days.firstWhere(
              (d) =>
                  d.year == day.year &&
                  d.month == day.month &&
                  d.day == day.day,
            );
          } catch (e) {
            // No match found, matchingDay remains null
          }
          if (matchingDay != null) {
            if (!dailyData.containsKey(matchingDay)) {
              dailyData[matchingDay] = {'income': 0.0, 'expenses': 0.0};
            }
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

        // Generate spots for the chart
        final incomeSpots = last7Days.map((day) {
          final data = dailyData[day] ?? {'income': 0.0, 'expenses': 0.0};
          return FlSpot(
              last7Days.indexOf(day).toDouble(), data['income']! / 1000);
        }).toList();
        final expenseSpots = last7Days.map((day) {
          final data = dailyData[day] ?? {'income': 0.0, 'expenses': 0.0};
          return FlSpot(
              last7Days.indexOf(day).toDouble(), data['expenses']! / 1000);
        }).toList();
        final profitSpots = last7Days.map((day) {
          final data = dailyData[day] ?? {'income': 0.0, 'expenses': 0.0};
          return FlSpot(last7Days.indexOf(day).toDouble(),
              (data['income']! - data['expenses']!) / 1000);
        }).toList();

        // Calculate total profit for display
        final totalProfit = transactions
            .where((t) => last7Days.any((d) =>
                d.year == t.date.year &&
                d.month == t.date.month &&
                d.day == t.date.day))
            .map((t) => t.isIncome ? t.amount : -t.amount)
            .fold(0.0, (a, b) => a + b);

        // Calculate maxY dynamically based on data
        final maxIncome = incomeSpots
            .map((spot) => spot.y)
            .fold(0.0, (a, b) => a > b ? a : b);
        final maxExpense = expenseSpots
            .map((spot) => spot.y)
            .fold(0.0, (a, b) => a > b ? a : b);
        final maxProfit = profitSpots
            .map((spot) => spot.y)
            .fold(0.0, (a, b) => a > b ? a : b);
        final maxY = ([maxIncome, maxExpense, maxProfit.abs(), 30.0]
                    .reduce((a, b) => a > b ? a : b) *
                1.2)
            .ceilToDouble();

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
                          getTitlesWidget: (value, meta) {
                            if (value % (maxY / 4) != 0)
                              return const SizedBox.shrink();
                            return Text(
                              '${value.toInt()}k',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final days =
                                DateUtilities.getDaysOfWeek(abbreviated: true);
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: -maxY,
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
                        color: profitSpots.any((spot) => spot.y < 0)
                            ? Colors.red
                            : AppColors.primaryColor,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: profitSpots.any((spot) => spot.y < 0)
                              ? Colors.red.withOpacity(0.2)
                              : AppColors.primaryColor.withOpacity(0.2),
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
}
