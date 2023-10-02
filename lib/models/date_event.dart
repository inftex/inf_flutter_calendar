class EventByDate {
  final DateTime dateTime;
  final List<Event> events;
  EventByDate({required this.dateTime, required this.events});
}

class Event {
  final String title;
  Event({
    required this.title,
  });
}
