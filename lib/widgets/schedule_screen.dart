import "package:Thermo/models/event.dart";
import "package:Thermo/widgets/add_schedule_screen.dart";
import "package:flutter/material.dart";
import "schedule_list_view.dart";

class ScheduleScreen extends StatefulWidget {
  final List<Event> events;

  ScheduleScreen(this.events);

  @override
  State<ScheduleScreen> createState() => new _ScheduleState(events);
}

class _ScheduleState extends State<ScheduleScreen> {
  List<Event> _events;

  _ScheduleState(final List<Event> events) {
    _events = events;
  }

  @override
  Widget build(final BuildContext context) {
    return new Scaffold(
      body: new ScheduleListView(
        events: _events,
        onTapped: (event) => print("Tapped Event: ${event.temp}"),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Text("+",
          style: new TextStyle(fontSize: 32.0, color: Colors.white),
        ),
        onPressed: () async {
          // Send the user to create a new Event
          final Event newEvent = await Navigator.of(context).push(
            new MaterialPageRoute<Event>(
              builder: (final BuildContext context) => new AddScheduleScreen(),
            ),
          );

          // Verify that the user successfully created an Event
          if (newEvent == null) return;

          // Add the new Event to the list
          setState(() => _events.add(newEvent));
        },
      ),
    );
  }
}