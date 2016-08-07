part of math;

/// A column vector of length 4 (a 4 by 1 matrix).
class Vector4 extends _VertexBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 1;

  final int rowDimension = 4;

  /// Instantiates a new [Vector4] with the specified values.
  factory Vector4(double x, double y, double z, double w) {
    final values = new Float32List(4);

    values[0] = x;
    values[1] = y;
    values[2] = z;
    values[3] = w;

    return new Vector4._internal(values);
  }

  /// Instantiates a new [Vector4] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 4.
  factory Vector4.fromList(List<double> values) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Vector4.');
    }

    return new Vector4._internal(new Float32List.fromList(values));
  }

  /// Instantiates a new [Vector4] where every position is set to the specified
  /// value.
  factory Vector4.constant(double value) =>
      new Vector4._internal(new Float32List(4)..fillRange(0, 4, value));

  /// Instantiates a new [Vector4] where every position is set to zero.
  factory Vector4.zero() => new Vector4._internal(new Float32List(4));

  Vector4._internal(this._storage);

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

  Vector4 scalarProduct(num s) {
    final values = new Float32List(4);

    values[0] = x * s;
    values[1] = y * s;
    values[2] = z * s;
    values[3] = w * s;

    return new Vector4._internal(values);
  }

  Vector4 scalarDivision(num s) {
    final values = new Float32List(4);

    values[0] = x / s;
    values[1] = y / s;
    values[2] = z / s;
    values[3] = w / s;

    return new Vector4._internal(values);
  }

  Vector4 entrywiseSum(Matrix B) {
    final values = new Float32List(4);

    if (B is Vector4) {
      values[0] = x + B.x;
      values[1] = y + B.y;
      values[2] = z + B.z;
      values[3] = w + B.w;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x + B.valueAt(0, 0);
      values[1] = y + B.valueAt(1, 0);
      values[2] = z + B.valueAt(2, 0);
      values[3] = w + B.valueAt(3, 0);
    }

    return new Vector4._internal(values);
  }

  Vector4 entrywiseDifference(Matrix B) {
    final values = new Float32List(4);

    if (B is Vector4) {
      values[0] = x - B.x;
      values[1] = y - B.y;
      values[2] = z - B.z;
      values[3] = w - B.w;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x - B.valueAt(0, 0);
      values[1] = y - B.valueAt(1, 0);
      values[2] = z - B.valueAt(2, 0);
      values[3] = w - B.valueAt(3, 0);
    }

    return new Vector4._internal(values);
  }

  Vector4 entrywiseProduct(Matrix B) {
    final values = new Float32List(4);

    if (B is Vector4) {
      values[0] = x * B.x;
      values[1] = y * B.y;
      values[2] = z * B.z;
      values[3] = w * B.w;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x * B.valueAt(0, 0);
      values[1] = y * B.valueAt(1, 0);
      values[2] = z * B.valueAt(2, 0);
      values[3] = w * B.valueAt(3, 0);
    }

    return new Vector4._internal(values);
  }

  Vector4 operator +(Matrix B) => entrywiseSum(B);

  Vector4 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 4);

    return _storage[index];
  }

  String toString() {
    return 'Vector4($x, $y, $z, $w)';
  }
}
