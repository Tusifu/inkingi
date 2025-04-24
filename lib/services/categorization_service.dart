// lib/services/categorization_service.dart
import 'package:inkingi/constants/transaction_keywords.dart';

class CategorizationService {
  // Main method to categorize a transaction
  static Map<String, dynamic> categorizeTransaction(
      String description, bool isIncome) {
    description = description.toLowerCase();

    // Step 1: Determine if it's income or expense based on description
    bool determinedIsIncome = _determineIncomeOrExpense(description, isIncome);

    // Step 2: Assign a specific category based on the determined type
    String category = _assignSpecificCategory(description, determinedIsIncome);

    return {
      'isIncome': determinedIsIncome,
      'category': category,
    };
  }

  // Helper method to determine if the transaction is income or expense
  static bool _determineIncomeOrExpense(String description, bool isIncome) {
    bool hasIncomeKeyword = TransactionKeywords.englishIncomeKeywords
            .any((keyword) => description.contains(keyword)) ||
        TransactionKeywords.kinyarwandaIncomeKeywords
            .any((keyword) => description.contains(keyword));

    bool hasExpenseKeyword = TransactionKeywords.englishExpenseKeywords
            .any((keyword) => description.contains(keyword)) ||
        TransactionKeywords.kinyarwandaExpenseKeywords
            .any((keyword) => description.contains(keyword));

    // If description contains income keywords, classify as income
    if (hasIncomeKeyword && !hasExpenseKeyword) {
      return true;
    }
    // If description contains expense keywords, classify as expense
    if (hasExpenseKeyword && !hasIncomeKeyword) {
      return false;
    }
    // If both or neither are present, use the provided isIncome value
    return isIncome;
  }

  // Helper method to assign a specific category
  static String _assignSpecificCategory(String description, bool isIncome) {
    if (isIncome) {
      // Income-specific categories
      if (description.contains('sold') ||
          description.contains('sales') ||
          description.contains('yaguze') ||
          description.contains('naranguje') ||
          description.contains('n\'aranguje') ||
          description.contains('yishyuye') ||
          description.contains('kugurisha') ||
          description.contains('kugurisha ibintu') ||
          description.contains('kugurisha ibicuruzwa') ||
          description.contains('kugurisha serivisi')) {
        return 'Sales';
      } else if (description.contains('umushahara') ||
          description.contains('umushahara yakiriye') ||
          description.contains('salary') ||
          description.contains('salary received') ||
          description.contains('wages') ||
          description.contains('wage received')) {
        return 'Salary';
      } else if (description.contains('kodesha yakiriye') ||
          description.contains('rent received') ||
          description.contains('kodesha yishyuye') ||
          description.contains('rent payment')) {
        return 'Rent Income';
      } else if (description.contains('umugabane') ||
          description.contains('umugabane yakiriye') ||
          description.contains('dividend') ||
          description.contains('dividends')) {
        return 'Dividend';
      } else if (description.contains('intere') ||
          description.contains('intere yakiriye') ||
          description.contains('interest') ||
          description.contains('interest earned')) {
        return 'Interest';
      } else if (description.contains('royalty') ||
          description.contains('royalty yakiriye') ||
          description.contains('royalty payment')) {
        return 'Royalty';
      } else if (description.contains('komisiyo') ||
          description.contains('komisiyo yakiriye') ||
          description.contains('commission') ||
          description.contains('commission earned')) {
        return 'Commission';
      } else if (description.contains('bonuse') ||
          description.contains('bonuse yakiriye') ||
          description.contains('bonus') ||
          description.contains('bonus received')) {
        return 'Bonus';
      }
      return 'Income'; // Default income category
    } else {
      // Expense-specific categories
      if (description.contains('bought') ||
          description.contains('purchased') ||
          description.contains('spent') ||
          description.contains('spend') ||
          description.contains('naguze') ||
          description.contains('n\'aguze') ||
          description.contains('kugura') ||
          description.contains('nishyuye') ||
          description.contains('ibicuruzwa') ||
          description.contains('nahashye') ||
          description.contains('naranguye') ||
          description.contains('n\'aranguye') ||
          description.contains('n\'ahashye') ||
          description.contains('ibicuruzwa') ||
          description.contains('stock') ||
          description.contains('ibintu')) {
        return 'Inventory';
      } else if (description.contains('electricity') ||
          description.contains('utilities') ||
          description.contains('amashanyarazi') ||
          description.contains('ibikoresho byo mu rugo') ||
          description.contains('amazi') ||
          description.contains('intarineti') ||
          description.contains('telefoni') ||
          description.contains('fature') ||
          description.contains('fature ya')) {
        return 'Utilities';
      } else if (description.contains('rent') ||
          description.contains('rental') ||
          description.contains('kukodesha') ||
          description.contains('kodesha') ||
          description.contains('kodesha yishyuye')) {
        return 'Rent';
      } else if (description.contains('umushahara yishyuye') ||
          description.contains('amafranga yishyurwa yishyuye') ||
          description.contains('salary paid') ||
          description.contains('wages paid') ||
          description.contains('payroll') ||
          description.contains('umukozi') ||
          description.contains('abakozi')) {
        return 'Payroll';
      } else if (description.contains('inguzanyo') ||
          description.contains('loan') ||
          description.contains('ubwongere') ||
          description.contains('interest paid')) {
        return 'Loan';
      } else if (description.contains('ubwishingizi') ||
          description.contains('insurance')) {
        return 'Insurance';
      } else if (description.contains('umutego') ||
          description.contains('tax')) {
        return 'Tax';
      } else if (description.contains('fine') ||
          description.contains('penalty')) {
        return 'Fine';
      } else if (description.contains('marketing') ||
          description.contains('kwamamaza') ||
          description.contains('advertising') ||
          description.contains('promotion') ||
          description.contains('campaign')) {
        return 'Marketing';
      } else if (description.contains('amasomo') ||
          description.contains('training') ||
          description.contains('education') ||
          description.contains('course') ||
          description.contains('workshop') ||
          description.contains('seminar') ||
          description.contains('conference')) {
        return 'Training';
      }
      return 'Expense'; // Default expense category
    }
  }
}
