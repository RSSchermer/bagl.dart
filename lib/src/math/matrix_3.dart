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
class Matrix3 extends GenericMatrix<Matrix3, Matrix3> {
  final Float32List _storage;

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

    return new Matrix3.fromFloat32List(values);
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
  factory Matrix3.fromList(List<double> values) =>
      new Matrix3.fromFloat32List(new Float32List.fromList(values));

  /// Instantiates a new [Matrix3] from the given [Float32List], partitioned
  /// into rows of length 3.
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 9.
  Matrix3.fromFloat32List(Float32List values)
      : _storage = values,
        super.fromFloat32List(values, 3) {
    if (values.length != 9) {
      throw new ArgumentError(
          'A list of length 9 required to instantiate a Matrix3.');
    }
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
      new Matrix3.fromFloat32List(new Float32List(9)..fillRange(0, 9, value));

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
  factory Matrix3.zero() => new Matrix3.fromFloat32List(new Float32List(9));

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
    values[1] = 0.0;
    values[2] = 0.0;
    values[3] = 0.0;
    values[4] = 1.0;
    values[5] = 0.0;
    values[6] = 0.0;
    values[7] = 0.0;
    values[8] = 1.0;

    return new Matrix3.fromFloat32List(values);
  }

  Matrix3 withValues(Float32List newValues) =>
      new Matrix3.fromFloat32List(newValues);

  Matrix3 transposeWithValues(Float32List newValues) =>
      new Matrix3.fromFloat32List(newValues);

  matrixProduct(GenericMatrix B) {
    if (B is Matrix3) {
      final m00 = _storage[0];
      final m01 = _storage[1];
      final m02 = _storage[2];
      final m10 = _storage[3];
      final m11 = _storage[4];
      final m12 = _storage[5];
      final m20 = _storage[6];
      final m21 = _storage[7];
      final m22 = _storage[8];

      final bStorage = B._storage;

      final n00 = bStorage[0];
      final n01 = bStorage[1];
      final n02 = bStorage[2];
      final n10 = bStorage[3];
      final n11 = bStorage[4];
      final n12 = bStorage[5];
      final n20 = bStorage[6];
      final n21 = bStorage[7];
      final n22 = bStorage[8];

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

      return new Matrix3.fromFloat32List(values);
    } else if (B is Vector3) {
      final bStorage = B._storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];
      final n2 = bStorage[2];

      final s = _storage;
      final values = new Float32List(3);

      values[0] = (s[0] * n0) + (s[1] * n1) + (s[2] * n2);
      values[1] = (s[3] * n0) + (s[4] * n1) + (s[5] * n2);
      values[2] = (s[6] * n0) + (s[7] * n1) + (s[8] * n2);

      return new Vector3.fromFloat32List(values);
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

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix3(${values.toString()})';
  }
}
