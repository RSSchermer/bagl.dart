part of bagl.math;

/// A column vector of length 2 (a 2 by 1 matrix).
abstract class Vector2 implements Matrix {
  /// Instantiates a new [Vector2] with the specified values.
  factory Vector2(x, y) = _Vector2;

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
  factory Vector2.constant(double value) => new _Vector2(value, value);

  /// Instantiates a new [Vector2] where every position is set to zero.
  const factory Vector2.zero() = _Vector2Zero;

  double get x;
  double get y;

  // Vector2 xy swizzles: x first
  Vector2 get xx;
  Vector2 get xy;

  // Vector2 xy swizzles: y first
  Vector2 get yx;
  Vector2 get yy;

  // Vector3 xy swizzles: x first
  Vector3 get xxx;
  Vector3 get xxy;
  Vector3 get xyx;
  Vector3 get xyy;

  // Vector3 xy swizzles: y first
  Vector3 get yxx;
  Vector3 get yxy;
  Vector3 get yyx;
  Vector3 get yyy;

  // Vector4 xy swizzles: x first
  Vector4 get xxxx;
  Vector4 get xxxy;
  Vector4 get xxyx;
  Vector4 get xxyy;
  Vector4 get xyxx;
  Vector4 get xyxy;
  Vector4 get xyyx;
  Vector4 get xyyy;

  // Vector4 xy swizzles: y first
  Vector4 get yxxx;
  Vector4 get yxxy;
  Vector4 get yxyx;
  Vector4 get yxyy;
  Vector4 get yyxx;
  Vector4 get yyxy;
  Vector4 get yyyx;
  Vector4 get yyyy;

  double get r;
  double get g;

  // Vector2 rg swizzles: r first
  Vector2 get rr;
  Vector2 get rg;

  // Vector2 rg swizzles: g first
  Vector2 get gr;
  Vector2 get gg;

  // Vector3 rg swizzles: r first
  Vector3 get rrr;
  Vector3 get rrg;
  Vector3 get rgr;
  Vector3 get rgg;

  // Vector3 rg swizzles: g first
  Vector3 get grr;
  Vector3 get grg;
  Vector3 get ggr;
  Vector3 get ggg;

  // Vector4 rg swizzles: r first
  Vector4 get rrrr;
  Vector4 get rrrg;
  Vector4 get rrgr;
  Vector4 get rrgg;
  Vector4 get rgrr;
  Vector4 get rgrg;
  Vector4 get rggr;
  Vector4 get rggg;

  // Vector4 rg swizzles: g first
  Vector4 get grrr;
  Vector4 get grrg;
  Vector4 get grgr;
  Vector4 get grgg;
  Vector4 get ggrr;
  Vector4 get ggrg;
  Vector4 get gggr;
  Vector4 get gggg;

  double get s;
  double get t;

  // Vector2 st swizzles: s first
  Vector2 get ss;
  Vector2 get st;

  // Vector2 st swizzles: t first
  Vector2 get ts;
  Vector2 get tt;

  // Vector3 st swizzles: s first
  Vector3 get sss;
  Vector3 get sst;
  Vector3 get sts;
  Vector3 get stt;

  // Vector3 st swizzles: t first
  Vector3 get tss;
  Vector3 get tst;
  Vector3 get tts;
  Vector3 get ttt;

  // Vector4 st swizzles: s first
  Vector4 get ssss;
  Vector4 get ssst;
  Vector4 get ssts;
  Vector4 get sstt;
  Vector4 get stss;
  Vector4 get stst;
  Vector4 get stts;
  Vector4 get sttt;

  // Vector4 st swizzles: t first
  Vector4 get tsss;
  Vector4 get tsst;
  Vector4 get tsts;
  Vector4 get tstt;
  Vector4 get ttss;
  Vector4 get ttst;
  Vector4 get ttts;
  Vector4 get tttt;

  /// The magnitude of this [Vector2].
  double get magnitude;

  /// This [Vector2]'s unit vector.
  ///
  /// A [Vector2] with a [magnitude] of `1` that has the same direction as this
  /// [Vector2].
  Vector2 get unitVector;

  /// Whether or not this [Vector2] is a unit vector.
  bool get isUnit;

  /// Computes the dot product of this [Vector2] `A` and another [Vector2] [B].
  double dotProduct(Vector2 B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index);
}

class _Vector2 extends _VertexBase implements Vector2 {
  final double x;

  final double y;

  final int columnDimension = 1;

  final int rowDimension = 2;

  Float32List _storageInternal;

  double _squareSum;

  double _magnitude;

  Vector2 _unitVector;

  /// Instantiates a new [Vector2] with the specified values.
  _Vector2(this.x, this.y);

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

  Float32List get _storage {
    if (_storageInternal == null) {
      _storageInternal = new Float32List(2);
      _storageInternal[0] = x;
      _storageInternal[1] = y;
    }

    return _storageInternal;
  }

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

  /// Returns the value at the [index].
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

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector2 && other.x == x && other.y == y;

  int get hashCode => hash2(x, y);
}

class _Vector2Zero implements Vector2 {
  const _Vector2Zero();

  double get x => 0.0;
  double get y => 0.0;

  // Vector2 xy swizzles: x first
  Vector2 get xx => const Vector2.zero();
  Vector2 get xy => const Vector2.zero();

  // Vector2 xy swizzles: y first
  Vector2 get yx => const Vector2.zero();
  Vector2 get yy => const Vector2.zero();

  // Vector3 xy swizzles: x first
  Vector3 get xxx => const Vector3.zero();
  Vector3 get xxy => const Vector3.zero();
  Vector3 get xyx => const Vector3.zero();
  Vector3 get xyy => const Vector3.zero();

  // Vector3 xy swizzles: y first
  Vector3 get yxx => const Vector3.zero();
  Vector3 get yxy => const Vector3.zero();
  Vector3 get yyx => const Vector3.zero();
  Vector3 get yyy => const Vector3.zero();

  // Vector4 xy swizzles: x first
  Vector4 get xxxx => const Vector4.zero();
  Vector4 get xxxy => const Vector4.zero();
  Vector4 get xxyx => const Vector4.zero();
  Vector4 get xxyy => const Vector4.zero();
  Vector4 get xyxx => const Vector4.zero();
  Vector4 get xyxy => const Vector4.zero();
  Vector4 get xyyx => const Vector4.zero();
  Vector4 get xyyy => const Vector4.zero();

  // Vector4 xy swizzles: y first
  Vector4 get yxxx => const Vector4.zero();
  Vector4 get yxxy => const Vector4.zero();
  Vector4 get yxyx => const Vector4.zero();
  Vector4 get yxyy => const Vector4.zero();
  Vector4 get yyxx => const Vector4.zero();
  Vector4 get yyxy => const Vector4.zero();
  Vector4 get yyyx => const Vector4.zero();
  Vector4 get yyyy => const Vector4.zero();

  double get r => x;
  double get g => y;

  // Vector2 rg swizzles: r first
  Vector2 get rr => const Vector2.zero();
  Vector2 get rg => const Vector2.zero();

  // Vector2 rg swizzles: g first
  Vector2 get gr => const Vector2.zero();
  Vector2 get gg => const Vector2.zero();

  // Vector3 rg swizzles: r first
  Vector3 get rrr => const Vector3.zero();
  Vector3 get rrg => const Vector3.zero();
  Vector3 get rgr => const Vector3.zero();
  Vector3 get rgg => const Vector3.zero();

  // Vector3 rg swizzles: g first
  Vector3 get grr => const Vector3.zero();
  Vector3 get grg => const Vector3.zero();
  Vector3 get ggr => const Vector3.zero();
  Vector3 get ggg => const Vector3.zero();

  // Vector4 rg swizzles: r first
  Vector4 get rrrr => const Vector4.zero();
  Vector4 get rrrg => const Vector4.zero();
  Vector4 get rrgr => const Vector4.zero();
  Vector4 get rrgg => const Vector4.zero();
  Vector4 get rgrr => const Vector4.zero();
  Vector4 get rgrg => const Vector4.zero();
  Vector4 get rggr => const Vector4.zero();
  Vector4 get rggg => const Vector4.zero();

  // Vector4 rg swizzles: g first
  Vector4 get grrr => const Vector4.zero();
  Vector4 get grrg => const Vector4.zero();
  Vector4 get grgr => const Vector4.zero();
  Vector4 get grgg => const Vector4.zero();
  Vector4 get ggrr => const Vector4.zero();
  Vector4 get ggrg => const Vector4.zero();
  Vector4 get gggr => const Vector4.zero();
  Vector4 get gggg => const Vector4.zero();

  double get s => x;
  double get t => y;

  // Vector2 st swizzles: s first
  Vector2 get ss => const Vector2.zero();
  Vector2 get st => const Vector2.zero();

  // Vector2 st swizzles: t first
  Vector2 get ts => const Vector2.zero();
  Vector2 get tt => const Vector2.zero();

  // Vector3 st swizzles: s first
  Vector3 get sss => const Vector3.zero();
  Vector3 get sst => const Vector3.zero();
  Vector3 get sts => const Vector3.zero();
  Vector3 get stt => const Vector3.zero();

  // Vector3 st swizzles: t first
  Vector3 get tss => const Vector3.zero();
  Vector3 get tst => const Vector3.zero();
  Vector3 get tts => const Vector3.zero();
  Vector3 get ttt => const Vector3.zero();

  // Vector4 st swizzles: s first
  Vector4 get ssss => const Vector4.zero();
  Vector4 get ssst => const Vector4.zero();
  Vector4 get ssts => const Vector4.zero();
  Vector4 get sstt => const Vector4.zero();
  Vector4 get stss => const Vector4.zero();
  Vector4 get stst => const Vector4.zero();
  Vector4 get stts => const Vector4.zero();
  Vector4 get sttt => const Vector4.zero();

  // Vector4 st swizzles: t first
  Vector4 get tsss => const Vector4.zero();
  Vector4 get tsst => const Vector4.zero();
  Vector4 get tsts => const Vector4.zero();
  Vector4 get tstt => const Vector4.zero();
  Vector4 get ttss => const Vector4.zero();
  Vector4 get ttst => const Vector4.zero();
  Vector4 get ttts => const Vector4.zero();
  Vector4 get tttt => const Vector4.zero();

  int get columnDimension => 1;

  int get rowDimension => 2;

  bool get isSquare => false;

  Iterable<double> get values => const [0.0, 0.0];

  Iterable<double> get valuesColumnPacked => const [0.0, 0.0];

  Iterable<double> get valuesRowPacked => const [0.0, 0.0];

  Matrix get transpose => new Matrix.fromList(const [0.0, 0.0], rowDimension);

  double get determinant =>
      throw new UnsupportedError('Matrix must be square.');

  bool get isNonSingular =>
      throw new UnsupportedError('Matrix must be square.');

  Vector2 get inverse =>
      throw new UnsupportedError('This matrix is singular (has no inverse).');

  double get magnitude => 0.0;

  bool get isUnit => false;

  Vector2 get unitVector =>
      throw new UnsupportedError('A vector of magnitude 0 has no unit vector.');

  PivotingLUDecomposition get luDecomposition =>
      new PivotingLUDecomposition(this);

  ReducedQRDecomposition get qrDecomposition =>
      new ReducedQRDecomposition(this);

  List<double> rowAt(int index) {
    RangeError.checkValueInInterval(index, 0, rowDimension);

    return const [0.0];
  }

  double valueAt(int row, int column) {
    RangeError.checkValueInInterval(row, 0, rowDimension);
    RangeError.checkValueInInterval(column, 0, columnDimension);

    return 0.0;
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

    return new Matrix.zero(rowEnd - rowStart, colEnd - colStart);
  }

  Vector2 scalarProduct(num s) => const Vector2.zero();

  Vector2 scalarDivision(num s) => const Vector2.zero();

  Vector2 entrywiseSum(Matrix B) {
    if (B is Vector2) {
      return new Vector2(B.x, B.y);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector2(B.valueAt(0, 0), B.valueAt(1, 0));
    }
  }

  Vector2 entrywiseDifference(Matrix B) {
    if (B is Vector2) {
      return new Vector2(B.x, B.y);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector2(B.valueAt(0, 0), B.valueAt(1, 0));
    }
  }

  Vector2 entrywiseProduct(Matrix B) {
    if (B is Vector2) {
      return const Vector2.zero();
    } else {
      _assertEqualDimensions(this, B);

      return const Vector2.zero();
    }
  }

  Matrix matrixProduct(Matrix B) {
    if (B.rowDimension != 1) {
      throw new ArgumentError('Matrix inner dimensions must agree.');
    }

    return new Matrix.zero(rowDimension, B.columnDimension);
  }

  double dotProduct(Vector2 B) => 0.0;

  Matrix solve(Matrix B) {
    return qrDecomposition.solve(B);
  }

  Matrix solveTranspose(Matrix B) {
    throw new UnsupportedError('Matrix has more rows than columns.');
  }

  operator *(a) {
    if (a is num) {
      return scalarProduct(a);
    } else if (a is Matrix) {
      return matrixProduct(a);
    } else {
      throw new ArgumentError('Expected num or Matrix.');
    }
  }

  Vector2 operator +(Matrix B) => entrywiseSum(B);

  Vector2 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 2);

    return 0.0;
  }

  String toString() {
    return 'Vector2(0.0, 0.0)';
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector2 && other.x == x && other.y == y;

  int get hashCode => hash2(x, y);
}
