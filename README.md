# inf_flutter_calendar

A new Flutter project.

## Getting Started

```
CalendarView(
    onDateClick: (calendarDate) {},
    calendarEvents: [
        CalendarEvent(
            dateTime: CalendarUtils.now, title: 'now event1'),
        CalendarEvent(
            dateTime: CalendarUtils.now, title: 'now event2'),
        CalendarEvent(
            dateTime: CalendarUtils.now.add(const Duration(days: 2)),
            title: 'event3'),
        CalendarEvent(
            dateTime: CalendarUtils.now.add(const Duration(days: 2)),
            title: 'event4'),
        CalendarEvent(
            dateTime: CalendarUtils.now.add(const Duration(days: 5)),
            title: 'event5')
    ],
)
```
