import 'package:flutter/material.dart';
import 'package:inkingi/models/loan.dart';

class LoansProvider with ChangeNotifier {
  double creditScore = 68.0; // From mock data
  List<Loan> availableLoans = [
    Loan(
      title: 'Overdraft',
      description: 'Inguzanyo nziza yo kuzamura ubucuruzi',
      amount: 50000,
      apr: 12.5,
      duration: 'Umwaka',
      isEligible: false,
    ),
    Loan(
      title: 'Stock Loan',
      description: 'Inguzanyo nziza yo kuzamura stock ya Business',
      amount: 100000,
      apr: 15.0,
      duration: 'imyaka 3',
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
