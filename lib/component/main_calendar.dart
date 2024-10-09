import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final availableHeight = constraints.maxHeight;
      final rowHeight = ((availableHeight - 70) / 6).floor().toDouble();
      print("rowHeight: ${rowHeight}");

      return TableCalendar(
        locale: 'ko_kr',
        onDaySelected: onDaySelected,
        selectedDayPredicate: (date) =>
            date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day,
        firstDay: DateTime(1800, 1, 1),
        lastDay: DateTime(3000, 1, 1),
        focusedDay: DateTime.now(),
        daysOfWeekHeight: 20,
        rowHeight: rowHeight,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
          headerMargin: EdgeInsets.only(bottom: 0),
          headerPadding: EdgeInsets.symmetric(vertical: 8),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: EdgeInsets.all(0),
          cellPadding: EdgeInsets.all(0),
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.red,
          ),
          defaultDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: LIGHT_GREY_COLOR,
          ),
          weekendDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: LIGHT_GREY_COLOR,
          ),
          selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: PRIMARY_COLOR,
              width: 1.0,
            ),
          ),
          defaultTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: DARK_GREY_COLOR,
          ),
          weekendTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: DARK_GREY_COLOR,
          ),
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: PRIMARY_COLOR,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(
              day,
              LIGHT_GREY_COLOR,
              DARK_GREY_COLOR,
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(
              day,
              Colors.white,
              PRIMARY_COLOR,
              borderColor: PRIMARY_COLOR,
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(day, Colors.red, Colors.white);
          },
        ),
      );
    });
  }
}

Widget _buildCalendarCell(DateTime day, Color backgroundColor, Color textColor,
    {Color? borderColor}) {
  return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  'Schedule',
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              ),
            ),
          ),
        ],
      ));
}
