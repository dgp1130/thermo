import "../../protos/out/event.pb.dart";
import "../utils/event.dart" as events_util;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

typedef void _OnTapped(Event event);

class ScheduleListItem extends StatelessWidget {
  static const num _detailsFontSize = 24.0;
  static const num _tempFontSize = 42.0;

  final Event event;
  final _OnTapped onTapped;

  ScheduleListItem({
    final Key key,
    @required this.event,
    this.onTapped: null
  }) : super(key: key);

  void _onTap() {
    onTapped?.call(event);
  }

  @override
  Widget build(final BuildContext context) {
    return new GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: new Flex(
        key: new Key("schedule_item_flex"),
        direction: Axis.horizontal,
        children: <Widget>[
          new Expanded(
            child: new Column(
              children: <Widget>[
                new RichText(
                  text: new TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: Event_DayOfWeek.values.map((day) => new TextSpan(
                      text: events_util.getAbbreviation(day),
                      style: new TextStyle(
                        color: event.days.contains(day) ? Colors.black : Colors.grey,
                        fontWeight: event.days.contains(day) ? FontWeight.bold : FontWeight.normal,
                        fontSize: _detailsFontSize,
                      ),
                    )).toList(),
                  )
                ),
                new Text(_getTimeSpan(event),
                  style: new TextStyle(fontSize: _detailsFontSize),
                ),
              ],
            ),
          ),
          new Text(event.temp.toString() + "°F",
            style: new TextStyle(fontSize: _tempFontSize),
          ),
        ],
      ),
    );
  }

  // Extract the timespan from the given event
  // Returns string of format: "09:00 AM - 12:00 PM"
  String _getTimeSpan(final Event event) {
    final DateTime start = new DateTime.fromMillisecondsSinceEpoch(event.startTime.toInt());
    final DateTime end = new DateTime.fromMillisecondsSinceEpoch(event.endTime.toInt());
    final NumberFormat formatter = new NumberFormat("00");

    final int startHour = _getPrintableHour(start.hour);
    final int endHour = _getPrintableHour(end.hour);

    final String startPeriod = start.hour < 12 ? "AM" : "PM";
    final String endPeriod = end.hour < 12 ? "AM" : "PM";

    return "${formatter.format(startHour)}:${formatter.format(start.minute)} $startPeriod"
        " - ${formatter.format(endHour)}:${formatter.format(end.minute)} $endPeriod";
  }

  // Converts the hour index (0 - 23) to the printable value (12 (AM) - 12 (PM))
  int _getPrintableHour(final int hour) {
    if (hour == 0) return 12; // 12 PM
    else if (hour > 12) return hour - 12; // PM hours
    else return hour; // AM hours
  }
}