import 'dart:ui';

import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  final year;
  final month;
  double width;
  double height;

  CalendarView({@required this.year, @required this.month});

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.utc(year, month, 1);
    int weekdayOfFirstDate = date.weekday % 7; // covert to sun(0) ~ sat(6)
    int daysOfMonth = DateTime(year, month + 1, 0).day;
    int lastWeek = (weekdayOfFirstDate + daysOfMonth - 1) ~/ 7;

    var heightWidthRatio = 1.2;
    var labelHeight = 40.0;

    width = MediaQuery.of(context).size.width;
    height = width / 7 * heightWidthRatio * (lastWeek + 1) + labelHeight;

    return CustomPaint(
      size: Size(width, height),
      painter: CalendarPainter(
          year: year,
          month: month,
          heightWidthRatio: heightWidthRatio,
          labelHeight: labelHeight),
    );
  }
}

class CalendarPainter extends CustomPainter {
  var _paint = Paint();

  var heightWidthRatio = 1.2;
  var labelHeight = 40.0;

  final weekdayNames = ["S", "M", "T", "W", "T", "F", "S"];
  final monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  final year;
  final month;

  DateTime today;

  CalendarPainter(
      {@required this.year,
      @required this.month,
      this.heightWidthRatio,
      this.labelHeight});

  @override
  void paint(Canvas canvas, Size size) {
    var xGridWidth = size.width / 7;
    var yGridWidth = xGridWidth * heightWidthRatio;
    var xOffset = xGridWidth / 2;
    var yOffset = yGridWidth / 2;

    today = new DateTime.now();

    var date = DateTime.utc(year, month, 1);
    int dayOfFirstDate = date.weekday % 7;
    int daysOfMonth = DateTime(year, month + 1, 0).day;
    drawLabelBackground(canvas, size.width, labelHeight, Colors.blue);
    drawText(canvas, "${monthNames[month - 1]}", size.width / 2,
        labelHeight / 2, Colors.white);

    for (var date = 1; date <= daysOfMonth; date++) {
      int day = (dayOfFirstDate + date - 1) % 7; // x
      int week = (dayOfFirstDate + date - 1) ~/ 7; // y

      if (day == 0 || day == 6) {
        // weekend
        drawWeekend(
            canvas, xGridWidth, yGridWidth, xOffset, yOffset, date, day, week);
      } else {
        drawDay(
            canvas, xGridWidth, yGridWidth, xOffset, yOffset, date, day, week);
      }
    }
  }

  void drawLabelBackground(
      Canvas canvas, double width, double height, Color color) {
    _paint.color = color;
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _paint);
  }

  void drawDay(Canvas canvas, double xGridWidth, double yGridWidth,
      double xOffset, double yOffset, int date, int day, int week) {
    drawDayOfWeek(canvas, xGridWidth, yGridWidth, xOffset, yOffset, date, day,
        week, Color(0xFFE3ECF3), Colors.black);
  }

  void drawWeekend(Canvas canvas, double xGridWidth, double yGridWidth,
      double xOffset, double yOffset, int date, int day, int week) {
    drawDayOfWeek(canvas, xGridWidth, yGridWidth, xOffset, yOffset, date, day,
        week, Color(0xFFF0F0F0), Colors.grey);
  }

  void drawDayOfWeek(
      Canvas canvas,
      double xGridWidth,
      double yGridWidth,
      double xOffset,
      double yOffset,
      int date,
      int day,
      int week,
      Color backgroundColor,
      Color textColor) {
    var x = xOffset + day * xGridWidth;
    var y = yOffset + week * yGridWidth + labelHeight;

    // background
    int padding = 3;
    int roundRadius = 10; // 10
    drawGridRoundRectBackground(canvas, xGridWidth, yGridWidth, x, y, padding,
        roundRadius, backgroundColor, false);

    // value
    drawDayValue(
        canvas, date, x, y, xGridWidth, yGridWidth, textColor, backgroundColor);

    // today
    if (today.year == year && today.month == month && today.day == date) {
      drawText(canvas, "Today", x, y + yGridWidth / 4, Colors.blue,
          fontSize: 15);
    }
  }

  void drawGridRoundRectBackground(
      Canvas canvas,
      double width,
      double height,
      double centerX,
      double centerY,
      int padding,
      int roundRadius,
      Color color,
      bool border) {
    _paint.color = color;
    _paint.style = PaintingStyle.fill;

    double left = centerX - width / 2 + padding;
    double top = centerY - height / 2 + padding;
    double right = centerX + width / 2 - padding;
    double bottom = centerY + height / 2 - padding;
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(left, top, right, bottom), _paint);
    if (border) {
      _paint.color = Color(0xFF888888);
      _paint.strokeWidth = 1;
      _paint.style = PaintingStyle.stroke;
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(left - 1, top - 1, right + 1, bottom + 1),
          _paint);
    }
  }

  void drawDayValue(
      Canvas canvas,
      int date,
      double x,
      double y,
      double xGridWidth,
      double yGridWidth,
      Color textColor,
      Color backgroundColor) {
    drawText(canvas, "$date", x, y - yGridWidth / 4, textColor);
  }

  void drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    Color textColor, {
    double fontSize,
  }) {
    final textSpan = TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: fontSize ?? 20));

    final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl);

    textPainter.layout();

    textPainter.paint(
        canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
