// lib/components/TBottomNavBar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/screens/add_transaction.dart';
import 'package:inkingi/screens/dashboard_screen.dart';
import 'package:inkingi/screens/loans_screen.dart';
import 'package:inkingi/screens/reports_screen.dart';
import 'package:inkingi/screens/transactions_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';

class TBottomNavBar extends StatelessWidget {
  final int currentSelected;
  final bool isHome;

  TBottomNavBar({Key? key, this.currentSelected = 0, this.isHome = false})
      : super(key: key);

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': 'assets/svgs/bottomNavbar/homeGrey.svg',
      'label': 'Ahabanza', // Home
      'route': DashboardScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/transactions.svg',
      'label': 'Ibikorwa', // Transactions
      'route': TransactionsScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/add.svg',
      'label': 'Ongeramo',
      'route': '',
    },
    {
      'icon': 'assets/svgs/bottomNavbar/reports.svg',
      'label': 'Raporo', // Reports
      'route': ReportsScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/loans.svg',
      'label': 'Inguzanyo', // Loans
      'route': LoansScreen.routeName,
    },
  ];

  void _navigateTo(BuildContext context, int index) {
    if (index == 2) {
      // Middle item (Add Transaction)
      Navigator.push(
        context,
        AppTransitions.fadeNamed(AddTransactionScreen.routeName),
      );
    } else {
      String routeName = _navItems[index]['route'];
      if (ModalRoute.of(context)?.settings.name != routeName &&
          routeName.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          AppTransitions.fadeReplacementNamed(routeName),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          bool isSelected = currentSelected == index;
          bool isAddButton = index == 2; // Middle item is the "Add" button

          return GestureDetector(
            onTap: () => _navigateTo(context, index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAddButton)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SvgPicture.asset(
                          _navItems[index]['icon'],
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SvgPicture.asset(
                    _navItems[index]['icon'],
                    width: 24,
                    height: 24,
                    colorFilter: isSelected
                        ? ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          )
                        : null,
                  ),
                const SizedBox(height: 4),
                Text(
                  _navItems[index]['label'],
                  style: TextStyle(
                    color: isSelected || isAddButton
                        ? AppColors.primaryColor
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected || isAddButton
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ),
    );
  }
}
