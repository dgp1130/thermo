import "dart:convert";
import "package:Thermo/models/day_of_week.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";
import "package:meta/meta.dart";

/// Model representing an Event which specifies the temperature for a given
/// time frame repeated over several days a week.
class Event {
  final Set<DayOfWeek> days;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Temp temp;

  Event({
    @required final this.days,
    @required final this.startTime,
    @required final this.endTime,
    @required final this.temp,
  });

  /// Construct an Event from a protobuf format
  Event.fromJson(final Map<String, Object> json)
      : this.days = (json["days"] as Iterable<String>).map((day) => new DayOfWeek.fromJson(day)),
        this.startTime = new TimeOfDay.fromJson(json["startTime"] as Map<String, int>),
        this.endTime = new TimeOfDay.fromJson(json["endTime"] as Map<String, int>),
        this.temp = new Temp.fromJson(json["temp"] as num)
  ;

  /// Serialize this event to JSON
  @override
  Map<String, Object> toJson() {
    return {
      "days": days.map((day) => JSON.encode(day)),
      "startTime": startTime.toJson(),
      "endTime": endTime.toJson(),
      "temp": temp.toJson(),
    };
  }
}

/// Builder class for the Event model
class EventBuilder {
  Set<DayOfWeek> _days = new Set<DayOfWeek>();
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  Temp _temp;

  Set<DayOfWeek> get days => _days;

  set startTime(final TimeOfDay time) => _startTime = time;

  set endTime(final TimeOfDay time) => _endTime = time;

  set temp(final Temp temp) => _temp = temp;

  Event build() {
    return new Event(days: _days, startTime: _startTime, endTime: _endTime,
        temp: _temp);
  }
}