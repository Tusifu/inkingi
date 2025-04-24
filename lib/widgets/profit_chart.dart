// lib/widgets/profit_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/utils/date_utils.dart';
import 'package:intl/intl.dart';

class ProfitChart extends StatelessWidget {
  final double profit; // Add profit as a parameter

  const ProfitChart({
    super.key,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
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
          // Profit title and value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inyungu', // Profit in Kinyarwanda
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '+${NumberFormat.decimalPattern().format(profit)} RWF',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          SizedBox(
            height: 160, // Adjust height to fit the chart below the title
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 7.5, // Consistent interval of 7.5k
                      getTitlesWidget: (value, meta) {
                        if (value % 7.5 != 0) return const SizedBox.shrink();
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
                minY: 0,
                maxY: 30, // Set to 30k to match the image
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 15.0),
                      FlSpot(1, 10.0),
                      FlSpot(2, 20.0),
                      FlSpot(3, 15.0),
                      FlSpot(4, 25.0),
                      FlSpot(5, 30.0),
                      FlSpot(6, 20.0),
                    ],
                    isCurved: true,
                    color: AppColors.lightGreen,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color:
                          AppColors.lightGreen.withOpacity(0.2), // Filled area
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 10.0),
                      FlSpot(1, 7.5),
                      FlSpot(2, 15.0),
                      FlSpot(3, 12.5),
                      FlSpot(4, 17.5),
                      FlSpot(5, 20.0),
                      FlSpot(6, 15.0),
                    ],
                    isCurved: true,
                    color: AppColors.secondaryOrange,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.secondaryOrange
                          .withOpacity(0.2), // Filled area
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 5.0),
                      FlSpot(1, 2.5),
                      FlSpot(2, 7.5),
                      FlSpot(3, 5.0),
                      FlSpot(4, 10.0),
                      FlSpot(5, 12.5),
                      FlSpot(6, 7.5),
                    ],
                    isCurved: true,
                    color: AppColors.primaryColor, // Blue line for profit
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryColor
                          .withOpacity(0.2), // Filled area
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
}
