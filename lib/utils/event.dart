import '../../protos/out/event.pb.dart';

const Map<Event_DayOfWeek, String> _dayAbbrMap = const <Event_DayOfWeek, String>{
  Event_DayOfWeek.Sunday: "U",
  Event_DayOfWeek.Monday: "M",
  Event_DayOfWeek.Tuesday: "T",
  Event_DayOfWeek.Wednesday: "W",
  Event_DayOfWeek.Thursday: "R",
  Event_DayOfWeek.Friday: "F",
  Event_DayOfWeek.Saturday: "S",
};

String getAbbreviation(final Event_DayOfWeek day) {
  return _dayAbbrMap[day];
}