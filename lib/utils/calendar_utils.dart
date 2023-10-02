class CalendarUtils {
  CalendarUtils._();

  static DateTime get now => DateTime.now();

  ///
  /// if start of month is not Monday, add null
  ///
  static List<DateTime?> createCalendarMonnthDates(DateTime dateTime) {
    final dates = <DateTime?>[];
    int dayOfMonth = getNumDayOfMonth(dateTime.month, dateTime.year);

    // Fill head
    int weekDay = DateTime(dateTime.year, dateTime.month, 1).weekday;
    for (int i = 1; i < weekDay; i++) {
      dates.add(null);
    }

    for (int i = 1; i <= dayOfMonth; i++) {
      dates.add(DateTime(dateTime.year, dateTime.month, i));
    }

    // Fill tail
    int weekDayTail =
        DateTime(dateTime.year, dateTime.month, dayOfMonth).weekday;
    for (int i = weekDayTail; i < 7; i++) {
      dates.add(null);
    }

    return dates;
  }

  static int getNumDayOfMonth(int month, int year) {
    List<int> dayOfMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (isLeapYear(year)) {
      dayOfMonth[1] = 29;
    }
    return dayOfMonth[month - 1];
  }

  static bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}
