import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfitChart extends StatefulWidget {
  const ProfitChart({super.key});

  @override
  State<ProfitChart> createState() => _ProfitChartState();
}

Color incomeColor = AppColors.incomeColor;
Color expensesColor = AppColors.expensesColor;
Color profitColor = AppColors.profitColor;

class _ProfitChartState extends State<ProfitChart> {
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
            List.generate(7, (i) => now.subtract(Duration(days: 6 - i)))
                .map((date) => DateTime(date.year, date.month, date.day))
                .toList();
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

        final profitSpots = last7Days.asMap().entries.map((entry) {
          final profit = ((dailyData[entry.value]?['income'] ?? 0) -
                  (dailyData[entry.value]?['expenses'] ?? 0)) /
              1000;
          // Ensure profit doesn't go below zero for display purposes
          return FlSpot(
            entry.key.toDouble(),
            profit >= 0 ? profit : 0,
          );
        }).toList();

        final totalProfit = transactions
            .where((t) => last7Days.any((d) =>
                d.year == t.date.year &&
                d.month == t.date.month &&
                d.day == t.date.day))
            .map((t) => t.isIncome ? t.amount : -t.amount)
            .fold(0.0, (a, b) => a + b);

        final maxY = [
              ...incomeSpots.map((e) => e.y),
              ...expenseSpots.map((e) => e.y),
              ...profitSpots.map((e) => e.y),
              30.0
            ].reduce((a, b) => a > b ? a : b) *
            1.2;

        return chartContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart Title
              const Text(
                'Ishusho y\'icyumweru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Profit Summary
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
                      color: totalProfit >= 0 ? profitColor : expensesColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // The Chart
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
                            if (value.toInt() >= 0 &&
                                value.toInt() < last7Days.length) {
                              final date = last7Days[value.toInt()];
                              final dayName = DateFormat('E').format(date);
                              return Text(
                                dayName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              );
                            }
                            return const Text('');
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
                        color: incomeColor,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: incomeColor.withOpacity(0.2),
                        ),
                      ),
                      LineChartBarData(
                        spots: expenseSpots,
                        isCurved: true,
                        color: expensesColor,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: expensesColor.withOpacity(0.2),
                        ),
                      ),
                      LineChartBarData(
                        spots: profitSpots,
                        isCurved: true,
                        color: profitColor,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: profitColor.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Legend/Key
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(
                    color: incomeColor,
                    text: 'Income',
                  ),
                  const SizedBox(width: 16),
                  _buildLegendItem(
                    color: expensesColor,
                    text: 'Expenses',
                  ),
                  const SizedBox(width: 16),
                  _buildLegendItem(
                    color: profitColor,
                    text: 'Profit',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart Title
        const Text(
          'Ishusho y\'icyumweru',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Empty content
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
                color: profitColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'No data',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),

        // Legend/Key (shown even when empty)
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              color: incomeColor,
              text: 'Income',
            ),
            const SizedBox(width: 16),
            _buildLegendItem(
              color: expensesColor,
              text: 'Expenses',
            ),
            const SizedBox(width: 16),
            _buildLegendItem(
              color: profitColor,
              text: 'Profit',
            ),
          ],
        ),
      ],
    );
  }
}
