import "dart:async";
import "package:Thermo/models/day_of_week.dart";
import "package:Thermo/models/event.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/models/time_of_day.dart";
import "package:Thermo/utils/event.dart" as event_util;
import "package:Thermo/widgets/dialogs/alert_message_dialog.dart";
import "package:Thermo/widgets/dialogs/temp_picker_dialog.dart";
import "package:flutter/material.dart" hide TimeOfDay;

class AddScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddScheduleState();
}

class _AddScheduleState extends State<AddScheduleScreen> with TempPickerDialog,
    AlertMessageDialog {
  final Set<DayOfWeek> _days = new Set<DayOfWeek>();
  TimeOfDay _startTime = new TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _endTime = new TimeOfDay(hour: 12, minute: 0);
  Temp _temp = const Temp.fromFahrenheit(72.0);

  // When the user completes the flow, create an Event and return it
  void _onAdd(final BuildContext context) {
    // Validate time
    if (_endTime.hour < _startTime.hour
        || (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
      alertMessage("Start time must come before end time.");
      return;
    }

    // Return an Event containing all the entered information
    Navigator.of(context).pop(new Event(temp: _temp, startTime: _startTime,
        endTime: _endTime, days: _days));
  }

  @override
  Widget build(final BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Add Schedule"),
        centerTitle: true,
      ),
      body: new Container(
        padding: const EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            // List of days of the week
            new Row(
              children: DayOfWeek.values.map((day) => new Expanded(
                child: new Column(
                  children: <Widget>[
                    new Text(event_util.getAbbreviation(day)),
                    new Checkbox(
                      value: _days.contains(day),
                      onChanged: (checked) => setState(() {
                        if (checked) _days.add(day);
                        else _days.remove(day);
                      }),
                    ),
                  ],
                ),
              )).toList(),
            ),

            // Start time picker
            new Row(
              children: <Widget>[
                const Expanded(
                  child: const Text("Start time:"),
                ),
                new MaterialButton(
                  padding: const EdgeInsets.all(0.0),
                  textColor: Theme.of(context).primaryColor,
                  child: new Text(_startTime.toString(),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () => showTimePicker(
                    context: context,
                    initialTime: _startTime,
                  ).then((time) => setState(() {
                    _startTime = time != null ? new TimeOfDay.fromMaterial(time) : _startTime;
                  })),
                ),
              ],
            ),

            // End time picker
            new Row(
              children: <Widget>[
                const Expanded(
                  child: const Text("End time:"),
                ),
                new MaterialButton(
                  padding: const EdgeInsets.all(0.0),
                  textColor: Theme.of(context).primaryColor,
                  child: new Text(_endTime.toString(),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () => showTimePicker(
                    context: context,
                    initialTime: _endTime,
                  ).then((time) => setState(() {
                    _endTime = time != null ? new TimeOfDay.fromMaterial(time) : _endTime;
                  })),
                ),
              ],
            ),

            // Temperature picker
            new Row(
              children: <Widget>[
                const Expanded(
                  child: const Text("Temperature:"),
                ),
                new MaterialButton(
                  padding: const EdgeInsets.all(0.0),
                  textColor: Theme.of(context).primaryColor,
                  child: new Text(TempUnit.fahrenheit.format(_temp.degFahrenheit.round()),
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () => showTempPicker(
                    context: context,
                    minValue: const Temp.fromFahrenheit(32.0),
                    maxValue: const Temp.fromFahrenheit(100.0),
                    defaultValue: _temp,
                  ).then((temp) => setState(() => _temp = temp ?? _temp)),
                ),
              ],
            ),

            // Add button
            new Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: new MaterialButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: const Text("Add"),
                onPressed: () => _onAdd(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}