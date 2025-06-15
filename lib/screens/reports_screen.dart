import 'package:flutter/material.dart';
import 'package:inkingi/components/TAppBar.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/providers/reports_provider.dart';
import 'package:inkingi/utils/date_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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
          final incomePercentage = total > 0 ? (income / total) * 100 : 0;
          final expensesPercentage = total > 0 ? (expenses / total) * 100 : 0;

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
                  CustomPieChart(
                    incomePercentage: incomePercentage / 100,
                    expensesPercentage: expensesPercentage / 100,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labelFormatter(key),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12, // Reduced from 14 to fit better
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profit: ${NumberFormat.decimalPattern().format(income - expenses)} RWF',
                    style: TextStyle(
                      color: (income - expenses) >= 0
                          ? AppColors.incomeColor
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
}

class CustomPieChart extends StatelessWidget {
  final double incomePercentage;
  final double expensesPercentage;

  const CustomPieChart({
    super.key,
    required this.incomePercentage,
    required this.expensesPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: PieChartPainter(incomePercentage, expensesPercentage),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double incomePercentage;
  final double expensesPercentage;

  PieChartPainter(this.incomePercentage, this.expensesPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw income segment (green)
    paint.color = AppColors.incomeColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      -math.pi * 2 * (incomePercentage.clamp(0.0, 1.0)),
      true,
      paint,
    );

    // Draw expenses segment (red)
    paint.color = AppColors.expensesColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 - math.pi * 2 * (incomePercentage.clamp(0.0, 1.0)),
      -math.pi * 2 * (expensesPercentage.clamp(0.0, 1.0)),
      true,
      paint,
    );

    // Draw border
    paint.color = Colors.grey.withOpacity(0.3);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
