part of bagl;

class Matrix3 extends GenericMatrix<Matrix3, Matrix3> {
  final Float32List storage;

  factory Matrix3(double val0, double val1, double val2, double val3,
          double val4, double val5, double val6, double val7, double val8) =>
      new Matrix3.fromFloat32List(new Float32List(9)
        ..[0] = val0
        ..[1] = val1
        ..[2] = val2
        ..[3] = val3
        ..[4] = val4
        ..[5] = val5
        ..[6] = val6
        ..[7] = val7
        ..[8] = val8);

  factory Matrix3.fromList(List<double> values) =>
      new Matrix3.fromFloat32List(new Float32List.fromList(values));

  Matrix3.fromFloat32List(Float32List values)
      : storage = values,
        super.fromFloat32List(values, 3) {
    if (values.length != 9) {
      throw new ArgumentError(
          'A list of length 9 required to instantiate a Matrix3.');
    }
  }

  factory Matrix3.constant(double value) =>
      new Matrix3.fromFloat32List(new Float32List(9)..fillRange(0, 9, value));

  factory Matrix3.zero() => new Matrix3.fromFloat32List(new Float32List(9));

  factory Matrix3.identity() => new Matrix3.fromFloat32List(new Float32List(9)
    ..[0] = 1.0
    ..[1] = 0.0
    ..[2] = 0.0
    ..[3] = 0.0
    ..[4] = 1.0
    ..[5] = 0.0
    ..[6] = 0.0
    ..[7] = 0.0
    ..[8] = 1.0);

  Matrix3 withValues(Float32List newValues) =>
      new Matrix3.fromFloat32List(newValues);

  Matrix3 transposeWithValues(Float32List newValues) =>
      new Matrix3.fromFloat32List(newValues);

  matrixProduct(GenericMatrix B) {
    if (B is Matrix3) {
      final m00 = storage[0];
      final m01 = storage[1];
      final m02 = storage[2];
      final m10 = storage[3];
      final m11 = storage[4];
      final m12 = storage[5];
      final m20 = storage[6];
      final m21 = storage[7];
      final m22 = storage[8];

      final bStorage = B.storage;

      final n00 = bStorage[0];
      final n01 = bStorage[1];
      final n02 = bStorage[2];
      final n10 = bStorage[3];
      final n11 = bStorage[4];
      final n12 = bStorage[5];
      final n20 = bStorage[6];
      final n21 = bStorage[7];
      final n22 = bStorage[8];

      return new Matrix3.fromFloat32List(new Float32List(9)
        ..[0] = (m00 * n00) + (m01 * n10) + (m02 * n20)
        ..[1] = (m00 * n01) + (m01 * n11) + (m02 * n21)
        ..[2] = (m00 * n02) + (m01 * n12) + (m02 * n22)
        ..[3] = (m10 * n00) + (m11 * n10) + (m12 * n20)
        ..[4] = (m10 * n01) + (m11 * n11) + (m12 * n21)
        ..[5] = (m10 * n02) + (m11 * n12) + (m12 * n22)
        ..[6] = (m20 * n00) + (m21 * n10) + (m22 * n20)
        ..[7] = (m20 * n01) + (m21 * n11) + (m22 * n21)
        ..[8] = (m20 * n02) + (m21 * n12) + (m22 * n22));
    } else if (B is Vector3) {
      final bStorage = B.storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];
      final n2 = bStorage[2];

      final s = storage;

      return new Vector3.fromFloat32List(new Float32List(3)
        ..[0] = (s[0] * n0) + (s[1] * n1) + (s[2] * n2)
        ..[1] = (s[3] * n0) + (s[4] * n1) + (s[5] * n2)
        ..[2] = (s[6] * n0) + (s[7] * n1) + (s[8] * n2));
    } else {
      return super.matrixProduct(B);
    }
  }

  List<double> operator [](int index) => rowAt(index);
}
