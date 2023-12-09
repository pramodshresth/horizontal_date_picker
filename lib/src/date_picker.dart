import 'dart:async';

import 'package:flutter/material.dart';

class HorizontalDatePicker extends StatefulWidget {
  const HorizontalDatePicker({
    super.key,
    this.onDateTap,
    this.startDate,
    this.endDate,
    this.margin,
    this.padding,
    this.monthTextStyle,
    this.dayTextStyle,
    this.weekDayTextStyle,
    this.monthDayGap,
    this.dayWeekGap,
    this.borderRadius,
    this.selectedItemColor,
    this.unSelectedItemColor,
    this.controller,
  });

  final Function(DateTime?)? onDateTap;
  final DateTime? startDate;
  final DateTime? endDate;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final TextStyle? monthTextStyle;
  final TextStyle? dayTextStyle;
  final TextStyle? weekDayTextStyle;
  final double? monthDayGap;
  final BorderRadiusGeometry? borderRadius;
  final double? dayWeekGap;
  final Color? selectedItemColor;
  final Color? unSelectedItemColor;
  final ScrollController? controller;

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  DateTime? selectedDate;
  double scrollOffset = 0;
  Timer? timer;
  late DateTime startDate;

  late DateTime endDate;
  int dateDifference = 0;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate ?? DateTime.now();
    endDate = widget.endDate ?? startDate.add(const Duration(days: 30));
    getDateDifference();
    initialSelectedDay();
  }

  getDateDifference() {
    Duration difference = endDate.difference(startDate);
    setState(() {
      dateDifference = difference.inDays;
    });
  }

  initialSelectedDay() {
    Duration difference = DateTime.now().difference(startDate);
    if (difference.inDays >= 0) {
      selectedDate = DateTime.now();
    } else {
      selectedDate = startDate;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  onDateTap(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    if (widget.onDateTap != null) {
      widget.onDateTap!(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        controller: widget.controller,
        scrollDirection: Axis.horizontal,
        child: Row(
            children: List.generate(dateDifference, (index) {
          var initDay = startDate.add(Duration(days: index));
          return GestureDetector(
            onTap: () => onDateTap(initDay),
            child: Container(
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
              margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: selectedDate == null
                    ? Colors.deepPurple
                    : selectedDate!.day == initDay.day &&
                            selectedDate!.month == initDay.month &&
                            selectedDate!.year == initDay.year
                        ? widget.selectedItemColor ?? Colors.deepPurple
                        : widget.unSelectedItemColor ?? Colors.grey,
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(
                      10,
                    ),
              ),
              child: Column(
                children: [
                  Text(
                    getMonthAbbreviation(initDay.month),
                    style: widget.monthTextStyle ?? TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(
                    height: widget.monthDayGap,
                  ),
                  Text(
                    initDay.day.toString(),
                    style: widget.dayTextStyle ??
                        const TextStyle(
                            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: widget.dayWeekGap ?? 2,
                  ),
                  Text(
                    getDayAbbreviation(initDay.weekday),
                    style: widget.weekDayTextStyle ??
                        const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        })),
      ),
    );
  }
}

String getMonthAbbreviation(int monthIndex) {
  const List<String> monthAbbreviations = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // Check if the monthIndex is within a valid range
  if (monthIndex >= 1 && monthIndex <= 12) {
    return monthAbbreviations[monthIndex - 1];
  } else {
    // Return an empty string or handle the error as needed
    return '';
  }
}

String getDayAbbreviation(int dayIndex) {
  const List<String> dayAbbreviations = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Check if the dayIndex is within a valid range
  if (dayIndex >= 1 && dayIndex <= 7) {
    return dayAbbreviations[dayIndex - 1];
  } else {
    // Return an empty string or handle the error as needed
    return '';
  }
}
