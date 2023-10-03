import 'package:inf_flutter_calendar/inf_flutter_calendar.dart';

class CalendarDate {
  final DateTime dateTime;
  final List<CalendarEvent> events;

  CalendarDate({required this.dateTime, required this.events});
}
