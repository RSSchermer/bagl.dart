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
class Matrix2 extends GenericMatrix<Matrix2, Matrix2> {
  final Float32List _storage;

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
    values[1] = val1;
    values[2] = val2;
    values[3] = val3;

    return new Matrix2.fromFloat32List(values);
  }

  /// Instantiates a new [Matrix2] from the given [Float32List], partitioned
  /// into rows of length 2.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 2.0
  ///     //    3.0 4.0
  ///     //
  ///     var matrix = new Matrix2([
  ///       1.0, 2.0,
  ///       3.0, 4.0
  ///     ]);
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 4.
  factory Matrix2.fromList(List<double> values) =>
      new Matrix2.fromFloat32List(new Float32List.fromList(values));

  /// Instantiates a new [Matrix2] from the given list, partitioned into rows
  /// of length 2.
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 4.
  Matrix2.fromFloat32List(Float32List values)
      : _storage = values,
        super.fromFloat32List(values, 2) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Matrix2.');
    }
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
      new Matrix2.fromFloat32List(new Float32List(4)..fillRange(0, 4, value));

  /// Instantiates a new [Matrix2] where every position is set to zero.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    0.0 0.0
  ///     //    0.0 0.0
  ///     //
  ///     var matrix = new Matrix2.zero();
  ///
  factory Matrix2.zero() => new Matrix2.fromFloat32List(new Float32List(4));

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

    return new Matrix2.fromFloat32List(values);
  }

  /// Instantiates a [Matrix2] that when multiplied with a [Vector2] translates
  /// it along the X axis by [translation].
  factory Matrix2.translation(double translation) {
    final values = new Float32List(4);

    values[0] = 1.0;
    values[1] = translation;
    values[3] = 1.0;

    return new Matrix2.fromFloat32List(values);
  }

  /// Instantiates a [Matrix2] that when multiplied with a [Vector2] scales it
  /// by [scaleX] in the X direction, and by [scaleY] in the Y direction.
  factory Matrix2.scale(double scaleX, double scaleY) {
    final values = new Float32List(4);

    values[0] = scaleX;
    values[3] = scaleY;

    return new Matrix2.fromFloat32List(values);
  }

  /// Instantiates a [Matrix2] that when multiplied with a [Vector2] rotates it
  /// around the origin by [radians].
  factory Matrix2.rotation(double radians) {
    final values = new Float32List(4);
    final sine = sin(radians);
    final cosine = cos(radians);

    values[0] = cosine;
    values[1] = -sine;
    values[2] = sine;
    values[3] = cosine;

    return new Matrix2.fromFloat32List(values);
  }

  Matrix2 withValues(Float32List newValues) =>
      new Matrix2.fromFloat32List(newValues);

  Matrix2 transposeWithValues(Float32List newValues) =>
      new Matrix2.fromFloat32List(newValues);

  matrixProduct(GenericMatrix B) {
    if (B is Matrix2) {
      final m00 = _storage[0];
      final m01 = _storage[1];
      final m10 = _storage[2];
      final m11 = _storage[3];

      final bStorage = B._storage;

      final n00 = bStorage[0];
      final n01 = bStorage[1];
      final n10 = bStorage[2];
      final n11 = bStorage[3];

      final values = new Float32List(4);

      values[0] = (m00 * n00) + (m01 * n10);
      values[1] = (m00 * n01) + (m01 * n11);
      values[2] = (m10 * n00) + (m11 * n10);
      values[3] = (m10 * n01) + (m11 * n11);

      return new Matrix2.fromFloat32List(values);
    } else if (B is Vector2) {
      final bStorage = B._storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];

      final s = _storage;
      final values = new Float32List(2);

      values[0] = (s[0] * n0) + (s[1] * n1);
      values[1] = (s[2] * n0) + (s[3] * n1);

      return new Vector2.fromFloat32List(values);
    } else {
      return super.matrixProduct(B);
    }
  }

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

  /// Returns the value in the first column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c0 => _storage[2];

  /// Returns the value in the second column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c1 => _storage[3];

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix2(${values.toString()})';
  }
}
