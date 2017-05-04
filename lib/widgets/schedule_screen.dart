import "../../protos/out/event.pb.dart";
import "../utils/event.dart" as eventsUtil;
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class ScheduleScreen extends StatelessWidget {
  final List<Event> events;

  ScheduleScreen(this.events);

  @override
  Widget build(final BuildContext context) {
    return new ListView(
      children: events.map((event) => new Container(
        padding: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: new Column(
          children: <Widget>[
            new Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                new Text(event.temp.toString() + "°F",
                  textAlign: TextAlign.right,
                  style: new TextStyle(fontSize: 46.0),
                ),
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new RichText(
                        text: new TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: Event_DayOfWeek.values.map((day) => new TextSpan(
                            text: eventsUtil.getAbbreviation(day),
                            style: new TextStyle(
                              color: event.days.contains(day) ? Colors.black : Colors.grey,
                              fontWeight: event.days.contains(day) ? FontWeight.bold : FontWeight.normal,
                              fontSize: 24.0,
                            ),
                          )).toList(),
                        )
                      ),
                      new Text(_getTimeSpan(event),
                        style: new TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            new Divider(height: 7.5, color: Theme.of(context).primaryColor),
          ],
        ),
      )).toList()
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