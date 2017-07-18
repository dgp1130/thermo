import "package:Thermo/models/day_of_week.dart";
import "package:Thermo/models/event.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";
import "package:Thermo/widgets/schedule_list_item.dart";
import "package:flutter/material.dart" hide TimeOfDay;
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("ScheduleItem", (final WidgetTester tester) async {
    final Event event = (new EventBuilder()
      ..temp = new Temp.fromFahrenheit(72.0)
      ..startTime = new TimeOfDay(hour: 12, minute: 0)
      ..endTime = new TimeOfDay(hour: 13, minute: 0)
      ..days.addAll(<DayOfWeek>[
        DayOfWeek.MONDAY,
        DayOfWeek.WEDNESDAY,
        DayOfWeek.FRIDAY,
      ])
    ).build();
    Event tappedEvent;

    await tester.pumpWidget(new StatefulBuilder(
      builder: (context, setState) => new ScheduleListItem(
        event: event,
        onTapped: (event) => tappedEvent = event,
      )
    ));

    expect(tappedEvent, equals(null));
    await tester.tap(find.byKey(new Key("schedule_item_flex")));
    expect(tappedEvent, equals(event));
  });
}