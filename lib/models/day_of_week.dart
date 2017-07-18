/// Model representing a day of the week
class DayOfWeek {
  static const SUNDAY = const DayOfWeek.fromJson("Sunday");
  static const MONDAY = const DayOfWeek.fromJson("Monday");
  static const TUESDAY = const DayOfWeek.fromJson("Tuesday");
  static const WEDNESDAY = const DayOfWeek.fromJson("Wednesday");
  static const THURSDAY = const DayOfWeek.fromJson("Thursday");
  static const FRIDAY = const DayOfWeek.fromJson("Friday");
  static const SATURDAY = const DayOfWeek.fromJson("Saturday");

  static const values = const <DayOfWeek>[ SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY ];

  final String _day;

  const DayOfWeek.fromJson(final String day) : this._day = day;

  @override
  String toString() {
    return _day;
  }
}