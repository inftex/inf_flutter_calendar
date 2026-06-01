import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
List<DateTime> currentWeek() {
    final now = DateTime.now();
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }


return InfiniteWeekPicker(
      selectedWeek: selectedWeekDays.first,
      onWeekChanged: (days) {
        setState(() {
          selectedWeekDays = days;
        });
      },
    );
 */

class InfiniteWeekPicker extends StatefulWidget {
  final double? height;
  final DateTime selectedWeek;
  final String? locale;
  final ValueChanged<List<DateTime>> onWeekChanged;

  const InfiniteWeekPicker({
    super.key,
    this.height,
    required this.selectedWeek,
    required this.onWeekChanged,
    this.locale,
  });

  @override
  State<InfiniteWeekPicker> createState() => _InfiniteWeekPickerState();
}

class _InfiniteWeekPickerState extends State<InfiniteWeekPicker> {
  static const int _initialPage = 10000;

  late final PageController _pageController;
  late final DateTime _anchorWeek;

  @override
  void initState() {
    super.initState();

    _anchorWeek = _startOfWeek(widget.selectedWeek);

    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  DateTime _weekForPage(int page) {
    final diff = page - _initialPage;
    return _anchorWeek.add(Duration(days: diff * 7));
  }

  List<DateTime> _weekDays(DateTime weekStart) {
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekTitle(List<DateTime> days) {
    final first = days.first;
    final last = days.last;

    if (first.year != last.year) {
      return '${DateFormat.MMMd(widget.locale).format(first)}'
          ' - '
          '${DateFormat.MMMd(widget.locale).format(last)}, ${last.year}';
    }

    if (first.month != last.month) {
      return '${DateFormat.MMMd(widget.locale).format(first)}'
          ' - '
          '${DateFormat.MMMd(widget.locale).format(last)}';
    }

    return '${DateFormat.MMM(widget.locale).format(first)} '
        '${first.day} - ${last.day}';
  }

  void _previousWeek() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _nextWeek() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 96,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (page) {
          widget.onWeekChanged(_weekDays(_weekForPage(page)));
        },
        itemBuilder: (context, page) {
          final days = _weekDays(_weekForPage(page));

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _previousWeek,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.chevron_left_rounded, size: 32),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _weekTitle(days),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _nextWeek,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.chevron_right_rounded, size: 32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: days.map((date) {
                  final isToday = _isSameDay(date, DateTime.now());

                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat.E(
                            widget.locale,
                          ).format(date).substring(0, 1),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isToday ? Colors.green : Colors.transparent,
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isToday ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
