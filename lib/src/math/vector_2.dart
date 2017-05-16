part of math;

/// A column vector of length 2 (a 2 by 1 matrix).
class Vector2 extends _VertexBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 1;

  final int rowDimension = 2;

  double _squareSum;

  double _magnitude;

  Vector2 _unitVector;

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

  /// The magnitude of this [Vector2].
  double get magnitude {
    if (_magnitude == null) {
      _squareSum ??= x * x + y * y;

      if ((_squareSum - 1).abs() < 0.0001) {
        _magnitude = 1.0;
      } else {
        _magnitude = sqrt(_squareSum);
      }
    }

    return _magnitude;
  }

  /// This [Vector2]'s unit vector.
  ///
  /// A [Vector2] with a [magnitude] of `1` that has the same direction as this
  /// [Vector2].
  Vector2 get unitVector {
    if (_unitVector == null) {
      if (_magnitude != null) {
        if (_magnitude == 1.0) {
          _unitVector = new Vector2(x, y);
        } else {
          _unitVector = new Vector2(x / _magnitude, y / _magnitude);
        }
      } else {
        _squareSum ??= x * x + y * y;

        if ((_squareSum - 1).abs() < 0.0001) {
          _unitVector = new Vector2(x, y);
        } else {
          _magnitude ??= sqrt(_squareSum);

          _unitVector = new Vector2(x / _magnitude, y / _magnitude);
        }
      }
    }

    return _unitVector;
  }

  /// Whether or not this [Vector2] is a unit vector.
  bool get isUnit {
    if (_magnitude != null) {
      return _magnitude == 1.0;
    } else {
      _squareSum ??= x * x + y * y;

      return (_squareSum - 1).abs() < 0.0001;
    }
  }

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

  /// Computes the dot product of this [Vector2] `A` and another [Vector2] [B].
  double dotProduct(Vector2 B) => x * B.x + y * B.y;

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
