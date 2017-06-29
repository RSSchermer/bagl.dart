part of bagl.math;

/// A 3 by 3 square matrix.
///
///     // Instantiates the following matrix:
///     //
///     //    1.0 2.0 3.0
///     //    4.0 5.0 6.0
///     //    7.0 8.0 9.0
///     //
///     var matrix = new Matrix3(
///       1.0, 2.0, 3.0,
///       4.0, 5.0, 6.0,
///       7.0, 8.0, 9.0
///     );
///

abstract class Matrix3 implements Matrix {
  /// Instantiates a new [Matrix3] from the given values, partitioned into rows
  /// of length 3.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 2.0 3.0
  ///     //    4.0 5.0 6.0
  ///     //    7.0 8.0 9.0
  ///     //
  ///     var matrix = new Matrix3(
  ///       1.0, 2.0, 3.0,
  ///       4.0, 5.0, 6.0,
  ///       7.0, 8.0, 9.0
  ///     );
  ///
  factory Matrix3(
      double val0,
      double val1,
      double val2,
      double val3,
      double val4,
      double val5,
      double val6,
      double val7,
      double val8) = _Matrix3;

  /// Instantiates a new [Matrix3] from the given list, partitioned into columns
  /// of length 3.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 2.0 3.0
  ///     //    4.0 5.0 6.0
  ///     //    7.0 8.0 9.0
  ///     //
  ///     var matrix = new Matrix3([
  ///       1.0, 4.0, 7.0,
  ///       2.0, 5.0, 8.0,
  ///       3.0, 6.0, 9.0
  ///     ]);
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 9.
  factory Matrix3.fromColumnPackedList(List<double> values) =
      _Matrix3.fromColumnPackedList;

  /// Instantiates a new [Matrix3] where every position is set to the given
  /// value.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    2.0 2.0 2.0
  ///     //    2.0 2.0 2.0
  ///     //    2.0 2.0 2.0
  ///     //
  ///     var matrix = new Matrix3.constant(2);
  ///
  factory Matrix3.constant(double value) = _Matrix3.constant;

  /// Instantiates a new [Matrix3] where every position is set to zero.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    0.0 0.0 0.0
  ///     //    0.0 0.0 0.0
  ///     //    0.0 0.0 0.0
  ///     //
  ///     var matrix = new Matrix3.zero();
  ///
  factory Matrix3.zero() = _Matrix3.zero;

  /// Instantiates a new [Matrix3] as an identity matrix.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 0.0 0.0
  ///     //    0.0 1.0 0.0
  ///     //    0.0 0.0 1.0
  ///     //
  ///     var matrix = new Matrix3.identity();
  ///
  const factory Matrix3.identity() = _Matrix3Identity;

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] translates
  /// it by [translateX] in the X direction and by [translateY] in the Y
  /// direction.
  factory Matrix3.translation(double translateX, double translateY) =
      _Matrix3.translation;

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] scales it
  /// by [scaleX] in the X direction, by [scaleY] in the Y direction, and by
  /// [scaleZ] in the Z direction.
  factory Matrix3.scale(double scaleX, double scaleY, double scaleZ) =
      _Matrix3.scale;

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the [axis] by [radians].
  factory Matrix3.rotation(Vector3 axis, double radians) = _Matrix3.rotation;

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the X axis by [radians].
  factory Matrix3.rotationX(double radians) = _Matrix3.rotationX;

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the Y axis by [radians].
  factory Matrix3.rotationY(double radians) = _Matrix3.rotationY;

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the Z axis by [radians].
  factory Matrix3.rotationZ(double radians) = _Matrix3.rotationZ;

  /// Returns the value in the first column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c0;

  /// Returns the value in the second column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c1;

  /// Returns the value in the third column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c2;

  /// Returns the value in the first column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c0;

  /// Returns the value in the second column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c1;

  /// Returns the value in the third column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c2;

  /// Returns the value in the first column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c0;

  /// Returns the value in the second column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c1;

  /// Returns the value in the third column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c2;

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index);
}

class _Matrix3 extends _MatrixBase implements Matrix3 {
  final Float32List _storage;

  final int columnDimension = 3;

  final int rowDimension = 3;

  final bool isSquare = true;

  Matrix3 _transpose;

  Matrix3 _inverse;

  double _determinant;

  Float32List _valuesRowPacked;

  factory _Matrix3(double val0, double val1, double val2, double val3,
      double val4, double val5, double val6, double val7, double val8) {
    final values = new Float32List(9);

    values[0] = val0;
    values[3] = val1;
    values[6] = val2;
    values[1] = val3;
    values[4] = val4;
    values[7] = val5;
    values[2] = val6;
    values[5] = val7;
    values[8] = val8;

    return new _Matrix3._internal(values);
  }

  factory _Matrix3.fromColumnPackedList(List<double> values) {
    if (values.length != 9) {
      throw new ArgumentError(
          'A list of length 9 required to instantiate a Matrix3.');
    }

    return new _Matrix3._internal(new Float32List.fromList(values));
  }

  factory _Matrix3.constant(double value) =>
      new _Matrix3._internal(new Float32List(9)..fillRange(0, 9, value));

  factory _Matrix3.zero() => new _Matrix3._internal(new Float32List(9));

  factory _Matrix3.translation(double translateX, double translateY) {
    final values = new Float32List(9);

    values[0] = 1.0;
    values[4] = 1.0;
    values[6] = translateX;
    values[7] = translateY;
    values[8] = 1.0;

    return new _Matrix3._internal(values);
  }

  factory _Matrix3.scale(double scaleX, double scaleY, double scaleZ) {
    final values = new Float32List(9);

    values[0] = scaleX;
    values[4] = scaleY;
    values[8] = scaleZ;

    return new _Matrix3._internal(values);
  }

  factory _Matrix3.rotation(Vector3 axis, double radians) {
    final values = new Float32List(9);
    final x = axis.x;
    final y = axis.y;
    final z = axis.z;
    final c = cos(radians);
    final s = sin(radians);
    final t = 1 - c;
    final tx = t * x;
    final ty = t * y;

    values[0] = tx * x + c;
    values[1] = tx * y + s * z;
    values[2] = tx * z - s * y;
    values[3] = tx * y - s * z;
    values[4] = ty * y + c;
    values[5] = ty * z + s * x;
    values[6] = tx * z + s * y;
    values[7] = ty * z - s * x;
    values[8] = t * z * z + c;

    return new _Matrix3._internal(values);
  }

  factory _Matrix3.rotationX(double radians) {
    final values = new Float32List(9);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = 1.0;
    values[4] = c;
    values[5] = s;
    values[7] = -s;
    values[8] = c;

    return new _Matrix3._internal(values);
  }

  factory _Matrix3.rotationY(double radians) {
    final values = new Float32List(9);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = c;
    values[2] = -s;
    values[4] = 1.0;
    values[6] = s;
    values[8] = c;

    return new _Matrix3._internal(values);
  }

  factory _Matrix3.rotationZ(double radians) {
    final values = new Float32List(9);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = c;
    values[1] = s;
    values[3] = -s;
    values[4] = c;
    values[8] = 1.0;

    return new _Matrix3._internal(values);
  }

  _Matrix3._internal(this._storage);

  double get r0c0 => _storage[0];

  double get r0c1 => _storage[3];

  double get r0c2 => _storage[6];

  double get r1c0 => _storage[1];

  double get r1c1 => _storage[4];

  double get r1c2 => _storage[7];

  double get r2c0 => _storage[2];

  double get r2c1 => _storage[5];

  double get r2c2 => _storage[8];

  bool get isNonSingular => determinant != 0;

  Iterable<double> get valuesRowPacked {
    if (_valuesRowPacked == null) {
      _valuesRowPacked = new Float32List(9);

      _valuesRowPacked[0] = r0c0;
      _valuesRowPacked[1] = r0c1;
      _valuesRowPacked[2] = r0c2;
      _valuesRowPacked[3] = r1c0;
      _valuesRowPacked[4] = r1c1;
      _valuesRowPacked[5] = r1c2;
      _valuesRowPacked[6] = r2c0;
      _valuesRowPacked[7] = r2c1;
      _valuesRowPacked[8] = r2c2;
    }

    return _valuesRowPacked;
  }

  Matrix3 get transpose {
    if (_transpose == null) {
      final values = new Float32List(9);

      values[0] = r0c0;
      values[1] = r0c1;
      values[2] = r0c2;
      values[3] = r1c0;
      values[4] = r1c1;
      values[5] = r1c2;
      values[6] = r2c0;
      values[7] = r2c1;
      values[8] = r2c2;

      _transpose = new _Matrix3._internal(values);
    }

    return _transpose;
  }

  double get determinant {
    if (_determinant == null) {
      final a = r0c0 * (r1c1 * r2c2 - r2c1 * r1c2);
      final b = r1c0 * (r0c1 * r2c2 - r2c1 * r0c2);
      final c = r2c0 * (r0c1 * r1c2 - r1c1 * r0c2);

      _determinant = a - b + c;
    }

    return _determinant;
  }

  Matrix3 get inverse {
    if (_inverse == null) {
      final det = determinant;

      if (det == 0) {
        throw new UnsupportedError('This matrix is singular (has no inverse).');
      }

      final detInv = 1.0 / det;
      final values = new Float32List(9);

      values[0] = detInv * (r1c1 * r2c2 - r1c2 * r2c1);
      values[1] = detInv * (r1c2 * r2c0 - r1c0 * r2c2);
      values[2] = detInv * (r1c0 * r2c1 - r1c1 * r2c0);
      values[3] = detInv * (r0c2 * r2c1 - r0c1 * r2c2);
      values[4] = detInv * (r0c0 * r2c2 - r0c2 * r2c0);
      values[5] = detInv * (r0c1 * r2c0 - r0c0 * r2c1);
      values[6] = detInv * (r0c1 * r1c2 - r0c2 * r1c1);
      values[7] = detInv * (r0c2 * r1c0 - r0c0 * r1c2);
      values[8] = detInv * (r0c0 * r1c1 - r0c1 * r1c0);

      _inverse = new _Matrix3._internal(values);
    }

    return _inverse;
  }

  Matrix3 scalarProduct(num s) {
    final values = new Float32List(9);

    values[0] = r0c0 * s;
    values[1] = r1c0 * s;
    values[2] = r2c0 * s;
    values[3] = r0c1 * s;
    values[4] = r1c1 * s;
    values[5] = r2c1 * s;
    values[6] = r0c2 * s;
    values[7] = r1c2 * s;
    values[8] = r2c2 * s;

    return new _Matrix3._internal(values);
  }

  Matrix3 scalarDivision(num s) {
    final values = new Float32List(9);

    values[0] = r0c0 / s;
    values[1] = r1c0 / s;
    values[2] = r2c0 / s;
    values[3] = r0c1 / s;
    values[4] = r1c1 / s;
    values[5] = r2c1 / s;
    values[6] = r0c2 / s;
    values[7] = r1c2 / s;
    values[8] = r2c2 / s;

    return new _Matrix3._internal(values);
  }

  Matrix3 entrywiseSum(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = r0c0 + B.r0c0;
      values[1] = r1c0 + B.r1c0;
      values[2] = r2c0 + B.r2c0;
      values[3] = r0c1 + B.r0c1;
      values[4] = r1c1 + B.r1c1;
      values[5] = r2c1 + B.r2c1;
      values[6] = r0c2 + B.r0c2;
      values[7] = r1c2 + B.r1c2;
      values[8] = r2c2 + B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 + B.valueAt(0, 0);
      values[1] = r1c0 + B.valueAt(1, 0);
      values[2] = r2c0 + B.valueAt(2, 0);
      values[3] = r0c1 + B.valueAt(0, 1);
      values[4] = r1c1 + B.valueAt(1, 1);
      values[5] = r2c1 + B.valueAt(2, 1);
      values[6] = r0c2 + B.valueAt(0, 2);
      values[7] = r1c2 + B.valueAt(1, 2);
      values[8] = r2c2 + B.valueAt(2, 2);
    }

    return new _Matrix3._internal(values);
  }

  Matrix3 entrywiseDifference(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = r0c0 - B.r0c0;
      values[3] = r0c1 - B.r0c1;
      values[6] = r0c2 - B.r0c2;
      values[1] = r1c0 - B.r1c0;
      values[4] = r1c1 - B.r1c1;
      values[7] = r1c2 - B.r1c2;
      values[2] = r2c0 - B.r2c0;
      values[5] = r2c1 - B.r2c1;
      values[8] = r2c2 - B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 - B.valueAt(0, 0);
      values[1] = r1c0 - B.valueAt(1, 0);
      values[2] = r2c0 - B.valueAt(2, 0);
      values[3] = r0c1 - B.valueAt(0, 1);
      values[4] = r1c1 - B.valueAt(1, 1);
      values[5] = r2c1 - B.valueAt(2, 1);
      values[6] = r0c2 - B.valueAt(0, 2);
      values[7] = r1c2 - B.valueAt(1, 2);
      values[8] = r2c2 - B.valueAt(2, 2);
    }

    return new _Matrix3._internal(values);
  }

  Matrix3 entrywiseProduct(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = r0c0 * B.r0c0;
      values[1] = r1c0 * B.r1c0;
      values[2] = r2c0 * B.r2c0;
      values[3] = r0c1 * B.r0c1;
      values[4] = r1c1 * B.r1c1;
      values[5] = r2c1 * B.r2c1;
      values[6] = r0c2 * B.r0c2;
      values[7] = r1c2 * B.r1c2;
      values[8] = r2c2 * B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 * B.valueAt(0, 0);
      values[1] = r1c0 * B.valueAt(1, 0);
      values[2] = r2c0 * B.valueAt(2, 0);
      values[3] = r0c1 * B.valueAt(0, 1);
      values[4] = r1c1 * B.valueAt(1, 1);
      values[5] = r2c1 * B.valueAt(2, 1);
      values[6] = r0c2 * B.valueAt(0, 2);
      values[7] = r1c2 * B.valueAt(1, 2);
      values[8] = r2c2 * B.valueAt(2, 2);
    }

    return new _Matrix3._internal(values);
  }

  matrixProduct(Matrix B) {
    if (B is _Matrix3) {
      final m00 = r0c0;
      final m01 = r0c1;
      final m02 = r0c2;
      final m10 = r1c0;
      final m11 = r1c1;
      final m12 = r1c2;
      final m20 = r2c0;
      final m21 = r2c1;
      final m22 = r2c2;

      final n00 = B.r0c0;
      final n01 = B.r0c1;
      final n02 = B.r0c2;
      final n10 = B.r1c0;
      final n11 = B.r1c1;
      final n12 = B.r1c2;
      final n20 = B.r2c0;
      final n21 = B.r2c1;
      final n22 = B.r2c2;

      final values = new Float32List(9);

      values[0] = (m00 * n00) + (m01 * n10) + (m02 * n20);
      values[1] = (m10 * n00) + (m11 * n10) + (m12 * n20);
      values[2] = (m20 * n00) + (m21 * n10) + (m22 * n20);
      values[3] = (m00 * n01) + (m01 * n11) + (m02 * n21);
      values[4] = (m10 * n01) + (m11 * n11) + (m12 * n21);
      values[5] = (m20 * n01) + (m21 * n11) + (m22 * n21);
      values[6] = (m00 * n02) + (m01 * n12) + (m02 * n22);
      values[7] = (m10 * n02) + (m11 * n12) + (m12 * n22);
      values[8] = (m20 * n02) + (m21 * n12) + (m22 * n22);

      return new _Matrix3._internal(values);
    } else if (B is Vector3) {
      final n0 = B.x;
      final n1 = B.y;
      final n2 = B.z;

      return new Vector3(
          (r0c0 * n0) + (r0c1 * n1) + (r0c2 * n2),
          (r1c0 * n0) + (r1c1 * n1) + (r1c2 * n2),
          (r2c0 * n0) + (r2c1 * n1) + (r2c2 * n2));
    } else if (B is _Matrix3Identity) {
      return this;
    } else {
      return super.matrixProduct(B);
    }
  }

  Matrix3 operator +(Matrix B) => entrywiseSum(B);

  Matrix3 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix3($r0c0, $r0c1, $r0c2, $r1c0, $r1c1, $r1c2, $r2c0, $r2c1, '
        '$r2c2)';
  }

  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _Matrix3) {
      final s = other._storage;

      return _storage[0] == s[0] &&
          _storage[1] == s[1] &&
          _storage[2] == s[2] &&
          _storage[3] == s[3] &&
          _storage[4] == s[4] &&
          _storage[5] == s[5] &&
          _storage[6] == s[6] &&
          _storage[7] == s[7] &&
          _storage[8] == s[8];
    } else if (other is _Matrix3Identity) {
      return _storage[0] == 1.0 &&
          _storage[1] == 0.0 &&
          _storage[2] == 0.0 &&
          _storage[3] == 0.0 &&
          _storage[4] == 1.0 &&
          _storage[5] == 0.0 &&
          _storage[6] == 0.0 &&
          _storage[7] == 0.0 &&
          _storage[8] == 1.0;
    } else {
      return false;
    }
  }
}

class _Matrix3Identity implements Matrix3 {
  final int rowDimension = 3;
  final int columnDimension = 3;

  final bool isSquare = true;

  final double determinant = 1.0;

  final bool isNonSingular = true;

  final double r0c0 = 1.0;
  final double r0c1 = 0.0;
  final double r0c2 = 0.0;
  final double r1c0 = 0.0;
  final double r1c1 = 1.0;
  final double r1c2 = 0.0;
  final double r2c0 = 0.0;
  final double r2c1 = 0.0;
  final double r2c2 = 1.0;

  final List<double> valuesColumnPacked = const <double>[
    1.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.0,
    0.0,
    1.0
  ];

  final List<double> _r0 = const <double>[1.0, 0.0, 0.0];
  final List<double> _r1 = const <double>[0.0, 1.0, 0.0];
  final List<double> _r2 = const <double>[0.0, 0.0, 1.0];

  const _Matrix3Identity();

  List<double> get values => valuesColumnPacked;

  List<double> get valuesRowPacked => valuesColumnPacked;

  Matrix3 get transpose => this;

  Matrix3 get inverse => this;

  PivotingLUDecomposition get luDecomposition =>
      new PivotingLUDecomposition(this);

  ReducedQRDecomposition get qrDecomposition =>
      new ReducedQRDecomposition(this);

  Matrix3 scalarProduct(num s) {
    final values = new Float32List(9);

    values[0] = s;
    values[4] = s;
    values[8] = s;

    return new _Matrix3._internal(values);
  }

  Matrix3 scalarDivision(num s) {
    final values = new Float32List(9);

    values[0] = 1.0 / s;
    values[4] = 1.0 / s;
    values[8] = 1.0 / s;

    return new _Matrix3._internal(values);
  }

  Matrix3 entrywiseSum(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = 1.0 + B.r0c0;
      values[1] = B.r1c0;
      values[2] = B.r2c0;
      values[3] = B.r0c1;
      values[4] = 1.0 + B.r1c1;
      values[5] = B.r2c1;
      values[6] = B.r0c2;
      values[7] = B.r1c2;
      values[8] = 1.0 + B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = 1.0 + B.valueAt(0, 0);
      values[1] = B.valueAt(1, 0);
      values[2] = B.valueAt(2, 0);
      values[3] = B.valueAt(0, 1);
      values[4] = 1.0 + B.valueAt(1, 1);
      values[5] = B.valueAt(2, 1);
      values[6] = B.valueAt(0, 2);
      values[7] = B.valueAt(1, 2);
      values[8] = 1.0 + B.valueAt(2, 2);
    }

    return new _Matrix3._internal(values);
  }

  Matrix3 entrywiseDifference(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = 1.0 - B.r0c0;
      values[1] = -B.r1c0;
      values[2] = -B.r2c0;
      values[3] = -B.r0c1;
      values[4] = 1.0 - B.r1c1;
      values[5] = -B.r2c1;
      values[6] = -B.r0c2;
      values[7] = -B.r1c2;
      values[8] = 1.0 - B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = 1.0 - B.valueAt(0, 0);
      values[1] = -B.valueAt(1, 0);
      values[2] = -B.valueAt(2, 0);
      values[3] = -B.valueAt(0, 1);
      values[4] = 1.0 - B.valueAt(1, 1);
      values[5] = -B.valueAt(2, 1);
      values[6] = -B.valueAt(0, 2);
      values[7] = -B.valueAt(1, 2);
      values[8] = 1.0 - B.valueAt(2, 2);
    }

    return new _Matrix3._internal(values);
  }

  Matrix3 entrywiseProduct(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = B.r0c0;
      values[4] = B.r1c1;
      values[8] = B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = B.valueAt(0, 0);
      values[4] = B.valueAt(1, 1);
      values[8] = B.valueAt(2, 2);
    }

    return new _Matrix3._internal(values);
  }

  matrixProduct(Matrix B) {
    if (B is _Matrix3) {
      return B;
    } else if (B is Vector3) {
      return B;
    } else if (B.rowDimension == 3) {
      return B;
    } else {
      throw new ArgumentError('The row dimension of the given matrix B '
          '(${B.rowDimension}), does not match this matrix\'s column dimension '
          '(3).');
    }
  }

  List<double> rowAt(int index) {
    if (index == 0) {
      return _r0;
    } else if (index == 1) {
      return _r1;
    } else if (index == 2) {
      return _r2;
    } else {
      throw new RangeError('Invalid index. Index must be 0, 1 or 2.');
    }
  }

  double valueAt(int row, int column) {
    RangeError.checkValueInInterval(row, 0, rowDimension);
    RangeError.checkValueInInterval(column, 0, columnDimension);

    return valuesRowPacked[column * rowDimension + row];
  }

  Matrix subMatrix(int rowStart, int rowEnd, int colStart, int colEnd) {
    if (rowEnd <= rowStart) {
      throw new ArgumentError(
          'The rowEnd index must be greater than the rowStart index.');
    }

    if (colEnd <= colStart) {
      throw new ArgumentError(
          'The colEnd index must be greater than the colStart index.');
    }

    final rows = (rowEnd - rowStart);
    final cols = (colEnd - colStart);
    final subMatrixVals = new Float32List(rows * cols);

    for (var i = rowStart; i < rowEnd; i++) {
      final m = (i - rowStart) * cols;

      for (var j = colStart; j < colEnd; j++) {
        subMatrixVals[m + j - colStart] = valueAt(i, j);
      }
    }

    return new Matrix.fromList(subMatrixVals, cols);
  }

  Matrix solve(Matrix B) {
    if (B.rowDimension == 3) {
      return B;
    } else {
      throw new ArgumentError('The row dimension of the given matrix B '
          '(${B.rowDimension}), does not match this matrix\'s column dimension '
          '(3).');
    }
  }

  Matrix solveTranspose(Matrix B) {
    if (B.columnDimension == 3) {
      return B;
    } else {
      throw new ArgumentError('The column dimension of the given matrix B '
          '(${B.rowDimension}), does not match this matrix\'s row dimension '
          '(3).');
    }
  }

  Matrix3 operator +(Matrix B) => entrywiseSum(B);

  Matrix3 operator -(Matrix B) => entrywiseDifference(B);

  operator *(a) {
    if (a is num) {
      return scalarProduct(a);
    } else if (a is Matrix) {
      return matrixProduct(a);
    } else {
      throw new ArgumentError('Expected num or Matrix.');
    }
  }

  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix3(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0)';
  }

  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _Matrix3Identity) {
      return true;
    } else if (other is _Matrix3) {
      final s = other._storage;

      return s[0] == 1.0 &&
          s[1] == 0.0 &&
          s[2] == 0.0 &&
          s[3] == 0.0 &&
          s[4] == 1.0 &&
          s[5] == 0.0 &&
          s[6] == 0.0 &&
          s[7] == 0.0 &&
          s[8] == 1.0;
    } else {
      return false;
    }
  }
}
