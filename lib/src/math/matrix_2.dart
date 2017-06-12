part of math;

/// A 2 by 2 square matrix.
///
///     // Instantiates the following matrix:
///     //
///     //    1.0 2.0
///     //    3.0 4.0
///     //
///     var matrix = new Matrix2(
///       1.0, 2.0,
///       3.0, 4.0
///     );
///
class Matrix2 extends _MatrixBase implements Matrix {
  final Float32List _storage;

  final int columnDimension = 2;

  final int rowDimension = 2;

  final bool isSquare = true;

  Matrix2 _transpose;

  Matrix2 _inverse;

  double _determinant;

  Float32List _valuesRowPacked;

  /// Instantiates a new [Matrix2] from the given values, partitioned into rows
  /// of length 2.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 2.0
  ///     //    3.0 4.0
  ///     //
  ///     var matrix = new Matrix2(
  ///       1.0, 2.0,
  ///       3.0, 4.0
  ///     );
  ///
  factory Matrix2(double val0, double val1, double val2, double val3) {
    final values = new Float32List(4);

    values[0] = val0;
    values[2] = val1;
    values[1] = val2;
    values[3] = val3;

    return new Matrix2._internal(values);
  }

  /// Instantiates a new [Matrix2] from the given [Float32List], partitioned
  /// into columns of length 2.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 3.0
  ///     //    2.0 4.0
  ///     //
  ///     var matrix = new Matrix2([
  ///       1.0, 2.0,
  ///       3.0, 4.0
  ///     ]);
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 4.
  factory Matrix2.fromColumnPackedList(List<double> values) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Matrix2.');
    }

    return new Matrix2._internal(new Float32List.fromList(values));
  }

  /// Instantiates a new [Matrix2] where every position is set to the given
  /// value.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    2.0 2.0
  ///     //    2.0 2.0
  ///     //
  ///     var matrix = new Matrix2.constant(2);
  ///
  factory Matrix2.constant(double value) =>
      new Matrix2._internal(new Float32List(4)..fillRange(0, 4, value));

  /// Instantiates a new [Matrix2] where every position is set to zero.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    0.0 0.0
  ///     //    0.0 0.0
  ///     //
  ///     var matrix = new Matrix2.zero();
  ///
  factory Matrix2.zero() => new Matrix2._internal(new Float32List(4));

  /// Instantiates a new [Matrix2] as an identity matrix.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 0.0
  ///     //    0.0 1.0
  ///     //
  ///     var matrix = new Matrix2.identity();
  ///
  factory Matrix2.identity() {
    final values = new Float32List(4);

    values[0] = 1.0;
    values[3] = 1.0;

    return new Matrix2._internal(values);
  }

  /// Instantiates a [Matrix2] that when multiplied with a [Vector2] translates
  /// it along the X axis by [translation].
  factory Matrix2.translation(double translation) {
    final values = new Float32List(4);

    values[0] = 1.0;
    values[2] = translation;
    values[3] = 1.0;

    return new Matrix2._internal(values);
  }

  /// Instantiates a [Matrix2] that when multiplied with a [Vector2] scales it
  /// by [scaleX] in the X direction, and by [scaleY] in the Y direction.
  factory Matrix2.scale(double scaleX, double scaleY) {
    final values = new Float32List(4);

    values[0] = scaleX;
    values[3] = scaleY;

    return new Matrix2._internal(values);
  }

  /// Instantiates a [Matrix2] that when multiplied with a [Vector2] rotates it
  /// around the origin by [radians].
  factory Matrix2.rotation(double radians) {
    final values = new Float32List(4);
    final sine = sin(radians);
    final cosine = cos(radians);

    values[0] = cosine;
    values[2] = -sine;
    values[1] = sine;
    values[3] = cosine;

    return new Matrix2._internal(values);
  }

  Matrix2._internal(this._storage);

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
  double get r0c1 => _storage[2];

  /// Returns the value in the first column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c0 => _storage[1];

  /// Returns the value in the second column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c1 => _storage[3];

  bool get isNonSingular => determinant != 0;

  Iterable<double> get valuesRowPacked {
    if (_valuesRowPacked == null) {
      _valuesRowPacked = new Float32List(4);

      _valuesRowPacked[0] = r0c0;
      _valuesRowPacked[1] = r0c1;
      _valuesRowPacked[2] = r1c0;
      _valuesRowPacked[3] = r1c1;
    }

    return _valuesRowPacked;
  }

  Matrix2 get transpose {
    if (_transpose == null) {
      final values = new Float32List(4);

      values[0] = r0c0;
      values[1] = r0c1;
      values[2] = r1c0;
      values[3] = r1c1;

      _transpose = new Matrix2._internal(values);
    }

    return _transpose;
  }

  double get determinant {
    if (_determinant == null) {
      _determinant = r0c0 * r1c1 - r1c0 * r0c1;
    }

    return _determinant;
  }

  Matrix2 get inverse {
    if (_inverse == null) {
      final det = determinant;

      if (det == 0) {
        throw new UnsupportedError('This matrix is singular (has no inverse).');
      }

      final detInv = 1 / det;
      final values = new Float32List(4);

      values[0] = detInv * r1c1;
      values[1] = detInv * -r1c0;
      values[2] = detInv * -r0c1;
      values[3] = detInv * r0c0;

      _inverse = new Matrix2._internal(values);
    }

    return _inverse;
  }

  Matrix2 scalarProduct(num s) {
    final values = new Float32List(4);

    values[0] = r0c0 * s;
    values[1] = r1c0 * s;
    values[2] = r0c1 * s;
    values[3] = r1c1 * s;

    return new Matrix2._internal(values);
  }

  Matrix2 scalarDivision(num s) {
    final values = new Float32List(4);

    values[0] = r0c0 / s;
    values[1] = r1c0 / s;
    values[2] = r0c1 / s;
    values[3] = r1c1 / s;

    return new Matrix2._internal(values);
  }

  Matrix2 entrywiseSum(Matrix B) {
    final values = new Float32List(4);

    if (B is Matrix2) {
      values[0] = r0c0 + B.r0c0;
      values[1] = r1c0 + B.r1c0;
      values[2] = r0c1 + B.r0c1;
      values[3] = r1c1 + B.r1c1;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 + B.valueAt(0, 0);
      values[1] = r1c0 + B.valueAt(1, 0);
      values[2] = r0c1 + B.valueAt(0, 1);
      values[3] = r1c1 + B.valueAt(1, 1);
    }

    return new Matrix2._internal(values);
  }

  Matrix2 entrywiseDifference(Matrix B) {
    final values = new Float32List(4);

    if (B is Matrix2) {
      values[0] = r0c0 - B.r0c0;
      values[1] = r1c0 - B.r1c0;
      values[2] = r0c1 - B.r0c1;
      values[3] = r1c1 - B.r1c1;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 - B.valueAt(0, 0);
      values[1] = r1c0 - B.valueAt(1, 0);
      values[2] = r0c1 - B.valueAt(0, 1);
      values[3] = r1c1 - B.valueAt(1, 1);
    }

    return new Matrix2._internal(values);
  }

  Matrix2 entrywiseProduct(Matrix B) {
    final values = new Float32List(4);

    if (B is Matrix2) {
      values[0] = r0c0 * B.r0c0;
      values[1] = r1c0 * B.r1c0;
      values[2] = r0c1 * B.r0c1;
      values[3] = r1c1 * B.r1c1;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 * B.valueAt(0, 0);
      values[1] = r1c0 * B.valueAt(1, 0);
      values[2] = r0c1 * B.valueAt(0, 1);
      values[3] = r1c1 * B.valueAt(1, 1);
    }

    return new Matrix2._internal(values);
  }

  matrixProduct(Matrix B) {
    if (B is Matrix2) {
      final m00 = r0c0;
      final m01 = r0c1;
      final m10 = r1c0;
      final m11 = r1c1;

      final n00 = B.r0c0;
      final n01 = B.r0c1;
      final n10 = B.r1c0;
      final n11 = B.r1c1;

      final values = new Float32List(4);

      values[0] = (m00 * n00) + (m01 * n10);
      values[1] = (m10 * n00) + (m11 * n10);
      values[2] = (m00 * n01) + (m01 * n11);
      values[3] = (m10 * n01) + (m11 * n11);

      return new Matrix2._internal(values);
    } else if (B is Vector2) {
      final n0 = B.x;
      final n1 = B.y;

      return new Vector2((r0c0 * n0) + (r0c1 * n1), (r1c0 * n0) + (r1c1 * n1));
    } else {
      return super.matrixProduct(B);
    }
  }

  Matrix2 operator +(Matrix B) => entrywiseSum(B);

  Matrix2 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix2($r0c0, $r0c1, $r1c0, $r1c1)';
  }

  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    } else if (other is Matrix2) {
      final s = other._storage;

      return _storage[0] == s[0] &&
          _storage[1] == s[1] &&
          _storage[2] == s[2] &&
          _storage[3] == s[3];
    } else {
      return false;
    }
  }
}
