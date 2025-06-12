# inf_flutter_calendar

```
CalendarView(
// borderRadius: BorderRadius.circular(16),
// dateBackgroundColor: Colors.lightBlue,
// todayBackgroundColor: Colors.greenAccent,
// headerBackgroundColor: Colors.yellow,
// dateStyle: const TextStyle(color: Colors.red),
// headerStyle: const TextStyle(
//     color: Colors.blue, fontWeight: FontWeight.bold),
// monthChangeStyle: const TextStyle(
//     color: Colors.blue, fontWeight: FontWeight.bold),
// eventStyle: const TextStyle(color: Colors.black),
// dateBuilder: (date) {
//   if (date?.day == DateTime.now().day) {
//     return const Text('Today event');
//   }
//   return Container();
// },
onDateClick: (calendarDate) {},
calendarEvents: [
CalendarEvent(
    dateTime: CalendarUtils.now, title: 'Now Event1'),
CalendarEvent(
    dateTime: CalendarUtils.now, title: 'Now Event2'),
CalendarEvent(
    dateTime:
        CalendarUtils.now.add(const Duration(days: 2)),
    title: 'event3'),
CalendarEvent(
    dateTime:
        CalendarUtils.now.add(const Duration(days: 2)),
    title: 'event4'),
CalendarEvent(
    dateTime:
        CalendarUtils.now.add(const Duration(days: 5)),
    title: 'event5'),
CalendarEvent(
    dateTime:
        CalendarUtils.now.add(const Duration(days: 5)),
    title: 'Nguyen Van A')
],
)
```
