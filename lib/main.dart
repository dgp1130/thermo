import "package:flutter/material.dart";
import "widgets/home_screen.dart";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Thermo",
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new HomeScreen(title: "Thermo"),
    );
  }
}
