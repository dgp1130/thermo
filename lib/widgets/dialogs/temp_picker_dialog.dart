import "dart:async";
import "package:Thermo/models/temp.dart";
import "package:Thermo/widgets/temp_picker.dart";
import "package:flutter/material.dart";
import "package:meta/meta.dart";

/// Mixin to show a dialog holding a TempPicker.
abstract class TempPickerDialog extends State<StatefulWidget> {
  Future<Temp> showTempPicker({
    @required final BuildContext context,
    @required final Temp minValue,
    @required final Temp maxValue,
    @required final Temp defaultValue,
  }) async {
    Temp temperature;

    return await showDialog(
      context: context,
      child: new AlertDialog(
        content: new SizedBox(
          height: 250.0,
          child: new TempPicker(
            minValue: minValue,
            maxValue: maxValue,
            defaultValue: defaultValue,
            onTempChanged: (temp) => temperature = temp,
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("CANCEL",
              style: new TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => Navigator.pop(context, null),
          ),
          new FlatButton(
            child: new Text("OK",
              style: new TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => Navigator.pop(context, temperature),
          ),
        ],
      ),
    );
  }
}
