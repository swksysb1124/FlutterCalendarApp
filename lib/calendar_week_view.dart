import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CalendarWeekView extends StatelessWidget {
  int year = 1983;
  int month = 11;
  int date = 24;
  Function(int, int, int) onDateSelected;
  List<DateTime> days = [];
  int _selectedDayIndex = 1;

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime(year, month, date);
    _selectedDayIndex = (dateTime.weekday % 7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addWeekdayLabels(),
        Container(height: 1, color: Colors.blue), // line
        addDayTab()
      ],
    );
  }

  Widget addDayTab() {
    DateTime dateTime = DateTime(year, month, date);
    int dayOfWeek = dateTime.weekday % 7; // sun(0) ~ sat(6)
    List<Widget> dayTabs = [];
    for (int i = 0; i < 7; i++) {
      DateTime newDaytime = dateTime.add(Duration(days: (i - dayOfWeek)));
      days.add(newDaytime);
      dayTabs.add(
          dayTab(i, newDaytime.day.toString(), isWeekend: i == 0 || i == 6));
    }
    return Row(
      children: dayTabs,
    );
  }

  Widget addWeekdayLabels() {
    return Row(
      children: [
        weekdayLabel('S'),
        weekdayLabel('M'),
        weekdayLabel('T'),
        weekdayLabel('W'),
        weekdayLabel('T'),
        weekdayLabel('F'),
        weekdayLabel('S')
      ],
    );
  }

  Widget weekdayLabel(String weekday) {
    return Expanded(
        child: Container(
            height: 30, alignment: Alignment.center, child: Text(weekday)));
  }

  Widget dayTab(int index, String weekday, {bool isWeekend = false}) {
    Color textColor = Colors.blue;
    if (index == _selectedDayIndex) {
      textColor = Colors.white;
    } else if (isWeekend) {
      textColor = Colors.grey;
    }
    return Expanded(
        child: GestureDetector(
      onTap: () {
        DateTime dateTime = days[index];
        onDateSelected(dateTime.year, dateTime.month, dateTime.day);
      },
      child: Container(
        decoration: (index == _selectedDayIndex)
            ? BoxDecoration(color: Colors.blue, shape: BoxShape.circle)
            : null,
        height: 50,
        margin: EdgeInsets.only(left: 8, right: 8),
        alignment: Alignment.center,
        child: Text(
          weekday,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    ));
  }

  CalendarWeekView(this.year, this.month, this.date, {this.onDateSelected});
}
