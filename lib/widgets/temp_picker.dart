import "dart:async";
import "dart:math";
import 'package:Thermo/models/temp.dart';
import "package:Thermo/widgets/multi_painter.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

typedef void OnTempChanged(Temp temp);

/// Widget to render a temperature picker which looks like a thermostat.
class TempPicker extends StatefulWidget {
  final Temp minValue;
  final Temp maxValue;
  final Temp defaultValue;
  final int borderSize;
  final Color color;
  final Color bgColor;
  final OnTempChanged onTempChanged;

  num get rangeValue => maxValue.degCelsius - minValue.degCelsius;

  TempPicker({
    @required this.minValue,
    @required this.maxValue,
    defaultValue,
    this.borderSize = 3,
    this.color,
    this.bgColor : Colors.white,
    this.onTempChanged,
  }) : this.defaultValue = defaultValue
      ?? new Temp.fromCelsius(((maxValue.degCelsius - minValue.degCelsius) / 2) + minValue.degCelsius)
  {
    if (minValue > maxValue) {
      throw new ArgumentError("minValue ($minValue) must be smaller than"
          " maxValue ($maxValue).");
    }

    if (this.defaultValue < minValue || this.defaultValue > maxValue) {
      throw new ArgumentError("defaultValue ($defaultValue) must be greater than"
          " minValue ($minValue) and smaller than maxValue ($maxValue).");
    }
  }

  @override
  _TempPickerState createState() => new _TempPickerState();
}

/// State maintained for the Temperature picker widget
class _TempPickerState extends State<TempPicker> {
  static const num _startAngle = -(4 / 3) * PI;
  static const num _endAngle = (1 / 3) * PI;
  static const num _numTicks = 10;
  static const num _tickLength = 30.0;
  static const num _tickThickness = 3.0;

  static get _rangeAngle => _endAngle - _startAngle;
  static get _deltaAngle => _rangeAngle / _numTicks;

  num _currentAngle;
  num get _currentValue => _getValueFromAngle(_currentAngle);

  @override
  void initState() {
    super.initState();

    // Initialize to current value
    _currentAngle = _getAngleFromValue(widget.defaultValue.degCelsius);
  }

  // Compute the angle from the center of the widget to the given global position
  static num _getAngleFromTapPos(final BuildContext context, final Offset globalPos) {
    // Convert global coordinates to coordinates relative to the origin of this Widget
    final RenderBox renderBox = context.findRenderObject();
    final Offset relativePos = renderBox.globalToLocal(globalPos);

    // Get center
    final Offset center = renderBox.paintBounds.center;

    // Compute the angle from the center to the tapped position
    return _getAngleFromPosition(relativePos, center);
  }

  // Take the given position and center and compute the angle (in radius)
  // from the center to the position
  static num _getAngleFromPosition(final Offset pos, final Offset center) {
    final Offset relPos = pos - center;
    final num distance = relPos.distance;
    final Offset normalized = new Offset(relPos.dx / distance, relPos.dy / distance);
    final num angle = atan2(normalized.dy, normalized.dx);
    return angle;
  }

  // Limit the given angle to stay within the minimum and maximum bounds
  static num _limitAngle(final num angle) {
    if (angle < _startAngle) {
      return _startAngle;
    } else if (angle > _endAngle) {
      return _endAngle;
    } else {
      return angle;
    }
  }

  // Convert the given value into an angle
  num _getAngleFromValue(final num value) {
    return (((value - widget.minValue.degCelsius) / widget.rangeValue) * _rangeAngle) + _startAngle;
  }

  // Convert the given angle into a value
  num _getValueFromAngle(final num angle) {
    // When the user touches directly left, the angle switches from PI to -PI
    // which screws up a lot of math in the bottom-left quadrant.
    // So we correct this by flipping it to be < -PI instead of > 0
    final num correctedAngle = angle < PI / 2 ? angle : -(2 * PI) + angle;

    // Convert the angle into a ratio from _startAngle to _endAngle
    // ie. .5 means half way between _startAngle and _endAngle
    final num ratio = (_limitAngle(correctedAngle) - _startAngle).abs() / _rangeAngle;

    // Convert this ratio into a value
    return (ratio * widget.rangeValue) + widget.minValue.degCelsius;
  }

  // Update the current value and notify observers
  void _onUpdate(final Offset globalPos) {
    setState(() => _currentAngle = _getAngleFromTapPos(context, globalPos));
    widget.onTempChanged?.call(new Temp.fromCelsius(_currentValue));
  }

  @override
  Widget build(final BuildContext context) {
    // RenderBox is only available after layout, wait for it
    // Hack: Look for a better way to do this...
    final RenderBox renderBox = context.findRenderObject();
    if (renderBox == null || !renderBox.hasSize) {
      // Wait 10 milliseconds and then reset state to trigger a refresh
      new Future.delayed(new Duration(milliseconds: 10)).then((_) => setState(() => null));
      return new Center(
          child: new CircularProgressIndicator()
      );
    }

    // Size is known, get the radius
    final num radius = renderBox.paintBounds.shortestSide / 2.0;

    final Paint paint = new Paint()..color = widget.color ?? Theme.of(context).primaryColor;
    return new Container(
      constraints: new BoxConstraints.expand(),
      child: new GestureDetector(
        onPanUpdate: (details) => _onUpdate(details.globalPosition),
        child: new MultiPainter(
          painters: <CustomPainter>[
            new _TempBorderPainter(
              color: paint.color,
              bgColor: widget.bgColor,
              borderSize: widget.borderSize,
            ),
          ]..addAll(new Iterable.generate(_numTicks + 1, (index) => new _TempTickPainter(
            angle: _startAngle + (_deltaAngle * index),
            startRadius: radius - _tickLength,
            endRadius: radius,
            paint: paint,
            thickness: _tickThickness,
          )))..add(new _TempTickPainter(
            angle: _currentAngle,
            startRadius: radius - (3 * _tickLength),
            endRadius: radius,
            paint: paint,
            thickness: _tickThickness,
          )),
          child: new Center(
            child: new Text(
              TempUnit.fahrenheit.format(
                new Temp.fromCelsius(_currentValue).degFahrenheit.round()
              ),
              style: new TextStyle(
                fontSize: 68.0,
                color: paint.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter for the circular border of the thermostat
class _TempBorderPainter extends CustomPainter {
  final Color color;
  final Color bgColor;
  final num borderSize;

  Paint get _paint => new Paint()..color = color;
  Paint get _bgPaint => new Paint()..color = bgColor;

  _TempBorderPainter({
    @required this.color,
    @required this.bgColor,
    @required this.borderSize,
  });

  @override
  void paint(final Canvas canvas, final Size size) {
    // Compute center of the drawable area
    final Offset center = size.center(Offset.zero);

    // Compute radius from the shorter side of the drawable area
    final num radius = size.shortestSide / 2.0;

    // Draw border by filling in a circle, subtracting the border, and filling in another
    canvas.drawCircle(center, radius, _paint);
    canvas.drawCircle(center, radius - borderSize, _bgPaint);
  }

  @override
  bool shouldRepaint(final _TempBorderPainter oldPainter) {
    return color != oldPainter.color
        || bgColor != oldPainter.bgColor
        || borderSize != oldPainter.borderSize
    ;
  }
}

/// Painter for an individual tick mark at a particular angle
class _TempTickPainter extends CustomPainter {
  final num angle;
  final num startRadius;
  final num endRadius;
  final num thickness;
  final Paint _paint;

  _TempTickPainter({
    @required this.angle,
    @required this.startRadius,
    @required this.endRadius,
    @required this.thickness,
    @required paint,
  }) : _paint = paint;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Offset center = size.center(Offset.zero);

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
      tickStart + (rotated * thickness),
      tickStart + (inverted * thickness),
      tickEnd + (inverted * thickness),
      tickEnd + (rotated * thickness)
    ], true), _paint);
  }

  // Create an offset from the given angle
  static Offset _offsetFromAngle(final num angle) {
    return new Offset(cos(angle), sin(angle));
  }

  // Create a new offset by rotating the given offset by the given angle
  static Offset _rotateOffset(final Offset offset, final num angle) {
    return new Offset(
        (offset.dx * cos(angle)) - (offset.dy * sin(angle)),
        ((offset.dx * sin(angle)) + (offset.dy * cos(angle)))
    );
  }

  // Create a new offset by taking the inversion of the given offset
  static Offset _invertOffset(final Offset offset) {
    return new Offset(-offset.dx, -offset.dy);
  }

  @override
  bool shouldRepaint(final _TempTickPainter oldPainter) {
    return angle != oldPainter.angle
        || startRadius != oldPainter.startRadius
        || endRadius != oldPainter.endRadius
        || thickness != oldPainter.thickness
        || _paint != oldPainter._paint
    ;
  }
}