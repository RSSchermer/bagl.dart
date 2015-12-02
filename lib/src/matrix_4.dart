part of bagl;

class Matrix4 extends GenericMatrix<Matrix4, Matrix4> {
  final Float32List storage;

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
          double val15) =>
      new Matrix4.fromFloat32List(new Float32List(16)
        ..[0] = val0
        ..[1] = val1
        ..[2] = val2
        ..[3] = val3
        ..[4] = val4
        ..[5] = val5
        ..[6] = val6
        ..[7] = val7
        ..[8] = val8
        ..[9] = val9
        ..[10] = val10
        ..[11] = val11
        ..[12] = val12
        ..[13] = val13
        ..[14] = val14
        ..[15] = val15);

  factory Matrix4.fromList(List<double> values) =>
      new Matrix4.fromFloat32List(new Float32List.fromList(values));

  Matrix4.fromFloat32List(Float32List values)
      : storage = values,
        super.fromFloat32List(values, 4) {
    if (values.length != 16) {
      throw new ArgumentError(
          'A list of length 16 required to instantiate a Matrix4.');
    }
  }

  factory Matrix4.constant(double value) =>
      new Matrix4.fromFloat32List(new Float32List(16)..fillRange(0, 16, value));

  factory Matrix4.zero() => new Matrix4.fromFloat32List(new Float32List(16));

  factory Matrix4.identity() => new Matrix4.fromFloat32List(new Float32List(16)
    ..[0] = 1.0
    ..[1] = 0.0
    ..[2] = 0.0
    ..[3] = 0.0
    ..[4] = 0.0
    ..[5] = 1.0
    ..[6] = 0.0
    ..[7] = 0.0
    ..[8] = 0.0
    ..[9] = 0.0
    ..[10] = 1.0
    ..[11] = 0.0
    ..[12] = 0.0
    ..[13] = 0.0
    ..[14] = 0.0
    ..[15] = 1.0);

  Matrix4 withValues(Float32List newValues) =>
      new Matrix4.fromFloat32List(newValues);

  Matrix4 transposeWithValues(Float32List newValues) =>
      new Matrix4.fromFloat32List(newValues);

  matrixProduct(GenericMatrix B) {
    if (B is Matrix4) {
      final m00 = storage[0];
      final m01 = storage[1];
      final m02 = storage[2];
      final m03 = storage[3];
      final m10 = storage[4];
      final m11 = storage[5];
      final m12 = storage[6];
      final m13 = storage[7];
      final m20 = storage[8];
      final m21 = storage[9];
      final m22 = storage[10];
      final m23 = storage[11];
      final m30 = storage[12];
      final m31 = storage[13];
      final m32 = storage[14];
      final m33 = storage[15];

      final bStorage = B.storage;

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

      return new Matrix3.fromFloat32List(new Float32List(16)
        ..[0] = (m00 * n00) + (m01 * n10) + (m02 * n20) + (m03 * n30)
        ..[1] = (m00 * n01) + (m01 * n11) + (m02 * n21) + (m03 * n31)
        ..[2] = (m00 * n02) + (m01 * n12) + (m02 * n22) + (m03 * n32)
        ..[3] = (m00 * n03) + (m01 * n13) + (m02 * n23) + (m03 * n33)
        ..[4] = (m10 * n00) + (m11 * n10) + (m12 * n20) + (m13 * n30)
        ..[5] = (m10 * n01) + (m11 * n11) + (m12 * n21) + (m13 * n31)
        ..[6] = (m10 * n02) + (m11 * n12) + (m12 * n22) + (m13 * n32)
        ..[7] = (m10 * n03) + (m11 * n13) + (m12 * n23) + (m13 * n33)
        ..[8] = (m20 * n00) + (m21 * n10) + (m22 * n20) + (m23 * n30)
        ..[9] = (m20 * n01) + (m21 * n11) + (m22 * n21) + (m23 * n31)
        ..[10] = (m20 * n02) + (m21 * n12) + (m22 * n22) + (m23 * n32)
        ..[11] = (m20 * n03) + (m21 * n13) + (m22 * n23) + (m23 * n33)
        ..[12] = (m30 * n00) + (m31 * n10) + (m32 * n20) + (m33 * n30)
        ..[13] = (m30 * n01) + (m31 * n11) + (m32 * n21) + (m33 * n31)
        ..[14] = (m30 * n02) + (m31 * n12) + (m32 * n22) + (m33 * n32)
        ..[15] = (m30 * n03) + (m31 * n13) + (m32 * n23) + (m33 * n33));
    } else if (B is Vector4) {
      final bStorage = B.storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];
      final n2 = bStorage[2];
      final n3 = bStorage[3];

      final s = storage;

      return new Vector3.fromFloat32List(new Float32List(4)
        ..[0] = (s[0] * n0) + (s[1] * n1) + (s[2] * n2) + (s[3] * n3)
        ..[1] = (s[4] * n0) + (s[5] * n1) + (s[6] * n2) + (s[7] * n3)
        ..[2] = (s[8] * n0) + (s[9] * n1) + (s[10] * n2) + (s[11] * n3)
        ..[3] = (s[12] * n0) + (s[13] * n1) + (s[14] * n2) + (s[15] * n3));
    } else {
      return super.matrixProduct(B);
    }
  }

  List<double> operator [](int index) => rowAt(index);
}
