import "package:Thermo/widgets/schedule_list_view.dart";
import "package:Thermo/protos/event.pb.dart";
import "package:fixnum/fixnum.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("ScheduleItem", (final WidgetTester tester) async {
    final List<Event> events = [ 1, 2, 3, 4, 5 ].map((index) => new Event()
      ..temp = 70 + index
      ..startTime = new Int64(new DateTime.now().millisecondsSinceEpoch)
      ..endTime = new Int64((new DateTime.now().add(new Duration(minutes: 5))).millisecondsSinceEpoch)
      ..days.addAll(<Event_DayOfWeek>[
        Event_DayOfWeek.Monday,
        Event_DayOfWeek.Tuesday,
        Event_DayOfWeek.Wednesday,
        Event_DayOfWeek.Thursday,
        Event_DayOfWeek.Friday,
      ])
    ).toList();
    Event tappedEvent;

    await tester.pumpWidget(new StatefulBuilder(
        builder: (context, setState) => new ScheduleListView(
          events: events,
          onTapped: (event) => tappedEvent = event,
        )
    ));

    expect(tappedEvent, equals(null));
    await tester.tap(find.byKey(new Key("schedule_list_item:71")));
    expect(tappedEvent, equals(events[0]));
  });
}