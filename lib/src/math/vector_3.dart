part of math;

/// A column vector of length 3 (a 3 by 1 matrix).
class Vector3 extends _VertexBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 1;

  final int rowDimension = 3;

  double _squareSum;

  double _magnitude;

  Vector3 _unitVector;

  /// Instantiates a new [Vector3] with the specified values.
  factory Vector3(double x, double y, double z) {
    final values = new Float32List(3);

    values[0] = x;
    values[1] = y;
    values[2] = z;

    return new Vector3._internal(values);
  }

  /// Instantiates a new [Vector3] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 3.
  factory Vector3.fromList(List<double> values) {
    if (values.length != 3) {
      throw new ArgumentError(
          'A list of length 3 required to instantiate a Vector3.');
    }

    return new Vector3._internal(new Float32List.fromList(values));
  }

  /// Instantiates a new [Vector3] where every position is set to the specified
  /// value.
  factory Vector3.constant(double value) =>
      new Vector3._internal(new Float32List(3)..fillRange(0, 3, value));

  /// Instantiates a new [Vector3] where every position is set to zero.
  factory Vector3.zero() => new Vector3._internal(new Float32List(3));

  Vector3._internal(this._storage);

  double get x => _storage[0];
  double get y => _storage[1];
  double get z => _storage[2];

  double get r => _storage[0];
  double get g => _storage[1];
  double get b => _storage[2];

  double get s => _storage[0];
  double get t => _storage[1];
  double get p => _storage[2];

  /// The magnitude of this [Vector3].
  double get magnitude {
    if (_magnitude == null) {
      _squareSum ??= x * x + y * y + z * z;

      if ((_squareSum - 1).abs() < 0.0001) {
        _magnitude = 1.0;
      } else {
        _magnitude = sqrt(_squareSum);
      }
    }

    return _magnitude;
  }

  /// This [Vector3]'s unit vector.
  ///
  /// A [Vector3] with a [magnitude] of `1` that has the same direction as this
  /// [Vector3].
  Vector3 get unitVector {
    if (_unitVector == null) {
      if (_unitVector == null) {
        if (_magnitude != null) {
          if (_magnitude == 1.0) {
            _unitVector = new Vector3(x, y, z);
          } else {
            _unitVector =
                new Vector3(x / _magnitude, y / _magnitude, z / _magnitude);
          }
        } else {
          _squareSum ??= x * x + y * y + z * z;

          if ((_squareSum - 1).abs() < 0.0001) {
            _unitVector = new Vector3(x, y, z);
          } else {
            _magnitude ??= sqrt(_squareSum);

            _unitVector =
                new Vector3(x / _magnitude, y / _magnitude, z / _magnitude);
          }
        }
      }

      return _unitVector;
    }

    return _unitVector;
  }

  /// Whether or not this [Vector3] is a unit vector.
  bool get isUnit {
    if (_magnitude != null) {
      return _magnitude == 1.0;
    } else {
      _squareSum ??= x * x + y * y + z * z;

      return (_squareSum - 1).abs() < 0.0001;
    }
  }

  Vector3 scalarProduct(num s) {
    final values = new Float32List(3);

    values[0] = x * s;
    values[1] = y * s;
    values[2] = z * s;

    return new Vector3._internal(values);
  }

  Vector3 scalarDivision(num s) {
    final values = new Float32List(3);

    values[0] = x / s;
    values[1] = y / s;
    values[2] = z / s;

    return new Vector3._internal(values);
  }

  Vector3 entrywiseSum(Matrix B) {
    final values = new Float32List(3);

    if (B is Vector3) {
      values[0] = x + B.x;
      values[1] = y + B.y;
      values[2] = z + B.z;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x + B.valueAt(0, 0);
      values[1] = y + B.valueAt(1, 0);
      values[2] = z + B.valueAt(2, 0);
    }

    return new Vector3._internal(values);
  }

  Vector3 entrywiseDifference(Matrix B) {
    final values = new Float32List(3);

    if (B is Vector3) {
      values[0] = x - B.x;
      values[1] = y - B.y;
      values[2] = z - B.z;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x - B.valueAt(0, 0);
      values[1] = y - B.valueAt(1, 0);
      values[2] = z - B.valueAt(2, 0);
    }

    return new Vector3._internal(values);
  }

  Vector3 entrywiseProduct(Matrix B) {
    final values = new Float32List(3);

    if (B is Vector3) {
      values[0] = x * B.x;
      values[1] = y * B.y;
      values[2] = z * B.z;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = x * B.valueAt(0, 0);
      values[1] = y * B.valueAt(1, 0);
      values[2] = z * B.valueAt(2, 0);
    }

    return new Vector3._internal(values);
  }

  /// Computes the dot product of this [Vector3] `A` and another [Vector3] [B].
  double dotProduct(Vector3 B) => x * B.x + y * B.y + z * B.z;

  /// Computes the cross product of this [Vector3] `A` and another [Vector3]
  /// [B].
  Vector3 crossProduct(Vector3 B) => new Vector3(
      y * B.z - z * B.y,
      z * B.x - x * B.z,
      x * B.y - y * B.x,
  );

  Vector3 operator +(Matrix B) => entrywiseSum(B);

  Vector3 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 3);

    return _storage[index];
  }

  String toString() {
    return 'Vector3(${values.toString()})';
  }
}
