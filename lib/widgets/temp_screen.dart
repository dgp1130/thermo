import "package:flutter/material.dart";
import "temp_picker.dart";

class TempScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return new TempPicker(
      minValue: 32.0,
      maxValue: 100.0,
      defaultValue: 72.0,
      onTempChanged: (temp) => print(temp),
    );
  }
}