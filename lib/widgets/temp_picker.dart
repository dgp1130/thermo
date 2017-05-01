import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/proxy_box.dart';

class TempPicker extends StatefulWidget {
  final num minValue;
  final num maxValue;
  final num tickValue;
  final num defaultValue;
  final Color color;
  final int borderSize;

  TempPicker({
    @required this.minValue,
    @required this.maxValue,
    @required this.tickValue,
    this.defaultValue,
    this.color = Colors.black,
    this.borderSize = 3,
  });

  @override
  _TempPickerState createState() => new _TempPickerState();
}

class _TempPickerState extends State<TempPicker> {
  @override
  Widget build(final BuildContext context) {
    return new Container(
      constraints: new BoxConstraints.expand(),
      child: new CustomPaint(
        painter: new _TempPainter(
          minValue: widget.minValue,
          maxValue: widget.maxValue,
          tickValue: widget.tickValue,
          defaultValue: widget.defaultValue,
          color: widget.color,
          borderSize: widget.borderSize,
        ),
      ),
    );
  }
}

class _TempPainter extends CustomPainter {
  static const num _startAngle = -(4 / 3) * PI;
  static const num _endAngle = (1 / 3) * PI;
  static const int _tickLength = 30;
  static const num _tickThickness = 3.0;

  static get _rangeAngle => _endAngle - _startAngle;

  final num minValue;
  final num maxValue;
  final num tickValue;
  final num defaultValue;
  final Color color;
  final int borderSize;

  num get _rangeValue => maxValue - minValue;
  num get _tickAngle => (tickValue / _rangeValue) * _rangeAngle;

  _TempPainter({
    @required this.minValue,
    @required this.maxValue,
    @required this.tickValue,
    @required this.defaultValue,
    @required this.color,
    @required this.borderSize,
  });

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = new Paint()
      ..color = color
    ;

    // Compute the center from the size provided
    final center = size.center(new Offset(0.0, 0.0));

    // Compute the radius by taking half of either the widget or height, whichever is smallest
    final radius = size.width < size.height ? size.width / 2 : size.height / 2;

    // Draw border by filling in a circle, subtracting the border, and filling in another
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius - borderSize, new Paint()..color = Colors.white);

    // Draw center point
    canvas.drawCircle(center, 10.0, new Paint()..color = Colors.red);

    // Iterate over each tick by angle
    for (num angle = _startAngle; angle <= _endAngle; angle += _tickAngle) {
      // Create a vector pointing from the center to the tick
      final Offset vector = _offsetFromAngle(angle);

      // Compute the tick's starting position by multiplying its magnitude by the components of the angle vector
      final tickStartMagnitude = radius - _tickLength;
      final tickStart = center + new Offset(
        tickStartMagnitude * vector.dx,
        tickStartMagnitude * vector.dy
      );

      // Compute the tick's ending position by multiplying its magnitude by the components of the angle vector
      final tickEndMagnitude = radius;
      final tickEnd = center + new Offset(
        tickEndMagnitude * vector.dx,
        tickEndMagnitude * vector.dy
      );

      // Get perpendicular vectors of the tick vector
      final Offset rotated = _rotateOffset(vector, PI / 2); // Rotate 90 degrees
      final Offset inverted = _invertOffset(rotated); // Invert after rotation

      // Create a polygon by extending the perpendicular vectors slightly away from the tick points
      canvas.drawPath(new Path()..addPolygon([
        tickStart + (rotated * _tickThickness),
        tickStart + (inverted * _tickThickness),
        tickEnd + (inverted * _tickThickness),
        tickEnd + (rotated * _tickThickness)
      ], true), paint);
    }
  }

  @override
  bool shouldRepaint(final CustomPainter oldDelegate) {
    return false; // Can't change yet
  }
}

// Create an offset from the given angle
Offset _offsetFromAngle(final num angle) {
  return new Offset(cos(angle), sin(angle));
}

// Create a new offset by rotating the given offset by the given angle
Offset _rotateOffset(final Offset offset, final num angle) {
  return new Offset(
    (offset.dx * cos(angle)) - (offset.dy * sin(angle)),
    ((offset.dx * sin(angle)) + (offset.dy * cos(angle)))
  );
}

// Create a new offset by taking the inversion of the given offset
Offset _invertOffset(final Offset offset) {
  return new Offset(-offset.dx, -offset.dy);
}