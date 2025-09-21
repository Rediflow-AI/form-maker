enum WorkingHoursLayout {
  /// Days as rows, hours as columns (default)
  daysAsRows,

  /// Hours as rows, days as columns
  hoursAsRows,
}

class WorkingHoursUtils {
  static const List<String> dayAbbreviations = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const List<String> fullDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static int timeStringToHour(String timeString) {
    try {
      return int.parse(timeString.split(':')[0]);
    } catch (e) {
      return 9; // Default to 9 AM
    }
  }

  static String hourToTimeString(int hour) {
    return '${hour.toString().padLeft(2, '0')}:00';
  }

  static bool isBusinessHour(int hour) {
    return hour >= 9 && hour <= 17;
  }

  static int calculateSelectedHours(Map<String, Set<int>> selectedSlots) {
    int total = 0;
    for (var slots in selectedSlots.values) {
      total += slots.length;
    }
    return total;
  }
}
