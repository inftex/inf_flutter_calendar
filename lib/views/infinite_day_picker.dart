import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfiniteDayPicker extends StatefulWidget {
  final double? height;
  final DateTime selectedDate;
  final String? locale;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final ValueChanged<DateTime> onDateSelected;

  const InfiniteDayPicker({
    super.key,
    this.height,
    required this.selectedDate,
    this.locale,
    this.backgroundColor,
    this.selectedBackgroundColor,
    required this.onDateSelected,
  });

  @override
  State<InfiniteDayPicker> createState() => _InfiniteDayPickerState();
}

class _InfiniteDayPickerState extends State<InfiniteDayPicker> {
  static const int _initialPage = 10000;

  late final PageController _pageController;

  DateTime get _today => DateTime.now();

  late final DateTime _anchorWeek;

  @override
  void initState() {
    super.initState();

    _anchorWeek = _startOfWeek(widget.selectedDate);

    _pageController = PageController(
      viewportFraction: 1,
      initialPage: _initialPage,
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  DateTime _weekForPage(int page) {
    final diff = page - _initialPage;
    // FIX:
    // Use stable anchor instead of widget.selectedDate
    return _anchorWeek.add(Duration(days: diff * 7));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 96,
      child: PageView.builder(
        controller: _pageController,
        padEnds: true,
        itemBuilder: (context, page) {
          final weekStart = _weekForPage(page);

          return Row(
            children: List.generate(7, (index) {
              final date = weekStart.add(Duration(days: index));

              final isSelected = _isSameDay(date, widget.selectedDate);

              final isToday = _isSameDay(date, _today);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onDateSelected(date);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (widget.selectedBackgroundColor ??
                              Colors.lightGreen)
                          : (widget.backgroundColor ?? Colors.transparent),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E(widget.locale).format(date),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          style: TextStyle(
                            fontSize: isSelected ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          child: Text('${date.day}'),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isToday
                                ? (isSelected
                                    ? Colors.white
                                    : Colors.lightGreen)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
