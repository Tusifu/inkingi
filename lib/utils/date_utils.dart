// lib/utils/date_utils.dart
abstract class DateUtilities {
  // Days of the week in Kinyarwanda (full and abbreviated)
  static const Map<int, String> _daysOfWeekFull = {
    0: 'Ku Cyumweru', // Sunday
    1: 'Kuwa Mbere', // Monday
    2: 'Kuwa Kabiri', // Tuesday
    3: 'Kuwa Gatatu', // Wednesday
    4: 'Kuwa Kane', // Thursday
    5: 'Kuwa Gatanu', // Friday
    6: 'Kuwa Gatandatu', // Saturday
  };

  static const Map<int, String> _daysOfWeekAbbrev = {
    0: 'Sun',
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thur',
    5: 'Fri',
    6: 'Sat',
  };

  // Months in Kinyarwanda (full and abbreviated)
  static const Map<int, String> _monthsFull = {
    1: 'Mutarama', // January
    2: 'Gashyantare', // February
    3: 'Werurwe', // March
    4: 'Mata', // April
    5: 'Gicurasi', // May
    6: 'Kamena', // June
    7: 'Nyakanga', // July
    8: 'Kanama', // August
    9: 'Nzeli', // September
    10: 'Ukwakira', // October
    11: 'Ugushyingo', // November
    12: 'Ukuboza', // December
  };

  static const Map<int, String> _monthsAbbrev = {
    1: 'Mutarama',
    2: 'Gashyantare',
    3: 'Werurwe',
    4: 'Mata',
    5: 'Gicurasi',
    6: 'Kamena',
    7: 'Nyakanga',
    8: 'Kanama',
    9: 'Nzeli',
    10: 'Ukwakira',
    11: 'Ugushyingo',
    12: 'Ukuboza',
  };

  // Translate "Week" and "Quarter"
  static String translateWeek(String period) {
    if (period.startsWith('Week')) {
      final weekNumber = period.split(' ')[1];
      return 'Icyumweru $weekNumber';
    }
    return period;
  }

  static String translateQuarter(String period) {
    if (period.startsWith('Q')) {
      final quarterNumber = period.substring(1);
      return 'Igice $quarterNumber';
    }
    return period;
  }

  // Translate a month name to Kinyarwanda
  static String translateMonth(String month, {bool abbreviated = false}) {
    const monthMap = {
      'January': 'Mutarama',
      'February': 'Gashyantare',
      'March': 'Werurwe',
      'April': 'Mata',
      'May': 'Gicurasi',
      'June': 'Kamena',
      'July': 'Nyakanga',
      'August': 'Kanama',
      'September': 'Nzeli',
      'October': 'Ukwakira',
      'November': 'Ugushyingo',
      'December': 'Ukuboza',
    };
    return monthMap[month] ?? month;
  }

  // Main method to format a date in Kinyarwanda
  static String formatDateToKinyarwanda(
    DateTime date, {
    bool includeDayOfWeek = true,
    bool abbreviatedDay = false,
    bool abbreviatedMonth = false,
    String format =
        'dayName, day month year', // Default format: "Kuwa Mbere, 1 Mata 2025"
  }) {
    final day = date.day;
    final month = abbreviatedMonth
        ? _monthsAbbrev[date.month]!
        : _monthsFull[date.month]!;
    final year = date.year;
    final dayOfWeek = abbreviatedDay
        ? _daysOfWeekAbbrev[date.weekday % 7]!
        : _daysOfWeekFull[date.weekday % 7]!;

    // Parse the format string
    switch (format) {
      case 'dayName, day month year':
        return includeDayOfWeek
            ? '$dayOfWeek, $day $month $year'
            : '$day $month $year';
      case 'day month year':
        return '$day $month $year';
      case 'month year':
        return '$month $year';
      case 'dayName':
        return dayOfWeek;
      default:
        // Custom format handling (e.g., "day/month/year")
        return format
            .replaceAll('dayName', includeDayOfWeek ? dayOfWeek : '')
            .replaceAll('day', day.toString())
            .replaceAll('month', month)
            .replaceAll('year', year.toString())
            .trim();
    }
  }

  // Helper method to format a list of days (e.g., for charts)
  static List<String> getDaysOfWeek({bool abbreviated = true}) {
    return abbreviated
        ? _daysOfWeekAbbrev.values.toList()
        : _daysOfWeekFull.values.toList();
  }
}
