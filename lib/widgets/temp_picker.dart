import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    defaultValue,
    this.color = Colors.black,
    this.borderSize = 3,
  }) : this.defaultValue = defaultValue ?? ((maxValue - minValue) / 2) + minValue;

  @override
  _TempPickerState createState() => new _TempPickerState();
}

class _TempPickerState extends State<TempPicker> {
  num _temp;
  Offset _tapPos;
  final GlobalKey _paintKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    _temp = widget.defaultValue;
  }

  @override
  Widget build(final BuildContext context) {
    final Color color = Theme.of(context).primaryColor;

    return new Container(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox box = _paintKey.currentContext.findRenderObject();
            _tapPos = box.globalToLocal(details.globalPosition);
          });
        },
        child: new CustomPaint(
          key: _paintKey,
          painter: new _TempPainter(
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            tickValue: widget.tickValue,
            defaultValue: widget.defaultValue,
            tapPosition: _tapPos,
            color: color,
            borderSize: widget.borderSize,
          ),
          child: new Center(
            child: new Text("$_temp°F",
              style: new TextStyle(
                fontSize: 68.0,
                color: color
              ),
            ),
          ),
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
  final Offset tapPosition;
  final Color color;
  final int borderSize;

  num get _rangeValue => maxValue - minValue;
  num get _tickAngle => (tickValue / _rangeValue) * _rangeAngle;

  _TempPainter({
    @required this.minValue,
    @required this.maxValue,
    @required this.tickValue,
    @required this.defaultValue,
    @required this.tapPosition,
    @required this.color,
    @required this.borderSize,
  });

  // Take the given position and center and compute the angle (in radius)
  // from the center to the position
  num getAngleFromPosition(final Offset pos, final Offset center) {
    final Offset relPos = pos - center;
    final num distance = relPos.distance;
    final Offset normalized = new Offset(relPos.dx / distance, relPos.dy / distance);
    final num angle = atan2(normalized.dy, normalized.dx);
    return angle;
  }

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = new Paint()
      ..color = color
    ;

    // Compute the center from the size provided
    final center = size.center(Offset.zero);

    // Compute the radius by taking half of either the widget or height, whichever is smallest
    final radius = size.shortestSide / 2;

    // Draw border by filling in a circle, subtracting the border, and filling in another
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius - borderSize, new Paint()..color = Colors.white);

    // Iterate over each tick by angle
    for (num angle = _startAngle; angle <= _endAngle; angle += _tickAngle) {
      _drawTickFromAngle(canvas, center, angle, radius - _tickLength, radius, paint);
    }

    // Draw current value tick
    final angle = tapPosition == null ? defaultValue : getAngleFromPosition(tapPosition, center);
    _drawTickFromAngle(canvas, center, angle, radius - (3 * _tickLength), radius, paint);
  }

  void _drawTickFromAngle(final Canvas canvas, final Offset center,
      final num angle, final num startRadius, final num endRadius,
      final Paint paint) {
    // Create a vector pointing from the center to the tick
    final Offset vector = _offsetFromAngle(angle);

    // Compute the tick's starting position by multiplying its magnitude by the components of the angle vector
    final tickStart = center + new Offset(
      startRadius * vector.dx,
      startRadius * vector.dy
    );

    // Compute the tick's ending position by multiplying its magnitude by the components of the angle vector
    final tickEnd = center + new Offset(
      endRadius * vector.dx,
      endRadius * vector.dy
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

  @override
  bool shouldRepaint(final _TempPainter oldPainter) {
    return minValue != oldPainter.minValue
      || maxValue != oldPainter.maxValue
      || tickValue != oldPainter.tickValue
      || defaultValue != oldPainter.defaultValue
      || tapPosition != oldPainter.tapPosition
      || color != oldPainter.color
      || borderSize != oldPainter.borderSize
    ;
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