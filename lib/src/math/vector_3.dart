part of math;

class Vector3 extends GenericMatrix<Vector3, Matrix> {
  final Float32List storage;

  factory Vector3(double x, double y, double z) {
    final values = new Float32List(3);

    values[0] = x;
    values[1] = y;
    values[2] = z;

    return new Vector3.fromFloat32List(values);
  }

  factory Vector3.fromList(List<double> values) =>
      new Vector3.fromFloat32List(new Float32List.fromList(values));

  Vector3.fromFloat32List(Float32List values)
      : storage = values,
        super.fromFloat32List(values, 1) {
    if (values.length != 3) {
      throw new ArgumentError(
          'A list of length 3 required to instantiate a Vector3.');
    }
  }

  factory Vector3.constant(double value) =>
      new Vector3.fromFloat32List(new Float32List(3)..fillRange(0, 3, value));

  factory Vector3.zero() => new Vector3.fromFloat32List(new Float32List(3));

  Vector3 withValues(Float32List newValues) =>
      new Vector3.fromFloat32List(newValues);

  Matrix transposeWithValues(Float32List newValues) =>
      new Matrix.fromFloat32List(newValues, 3);

  double get x => storage[0];
  double get y => storage[1];
  double get z => storage[2];

  double get r => storage[0];
  double get g => storage[1];
  double get b => storage[2];

  double get s => storage[0];
  double get t => storage[1];
  double get p => storage[2];

  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 3);

    return storage[index];
  }

  String toString() {
    return 'Vector3(${values.toString()})';
  }
}
