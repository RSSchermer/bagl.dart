part of math;

/// A column vector of length 4 (a 4 by 1 matrix).
class Vector4 extends _VertexBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 1;

  final int rowDimension = 4;

  double _squareSum;

  double _magnitude;

  Vector4 _unitVector;

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

  /// The magnitude of this [Vector4].
  double get magnitude {
    if (_magnitude == null) {
      _squareSum ??= x * x + y * y + z * z + w * w;

      if ((_squareSum - 1).abs() < 0.0001) {
        _magnitude = 1.0;
      } else {
        _magnitude = sqrt(_squareSum);
      }
    }

    return _magnitude;
  }

  /// This [Vector4]'s unit vector.
  ///
  /// A [Vector4] with a [magnitude] of `1` that has the same direction as this
  /// [Vector4].
  Vector4 get unitVector {
    if (_unitVector == null) {
      if (_unitVector == null) {
        if (_magnitude != null) {
          if (_magnitude == 1.0) {
            _unitVector = new Vector4(x, y, z, w);
          } else {
            _unitVector = new Vector4(
                x / _magnitude, y / _magnitude, z / _magnitude, w / _magnitude);
          }
        } else {
          _squareSum ??= x * x + y * y + z * z + w * w;

          if ((_squareSum - 1).abs() < 0.0001) {
            _unitVector = new Vector4(x, y, z, w);
          } else {
            _magnitude ??= sqrt(_squareSum);

            _unitVector = new Vector4(
                x / _magnitude, y / _magnitude, z / _magnitude, w / _magnitude);
          }
        }
      }

      return _unitVector;
    }

    return _unitVector;
  }

  /// Whether or not this [Vector4] is a unit vector.
  bool get isUnit {
    if (_magnitude != null) {
      return _magnitude == 1.0;
    } else {
      _squareSum ??= x * x + y * y + z * z + w * w;

      return (_squareSum - 1).abs() < 0.0001;
    }
  }

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

  /// Computes the dot product of this [Vector4] `A` and another [Vector4] [B].
  double dotProduct(Vector4 B) => x * B.x + y * B.y + z * B.z + w * B.w;

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
