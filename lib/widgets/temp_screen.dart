import "package:Thermo/models/temp.dart";
import "package:flutter/material.dart";
import "temp_picker.dart";

class TempScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return new TempPicker(
      minValue: const Temp.fromFahrenheit(32.0),
      maxValue: const Temp.fromFahrenheit(100.0),
      defaultValue: const Temp.fromFahrenheit(72.0),
      onTempChanged: (temp) => print(temp.toString(TempUnit.fahrenheit)),
    );
  }
}