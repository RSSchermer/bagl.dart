part of math;

/// A 4 by 4 square matrix.
///
///     // Instantiates the following matrix:
///     //
///     //     1.0  2.0  3.0  4.0
///     //     5.0  6.0  7.0  8.0
///     //     9.0 10.0 11.0 12.0
///     //    13.0 14.0 15.0 16.0
///     //
///     var matrix = new Matrix4(
///        1.0,  2.0,  3.0,  4.0,
///        5.0,  6.0,  7.0,  8.0,
///        9.0, 10.0, 11.0, 12.0,
///       13.0, 14.0, 15.0, 16.0
///     );
///
class Matrix4 extends GenericMatrix<Matrix4, Matrix4> {
  final Float32List _storage;

  /// Instantiates a new [Matrix4] from the given values, partitioned into rows
  /// of length 4.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //     1.0  2.0  3.0  4.0
  ///     //     5.0  6.0  7.0  8.0
  ///     //     9.0 10.0 11.0 12.0
  ///     //    13.0 14.0 15.0 16.0
  ///     //
  ///     var matrix = new Matrix4(
  ///        1.0,  2.0,  3.0,  4.0,
  ///        5.0,  6.0,  7.0,  8.0,
  ///        9.0, 10.0, 11.0, 12.0,
  ///       13.0, 14.0, 15.0, 16.0
  ///     );
  ///
  factory Matrix4(
      double val0,
      double val1,
      double val2,
      double val3,
      double val4,
      double val5,
      double val6,
      double val7,
      double val8,
      double val9,
      double val10,
      double val11,
      double val12,
      double val13,
      double val14,
      double val15) {
    final values = new Float32List(16);

    values[0] = val0;
    values[1] = val1;
    values[2] = val2;
    values[3] = val3;
    values[4] = val4;
    values[5] = val5;
    values[6] = val6;
    values[7] = val7;
    values[8] = val8;
    values[9] = val9;
    values[10] = val10;
    values[11] = val11;
    values[12] = val12;
    values[13] = val13;
    values[14] = val14;
    values[15] = val15;

    return new Matrix4.fromFloat32List(values);
  }

  /// Instantiates a new [Matrix4] from the given list, partitioned into rows
  /// of length 4.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //     1.0  2.0  3.0  4.0
  ///     //     5.0  6.0  7.0  8.0
  ///     //     9.0 10.0 11.0 12.0
  ///     //    13.0 14.0 15.0 16.0
  ///     //
  ///     var matrix = new Matrix4([
  ///        1.0,  2.0,  3.0,  4.0,
  ///        5.0,  6.0,  7.0,  8.0,
  ///        9.0, 10.0, 11.0, 12.0,
  ///       13.0, 14.0, 15.0, 16.0
  ///     ]);
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 16.
  factory Matrix4.fromList(List<double> values) =>
      new Matrix4.fromFloat32List(new Float32List.fromList(values));

  /// Instantiates a new [Matrix4] from the given [Float32List], partitioned
  /// into rows of length 4.
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 16.
  Matrix4.fromFloat32List(Float32List values)
      : _storage = values,
        super.fromFloat32List(values, 4) {
    if (values.length != 16) {
      throw new ArgumentError(
          'A list of length 16 required to instantiate a Matrix4.');
    }
  }

  /// Instantiates a new [Matrix4] where every position is set to the given
  /// value.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    2.0 2.0 2.0 2.0
  ///     //    2.0 2.0 2.0 2.0
  ///     //    2.0 2.0 2.0 2.0
  ///     //    2.0 2.0 2.0 2.0
  ///     //
  ///     var matrix = new Matrix4.constant(2);
  ///
  factory Matrix4.constant(double value) =>
      new Matrix4.fromFloat32List(new Float32List(16)..fillRange(0, 16, value));

  /// Instantiates a new [Matrix4] where every position is set to zero.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    0.0 0.0 0.0 0.0
  ///     //    0.0 0.0 0.0 0.0
  ///     //    0.0 0.0 0.0 0.0
  ///     //    0.0 0.0 0.0 0.0
  ///     //
  ///     var matrix = new Matrix4.zero();
  ///
  factory Matrix4.zero() => new Matrix4.fromFloat32List(new Float32List(16));

  /// Instantiates a new [Matrix4] as an identity matrix.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 0.0 0.0 0.0
  ///     //    0.0 1.0 0.0 0.0
  ///     //    0.0 0.0 1.0 0.0
  ///     //    0.0 0.0 0.0 1.0
  ///     //
  ///     var matrix = new Matrix4.identity();
  ///
  factory Matrix4.identity() {
    final values = new Float32List(16);

    values[0] = 1.0;
    values[1] = 0.0;
    values[2] = 0.0;
    values[3] = 0.0;
    values[4] = 0.0;
    values[5] = 1.0;
    values[6] = 0.0;
    values[7] = 0.0;
    values[8] = 0.0;
    values[9] = 0.0;
    values[10] = 1.0;
    values[11] = 0.0;
    values[12] = 0.0;
    values[13] = 0.0;
    values[14] = 0.0;
    values[15] = 1.0;

    return new Matrix4.fromFloat32List(values);
  }

  Matrix4 withValues(Float32List newValues) =>
      new Matrix4.fromFloat32List(newValues);

  Matrix4 transposeWithValues(Float32List newValues) =>
      new Matrix4.fromFloat32List(newValues);

  matrixProduct(GenericMatrix B) {
    if (B is Matrix4) {
      final m00 = _storage[0];
      final m01 = _storage[1];
      final m02 = _storage[2];
      final m03 = _storage[3];
      final m10 = _storage[4];
      final m11 = _storage[5];
      final m12 = _storage[6];
      final m13 = _storage[7];
      final m20 = _storage[8];
      final m21 = _storage[9];
      final m22 = _storage[10];
      final m23 = _storage[11];
      final m30 = _storage[12];
      final m31 = _storage[13];
      final m32 = _storage[14];
      final m33 = _storage[15];

      final bStorage = B._storage;

      final n00 = bStorage[0];
      final n01 = bStorage[1];
      final n02 = bStorage[2];
      final n03 = bStorage[3];
      final n10 = bStorage[4];
      final n11 = bStorage[5];
      final n12 = bStorage[6];
      final n13 = bStorage[7];
      final n20 = bStorage[8];
      final n21 = bStorage[9];
      final n22 = bStorage[10];
      final n23 = bStorage[11];
      final n30 = bStorage[12];
      final n31 = bStorage[13];
      final n32 = bStorage[14];
      final n33 = bStorage[15];

      final values = new Float32List(16);

      values[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
      values[1] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
      values[2] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
      values[3] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
      values[4] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
      values[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
      values[6] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
      values[7] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
      values[8] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
      values[9] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
      values[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
      values[11] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
      values[12] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
      values[13] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
      values[14] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
      values[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);

      return new Matrix4.fromFloat32List(values);
    } else if (B is Vector4) {
      final bStorage = B._storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];
      final n2 = bStorage[2];
      final n3 = bStorage[3];

      final s = _storage;
      final values = new Float32List(4);

      values[0] = (s[0] * n0) + (s[1] * n1) + (s[2] * n2) + (s[3] * n3);
      values[1] = (s[4] * n0) + (s[5] * n1) + (s[6] * n2) + (s[7] * n3);
      values[2] = (s[8] * n0) + (s[9] * n1) + (s[10] * n2) + (s[11] * n3);
      values[3] = (s[12] * n0) + (s[13] * n1) + (s[14] * n2) + (s[15] * n3);

      return new Vector4.fromFloat32List(values);
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

  /// Returns the value in the fourth column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c3 => _storage[3];

  /// Returns the value in the first column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c0 => _storage[4];

  /// Returns the value in the second column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c1 => _storage[5];

  /// Returns the value in the third column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c2 => _storage[6];

  /// Returns the value in the fourth column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c3 => _storage[7];

  /// Returns the value in the first column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c0 => _storage[8];

  /// Returns the value in the second column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c1 => _storage[9];

  /// Returns the value in the third column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c2 => _storage[10];

  /// Returns the value in the fourth column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c3 => _storage[11];

  /// Returns the value in the first column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c0 => _storage[12];

  /// Returns the value in the second column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c1 => _storage[13];

  /// Returns the value in the third column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c2 => _storage[14];

  /// Returns the value in the fourth column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c3 => _storage[15];

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix4(${values.toString()})';
  }
}
