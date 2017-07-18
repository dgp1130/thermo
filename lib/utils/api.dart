import "dart:async";
import "dart:convert";
import "package:flutter/services.dart";
import "package:Thermo/models/day_of_week.dart";
import "package:Thermo/models/event.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";

const String _protocol = "http";
const String _thermoThing = "192.168.1.7";
const int _port = 8000;

class _HTTP {
  static const OK = 200;
}

// Get the full host URI for the ThermoThing server
String _getThermoThingHost() {
  return "$_protocol://$_thermoThing:$_port";
}

// Get the desired temperature from the ThermoThing server
Future<Temp> fetchDesiredTemp() async {
  final http = createHttpClient();
  final res = await http.get("${_getThermoThingHost()}/desired-temp");

  if (res.statusCode != _HTTP.OK) {
    throw new Exception("Received HTTP ${res.statusCode}.\n${res.body}");
  }

  return new Temp.fromCelsius(num.parse(res.body));
}

// Post the given temperature to the ThermoThing server as the desired temperature
Future postDesiredTemp(final Temp temp) async {
  final http = createHttpClient();
  final res = await http.post("${_getThermoThingHost()}/desired-temp", body: JSON.encode({
    "temp": temp.toJson()
  }));

  if (res.statusCode != _HTTP.OK) {
    throw new Exception("Received HTTP ${res.statusCode}.\n${res.body}");
  }
}

Future<List<Event>> fetchEvents() async {
  await new Future.delayed(new Duration(seconds: 5));

  return (const <int>[ 1, 2, 3, 4, 5 ]).map((val) => (new EventBuilder()
    ..temp = new Temp.fromFahrenheit(70 + val)
    ..startTime = new TimeOfDay(hour: 12 + val, minute: 20 + val)
    ..endTime = new TimeOfDay(hour: 13 + val, minute: 40 + val)
    ..days.addAll(const <DayOfWeek>[
      DayOfWeek.MONDAY,
      DayOfWeek.TUESDAY,
      DayOfWeek.WEDNESDAY,
      DayOfWeek.THURSDAY,
      DayOfWeek.FRIDAY,
    ])
  ).build()).toList();
}