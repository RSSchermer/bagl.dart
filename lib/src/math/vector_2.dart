part of math;

/// A column vector of length 2 (a 2 by 1 matrix).
class Vector2 extends GenericMatrix<Vector2, Matrix> {
  final Float32List storage;

  /// Instantiates a new [Vector2] with the specified values.
  factory Vector2(double x, double y) {
    final values = new Float32List(2);

    values[0] = x;
    values[1] = y;

    return new Vector2.fromFloat32List(values);
  }

  /// Instantiates a new [Vector2] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 2.
  factory Vector2.fromList(List<double> values) =>
      new Vector2.fromFloat32List(new Float32List.fromList(values));

  /// Instantiates a new [Vector2] from the given [Float32List].
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 2.
  Vector2.fromFloat32List(Float32List values)
      : storage = values,
        super.fromFloat32List(values, 1) {
    if (values.length != 2) {
      throw new ArgumentError(
          'A list of length 2 required to instantiate a Vector2.');
    }
  }

  /// Instantiates a new [Vector2] where every position is set to the specified
  /// value.
  factory Vector2.constant(double value) =>
      new Vector2.fromFloat32List(new Float32List(2)..fillRange(0, 2, value));

  /// Instantiates a new [Vector2] where every position is set to zero.
  factory Vector2.zero() => new Vector2.fromFloat32List(new Float32List(2));

  Vector2 withValues(Float32List newValues) =>
      new Vector2.fromFloat32List(newValues);

  Matrix transposeWithValues(Float32List newValues) =>
      new Matrix.fromFloat32List(newValues, 2);

  double get x => storage[0];
  double get y => storage[1];

  double get r => storage[0];
  double get g => storage[1];

  double get s => storage[0];
  double get t => storage[1];

  /// Returns the value at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 2);

    return storage[index];
  }

  String toString() {
    return 'Vector2(${values.toString()})';
  }
}
