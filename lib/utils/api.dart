import '../../protos/out/event.pb.dart';
import 'dart:async';
import 'package:fixnum/fixnum.dart';

Future<List<Event>> fetchEvents() async {
  await new Future.delayed(new Duration(seconds: 5));

  return <int>[ 1, 2, 3, 4, 5 ].map((val) => new Event()
    ..temp = 70 + val
    ..startTime = new Int64(new DateTime.now().millisecondsSinceEpoch)
    ..endTime = new Int64(new DateTime.now().add(new Duration(minutes: val)).millisecondsSinceEpoch)
    ..days.addAll(<Event_DayOfWeek>[
      Event_DayOfWeek.Monday,
      Event_DayOfWeek.Tuesday,
      Event_DayOfWeek.Wednesday,
      Event_DayOfWeek.Thursday,
      Event_DayOfWeek.Friday,
    ])
  ).toList();
}