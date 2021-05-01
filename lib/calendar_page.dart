import 'package:calendar_view/calendar_week_page.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'calendar_view.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  int currentMonthIndex = 0;
  int currentMonth = 1;
  int currentYear = 1983;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DateTime date = DateTime.now();
      setState(() {
        currentYear = date.year;
        currentMonthIndex = date.month;
        _itemScrollController.jumpTo(index: currentMonthIndex);
      });

      _itemPositionsListener.itemPositions.addListener(() {
        int index = _itemPositionsListener.itemPositions.value.first.index;
        if (currentMonthIndex != index) {
          setState(() {
            currentMonthIndex = index;
            currentMonth = months[currentMonthIndex - 1];
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2021/$currentMonth"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                weekdayLabel('S'),
                weekdayLabel('M'),
                weekdayLabel('T'),
                weekdayLabel('W'),
                weekdayLabel('T'),
                weekdayLabel('F'),
                weekdayLabel('S')
              ],
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: months.length,
                itemBuilder: (context, index) =>
                    CalendarView(year: currentYear, month: months[index]),
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
              ),
            ),
            FlatButton(
                child: Text("Today",
                    style: TextStyle(color: Colors.blue, fontSize: 18)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarWeekPage()));
                })
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget weekdayLabel(String weekday) {
    return Expanded(
        child: Container(
            height: 30, alignment: Alignment.center, child: Text(weekday)));
  }
}
