import 'package:inf_flutter_calendar/inf_flutter_calendar.dart';

class CalendarUtils {
  CalendarUtils._();

  static DateTime get now => DateTime.now();

  ///
  /// if start of month is not Monday, add null
  ///
  static List<CalendarDate?> createCalendarMonthDates(
      DateTime anchorMonth, List<CalendarEvent> events) {
    final dates = <CalendarDate?>[];
    int dayOfMonth = getNumDayOfMonth(anchorMonth.month, anchorMonth.year);

    // Fill head
    int weekDay = DateTime(anchorMonth.year, anchorMonth.month, 1).weekday;
    for (int i = 1; i < weekDay; i++) {
      dates.add(null);
    }

    late DateTime date;
    for (int i = 1; i <= dayOfMonth; i++) {
      date = DateTime(anchorMonth.year, anchorMonth.month, i);
      dates.add(CalendarDate(
        dateTime: date,
        events: events.where((e) => isSameDate(e.dateTime, date)).toList(),
      ));
    }

    // Fill tail
    int weekDayTail =
        DateTime(anchorMonth.year, anchorMonth.month, dayOfMonth).weekday;
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

  static bool isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
