import 'dart:ui';

import 'package:flutter/material.dart';

class CalendarDateView extends StatelessWidget {
  double hourSpace = 60;
  double topOffset = 10;

  List<CalendarDateEvent> event = [
    CalendarDateEvent(start: 300, end: 12800, label: 'Sport'),
    CalendarDateEvent(start: 15000, end: 25000, label: 'Running'),
    CalendarDateEvent(start: 30000, end: 40000, label: 'Coding'),
  ];

  @override
  Widget build(BuildContext context) {
    double height = topOffset + hourSpace * 24 + 20;
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, height),
      painter: CalendarDateViewPainter(
          topOffset: topOffset, hourSpace: hourSpace, events: event),
    );
  }
}

class CalendarDateEvent {
  int start;
  int end;
  String label;

  CalendarDateEvent(
      {@required this.start, @required this.end, @required this.label});
}

class CalendarDateViewPainter extends CustomPainter {
  double hourSpace = 50;
  double lineWidth = 1.2;
  double topOffset = 10;
  double startOffset = 10;
  Color color = Colors.blue;
  static const int DAY_IN_SECONDS = (3600 * 24);
  static const int HOUR_IN_SECONDS = (3600);

  Paint _paint = Paint();

  List<CalendarDateEvent> events;

  CalendarDateViewPainter({this.hourSpace, this.topOffset, this.events});

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = lineWidth;

    drawIndicator(canvas, '00:00', color, width, topOffset);
    for (int i = 1; i <= 24; i++) {
      String timeLabel = i < 10 ? '0$i:00' : '$i:00';
      drawIndicator(canvas, timeLabel, color, width, topOffset + i * hourSpace);
    }
    drawEvents(canvas, width);
  }

  void drawEvents(Canvas canvas, double width) {
    _paint.style = PaintingStyle.fill;

    events?.forEach((event) {
      drawEvent(canvas, event,
          offset: startOffset + 50, width: width, radius: 4);
    });
  }

  void drawEvent(Canvas canvas, CalendarDateEvent event,
      {@required double offset,
      @required double width,
      @required double radius}) {
    double top =
        event.start.toDouble() * hourSpace / HOUR_IN_SECONDS + topOffset;

    double bottom =
        event.end.toDouble() * hourSpace / HOUR_IN_SECONDS + topOffset;

    int colorCode = Colors.blue.value;
    _paint.color = Color(colorCode & 0x7FFFFFFF);

    canvas.drawRRect(
        RRect.fromLTRBAndCorners(offset, top, width, bottom,
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius)),
        _paint);

    drawText(canvas, event.label, (offset + width) / 2, (top + bottom) / 2,
        Colors.white,
        fontSize: 15);

    _paint.color = Color(colorCode);
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(offset, top, offset + radius, bottom,
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius)),
        _paint);
  }

  void drawIndicator(
      Canvas canvas, String timeLabel, Color color, double width, double y) {
    drawText(canvas, timeLabel, 30, y, color);
    _paint.color = color;
    canvas.drawLine(Offset(startOffset + 45, y), Offset(width, y), _paint);
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
        style: TextStyle(color: textColor, fontSize: fontSize ?? 13));

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
    return false;
  }
}
