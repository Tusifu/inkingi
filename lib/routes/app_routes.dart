import 'package:flutter/material.dart';
import 'package:inkingi/screens/add_transaction.dart';
import 'package:inkingi/screens/authentication/login_screen.dart';
import 'package:inkingi/screens/authentication/register_screen.dart';
import 'package:inkingi/screens/authentication/verify_otp_screen.dart';
import 'package:inkingi/screens/dashboard_screen.dart';
import 'package:inkingi/screens/loans_screen.dart';
import 'package:inkingi/screens/profile_screen.dart';
import 'package:inkingi/screens/reports_screen.dart';
import 'package:inkingi/screens/SplashScreen.dart';
import 'package:inkingi/screens/transactions_screen.dart';

class AppRoutes {
  // Getter methods for each route using the page's routeName
  static String get dashboard => DashboardScreen.routeName;
  static String get transactions => TransactionsScreen.routeName;
  static String get addTransaction => AddTransactionScreen.routeName;
  static String get reports => ReportsScreen.routeName;
  static String get loans => LoansScreen.routeName;
  static String get splash => SplashScreen.routeName;
  static String get register => RegisterScreen.routeName;
  static String get login => LoginScreen.routeName;
  static String get verifyOtp => VerifyOtpScreen.routeName;
  static String get profile => ProfileScreen.routeName;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DashboardScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case TransactionsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const TransactionsScreen());
      case AddTransactionScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AddTransactionScreen());
      case ReportsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case LoansScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoansScreen());
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case VerifyOtpScreen.routeName:
        return MaterialPageRoute(builder: (_) => const VerifyOtpScreen());
      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return _errorRoute();
    }
  }

  static Widget getPageFromRouteName(String routeName) {
    switch (routeName) {
      case DashboardScreen.routeName:
        return const DashboardScreen();
      case TransactionsScreen.routeName:
        return const TransactionsScreen();
      case AddTransactionScreen.routeName:
        return const AddTransactionScreen();
      case ReportsScreen.routeName:
        return const ReportsScreen();
      case LoansScreen.routeName:
        return const LoansScreen();
      case SplashScreen.routeName:
        return const SplashScreen();
      case LoginScreen.routeName:
        return const LoginScreen();
      case RegisterScreen.routeName:
        return const RegisterScreen();
      case VerifyOtpScreen.routeName:
        return const VerifyOtpScreen();
      case ProfileScreen.routeName:
        return const ProfileScreen();
      default:
        return const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        );
    }
  }

  static MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined'),
        ),
      ),
    );
  }
}
