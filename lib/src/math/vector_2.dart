part of math;

/// A column vector of length 2 (a 2 by 1 matrix).
class Vector2 extends _VertexBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 1;

  final int rowDimension = 2;

  /// Instantiates a new [Vector2] with the specified values.
  factory Vector2(double x, double y) {
    final values = new Float32List(2);

    values[0] = x;
    values[1] = y;

    return new Vector2._internal(values);
  }

  /// Instantiates a new [Vector2] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 2.
  factory Vector2.fromList(List<double> values) {
    if (values.length != 2) {
      throw new ArgumentError(
          'A list of length 2 required to instantiate a Vector2.');
    }

    return new Vector2._internal(new Float32List.fromList(values));
  }

  /// Instantiates a new [Vector2] where every position is set to the specified
  /// value.
  factory Vector2.constant(double value) =>
      new Vector2._internal(new Float32List(2)..fillRange(0, 2, value));

  /// Instantiates a new [Vector2] where every position is set to zero.
  factory Vector2.zero() => new Vector2._internal(new Float32List(2));

  Vector2._internal(this._storage);

  double get x => _storage[0];
  double get y => _storage[1];

  double get r => _storage[0];
  double get g => _storage[1];

  double get s => _storage[0];
  double get t => _storage[1];

  Vector2 scalarProduct(num s) {
    final values = new Float32List(2);

    values[0] = x * s;
    values[1] = y * s;

    return new Vector2._internal(values);
  }

  Vector2 scalarDivision(num s) {
    final values = new Float32List(2);

    values[0] = x / s;
    values[1] = y / s;

    return new Vector2._internal(values);
  }

  Vector2 entrywiseSum(Matrix B) {
    final values = new Float32List(2);

    if (B is Vector2) {
      values[0] = x + B.x;
      values[1] = y + B.y;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x + B.valueAt(0, 0);
      values[1] = y + B.valueAt(1, 0);
    }

    return new Vector2._internal(values);
  }

  Vector2 entrywiseDifference(Matrix B) {
    final values = new Float32List(2);

    if (B is Vector2) {
      values[0] = x - B.x;
      values[1] = y - B.y;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x - B.valueAt(0, 0);
      values[1] = y - B.valueAt(1, 0);
    }

    return new Vector2._internal(values);
  }

  Vector2 entrywiseProduct(Matrix B) {
    final values = new Float32List(2);

    if (B is Vector2) {
      values[0] = x * B.x;
      values[1] = y * B.y;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x * B.valueAt(0, 0);
      values[1] = y * B.valueAt(1, 0);
    }

    return new Vector2._internal(values);
  }

  Vector2 operator +(Matrix B) => entrywiseSum(B);

  Vector2 operator -(Matrix B) => entrywiseDifference(B);

  //// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 2);

    return _storage[index];
  }

  String toString() {
    return 'Vector2($x, $y)';
  }
}
