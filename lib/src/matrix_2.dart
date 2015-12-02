part of bagl;

class Matrix2 extends GenericMatrix<Matrix2, Matrix2> {
  final Float32List storage;

  factory Matrix2(double val0, double val1, double val2, double val3) {
    final values = new Float32List(4);

    values[0] = val0;
    values[1] = val1;
    values[2] = val2;
    values[3] = val3;

    return new Matrix2.fromFloat32List(values);
  }

  factory Matrix2.fromList(List<double> values) =>
      new Matrix2.fromFloat32List(new Float32List.fromList(values));

  Matrix2.fromFloat32List(Float32List values)
      : storage = values,
        super.fromFloat32List(values, 2) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Matrix2.');
    }
  }

  factory Matrix2.constant(double value) =>
      new Matrix2.fromFloat32List(new Float32List(4)..fillRange(0, 4, value));

  factory Matrix2.zero() => new Matrix2.fromFloat32List(new Float32List(4));

  factory Matrix2.identity() {
    final values = new Float32List(4);

    values[0] = 1.0;
    values[1] = 0.0;
    values[2] = 0.0;
    values[3] = 1.0;

    return new Matrix2.fromFloat32List(values);
  }

  Matrix2 withValues(Float32List newValues) =>
      new Matrix2.fromFloat32List(newValues);

  Matrix2 transposeWithValues(Float32List newValues) =>
      new Matrix2.fromFloat32List(newValues);

  matrixProduct(GenericMatrix B) {
    if (B is Matrix2) {
      final m00 = storage[0];
      final m01 = storage[1];
      final m10 = storage[2];
      final m11 = storage[3];

      final bStorage = B.storage;

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
      final bStorage = B.storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];

      final s = storage;
      final values = new Float32List(2);

      values[0] = (s[0] * n0) + (s[1] * n1);
      values[1] = (s[2] * n0) + (s[3] * n1);

      return new Vector2.fromFloat32List(values);
    } else {
      return super.matrixProduct(B);
    }
  }

  List<double> operator [](int index) => rowAt(index);
}
