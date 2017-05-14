import "package:Thermo/models/event.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "schedule_list_item.dart";

typedef void _OnTapped(Event event);

class ScheduleListView extends StatelessWidget {
  final List<Event> events;
  final _OnTapped onTapped;

  ScheduleListView({
    @required this.events,
    this.onTapped,
  });

  void _onTap(final Event event) {
    onTapped?.call(event);
  }

  @override
  Widget build(final BuildContext context) {
    return new ListView(
      children: events.map((event) => new Container(
        padding: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: new Column(
          children: <Widget>[
            new ScheduleListItem(
              key: new Key("schedule_list_item:${event.temp.degFahrenheit.round()}"),
              event: event,
              onTapped: _onTap,
            ),
            new Divider(height: 7.5, color: Theme.of(context).primaryColor),
          ],
        ),
      )).toList()
    );
  }
}