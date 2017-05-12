import "package:Thermo/protos/time_of_day.pb.dart" as pb;
import "package:flutter/material.dart" as material;

class TimeOfDay extends material.TimeOfDay {
  TimeOfDay({ final int hour, final int minute })
      : super(hour: hour, minute: minute);

  TimeOfDay.fromMaterial(final material.TimeOfDay time)
      : super(hour: time.hour, minute: time.minute);

  TimeOfDay.fromPb(final pb.TimeOfDay time)
      : super(hour: time.hour, minute: time.minute);

  pb.TimeOfDay toPb() {
    return new pb.TimeOfDay()
      ..hour = hour
      ..minute = minute
    ;
  }

  @override
  String toString() {
    return "$hourOfPeriodLabel:$minuteLabel"
        " ${period == material.DayPeriod.am ? "AM" : "PM"}";
  }
}