import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/screens/dashboard_screen.dart';
import 'package:inkingi/screens/loans_screen.dart';
import 'package:inkingi/screens/reports_screen.dart';
import 'package:inkingi/screens/transactions_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';
import 'package:inkingi/utils/styles.dart';

class TBottomNavBar extends StatelessWidget {
  final int currentSelected;
  final bool isHome;

  TBottomNavBar({Key? key, this.currentSelected = 0, this.isHome = false})
      : super(key: key);

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': 'assets/svgs/bottomNavbar/homeGrey.svg',
      'label': 'Home',
      'route': DashboardScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/transactions.svg',
      'label': 'Transactions',
      'route': TransactionsScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/reports.svg',
      'label': 'Reports',
      'route': ReportsScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/loans.svg',
      'label': 'Loans',
      'route': LoansScreen.routeName,
    },
    {
      'icon': 'assets/svgs/bottomNavbar/profileGrey.svg',
      'label': 'Profile',
      'route': '',
    },
  ];

  void _navigateTo(BuildContext context, int index) {
    String routeName = _navItems[index]['route'];
    if (ModalRoute.of(context)?.settings.name != routeName &&
        routeName.isNotEmpty) {
      // Use fadeReplacementNamed for other routes
      Navigator.pushReplacement(
        context,
        AppTransitions.fadeReplacementNamed(routeName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
        bottom: 34,
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isHome ? AppColors.greyColor50 : AppColors.background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_navItems.length, (index) {
          bool isSelected = currentSelected == index;
          return GestureDetector(
            onTap: () => _navigateTo(context, index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 4 : 0,
                vertical: isSelected ? 4 : 0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(0.4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isSelected
                        ? AppColors.primaryColor
                        : isHome
                            ? AppColors.greyColor100
                            : Colors.transparent,
                    radius: isSelected ? 16 : 20,
                    child: SvgPicture.asset(
                      _navItems[index]['icon'],
                      width: 20,
                      height: 20,
                      colorFilter: isSelected
                          ? const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    Text(
                      _navItems[index]['label'],
                      style: Styles.h8HeadingWithPrimary100,
                    ),
                    const SizedBox(width: 8),
                  ]
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
