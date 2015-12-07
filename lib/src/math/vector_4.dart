part of math;

class Vector4 extends GenericMatrix<Vector4, Matrix> {
  final Float32List storage;

  factory Vector4(double x, double y, double z, double w) {
    final values = new Float32List(4);

    values[0] = x;
    values[1] = y;
    values[2] = z;
    values[3] = w;

    return new Vector4.fromFloat32List(values);
  }

  factory Vector4.fromList(List<double> values) =>
      new Vector4.fromFloat32List(new Float32List.fromList(values));

  Vector4.fromFloat32List(Float32List values)
      : storage = values,
        super.fromFloat32List(values, 1) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Vector4.');
    }
  }

  factory Vector4.constant(double value) =>
      new Vector4.fromFloat32List(new Float32List(4)..fillRange(0, 4, value));

  factory Vector4.zero() => new Vector4.fromFloat32List(new Float32List(4));

  Vector4 withValues(Float32List newValues) =>
      new Vector4.fromFloat32List(newValues);

  Matrix transposeWithValues(Float32List newValues) =>
      new Matrix.fromFloat32List(newValues, 4);

  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];
  double get w => storage[3];

  double get r => storage[0];
  double get g => storage[1];
  double get b => storage[2];
  double get a => storage[3];

  double get s => storage[0];
  double get t => storage[1];
  double get p => storage[2];
  double get q => storage[3];

  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 4);

    return storage[index];
  }

  String toString() {
    return 'Vector4(${values.toString()})';
  }
}
