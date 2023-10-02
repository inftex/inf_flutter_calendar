import 'package:flutter/material.dart';
import 'package:inf_flutter_calendar/inf_flutter_calendar.dart';

class CalendarView extends StatefulWidget {
  final List<EventByDate> eventByDateList;

  const CalendarView({
    super.key,
    required this.eventByDateList,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final DateTime _now = DateTime.now();

  ///
  /// Use to calculate next, prev months
  ///
  late DateTime _currentDateAnchor;

  List<DateTime?> get _datesOfMonth =>
      CalendarUtils.createCalendarMonnthDates(_currentDateAnchor);

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    // anchor date
    _currentDateAnchor = DateTime(_now.year, _now.month, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header
        Row(
          children: [
            Expanded(child: buildWeekday('T2')),
            Expanded(child: buildWeekday('T3')),
            Expanded(child: buildWeekday('T4')),
            Expanded(child: buildWeekday('T5')),
            Expanded(child: buildWeekday('T6')),
            Expanded(child: buildWeekday('T7')),
            Expanded(child: buildWeekday('CN'))
          ],
        ),

        // calendar
        Flexible(
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: _datesOfMonth.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                final date = _datesOfMonth[index];
                return buildDay(date);
              }),
        ),

        // nex prev month
        const SizedBox(height: 16),
        buildNextPrevMonth()
      ],
    );
  }

  Widget buildNextPrevMonth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _currentDateAnchor = DateTime(_currentDateAnchor.year,
                _currentDateAnchor.month - 1, _currentDateAnchor.day);
            setState(() {});
          },
          highlightColor: null,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
            ),
          ),
        ),
        Text('${_currentDateAnchor.month}/${_currentDateAnchor.year}',
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500)),
        InkWell(
          onTap: () {
            _currentDateAnchor = DateTime(_currentDateAnchor.year,
                _currentDateAnchor.month + 1, _currentDateAnchor.day);
            setState(() {});
          },
          highlightColor: null,
          splashColor: null,
          child: Container(
            padding: EdgeInsets.all(4.0),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDay(DateTime? dateTime) {
    return Container(
      decoration: BoxDecoration(
          color: (dateTime == null)
              ? Colors.grey.withOpacity(0.2)
              : (dateTime.year == _now.year &&
                      dateTime.day == _now.day &&
                      dateTime.month == _now.month)
                  ? Colors.green.withOpacity(0.3)
                  : null,
          border: Border.all(color: Colors.grey.withOpacity(0.7), width: 0.5)),
      child: Text(
        (dateTime?.day ?? '').toString(),
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget buildWeekday(String weekdayName) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.4),
          border: Border.all(color: Colors.grey.withOpacity(0.7), width: 0.5)),
      child: Text(
        weekdayName,
        style: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }
}
