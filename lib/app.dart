import 'package:flutter/material.dart';
import 'package:inkingi/screens/add_transaction.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/loans_screen.dart';

class InkingiApp extends StatelessWidget {
  const InkingiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Inkingi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/dashboard',
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/transactions': (context) => const TransactionsScreen(),
          '/add_transaction': (context) => const AddTransactionScreen(),
          '/reports': (context) => const ReportsScreen(),
          '/loans': (context) => const LoansScreen(),
        },
      ),
    );
  }
}
