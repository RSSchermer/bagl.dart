part of bagl.math;

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
abstract class Matrix4 implements Matrix {
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
      double r0c0,
      double r0c1,
      double r0c2,
      double r0c3,
      double r1c0,
      double r1c1,
      double r1c2,
      double r1c3,
      double r2c0,
      double r2c1,
      double r2c2,
      double r2c3,
      double r3c0,
      double r3c1,
      double r3c2,
      double r3c3) = _Matrix4;

  /// Instantiates a new [Matrix4] from the given list, partitioned into rows
  /// of length 4.
  ///
  ///     // Instantiates the following matrix:
  ///     //
  ///     //    1.0 5.0  9.0 13.0
  ///     //    2.0 6.0 10.0 14.0
  ///     //    3.0 7.0 11.0 15.0
  ///     //    4.0 8.0 12.0 16.0
  ///     //
  ///     var matrix = new Matrix4([
  ///        1.0,  2.0,  3.0,  4.0,
  ///        5.0,  6.0,  7.0,  8.0,
  ///        9.0, 10.0, 11.0, 12.0,
  ///       13.0, 14.0, 15.0, 16.0
  ///     ]);
  ///
  /// Throws an [ArgumentError] if the list does not have a length of 16.
  factory Matrix4.fromColumnPackedList(List<double> values) =
      _Matrix4.fromColumnPackedList;

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
  factory Matrix4.constant(double value) = _Matrix4.constant;

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
  factory Matrix4.zero() = _Matrix4.zero;

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
  const factory Matrix4.identity() = _Matrix4Identity;

  /// Instantiates a [Matrix4] that when multiplied with a [Vector4] translates
  /// it by [translateX] in the X direction, by [translateY] in the Y direction,
  /// and by [translateZ] in the Z direction.
  factory Matrix4.translation(
          double translateX, double translateY, double translateZ) =
      _Matrix4.translation;

  /// Instantiates a [Matrix4] that when multiplied with a [Vector4] scales it
  /// by [scaleX] in the X direction, by [scaleY] in the Y direction, and by
  /// [scaleZ] in the Z direction.
  factory Matrix4.scale(double scaleX, double scaleY, double scaleZ) =
      _Matrix4.scale;

  /// Instantiates a [Matrix4] that when multiplied with a [Vector4] will rotate
  /// it around the [axis] by [radians].
  factory Matrix4.rotation(Vector3 axis, double radians) = _Matrix4.rotation;

  /// Instantiates a [Matrix4] that when multiplied with a [Vector4] will rotate
  /// it around the X axis by [radians].
  factory Matrix4.rotationX(double radians) = _Matrix4.rotationX;

  /// Instantiates a [Matrix4] that when multiplied with a [Vector4] will rotate
  /// it around the Y axis by [radians].
  factory Matrix4.rotationY(double radians) = _Matrix4.rotationY;

  /// Instantiates a [Matrix4] that when multiplied with a [Vector4] will rotate
  /// it around the Z axis by [radians].
  factory Matrix4.rotationZ(double radians) = _Matrix4.rotationZ;

  /// Instantiates a new [Matrix4] as a frustum projection matrix for a frustum
  /// for which the near plane is the rectangle defined by [left], [right],
  /// [bottom] and [top] at [near] distance and the far plane at [far] distance.
  ///
  /// A frustum projection matrix projects coordinates inside a frustum onto
  /// clip coordinates.
  factory Matrix4.frustum(double left, double right, double bottom, double top,
      double near, double far) = _Matrix4.frustum;

  /// Instantiates a new [Matrix4] as a perspective projection matrix for a
  /// view frustum with a field-of-view of [fovRadians], a `width / height`
  /// aspect ratio of [aspectRatio], the near frustum plane at a distance of
  /// [near] and the far frustum plane at a distance of [far].
  ///
  /// A perspective projection matrix projects coordinates inside its view
  /// frustum onto clip coordinates.
  factory Matrix4.perspective(
          double fovRadians, double aspectRatio, double near, double far) =
      _Matrix4.perspective;

  /// Instantiates a new [Matrix4] as an orthographic projection matrix for a
  /// view cuboid for which the near plane is the rectangle defined by [left],
  /// [right], [bottom] and [top] at [near] distance and the far plane at [far]
  /// distance.
  ///
  /// An orthographic projection matrix project coordinates inside its view
  /// cuboid onto clip coordinates.
  factory Matrix4.orthographic(double left, double right, double top,
      double bottom, double near, double far) = _Matrix4.orthographic;

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

  /// Returns the value in the fourth column of the first row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r0c3;

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

  /// Returns the value in the fourth column of the second row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r1c3;

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

  /// Returns the value in the fourth column of the third row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r2c3;

  /// Returns the value in the first column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c0;

  /// Returns the value in the second column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c1;

  /// Returns the value in the third column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c2;

  /// Returns the value in the fourth column of the fourth row.
  ///
  /// This should provide better performance than using [valueAt] or the array
  /// operator `[]` to retrieve a specific value, as no bounds checks need to
  /// be performed on value indices.
  double get r3c3;

  /// Returns the row at the specified index.
  ///
  /// Throws a [RangeError] if the specified index is out of bounds.
  List<double> operator [](int index);
}

class _Matrix4 extends _MatrixBase implements Matrix4 {
  final Float32List _storage;

  final int columnDimension = 4;

  final int rowDimension = 4;

  final bool isSquare = true;

  Matrix4 _transpose;

  Matrix4 _inverse;

  double _determinant;

  Float32List _valuesRowPacked;

  factory _Matrix4(
      double r0c0,
      double r0c1,
      double r0c2,
      double r0c3,
      double r1c0,
      double r1c1,
      double r1c2,
      double r1c3,
      double r2c0,
      double r2c1,
      double r2c2,
      double r2c3,
      double r3c0,
      double r3c1,
      double r3c2,
      double r3c3) {
    final values = new Float32List(16);

    values[0] = r0c0;
    values[1] = r1c0;
    values[2] = r2c0;
    values[3] = r3c0;
    values[4] = r0c1;
    values[5] = r1c1;
    values[6] = r2c1;
    values[7] = r3c1;
    values[8] = r0c2;
    values[9] = r1c2;
    values[10] = r2c2;
    values[11] = r3c2;
    values[12] = r0c3;
    values[13] = r1c3;
    values[14] = r2c3;
    values[15] = r3c3;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.fromColumnPackedList(List<double> values) {
    if (values.length != 16) {
      throw new ArgumentError(
          'A list of length 16 required to instantiate a Matrix4.');
    }

    return new _Matrix4._internal(new Float32List.fromList(values));
  }

  factory _Matrix4.constant(double value) =>
      new _Matrix4._internal(new Float32List(16)..fillRange(0, 16, value));

  factory _Matrix4.zero() => new _Matrix4._internal(new Float32List(16));

  factory _Matrix4.translation(
      double translateX, double translateY, double translateZ) {
    final values = new Float32List(16);

    values[0] = 1.0;
    values[5] = 1.0;
    values[10] = 1.0;
    values[12] = translateX;
    values[13] = translateY;
    values[14] = translateZ;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.scale(double scaleX, double scaleY, double scaleZ) {
    final values = new Float32List(16);

    values[0] = scaleX;
    values[5] = scaleY;
    values[10] = scaleZ;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.rotation(Vector3 axis, double radians) {
    final values = new Float32List(16);
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
    values[4] = tx * y - s * z;
    values[5] = ty * y + c;
    values[6] = ty * z + s * x;
    values[8] = tx * z + s * y;
    values[9] = ty * z - s * x;
    values[10] = t * z * z + c;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.rotationX(double radians) {
    final values = new Float32List(16);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = 1.0;
    values[5] = c;
    values[6] = s;
    values[9] = -s;
    values[10] = c;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.rotationY(double radians) {
    final values = new Float32List(16);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = c;
    values[2] = -s;
    values[5] = 1.0;
    values[8] = s;
    values[10] = c;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.rotationZ(double radians) {
    final values = new Float32List(16);
    final c = cos(radians);
    final s = sin(radians);

    values[0] = c;
    values[1] = s;
    values[4] = -s;
    values[5] = c;
    values[10] = 1.0;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.frustum(double left, double right, double bottom, double top,
      double near, double far) {
    final values = new Float32List(16);
    final x = 2.0 * near / (right - left);
    final y = 2.0 * near / (top - bottom);
    final a = (right + left) / (right - left);
    final b = (top + bottom) / (top - bottom);
    final c = -(far + near) / (far - near);
    final d = -2.0 * far * near / (far - near);

    values[0] = x;
    values[5] = y;
    values[8] = a;
    values[9] = b;
    values[10] = c;
    values[11] = -1.0;
    values[14] = d;

    return new _Matrix4._internal(values);
  }

  factory _Matrix4.perspective(
      double fovRadians, double aspectRatio, double near, double far) {
    final yMax = near * tan(fovRadians / 2.0);
    final yMin = -yMax;
    final xMin = yMin * aspectRatio;
    final xMax = yMax * aspectRatio;

    return new _Matrix4.frustum(xMin, xMax, yMin, yMax, near, far);
  }

  factory _Matrix4.orthographic(double left, double right, double top,
      double bottom, double near, double far) {
    final values = new Float32List(16);
    final w = 1.0 / (right - left);
    final h = 1.0 / (top - bottom);
    final p = 1.0 / (far - near);
    final x = (right + left) * w;
    final y = (top + bottom) * h;
    final z = (far + near) * p;

    values[0] = 2.0 * w;
    values[5] = 2.0 * h;
    values[10] = -2.0 * p;
    values[12] = -x;
    values[13] = -y;
    values[14] = -z;
    values[15] = 1.0;

    return new _Matrix4._internal(values);
  }

  _Matrix4._internal(this._storage);

  double get r0c0 => _storage[0];

  double get r0c1 => _storage[4];

  double get r0c2 => _storage[8];

  double get r0c3 => _storage[12];

  double get r1c0 => _storage[1];

  double get r1c1 => _storage[5];

  double get r1c2 => _storage[9];

  double get r1c3 => _storage[13];

  double get r2c0 => _storage[2];

  double get r2c1 => _storage[6];

  double get r2c2 => _storage[10];

  double get r2c3 => _storage[14];

  double get r3c0 => _storage[3];

  double get r3c1 => _storage[7];

  double get r3c2 => _storage[11];

  double get r3c3 => _storage[15];

  bool get isNonSingular => determinant != 0;

  Iterable<double> get valuesRowPacked {
    if (_valuesRowPacked == null) {
      _valuesRowPacked = new Float32List(16);

      _valuesRowPacked[0] = r0c0;
      _valuesRowPacked[1] = r0c1;
      _valuesRowPacked[2] = r0c2;
      _valuesRowPacked[3] = r0c3;
      _valuesRowPacked[4] = r1c0;
      _valuesRowPacked[5] = r1c1;
      _valuesRowPacked[6] = r1c2;
      _valuesRowPacked[7] = r1c3;
      _valuesRowPacked[8] = r2c0;
      _valuesRowPacked[9] = r2c1;
      _valuesRowPacked[10] = r2c2;
      _valuesRowPacked[11] = r2c3;
      _valuesRowPacked[12] = r3c0;
      _valuesRowPacked[13] = r3c1;
      _valuesRowPacked[14] = r3c2;
      _valuesRowPacked[15] = r3c3;
    }

    return _valuesRowPacked;
  }

  Matrix4 get transpose {
    if (_transpose == null) {
      final values = new Float32List(16);

      values[0] = r0c0;
      values[1] = r0c1;
      values[2] = r0c2;
      values[3] = r0c3;
      values[4] = r1c0;
      values[5] = r1c1;
      values[6] = r1c2;
      values[7] = r1c3;
      values[8] = r2c0;
      values[9] = r2c1;
      values[10] = r2c2;
      values[11] = r2c3;
      values[12] = r3c0;
      values[13] = r3c1;
      values[14] = r3c2;
      values[15] = r3c3;

      _transpose = new _Matrix4._internal(values);
    }

    return _transpose;
  }

  double get determinant {
    if (_determinant == null) {
      final det2_01_01 = r0c0 * r1c1 - r1c0 * r0c1;
      final det2_01_02 = r0c0 * r2c1 - r2c0 * r0c1;
      final det2_01_03 = r0c0 * r3c1 - r3c0 * r0c1;
      final det2_01_12 = r1c0 * r2c1 - r2c0 * r1c1;
      final det2_01_13 = r1c0 * r3c1 - r3c0 * r1c1;
      final det2_01_23 = r2c0 * r3c1 - r3c0 * r2c1;

      final det3_201_012 =
          r0c2 * det2_01_12 - r1c2 * det2_01_02 + r2c2 * det2_01_01;
      final det3_201_013 =
          r0c2 * det2_01_13 - r1c2 * det2_01_03 + r3c2 * det2_01_01;
      final det3_201_023 =
          r0c2 * det2_01_23 - r2c2 * det2_01_03 + r3c2 * det2_01_02;
      final det3_201_123 =
          r1c2 * det2_01_23 - r2c2 * det2_01_13 + r3c2 * det2_01_12;

      _determinant = -det3_201_123 * r0c3 +
          det3_201_023 * r1c3 -
          det3_201_013 * r2c3 +
          det3_201_012 * r3c3;
    }

    return _determinant;
  }

  Matrix4 get inverse {
    if (_inverse == null) {
      final b00 = r0c0 * r1c1 - r1c0 * r0c1;
      final b01 = r0c0 * r2c1 - r2c0 * r0c1;
      final b02 = r0c0 * r3c1 - r3c0 * r0c1;
      final b03 = r1c0 * r2c1 - r2c0 * r1c1;
      final b04 = r1c0 * r3c1 - r3c0 * r1c1;
      final b05 = r2c0 * r3c1 - r3c0 * r2c1;
      final b06 = r0c2 * r1c3 - r1c2 * r0c3;
      final b07 = r0c2 * r2c3 - r2c2 * r0c3;
      final b08 = r0c2 * r3c3 - r3c2 * r0c3;
      final b09 = r1c2 * r2c3 - r2c2 * r1c3;
      final b10 = r1c2 * r3c3 - r3c2 * r1c3;
      final b11 = r2c2 * r3c3 - r3c2 * r2c3;

      final det = _determinant ??
          b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

      if (det == 0) {
        throw new UnsupportedError('This matrix is singular (has no inverse).');
      }

      final detInv = 1.0 / det;
      final values = new Float32List(16);

      values[0] = detInv * (r1c1 * b11 - r2c1 * b10 + r3c1 * b09);
      values[1] = detInv * (-r1c0 * b11 + r2c0 * b10 - r3c0 * b09);
      values[2] = detInv * (r1c3 * b05 - r2c3 * b04 + r3c3 * b03);
      values[3] = detInv * (-r1c2 * b05 + r2c2 * b04 - r3c2 * b03);
      values[4] = detInv * (-r0c1 * b11 + r2c1 * b08 - r3c1 * b07);
      values[5] = detInv * (r0c0 * b11 - r2c0 * b08 + r3c0 * b07);
      values[6] = detInv * (-r0c3 * b05 + r2c3 * b02 - r3c3 * b01);
      values[7] = detInv * (r0c2 * b05 - r2c2 * b02 + r3c2 * b01);
      values[8] = detInv * (r0c1 * b10 - r1c1 * b08 + r3c1 * b06);
      values[9] = detInv * (-r0c0 * b10 + r1c0 * b08 - r3c0 * b06);
      values[10] = detInv * (r0c3 * b04 - r1c3 * b02 + r3c3 * b00);
      values[11] = detInv * (-r0c2 * b04 + r1c2 * b02 - r3c2 * b00);
      values[12] = detInv * (-r0c1 * b09 + r1c1 * b07 - r2c1 * b06);
      values[13] = detInv * (r0c0 * b09 - r1c0 * b07 + r2c0 * b06);
      values[14] = detInv * (-r0c3 * b03 + r1c3 * b01 - r2c3 * b00);
      values[15] = detInv * (r0c2 * b03 - r1c2 * b01 + r2c2 * b00);

      _inverse = new _Matrix4._internal(values);
    }

    return _inverse;
  }

  Matrix4 scalarProduct(num s) {
    final values = new Float32List(16);

    values[0] = r0c0 * s;
    values[1] = r1c0 * s;
    values[2] = r2c0 * s;
    values[3] = r3c0 * s;
    values[4] = r0c1 * s;
    values[5] = r1c1 * s;
    values[6] = r2c1 * s;
    values[7] = r3c1 * s;
    values[8] = r0c2 * s;
    values[9] = r1c2 * s;
    values[10] = r2c2 * s;
    values[11] = r3c2 * s;
    values[12] = r0c3 * s;
    values[13] = r1c3 * s;
    values[14] = r2c3 * s;
    values[15] = r3c3 * s;

    return new _Matrix4._internal(values);
  }

  Matrix4 scalarDivision(num s) {
    final values = new Float32List(16);

    values[0] = r0c0 / s;
    values[1] = r1c0 / s;
    values[2] = r2c0 / s;
    values[3] = r3c0 / s;
    values[4] = r0c1 / s;
    values[5] = r1c1 / s;
    values[6] = r2c1 / s;
    values[7] = r3c1 / s;
    values[8] = r0c2 / s;
    values[9] = r1c2 / s;
    values[10] = r2c2 / s;
    values[11] = r3c2 / s;
    values[12] = r0c3 / s;
    values[13] = r1c3 / s;
    values[14] = r2c3 / s;
    values[15] = r3c3 / s;

    return new _Matrix4._internal(values);
  }

  Matrix4 entrywiseSum(Matrix B) {
    final values = new Float32List(16);

    if (B is Matrix4) {
      values[0] = r0c0 + B.r0c0;
      values[1] = r1c0 + B.r1c0;
      values[2] = r2c0 + B.r2c0;
      values[3] = r3c0 + B.r3c0;
      values[4] = r0c1 + B.r0c1;
      values[5] = r1c1 + B.r1c1;
      values[6] = r2c1 + B.r2c1;
      values[7] = r3c1 + B.r3c1;
      values[8] = r0c2 + B.r0c2;
      values[9] = r1c2 + B.r1c2;
      values[10] = r2c2 + B.r2c2;
      values[11] = r3c2 + B.r3c2;
      values[12] = r0c3 + B.r0c3;
      values[13] = r1c3 + B.r1c3;
      values[14] = r2c3 + B.r2c3;
      values[15] = r3c3 + B.r3c3;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 + B.valueAt(0, 0);
      values[1] = r1c0 + B.valueAt(1, 0);
      values[2] = r2c0 + B.valueAt(2, 0);
      values[3] = r3c0 + B.valueAt(3, 0);
      values[4] = r0c1 + B.valueAt(0, 1);
      values[5] = r1c1 + B.valueAt(1, 1);
      values[6] = r2c1 + B.valueAt(2, 1);
      values[7] = r3c1 + B.valueAt(3, 1);
      values[8] = r0c2 + B.valueAt(0, 2);
      values[9] = r1c2 + B.valueAt(1, 2);
      values[10] = r2c2 + B.valueAt(2, 2);
      values[11] = r3c2 + B.valueAt(3, 2);
      values[12] = r0c3 + B.valueAt(0, 3);
      values[13] = r1c3 + B.valueAt(1, 3);
      values[14] = r2c3 + B.valueAt(2, 3);
      values[15] = r3c3 + B.valueAt(3, 3);
    }

    return new _Matrix4._internal(values);
  }

  Matrix4 entrywiseDifference(Matrix B) {
    final values = new Float32List(16);

    if (B is Matrix4) {
      values[0] = r0c0 - B.r0c0;
      values[1] = r1c0 - B.r1c0;
      values[2] = r2c0 - B.r2c0;
      values[3] = r3c0 - B.r3c0;
      values[4] = r0c1 - B.r0c1;
      values[5] = r1c1 - B.r1c1;
      values[6] = r2c1 - B.r2c1;
      values[7] = r3c1 - B.r3c1;
      values[8] = r0c2 - B.r0c2;
      values[9] = r1c2 - B.r1c2;
      values[10] = r2c2 - B.r2c2;
      values[11] = r3c2 - B.r3c2;
      values[12] = r0c3 - B.r0c3;
      values[13] = r1c3 - B.r1c3;
      values[14] = r2c3 - B.r2c3;
      values[15] = r3c3 - B.r3c3;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 - B.valueAt(0, 0);
      values[1] = r1c0 - B.valueAt(1, 0);
      values[2] = r2c0 - B.valueAt(2, 0);
      values[3] = r3c0 - B.valueAt(3, 0);
      values[4] = r0c1 - B.valueAt(0, 1);
      values[5] = r1c1 - B.valueAt(1, 1);
      values[6] = r2c1 - B.valueAt(2, 1);
      values[7] = r3c1 - B.valueAt(3, 1);
      values[8] = r0c2 - B.valueAt(0, 2);
      values[9] = r1c2 - B.valueAt(1, 2);
      values[10] = r2c2 - B.valueAt(2, 2);
      values[11] = r3c2 - B.valueAt(3, 2);
      values[12] = r0c3 - B.valueAt(0, 3);
      values[13] = r1c3 - B.valueAt(1, 3);
      values[14] = r2c3 - B.valueAt(2, 3);
      values[15] = r3c3 - B.valueAt(3, 3);
    }

    return new _Matrix4._internal(values);
  }

  Matrix4 entrywiseProduct(Matrix B) {
    final values = new Float32List(16);

    if (B is Matrix4) {
      values[0] = r0c0 * B.r0c0;
      values[1] = r1c0 * B.r1c0;
      values[2] = r2c0 * B.r2c0;
      values[3] = r3c0 * B.r3c0;
      values[4] = r0c1 * B.r0c1;
      values[5] = r1c1 * B.r1c1;
      values[6] = r2c1 * B.r2c1;
      values[7] = r3c1 * B.r3c1;
      values[8] = r0c2 * B.r0c2;
      values[9] = r1c2 * B.r1c2;
      values[10] = r2c2 * B.r2c2;
      values[11] = r3c2 * B.r3c2;
      values[12] = r0c3 * B.r0c3;
      values[13] = r1c3 * B.r1c3;
      values[14] = r2c3 * B.r2c3;
      values[15] = r3c3 * B.r3c3;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = r0c0 * B.valueAt(0, 0);
      values[1] = r1c0 * B.valueAt(1, 0);
      values[2] = r2c0 * B.valueAt(2, 0);
      values[3] = r3c0 * B.valueAt(3, 0);
      values[4] = r0c1 * B.valueAt(0, 1);
      values[5] = r1c1 * B.valueAt(1, 1);
      values[6] = r2c1 * B.valueAt(2, 1);
      values[7] = r3c1 * B.valueAt(3, 1);
      values[8] = r0c2 * B.valueAt(0, 2);
      values[9] = r1c2 * B.valueAt(1, 2);
      values[10] = r2c2 * B.valueAt(2, 2);
      values[11] = r3c2 * B.valueAt(3, 2);
      values[12] = r0c3 * B.valueAt(0, 3);
      values[13] = r1c3 * B.valueAt(1, 3);
      values[14] = r2c3 * B.valueAt(2, 3);
      values[15] = r3c3 * B.valueAt(3, 3);
    }

    return new _Matrix4._internal(values);
  }

  matrixProduct(Matrix B) {
    if (B is _Matrix4) {
      final m00 = r0c0;
      final m01 = r0c1;
      final m02 = r0c2;
      final m03 = r0c3;
      final m10 = r1c0;
      final m11 = r1c1;
      final m12 = r1c2;
      final m13 = r1c3;
      final m20 = r2c0;
      final m21 = r2c1;
      final m22 = r2c2;
      final m23 = r2c3;
      final m30 = r3c0;
      final m31 = r3c1;
      final m32 = r3c2;
      final m33 = r3c3;

      final n00 = B.r0c0;
      final n01 = B.r0c1;
      final n02 = B.r0c2;
      final n03 = B.r0c3;
      final n10 = B.r1c0;
      final n11 = B.r1c1;
      final n12 = B.r1c2;
      final n13 = B.r1c3;
      final n20 = B.r2c0;
      final n21 = B.r2c1;
      final n22 = B.r2c2;
      final n23 = B.r2c3;
      final n30 = B.r3c0;
      final n31 = B.r3c1;
      final n32 = B.r3c2;
      final n33 = B.r3c3;

      final values = new Float32List(16);

      values[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30);
      values[1] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30);
      values[2] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30);
      values[3] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30);
      values[4] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31);
      values[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31);
      values[6] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31);
      values[7] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31);
      values[8] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32);
      values[9] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32);
      values[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32);
      values[11] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32);
      values[12] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33);
      values[13] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33);
      values[14] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33);
      values[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33);

      return new _Matrix4._internal(values);
    } else if (B is Vector4) {
      final n0 = B.x;
      final n1 = B.y;
      final n2 = B.z;
      final n3 = B.w;

      return new Vector4(
          (r0c0 * n0) + (r0c1 * n1) + (r0c2 * n2) + (r0c3 * n3),
          (r1c0 * n0) + (r1c1 * n1) + (r1c2 * n2) + (r1c3 * n3),
          (r2c0 * n0) + (r2c1 * n1) + (r2c2 * n2) + (r2c3 * n3),
          (r3c0 * n0) + (r3c1 * n1) + (r3c2 * n2) + (r3c3 * n3));
    } else if (B is _Matrix4Identity) {
      return this;
    } else {
      return super.matrixProduct(B);
    }
  }

  Matrix4 operator +(Matrix B) => entrywiseSum(B);

  Matrix4 operator -(Matrix B) => entrywiseDifference(B);

  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix4($r0c0, $r0c1, $r0c2, $r0c3, $r1c0, $r1c1, $r1c2, $r1c3, '
        '$r2c0, $r2c1, $r2c2, $r2c3, $r3c0, $r3c1, $r3c2, $r3c3)';
  }

  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _Matrix4) {
      final s = other._storage;

      return _storage[0] == s[0] &&
          _storage[1] == s[1] &&
          _storage[2] == s[2] &&
          _storage[3] == s[3] &&
          _storage[4] == s[4] &&
          _storage[5] == s[5] &&
          _storage[6] == s[6] &&
          _storage[7] == s[7] &&
          _storage[8] == s[8] &&
          _storage[9] == s[9] &&
          _storage[10] == s[10] &&
          _storage[11] == s[11] &&
          _storage[12] == s[12] &&
          _storage[13] == s[13] &&
          _storage[14] == s[14] &&
          _storage[15] == s[15];
    } else if (other is _Matrix4Identity) {
      return _storage[0] == 1.0 &&
          _storage[1] == 0.0 &&
          _storage[2] == 0.0 &&
          _storage[3] == 0.0 &&
          _storage[4] == 0.0 &&
          _storage[5] == 1.0 &&
          _storage[6] == 0.0 &&
          _storage[7] == 0.0 &&
          _storage[8] == 0.0 &&
          _storage[9] == 0.0 &&
          _storage[10] == 1.0 &&
          _storage[11] == 0.0 &&
          _storage[12] == 0.0 &&
          _storage[13] == 0.0 &&
          _storage[14] == 0.0 &&
          _storage[15] == 1.0;
    } else {
      return false;
    }
  }
}

class _Matrix4Identity implements Matrix4 {
  final int rowDimension = 4;
  final int columnDimension = 4;

  final bool isSquare = true;

  final double r0c0 = 1.0;
  final double r0c1 = 0.0;
  final double r0c2 = 0.0;
  final double r0c3 = 0.0;
  final double r1c0 = 0.0;
  final double r1c1 = 1.0;
  final double r1c2 = 0.0;
  final double r1c3 = 0.0;
  final double r2c0 = 0.0;
  final double r2c1 = 0.0;
  final double r2c2 = 1.0;
  final double r2c3 = 0.0;
  final double r3c0 = 0.0;
  final double r3c1 = 0.0;
  final double r3c2 = 0.0;
  final double r3c3 = 1.0;

  final List<double> _r0 = const <double>[1.0, 0.0, 0.0, 0.0];
  final List<double> _r1 = const <double>[1.0, 0.0, 0.0, 0.0];
  final List<double> _r2 = const <double>[1.0, 0.0, 0.0, 0.0];
  final List<double> _r3 = const <double>[1.0, 0.0, 0.0, 0.0];

  final List<double> valuesRowPacked = const <double>[
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0,
    0.0,
    0.0,
    0.0,
    0.0,
    1.0
  ];

  final double determinant = 1.0;
  final bool isNonSingular = true;

  const _Matrix4Identity();

  Iterable<double> get values => valuesRowPacked;

  Iterable<double> get valuesColumnPacked => valuesRowPacked;

  Matrix4 get transpose => this;

  Matrix4 get inverse => this;

  Matrix4 scalarProduct(num s) {
    final values = new Float32List(16);

    values[0] = s;
    values[5] = s;
    values[10] = s;
    values[15] = s;

    return new _Matrix4._internal(values);
  }

  Matrix4 scalarDivision(num s) {
    final values = new Float32List(16);

    values[0] = 1.0 / s;
    values[5] = 1.0 / s;
    values[10] = 1.0 / s;
    values[15] = 1.0 / s;

    return new _Matrix4._internal(values);
  }

  Matrix4 entrywiseSum(Matrix B) {
    final values = new Float32List(16);

    if (B is Matrix4) {
      values[0] = 1.0 + B.r0c0;
      values[1] = B.r1c0;
      values[2] = B.r2c0;
      values[3] = B.r3c0;
      values[4] = B.r0c1;
      values[5] = 1.0 + B.r1c1;
      values[6] = B.r2c1;
      values[7] = B.r3c1;
      values[8] = B.r0c2;
      values[9] = B.r1c2;
      values[10] = 1.0 + B.r2c2;
      values[11] = B.r3c2;
      values[12] = B.r0c3;
      values[13] = B.r1c3;
      values[14] = B.r2c3;
      values[15] = 1.0 + B.r3c3;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = 1.0 + B.valueAt(0, 0);
      values[1] = B.valueAt(1, 0);
      values[2] = B.valueAt(2, 0);
      values[3] = B.valueAt(3, 0);
      values[4] = B.valueAt(0, 1);
      values[5] = 1.0 + B.valueAt(1, 1);
      values[6] = B.valueAt(2, 1);
      values[7] = B.valueAt(3, 1);
      values[8] = B.valueAt(0, 2);
      values[9] = B.valueAt(1, 2);
      values[10] = 1.0 + B.valueAt(2, 2);
      values[11] = B.valueAt(3, 2);
      values[12] = B.valueAt(0, 3);
      values[13] = B.valueAt(1, 3);
      values[14] = B.valueAt(2, 3);
      values[15] = 1.0 + B.valueAt(3, 3);
    }

    return new _Matrix4._internal(values);
  }

  Matrix4 entrywiseDifference(Matrix B) {
    final values = new Float32List(16);

    if (B is Matrix4) {
      values[0] = 1.0 - B.r0c0;
      values[1] = -B.r1c0;
      values[2] = -B.r2c0;
      values[3] = -B.r3c0;
      values[4] = -B.r0c1;
      values[5] = 1.0 - B.r1c1;
      values[6] = -B.r2c1;
      values[7] = -B.r3c1;
      values[8] = -B.r0c2;
      values[9] = -B.r1c2;
      values[10] = 1.0 - B.r2c2;
      values[11] = -B.r3c2;
      values[12] = -B.r0c3;
      values[13] = -B.r1c3;
      values[14] = -B.r2c3;
      values[15] = 1.0 - B.r3c3;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = 1.0 - B.valueAt(0, 0);
      values[1] = -B.valueAt(1, 0);
      values[2] = -B.valueAt(2, 0);
      values[3] = -B.valueAt(3, 0);
      values[4] = -B.valueAt(0, 1);
      values[5] = 1.0 - B.valueAt(1, 1);
      values[6] = -B.valueAt(2, 1);
      values[7] = -B.valueAt(3, 1);
      values[8] = -B.valueAt(0, 2);
      values[9] = -B.valueAt(1, 2);
      values[10] = 1.0 - B.valueAt(2, 2);
      values[11] = -B.valueAt(3, 2);
      values[12] = -B.valueAt(0, 3);
      values[13] = -B.valueAt(1, 3);
      values[14] = -B.valueAt(2, 3);
      values[15] = 1.0 - B.valueAt(3, 3);
    }

    return new _Matrix4._internal(values);
  }

  Matrix4 entrywiseProduct(Matrix B) {
    final values = new Float32List(16);

    if (B is Matrix4) {
      values[0] = B.r0c0;
      values[5] = B.r1c1;
      values[10] = B.r2c2;
      values[15] = B.r3c3;
    } else {
      _assertEqualDimensions(this, B);

      values[0] = B.valueAt(0, 0);
      values[5] = B.valueAt(1, 1);
      values[10] = B.valueAt(2, 2);
      values[15] = B.valueAt(3, 3);
    }

    return new _Matrix4._internal(values);
  }

  matrixProduct(Matrix B) {
    if (B is Matrix4) {
      return B;
    } else if (B is Vector4) {
      return B;
    } else if (B.rowDimension == 4) {
      return B;
    } else {
      throw new ArgumentError('The row dimension of the given matrix B '
          '(${B.rowDimension}), does not match this matrix\'s column dimension '
          '(4).');
    }
  }

  List<double> rowAt(int index) {
    if (index == 0) {
      return _r0;
    } else if (index == 1) {
      return _r1;
    } else if (index == 2) {
      return _r2;
    } else if (index == 3) {
      return _r3;
    } else {
      throw new RangeError('Invalid index. Index must be 0, 1, 2 or 3.');
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
    if (B.rowDimension == 4) {
      return B;
    } else {
      throw new ArgumentError('The row dimension of the given matrix B '
          '(${B.rowDimension}), does not match this matrix\'s column dimension '
          '(4).');
    }
  }

  Matrix solveTranspose(Matrix B) {
    if (B.columnDimension == 4) {
      return B;
    } else {
      throw new ArgumentError('The column dimension of the given matrix B '
          '(${B.rowDimension}), does not match this matrix\'s row dimension '
          '(4).');
    }
  }

  PivotingLUDecomposition get luDecomposition =>
      new PivotingLUDecomposition(this);

  ReducedQRDecomposition get qrDecomposition =>
      new ReducedQRDecomposition(this);

  Matrix4 operator +(Matrix B) => entrywiseSum(B);

  Matrix4 operator -(Matrix B) => entrywiseDifference(B);

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
    return 'Matrix4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, '
        '0.0, 0.0, 0.0, 0.0, 1.0)';
  }

  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _Matrix4Identity) {
      return true;
    } else if (other is _Matrix4) {
      final s = other._storage;

      return s[0] == 1.0 &&
          s[1] == 0.0 &&
          s[2] == 0.0 &&
          s[3] == 0.0 &&
          s[4] == 0.0 &&
          s[5] == 1.0 &&
          s[6] == 0.0 &&
          s[7] == 0.0 &&
          s[8] == 0.0 &&
          s[9] == 0.0 &&
          s[10] == 1.0 &&
          s[11] == 0.0 &&
          s[12] == 0.0 &&
          s[13] == 0.0 &&
          s[14] == 0.0 &&
          s[15] == 1.0;
    } else {
      return false;
    }
  }
}
