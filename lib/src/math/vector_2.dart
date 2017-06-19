part of bagl.math;

/// A column vector of length 2 (a 2 by 1 matrix).
class Vector2 extends _VertexBase implements Matrix {
  final double x;

  final double y;

  final int columnDimension = 1;

  final int rowDimension = 2;

  Float32List _storageInternal;

  double _squareSum;

  double _magnitude;

  Vector2 _unitVector;

  /// Instantiates a new [Vector2] with the specified values.
  Vector2(this.x, this.y);

  /// Instantiates a new [Vector2] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 2.
  factory Vector2.fromList(List<double> values) {
    if (values.length != 2) {
      throw new ArgumentError(
          'A list of length 2 required to instantiate a Vector2.');
    }

    return new Vector2(values[0], values[1]);
  }

  /// Instantiates a new [Vector2] where every position is set to the specified
  /// value.
  Vector2.constant(double value)
      : x = value,
        y = value;

  /// Instantiates a new [Vector2] where every position is set to zero.
  Vector2.zero()
      : x = 0.0,
        y = 0.0;

  Float32List get _storage {
    if (_storageInternal == null) {
      _storageInternal = new Float32List(2);
      _storageInternal[0] = x;
      _storageInternal[1] = y;
    }

    return _storageInternal;
  }

  // Vector2 xy swizzles: x first
  Vector2 get xx => new Vector2(x, x);
  Vector2 get xy => new Vector2(x, y);

  // Vector2 xy swizzles: y first
  Vector2 get yx => new Vector2(y, x);
  Vector2 get yy => new Vector2(y, y);

  // Vector3 xy swizzles: x first
  Vector3 get xxx => new Vector3(x, x, x);
  Vector3 get xxy => new Vector3(x, x, y);
  Vector3 get xyx => new Vector3(x, y, x);
  Vector3 get xyy => new Vector3(x, y, y);

  // Vector3 xy swizzles: y first
  Vector3 get yxx => new Vector3(y, x, x);
  Vector3 get yxy => new Vector3(y, x, y);
  Vector3 get yyx => new Vector3(y, y, x);
  Vector3 get yyy => new Vector3(y, y, y);

  // Vector4 xy swizzles: x first
  Vector4 get xxxx => new Vector4(x, x, x, x);
  Vector4 get xxxy => new Vector4(x, x, x, y);
  Vector4 get xxyx => new Vector4(x, x, y, x);
  Vector4 get xxyy => new Vector4(x, x, y, y);
  Vector4 get xyxx => new Vector4(x, y, x, x);
  Vector4 get xyxy => new Vector4(x, y, x, y);
  Vector4 get xyyx => new Vector4(x, y, y, x);
  Vector4 get xyyy => new Vector4(x, y, y, y);

  // Vector4 xy swizzles: y first
  Vector4 get yxxx => new Vector4(y, x, x, x);
  Vector4 get yxxy => new Vector4(y, x, x, y);
  Vector4 get yxyx => new Vector4(y, x, y, x);
  Vector4 get yxyy => new Vector4(y, x, y, y);
  Vector4 get yyxx => new Vector4(y, y, x, x);
  Vector4 get yyxy => new Vector4(y, y, x, y);
  Vector4 get yyyx => new Vector4(y, y, y, x);
  Vector4 get yyyy => new Vector4(y, y, y, y);

  double get r => x;
  double get g => y;

  // Vector2 rg swizzles: r first
  Vector2 get rr => new Vector2(r, r);
  Vector2 get rg => new Vector2(r, g);

  // Vector2 rg swizzles: g first
  Vector2 get gr => new Vector2(g, r);
  Vector2 get gg => new Vector2(g, g);

  // Vector3 rg swizzles: r first
  Vector3 get rrr => new Vector3(r, r, r);
  Vector3 get rrg => new Vector3(r, r, g);
  Vector3 get rgr => new Vector3(r, g, r);
  Vector3 get rgg => new Vector3(r, g, g);

  // Vector3 rg swizzles: g first
  Vector3 get grr => new Vector3(g, r, r);
  Vector3 get grg => new Vector3(g, r, g);
  Vector3 get ggr => new Vector3(g, g, r);
  Vector3 get ggg => new Vector3(g, g, g);

  // Vector4 rg swizzles: r first
  Vector4 get rrrr => new Vector4(r, r, r, r);
  Vector4 get rrrg => new Vector4(r, r, r, g);
  Vector4 get rrgr => new Vector4(r, r, g, r);
  Vector4 get rrgg => new Vector4(r, r, g, g);
  Vector4 get rgrr => new Vector4(r, g, r, r);
  Vector4 get rgrg => new Vector4(r, g, r, g);
  Vector4 get rggr => new Vector4(r, g, g, r);
  Vector4 get rggg => new Vector4(r, g, g, g);

  // Vector4 rg swizzles: g first
  Vector4 get grrr => new Vector4(g, r, r, r);
  Vector4 get grrg => new Vector4(g, r, r, g);
  Vector4 get grgr => new Vector4(g, r, g, r);
  Vector4 get grgg => new Vector4(g, r, g, g);
  Vector4 get ggrr => new Vector4(g, g, r, r);
  Vector4 get ggrg => new Vector4(g, g, r, g);
  Vector4 get gggr => new Vector4(g, g, g, r);
  Vector4 get gggg => new Vector4(g, g, g, g);

  double get s => x;
  double get t => y;

  // Vector2 st swizzles: s first
  Vector2 get ss => new Vector2(s, s);
  Vector2 get st => new Vector2(s, t);

  // Vector2 st swizzles: t first
  Vector2 get ts => new Vector2(t, s);
  Vector2 get tt => new Vector2(t, t);

  // Vector3 st swizzles: s first
  Vector3 get sss => new Vector3(s, s, s);
  Vector3 get sst => new Vector3(s, s, t);
  Vector3 get sts => new Vector3(s, t, s);
  Vector3 get stt => new Vector3(s, t, t);

  // Vector3 st swizzles: t first
  Vector3 get tss => new Vector3(t, s, s);
  Vector3 get tst => new Vector3(t, s, t);
  Vector3 get tts => new Vector3(t, t, s);
  Vector3 get ttt => new Vector3(t, t, t);

  // Vector4 st swizzles: s first
  Vector4 get ssss => new Vector4(s, s, s, s);
  Vector4 get ssst => new Vector4(s, s, s, t);
  Vector4 get ssts => new Vector4(s, s, t, s);
  Vector4 get sstt => new Vector4(s, s, t, t);
  Vector4 get stss => new Vector4(s, t, s, s);
  Vector4 get stst => new Vector4(s, t, s, t);
  Vector4 get stts => new Vector4(s, t, t, s);
  Vector4 get sttt => new Vector4(s, t, t, t);

  // Vector4 st swizzles: t first
  Vector4 get tsss => new Vector4(t, s, s, s);
  Vector4 get tsst => new Vector4(t, s, s, t);
  Vector4 get tsts => new Vector4(t, s, t, s);
  Vector4 get tstt => new Vector4(t, s, t, t);
  Vector4 get ttss => new Vector4(t, t, s, s);
  Vector4 get ttst => new Vector4(t, t, s, t);
  Vector4 get ttts => new Vector4(t, t, t, s);
  Vector4 get tttt => new Vector4(t, t, t, t);

  /// The magnitude of this [Vector2].
  double get magnitude {
    if (_magnitude == null) {
      _squareSum ??= x * x + y * y;

      if ((_squareSum - 1).abs() < 0.0001) {
        _magnitude = 1.0;
      } else {
        _magnitude = sqrt(_squareSum);
      }
    }

    return _magnitude;
  }

  /// This [Vector2]'s unit vector.
  ///
  /// A [Vector2] with a [magnitude] of `1` that has the same direction as this
  /// [Vector2].
  Vector2 get unitVector {
    if (_unitVector == null) {
      if (_magnitude != null) {
        if (_magnitude == 1.0) {
          _unitVector = new Vector2(x, y);
        } else {
          _unitVector = new Vector2(x / _magnitude, y / _magnitude);
        }
      } else {
        _squareSum ??= x * x + y * y;

        if ((_squareSum - 1).abs() < 0.0001) {
          _unitVector = new Vector2(x, y);
        } else {
          _magnitude ??= sqrt(_squareSum);

          _unitVector = new Vector2(x / _magnitude, y / _magnitude);
        }
      }
    }

    return _unitVector;
  }

  /// Whether or not this [Vector2] is a unit vector.
  bool get isUnit {
    if (_magnitude != null) {
      return _magnitude == 1.0;
    } else {
      _squareSum ??= x * x + y * y;

      return (_squareSum - 1).abs() < 0.0001;
    }
  }

  Vector2 scalarProduct(num s) => new Vector2(x * s, y * s);

  Vector2 scalarDivision(num s) => new Vector2(x / s, y / s);

  Vector2 entrywiseSum(Matrix B) {
    if (B is Vector2) {
      return new Vector2(x + B.x, y + B.y);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector2(x + B.valueAt(0, 0), y + B.valueAt(1, 0));
    }
  }

  Vector2 entrywiseDifference(Matrix B) {
    if (B is Vector2) {
      return new Vector2(x - B.x, y - B.y);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector2(x - B.valueAt(0, 0), y - B.valueAt(1, 0));
    }
  }

  Vector2 entrywiseProduct(Matrix B) {
    if (B is Vector2) {
      return new Vector2(x * B.x, y * B.y);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector2(x * B.valueAt(0, 0), y * B.valueAt(1, 0));
    }
  }

  /// Computes the dot product of this [Vector2] `A` and another [Vector2] [B].
  double dotProduct(Vector2 B) => x * B.x + y * B.y;

  Vector2 operator +(Matrix B) => entrywiseSum(B);

  Vector2 operator -(Matrix B) => entrywiseDifference(B);

  //// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 2);

    if (index == 0) {
      return x;
    } else {
      return y;
    }
  }

  String toString() {
    return 'Vector2($x, $y)';
  }

  bool operator ==(Object other) => identical(this, other) || other is Vector2 && other.x == x && other.y == y;

  int get hashCode => hash2(x, y);
}
