import 'package:flutter/material.dart';
import 'package:inkingi/models/loan.dart';

class LoansProvider with ChangeNotifier {
  double creditScore = 68.0; // From mock data
  List<Loan> availableLoans = [
    Loan(
      title: 'Small Business Starter',
      description:
          'Perfect for small inventory purchases or minor business expenses.',
      amount: 50000,
      apr: 12.5,
      duration: '3 months',
      isEligible: false,
    ),
    Loan(
      title: 'Business Growth',
      description: 'Ideal for expanding your business operations.',
      amount: 100000,
      apr: 15.0,
      duration: '6 months',
      isEligible: false,
    ),
  ];

  void checkEligibility() {
    // Simulate loan eligibility based on credit score
    for (var loan in availableLoans) {
      loan.isEligible = creditScore >= 70;
    }
    notifyListeners();
  }
}
