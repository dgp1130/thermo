import "package:Thermo/models/day_of_week.dart";

const Map<DayOfWeek, String> _dayAbbrMap = const <DayOfWeek, String>{
  DayOfWeek.SUNDAY: "U",
  DayOfWeek.MONDAY: "M",
  DayOfWeek.TUESDAY: "T",
  DayOfWeek.WEDNESDAY: "W",
  DayOfWeek.THURSDAY: "R",
  DayOfWeek.FRIDAY: "F",
  DayOfWeek.SATURDAY: "S",
};

String getAbbreviation(final DayOfWeek day) {
  return _dayAbbrMap[day];
}