import "dart:async";
import "package:flutter/material.dart";
import "package:Thermo/models/temp.dart";
import "package:Thermo/utils/api.dart" as api;
import "package:Thermo/widgets/temp_picker.dart";

class TempScreen extends StatefulWidget {
  @override
  State<TempScreen> createState() => new _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  Temp temperature;

  @override
  void initState() {
    super.initState();

    api.fetchDesiredTemp().then((temp) => temperature = temp)
      .catchError((err) => print("Failed to get temperature:\n$err"))
    ;
  }

  @override
  Widget build(final BuildContext context) {
    // Show loading icon while waiting for temperature to load
    if (temperature == null) {
      return new Center(
        child: new CircularProgressIndicator()
      );
    }

    // Render temperature picker
    Timer timer;
    return new TempPicker(
      minValue: const Temp.fromFahrenheit(32.0),
      maxValue: const Temp.fromFahrenheit(100.0),
      defaultValue: temperature,
      onTempChanged: (temp) {
        timer?.cancel();
        timer = new Timer(new Duration(seconds: 1), () => _setThermoTemp(temp));
      },
    );
  }

  // Set the thermostat temperature on the server
  void _setThermoTemp(final Temp temp) {
    print("Setting to ${temp.toString(TempUnit.celsius)}.");
    api.postDesiredTemp(temp).catchError((err) {
      print("Failed to set temperature:\n$err");
    });
  }
}