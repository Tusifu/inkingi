import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inkingi/components/TBottomNavBar.dart';
import 'package:inkingi/components/TProfileAvatar.dart';
import 'package:inkingi/components/TTransactionTile.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/screens/profile_screen.dart';
import 'package:inkingi/screens/transactions_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';
import 'package:inkingi/widgets/overview_card.dart';
import 'package:inkingi/widgets/profit_card.dart';
import 'package:inkingi/widgets/profit_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboardScreen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final recentTransactions = provider.transactions
          ..sort((a, b) => b.date.compareTo(a.date));
        final lastThreeTransactions = recentTransactions.take(3).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 32, 58, 85),
                  Colors.transparent,
                ],
                stops: [0.0, 0.3],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset("assets/svgs/bk_logo.svg"),
                            const SizedBox(width: 8),
                            Text(
                              "Inkingi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.filter_alt,
                                color: Colors.white70,
                                size: 30,
                              ),
                              onSelected: (String value) {
                                provider.setFilter(value);
                              },
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'Daily',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF1C2526),
                                          Color(0xFF2A3435),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.white70,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 24),
                                        const Text(
                                          "Uyu Munsi",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Weekly',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF1C2526),
                                          Color(0xFF2A3435),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Colors.white70,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 24),
                                        const Text(
                                          "Iminsi 7 ishize",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Monthly',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF1C2526),
                                          Color(0xFF2A3435),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          color: Colors.white70,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 24),
                                        const Text(
                                          "Iminsi 30 ishize",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                                bottom: 5.0,
                              ),
                              child: ProfileAvatar(
                                initial: "T",
                                size: 35.0,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    AppTransitions.fadeNamed(
                                        ProfileScreen.routeName),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.translatedFilter,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ProfitCard(
                            title:
                                provider.totalIncome - provider.totalExpenses >
                                        0
                                    ? 'Inyungu'
                                    : 'Igihombo',
                            amount:
                                provider.totalIncome - provider.totalExpenses,
                            percentageChange: 8,
                            isPositive: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OverviewCard(
                            title: 'Ayinjiye',
                            amount: provider.totalIncome,
                            percentageChange: 12,
                            isPositive: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OverviewCard(
                            title: 'Ayasohotse',
                            amount: provider.totalExpenses,
                            percentageChange: 5,
                            isPositive: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ProfitChart(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Incamake',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              AppTransitions.fadeNamed(
                                  TransactionsScreen.routeName),
                            );
                          },
                          child: const Text(
                            'Reba Byose',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (lastThreeTransactions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Nta bikorwa bya vuba a vuba biracyari',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: lastThreeTransactions
                            .map((transaction) => TTransactionTile(
                                  transaction: transaction,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: TBottomNavBar(
            currentSelected: 0,
            isHome: true,
          ),
        );
      },
    );
  }
}
