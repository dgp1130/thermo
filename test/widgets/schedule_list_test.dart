import "package:Thermo/models/day_of_week.dart";
import "package:Thermo/models/event.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";
import "package:Thermo/widgets/schedule_list_view.dart";
import "package:flutter/material.dart" hide TimeOfDay;
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("ScheduleItem", (final WidgetTester tester) async {
    final List<Event> events = new Iterable.generate(5, (index) => (new EventBuilder()
      ..temp = new Temp.fromFahrenheit(70 + index)
      ..startTime = new TimeOfDay(hour: 12 + index, minute: 0)
      ..endTime = new TimeOfDay(hour: 13 + index, minute: 0)
      ..days.addAll(<DayOfWeek>[
        DayOfWeek.MONDAY,
        DayOfWeek.TUESDAY,
        DayOfWeek.WEDNESDAY,
        DayOfWeek.THURSDAY,
        DayOfWeek.FRIDAY,
      ])
    ).build()).toList();
    Event tappedEvent;

    await tester.pumpWidget(new StatefulBuilder(
        builder: (context, setState) => new ScheduleListView(
          events: events,
          onTapped: (event) => tappedEvent = event,
        )
    ));

    expect(tappedEvent, equals(null));
    await tester.tap(find.byKey(new Key("schedule_list_item:70")));
    expect(tappedEvent, equals(events[0]));
  });
}