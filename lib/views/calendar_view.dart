import 'package:flutter/material.dart';
import 'package:inf_flutter_calendar/inf_flutter_calendar.dart';

class CalendarView extends StatefulWidget {
  final DateTime? initialMonth;
  final List<CalendarEvent> calendarEvents;
  final TextStyle? headerStyle;
  final TextStyle? dateStyle;
  final TextStyle? eventStyle;
  final TextStyle? monthChangeStyle;
  final Color? emptyDateBackgroundColor;
  final Color? headerBackgroundColor;
  final Color? dateBackgroundColor;
  final Color? todayBackgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Border? tabletBorder;
  final Widget Function(DateTime? date)? dateBuilder;
  final Function(DateTime month)? onMonthChanged;
  final Function(CalendarDate? calendarDate)? onDateClick;

  const CalendarView(
      {super.key,
      this.initialMonth,
      required this.calendarEvents,
      this.headerStyle,
      this.dateStyle,
      this.eventStyle,
      this.monthChangeStyle,
      this.emptyDateBackgroundColor,
      this.headerBackgroundColor,
      this.dateBackgroundColor,
      this.todayBackgroundColor,
      this.borderRadius,
      this.tabletBorder,
      this.dateBuilder,
      this.onMonthChanged,
      required this.onDateClick});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime get _now => CalendarUtils.now;

  ///
  /// Use to calculate next, prev months
  ///
  late DateTime _currentDateAnchor;

  List<CalendarDate?> get _datesOfMonth =>
      CalendarUtils.createCalendarMonthDates(
          _currentDateAnchor, widget.calendarEvents);

  Border get _tableBorder =>
      widget.tabletBorder ??
      Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 0.5);

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    // anchor date
    _currentDateAnchor =
        widget.initialMonth ?? DateTime(_now.year, _now.month, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
              border: _tableBorder, borderRadius: widget.borderRadius),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: Column(
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
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: _datesOfMonth.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final date = _datesOfMonth[index];
                      return buildDay(date);
                    })
              ],
            ),
          ),
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
            widget.onMonthChanged?.call(_currentDateAnchor);
          },
          highlightColor: null,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_back_ios,
              size: 24,
            ),
          ),
        ),
        Text('${_currentDateAnchor.month}/${_currentDateAnchor.year}',
            style: widget.monthChangeStyle ??
                const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
        InkWell(
          onTap: () {
            _currentDateAnchor = DateTime(_currentDateAnchor.year,
                _currentDateAnchor.month + 1, _currentDateAnchor.day);
            setState(() {});
            widget.onMonthChanged?.call(_currentDateAnchor);
          },
          highlightColor: null,
          splashColor: null,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDay(CalendarDate? calendarDate) {
    return InkWell(
      onTap: () {
        widget.onDateClick?.call(calendarDate);
      },
      child: Container(
        decoration: BoxDecoration(
            color: (calendarDate == null)
                ? (widget.emptyDateBackgroundColor ??
                    Colors.grey.withValues(alpha: 0.2))
                : (CalendarUtils.isSameDate(calendarDate.dateTime, _now))
                    ? (widget.todayBackgroundColor ??
                        Colors.green.withValues(alpha: 0.3))
                    : (widget.dateBackgroundColor ?? Colors.white),
            border: _tableBorder),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              (calendarDate?.dateTime.day ?? '').toString(),
              style: widget.dateStyle ??
                  const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Expanded(
                child: widget.dateBuilder != null
                    ? widget.dateBuilder!(calendarDate?.dateTime)
                    : ListView(
                        padding: const EdgeInsets.all(2),
                        children: List.generate(
                            calendarDate?.events.length ?? 0, (i) {
                          final event = calendarDate?.events[i];
                          return Text('${event?.title}',
                              style: widget.eventStyle ??
                                  const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500));
                        }),
                      )),
          ],
        ),
      ),
    );
  }

  Widget buildWeekday(String weekdayName) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: widget.headerBackgroundColor ??
              Colors.grey.withValues(alpha: 0.4),
          border: _tableBorder),
      child: Text(
        weekdayName,
        style: widget.headerStyle ??
            const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }
}
