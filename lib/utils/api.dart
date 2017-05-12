import "dart:async";
import "package:Thermo/models/event.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";
import "package:Thermo/protos/event.pbenum.dart";

Future<List<Event>> fetchEvents() async {
  await new Future.delayed(new Duration(seconds: 5));

  return (const <int>[ 1, 2, 3, 4, 5 ]).map((val) => (new EventBuilder()
    ..temp = new Temp.fromFahrenheit(70 + val)
    ..startTime = new TimeOfDay(hour: 12 + val, minute: 20 + val)
    ..endTime = new TimeOfDay(hour: 13 + val, minute: 40 + val)
    ..days.addAll(const <Event_DayOfWeek>[
      Event_DayOfWeek.Monday,
      Event_DayOfWeek.Tuesday,
      Event_DayOfWeek.Wednesday,
      Event_DayOfWeek.Thursday,
      Event_DayOfWeek.Friday,
    ])
  ).build()).toList();
}