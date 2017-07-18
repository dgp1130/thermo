import "package:flutter/material.dart" as material;

class TimeOfDay extends material.TimeOfDay {
  TimeOfDay({ final int hour, final int minute })
      : super(hour: hour, minute: minute);

  TimeOfDay.fromMaterial(final material.TimeOfDay time)
      : super(hour: time.hour, minute: time.minute);

  TimeOfDay.fromJson(final Map<String, int> json)
      : super(hour: json["hour"], minute: json["minute"]);

  Map<String, int> toJson() {
    return <String, int>{
      "hour": hour,
      "minute": minute,
    };
  }

  @override
  String toString() {
    return "$hourOfPeriodLabel:$minuteLabel"
        " ${period == material.DayPeriod.am ? "AM" : "PM"}";
  }
}