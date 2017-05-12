import "package:Thermo/models/event.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/utils/event.dart" as events_util;
import "package:Thermo/protos/event.pbenum.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

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
          new Text(TempUnit.fahrenheit.format(event.temp.degFahrenheit.round()),
            style: new TextStyle(fontSize: _tempFontSize),
          ),
        ],
      ),
    );
  }

  // Extract the timespan from the given event
  // Returns string of format: "09:00 AM - 12:00 PM"
  String _getTimeSpan(final Event event) {
    return "${event.startTime} - ${event.endTime}";
  }
}