class CategorizationService {
  static String categorizeTransaction(String description, bool isIncome) {
    description = description.toLowerCase();

    if (isIncome) {
      if (description.contains('sold') || description.contains('sales')) {
        return 'Sales';
      }
      return 'Income';
    } else {
      if (description.contains('bought') || description.contains('inventory')) {
        return 'Inventory';
      } else if (description.contains('electricity') ||
          description.contains('utilities')) {
        return 'Utilities';
      } else if (description.contains('rent')) {
        return 'Rent';
      }
      return 'Expense';
    }
  }
}
