part of math;

/// A column vector of length 4 (a 4 by 1 matrix).
class Vector4 extends GenericMatrix<Vector4, Matrix> {
  final Float32List _storage;

  /// Instantiates a new [Vector4] with the specified values.
  factory Vector4(double x, double y, double z, double w) {
    final values = new Float32List(4);

    values[0] = x;
    values[1] = y;
    values[2] = z;
    values[3] = w;

    return new Vector4.fromFloat32List(values);
  }

  /// Instantiates a new [Vector4] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 4.
  factory Vector4.fromList(List<double> values) =>
      new Vector4.fromFloat32List(new Float32List.fromList(values));

  /// Instantiates a new [Vector4] from the given [Float32List].
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 4.
  Vector4.fromFloat32List(Float32List values)
      : _storage = values,
        super.fromFloat32List(values, 1) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Vector4.');
    }
  }

  /// Instantiates a new [Vector4] where every position is set to the specified
  /// value.
  factory Vector4.constant(double value) =>
      new Vector4.fromFloat32List(new Float32List(4)..fillRange(0, 4, value));

  /// Instantiates a new [Vector4] where every position is set to zero.
  factory Vector4.zero() => new Vector4.fromFloat32List(new Float32List(4));

  Vector4 withValues(Float32List newValues) =>
      new Vector4.fromFloat32List(newValues);

  Matrix transposeWithValues(Float32List newValues) =>
      new Matrix.fromFloat32List(newValues, 4);

  double get x => _storage[0];
  double get y => _storage[1];
  double get z => _storage[2];
  double get w => _storage[3];

  double get r => _storage[0];
  double get g => _storage[1];
  double get b => _storage[2];
  double get a => _storage[3];

  double get s => _storage[0];
  double get t => _storage[1];
  double get p => _storage[2];
  double get q => _storage[3];

  /// Returns the value at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 4);

    return _storage[index];
  }

  String toString() {
    return 'Vector4(${values.toString()})';
  }
}
