import 'package:flutter/material.dart';

import 'calendar_date_view.dart';
import 'calendar_week_view.dart';

class CalendarWeekPage extends StatefulWidget {
  @override
  _CalendarWeekPageState createState() => _CalendarWeekPageState();
}

class _CalendarWeekPageState extends State<CalendarWeekPage> {
  int year = 2021;
  int month = 5;
  int date = 1;
  int dayCount = 300; // from to today
  int currentDayIndex = 1;
  List<DateTime> recordDays = [];
  DateTime from;

  PageController _pageController = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DateTime today = DateTime.now();
      from = DateTime.now().subtract(Duration(days: dayCount - 1));
      for (int i = 0; i < dayCount; i++) {
        recordDays.add(from.add(Duration(days: i)));
      }
      selectDate(today.year, today.month, today.day);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2021/5'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CalendarWeekView(year, month, date,
              onDateSelected: (year, month, date) {
            selectDate(year, month, date);
          }),
          Expanded(
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                setState(() {
                  DateTime newDay = from.add(Duration(days: currentDayIndex));
                  selectDate(newDay.year, newDay.month, newDay.day,
                      needScrollToDate: false);
                });
                return true;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: recordDays.length,
                physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
                itemBuilder: (context, index) {
                  DateTime time = recordDays[index];
                  String timeLabel = '${time.year}/${time.month}/${time.day}';
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(timeLabel,
                            style: TextStyle(fontSize: 20, wordSpacing: 2)),
                        SizedBox(height: 20),
                        CalendarDateView()
                      ],
                    ),
                  );
                },
                onPageChanged: (index) {
                  currentDayIndex = index;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void selectDate(int year, int month, int date,
      {bool needScrollToDate = true}) {
    setState(() {
      this.year = year;
      this.month = month;
      this.date = date;
    });
    if (needScrollToDate) {
      scrollToDate(year, month, date);
    }
  }

  void scrollToDate(int year, int month, int date) {
    DateTime selectedDay = DateTime(year, month, date);
    int index = getPageIndexByTime(selectedDay);
    if (index < recordDays.length) {
      _pageController.animateToPage(index,
          curve: Curves.easeInOut, duration: Duration(milliseconds: 250));
    } else {
      print("out of bound");
    }
  }

  int getPageIndexByTime(DateTime selectedDay) {
    Duration diffDays = selectedDay.difference(from);
    int index = diffDays.inDays + 1;
    return index;
  }
}
