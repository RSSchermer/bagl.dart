part of math;

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
class Matrix3 extends _MatrixBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 3;

  final int rowDimension = 3;

  final bool isSquare = true;

  Matrix3 _transpose;

  Matrix3 _inverse;

  double _determinant;

  Iterable<double> _valuesColumnPacked;

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
  factory Matrix3(double val0, double val1, double val2, double val3,
      double val4, double val5, double val6, double val7, double val8) {
    final values = new Float32List(9);

    values[0] = val0;
    values[1] = val1;
    values[2] = val2;
    values[3] = val3;
    values[4] = val4;
    values[5] = val5;
    values[6] = val6;
    values[7] = val7;
    values[8] = val8;

    return new Matrix3._internal(values);
  }

  /// Instantiates a new [Matrix3] from the given list, partitioned into rows
  /// of length 3.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 2.0 3.0
  ///     //    4.0 5.0 6.0
  ///     //    7.0 8.0 9.0
  ///     //
  ///     var matrix = new Matrix3([
  ///       1.0, 2.0, 3.0,
  ///       4.0, 5.0, 6.0,
  ///       7.0, 8.0, 9.0
  ///     ]);
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 9.
  factory Matrix3.fromList(List<double> values) {
    if (values.length != 9) {
      throw new ArgumentError(
          'A list of length 9 required to instantiate a Matrix3.');
    }

    return new Matrix3._internal(new Float32List.fromList(values));
  }

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
  factory Matrix3.constant(double value) =>
      new Matrix3._internal(new Float32List(9)..fillRange(0, 9, value));

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
  factory Matrix3.zero() => new Matrix3._internal(new Float32List(9));

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
  factory Matrix3.identity() {
    final values = new Float32List(9);

    values[0] = 1.0;
    values[4] = 1.0;
    values[8] = 1.0;

    return new Matrix3._internal(values);
  }

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] translates
  /// it along the X-Y plane by [translation].
  factory Matrix3.translation(Vector2 translation) {
    final values = new Float32List(9);

    values[0] = 1.0;
    values[2] = translation.x;
    values[4] = 1.0;
    values[5] = translation.y;
    values[8] = 1.0;

    return new Matrix3._internal(values);
  }

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] scales it
  /// by [scaleX] in the X direction, by [scaleY] in the Y direction, and by
  /// [scaleZ] in the Z direction.
  factory Matrix3.scale(double scaleX, double scaleY, double scaleZ) {
    final values = new Float32List(9);

    values[0] = scaleX;
    values[4] = scaleY;
    values[8] = scaleZ;

    return new Matrix3._internal(values);
  }

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the [axis] by [radians].
  factory Matrix3.rotation(Vector3 axis, double radians) {
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
    values[1] = tx * y - s * z;
    values[2] = tx * z + s * y;
    values[3] = tx * y + s * z;
    values[4] = ty * y + c;
    values[5] = ty * z - s * x;
    values[6] = tx * z - s * y;
    values[7] = ty * z + s * x;
    values[8] = t * z * z + c;

    return new Matrix3._internal(values);
  }

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the X axis by [radians].
  factory Matrix3.rotationX(double radians) {
    final values = new Float32List(9);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = 1.0;
    values[4] = c;
    values[5] = -s;
    values[7] = s;
    values[8] = c;

    return new Matrix3._internal(values);
  }

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the Y axis by [radians].
  factory Matrix3.rotationY(double radians) {
    final values = new Float32List(9);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = c;
    values[2] = s;
    values[4] = 1.0;
    values[6] = -s;
    values[8] = c;

    return new Matrix3._internal(values);
  }

  /// Instantiates a [Matrix3] that when multiplied with a [Vector3] will rotate
  /// it around the Z axis by [radians].
  factory Matrix3.rotationZ(double radians) {
    final values = new Float32List(9);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = c;
    values[1] = -s;
    values[3] = s;
    values[4] = c;
    values[8] = 1.0;

    return new Matrix3._internal(values);
  }

  Matrix3._internal(this._storage);

  /// Returns the value in the first column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c0 => _storage[0];

  /// Returns the value in the second column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c1 => _storage[1];

  /// Returns the value in the third column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c2 => _storage[2];

  /// Returns the value in the first column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c0 => _storage[3];

  /// Returns the value in the second column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c1 => _storage[4];

  /// Returns the value in the third column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c2 => _storage[5];

  /// Returns the value in the first column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c0 => _storage[6];

  /// Returns the value in the second column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c1 => _storage[7];

  /// Returns the value in the third column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c2 => _storage[8];

  bool get isNonSingular => determinant != 0;

  Iterable<double> get valuesColumnPacked {
    if (_valuesColumnPacked == null) {
      final values = new Float32List(9);

      values[0] = r0c0;
      values[1] = r1c0;
      values[2] = r2c0;
      values[3] = r0c1;
      values[4] = r1c1;
      values[5] = r2c1;
      values[6] = r0c2;
      values[7] = r1c2;
      values[8] = r2c2;

      _valuesColumnPacked = new UnmodifiableListView(values);
    }

    return _valuesColumnPacked;
  }

  Matrix3 get transpose {
    if (_transpose == null) {
      final values = new Float32List(9);

      values[0] = r0c0;
      values[1] = r1c0;
      values[2] = r2c0;
      values[3] = r0c1;
      values[4] = r1c1;
      values[5] = r2c1;
      values[6] = r0c2;
      values[7] = r1c2;
      values[8] = r2c2;

      _transpose = new Matrix3._internal(values);
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
      values[1] = detInv * (r0c2 * r2c1 - r0c1 * r2c2);
      values[2] = detInv * (r0c1 * r1c2 - r0c2 * r1c1);
      values[3] = detInv * (r1c2 * r2c0 - r1c0 * r2c2);
      values[4] = detInv * (r0c0 * r2c2 - r0c2 * r2c0);
      values[5] = detInv * (r0c2 * r1c0 - r0c0 * r1c2);
      values[6] = detInv * (r1c0 * r2c1 - r1c1 * r2c0);
      values[7] = detInv * (r0c1 * r2c0 - r0c0 * r2c1);
      values[8] = detInv * (r0c0 * r1c1 - r0c1 * r1c0);

      _inverse = new Matrix3._internal(values);
    }

    return _inverse;
  }

  Matrix3 scalarProduct(num s) {
    final values = new Float32List(9);

    values[0] = r0c0 * s;
    values[1] = r0c1 * s;
    values[2] = r0c2 * s;
    values[3] = r1c0 * s;
    values[4] = r1c1 * s;
    values[5] = r1c2 * s;
    values[6] = r2c0 * s;
    values[7] = r2c1 * s;
    values[8] = r2c2 * s;

    return new Matrix3._internal(values);
  }

  Matrix3 scalarDivision(num s) {
    final values = new Float32List(9);

    values[0] = r0c0 / s;
    values[1] = r0c1 / s;
    values[2] = r0c2 / s;
    values[3] = r1c0 / s;
    values[4] = r1c1 / s;
    values[5] = r1c2 / s;
    values[6] = r2c0 / s;
    values[7] = r2c1 / s;
    values[8] = r2c2 / s;

    return new Matrix3._internal(values);
  }

  Matrix3 entrywiseSum(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = r0c0 + B.r0c0;
      values[1] = r0c1 + B.r0c1;
      values[2] = r0c2 + B.r0c2;
      values[3] = r1c0 + B.r1c0;
      values[4] = r1c1 + B.r1c1;
      values[5] = r1c2 + B.r1c2;
      values[6] = r2c0 + B.r2c0;
      values[7] = r2c1 + B.r2c1;
      values[8] = r2c2 + B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 + B.valueAt(0, 0);
      values[1] = r0c1 + B.valueAt(0, 1);
      values[2] = r0c2 + B.valueAt(0, 2);
      values[3] = r1c0 + B.valueAt(1, 0);
      values[4] = r1c1 + B.valueAt(1, 1);
      values[5] = r1c2 + B.valueAt(1, 2);
      values[6] = r2c0 + B.valueAt(2, 0);
      values[7] = r2c1 + B.valueAt(2, 1);
      values[8] = r2c2 + B.valueAt(2, 2);
    }

    return new Matrix3._internal(values);
  }

  Matrix3 entrywiseDifference(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = r0c0 - B.r0c0;
      values[1] = r0c1 - B.r0c1;
      values[2] = r0c2 - B.r0c2;
      values[3] = r1c0 - B.r1c0;
      values[4] = r1c1 - B.r1c1;
      values[5] = r1c2 - B.r1c2;
      values[6] = r2c0 - B.r2c0;
      values[7] = r2c1 - B.r2c1;
      values[8] = r2c2 - B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 - B.valueAt(0, 0);
      values[1] = r0c1 - B.valueAt(0, 1);
      values[2] = r0c2 - B.valueAt(0, 2);
      values[3] = r1c0 - B.valueAt(1, 0);
      values[4] = r1c1 - B.valueAt(1, 1);
      values[5] = r1c2 - B.valueAt(1, 2);
      values[6] = r2c0 - B.valueAt(2, 0);
      values[7] = r2c1 - B.valueAt(2, 1);
      values[8] = r2c2 - B.valueAt(2, 2);
    }

    return new Matrix3._internal(values);
  }

  Matrix3 entrywiseProduct(Matrix B) {
    final values = new Float32List(9);

    if (B is Matrix3) {
      values[0] = r0c0 * B.r0c0;
      values[1] = r0c1 * B.r0c1;
      values[2] = r0c2 * B.r0c2;
      values[3] = r1c0 * B.r1c0;
      values[4] = r1c1 * B.r1c1;
      values[5] = r1c2 * B.r1c2;
      values[6] = r2c0 * B.r2c0;
      values[7] = r2c1 * B.r2c1;
      values[8] = r2c2 * B.r2c2;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 * B.valueAt(0, 0);
      values[1] = r0c1 * B.valueAt(0, 1);
      values[2] = r0c2 * B.valueAt(0, 2);
      values[3] = r1c0 * B.valueAt(1, 0);
      values[4] = r1c1 * B.valueAt(1, 1);
      values[5] = r1c2 * B.valueAt(1, 2);
      values[6] = r2c0 * B.valueAt(2, 0);
      values[7] = r2c1 * B.valueAt(2, 1);
      values[8] = r2c2 * B.valueAt(2, 2);
    }

    return new Matrix3._internal(values);
  }

  matrixProduct(Matrix B) {
    if (B is Matrix3) {
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
      values[1] = (m00 * n01) + (m01 * n11) + (m02 * n21);
      values[2] = (m00 * n02) + (m01 * n12) + (m02 * n22);
      values[3] = (m10 * n00) + (m11 * n10) + (m12 * n20);
      values[4] = (m10 * n01) + (m11 * n11) + (m12 * n21);
      values[5] = (m10 * n02) + (m11 * n12) + (m12 * n22);
      values[6] = (m20 * n00) + (m21 * n10) + (m22 * n20);
      values[7] = (m20 * n01) + (m21 * n11) + (m22 * n21);
      values[8] = (m20 * n02) + (m21 * n12) + (m22 * n22);

      return new Matrix3._internal(values);
    } else if (B is Vector3) {
      final n0 = B.x;
      final n1 = B.y;
      final n2 = B.z;

      final values = new Float32List(3);

      values[0] = (r0c0 * n0) + (r0c1 * n1) + (r0c2 * n2);
      values[1] = (r1c0 * n0) + (r1c1 * n1) + (r1c2 * n2);
      values[2] = (r2c0 * n0) + (r2c1 * n1) + (r2c2 * n2);

      return new Vector3._internal(values);
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
}
