import 'package:flutter/material.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import 'transaction_form.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'Bika Igikorwa',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: TransactionForm(),
        ),
      ),
    );
  }
}
