import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";
import "package:Thermo/protos/event.pb.dart" as pb;
import "package:meta/meta.dart";

/// Model representing an Event which specifies the temperature for a given
/// time frame repeated over several days a week.
class Event {
  final Set<pb.Event_DayOfWeek> days;
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
  Event.fromPb(final pb.Event event)
      : this.days = event.days.toSet(),
        this.startTime = new TimeOfDay.fromPb(event.startTime),
        this.endTime = new TimeOfDay.fromPb(event.endTime),
        this.temp = new Temp.fromPb(event.temp)
  ;

  /// Construct a protobuf from this Event
  @override
  pb.Event toPb() {
    return new pb.Event()
      ..days.addAll(days.toList())
      ..startTime = startTime.toPb()
      ..endTime = endTime.toPb()
      ..temp = temp.toPb()
    ;
  }
}

/// Builder class for the Event model
class EventBuilder {
  Set<pb.Event_DayOfWeek> _days = new Set<pb.Event_DayOfWeek>();
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  Temp _temp;

  Set<pb.Event_DayOfWeek> get days => _days;

  set startTime(final TimeOfDay time) => _startTime = time;

  set endTime(final TimeOfDay time) => _endTime = time;

  set temp(final Temp temp) => _temp = temp;

  Event build() {
    return new Event(days: _days, startTime: _startTime, endTime: _endTime,
        temp: _temp);
  }
}