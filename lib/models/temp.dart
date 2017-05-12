import "package:Thermo/protos/temp.pb.dart" as pb;

/// Model representing a temperature value.
class Temp {
  final num degCelsius;
  num get degFahrenheit => _celToFaren(degCelsius);
  num get degKelvin => _celToKel(degCelsius);

  const Temp.fromCelsius(final num cel) : degCelsius = cel;
  const Temp.fromFahrenheit(final num faren) : degCelsius = (faren - 32) * (5 / 9);
  const Temp.fromKelvin(final num kel) : degCelsius = kel + 273.15;

  /// Construct a new model from the given protobuf format
  Temp.fromPb(final pb.Temp temp) : degCelsius = temp.celsius;

  /// Construct a protobuf from this model
  pb.Temp toPb() {
    return new pb.Temp()
      ..celsius = degCelsius
    ;
  }

  static num _celToFaren(final num cel) {
    return cel * (9 / 5) + 32;
  }

  static num _celToKel(final num cel) {
    return cel - 273.15;
  }

  @override
  String toString([ final TempUnit unit = TempUnit.celsius ]) {
    switch (unit) {
      case TempUnit.fahrenheit: return unit.format(degFahrenheit);
      case TempUnit.celsius: return unit.format(degCelsius);
      case TempUnit.kelvin: return unit.format(degKelvin);
      default: throw new ArgumentError("Unknown TempUnit: $unit");
    }
  }

  operator<(final Temp other) {
    return this.degCelsius < other.degCelsius;
  }

  operator>(final Temp other) {
    return this.degCelsius > other.degCelsius;
  }

  operator<=(final Temp other) {
    return this.degCelsius <= other.degCelsius;
  }

  operator>=(final Temp other) {
    return this.degCelsius >= other.degCelsius;
  }
}

/// Model representing a unit of temperature (Fahrenheit, Celsius, Kelvin)
class TempUnit {
  static const TempUnit fahrenheit = const TempUnit._internal("°F");
  static const TempUnit celsius = const TempUnit._internal("°C");
  static const TempUnit kelvin = const TempUnit._internal("°K");
  static const List<TempUnit> values = const <TempUnit>[ fahrenheit, celsius, kelvin ];

  final String suffix;

  const TempUnit._internal(this.suffix);

  String format(final num temp) {
    return temp.toString() + suffix;
  }
}