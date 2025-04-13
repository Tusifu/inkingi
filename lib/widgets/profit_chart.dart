// lib/widgets/profit_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';

class ProfitChart extends StatelessWidget {
  const ProfitChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}k',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    'Mon', // Mweri
                    'Tue', // Kabiri
                    'Wed', // Gatatu
                    'Thu', // Kane
                    'Fri', // Gatanu
                    'Sat', // Gatandatu
                    'Sun' // Cyumweru
                  ];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 7.5),
                const FlSpot(1, 5.0),
                const FlSpot(2, 10.0),
                const FlSpot(3, 8.0),
                const FlSpot(4, 12.0),
                const FlSpot(5, 15.0),
                const FlSpot(6, 10.0),
              ],
              isCurved: true,
              color: AppColors.lightGreen,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: [
                const FlSpot(0, 5.0),
                const FlSpot(1, 3.0),
                const FlSpot(2, 7.0),
                const FlSpot(3, 6.0),
                const FlSpot(4, 8.0),
                const FlSpot(5, 10.0),
                const FlSpot(6, 7.0),
              ],
              isCurved: true,
              color: AppColors.secondaryOrange,
              barWidth: 3,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
