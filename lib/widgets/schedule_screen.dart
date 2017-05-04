import "../../protos/out/event.pb.dart";
import "package:flutter/material.dart";
import "schedule_list_view.dart";

class ScheduleScreen extends StatelessWidget {
  final List<Event> events;

  ScheduleScreen(this.events);

  @override
  Widget build(final BuildContext context) {
    return new ScheduleListView(
      events: events,
      onTapped: (event) => print("Tapped Event: ${event.temp}"),
    );
  }
}