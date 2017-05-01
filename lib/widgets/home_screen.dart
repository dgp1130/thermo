import "../models/screen.dart";
import "package:flutter/material.dart";
import "schedule_screen.dart";
import "temp_screen.dart";

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({ final Key key, this.title }) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _innerScreenIndex = 0;

  @override
  Widget build(final BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Center(child: new Text(widget.title))),
      body: _buildBody(Screen.screens[_innerScreenIndex]),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _innerScreenIndex,
        items: Screen.screens.map((screen) => new BottomNavigationBarItem(
          title: new Text(screen.title),
          icon: new Icon(screen.icon),
        )).toList(),
        onTap: (index) => setState(() => _innerScreenIndex = index),
      ),
    );
  }
}

Widget _buildBody(final Screen screen) {
  if (screen == Screen.temperature) return new TempScreen();
  else if (screen == Screen.schedule) return new ScheduleScreen();
  else throw new ArgumentError("Unknown screen: " + screen.toString());
}