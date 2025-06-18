import 'package:flutter/material.dart';
import 'package:inkingi/screens/category/add_category_screen.dart';
import 'package:inkingi/screens/transaction/add_transaction_screen.dart';
import 'package:inkingi/screens/authentication/login_screen.dart';
import 'package:inkingi/screens/authentication/register_screen.dart';
import 'package:inkingi/screens/authentication/verify_otp_screen.dart';
import 'package:inkingi/screens/core/dashboard_screen.dart';
import 'package:inkingi/screens/core/loans_screen.dart';
import 'package:inkingi/screens/product/add_product_screen.dart';
import 'package:inkingi/screens/general/profile_screen.dart';
import 'package:inkingi/screens/core/reports_screen.dart';
import 'package:inkingi/screens/general/SplashScreen.dart';
import 'package:inkingi/screens/transaction/transaction_message_reader.dart';
import 'package:inkingi/screens/transaction/transactions_screen.dart';

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
  static String get product => AddProductScreen.routeName;
  static String get category => AddCategoryScreen.routeName;
  static String get messageReader => MessageReaderScreen.routeName;

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
      case AddProductScreen.routeName:
        return MaterialPageRoute(builder: (_) => AddProductScreen());
      case AddCategoryScreen.routeName:
        return MaterialPageRoute(builder: (_) => AddCategoryScreen());
      case MessageReaderScreen.routeName:
        return MaterialPageRoute(builder: (_) => MessageReaderScreen());
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
      case AddProductScreen.routeName:
        return AddProductScreen();
      case AddCategoryScreen.routeName:
        return AddCategoryScreen();
      case MessageReaderScreen.routeName:
        return MessageReaderScreen();
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
