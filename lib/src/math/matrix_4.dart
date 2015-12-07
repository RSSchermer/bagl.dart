part of math;

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
      final bStorage = B.storage;

      final n0 = bStorage[0];
      final n1 = bStorage[1];
      final n2 = bStorage[2];
      final n3 = bStorage[3];

      final s = storage;
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

  List<double> operator [](int index) => rowAt(index);

  String toString() {
    return 'Matrix4(${values.toString()})';
  }
}
