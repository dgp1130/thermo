import "dart:async";
import "package:flutter/material.dart";

/// Show an alert box with the given message and an OK button to dismiss
abstract class AlertMessageDialog extends State<StatefulWidget> {
  Future alertMessage(final String msg, [ final String buttonText = "OK" ]) async {
    await showDialog(
      context: context,
      child: new AlertDialog(
        content: new Text(msg),
        actions: <Widget>[
          new FlatButton(
            child: new Text(buttonText,
              style: new TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}