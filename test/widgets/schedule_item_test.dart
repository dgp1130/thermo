import "../../lib/widgets/schedule_list_item.dart";
import "../../protos/out/event.pb.dart";
import "package:fixnum/fixnum.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("ScheduleItem", (final WidgetTester tester) async {
    final Event event = new Event()
      ..temp = 72
      ..startTime = new Int64(new DateTime.now().millisecondsSinceEpoch)
      ..endTime = new Int64((new DateTime.now().add(new Duration(minutes: 5))).millisecondsSinceEpoch)
      ..days.addAll(<Event_DayOfWeek>[
        Event_DayOfWeek.Monday,
        Event_DayOfWeek.Tuesday,
        Event_DayOfWeek.Wednesday,
        Event_DayOfWeek.Thursday,
        Event_DayOfWeek.Friday,
      ])
    ;
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