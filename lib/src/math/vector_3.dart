part of bagl.math;

/// A column vector of length 3 (a 3 by 1 matrix).
abstract class Vector3 implements Matrix {
  /// Instantiates a new [Vector3] with the specified values.
  factory Vector3(x, y, z) = _Vector3;

  /// Instantiates a new [Vector3] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 3.
  factory Vector3.fromList(List<double> values) {
    if (values.length != 3) {
      throw new ArgumentError(
          'A list of length 3 required to instantiate a Vector3.');
    }

    return new Vector3(values[0], values[1], values[2]);
  }

  /// Instantiates a new [Vector3] where every position is set to the specified
  /// value.
  factory Vector3.constant(double value) => new _Vector3(value, value, value);

  /// Instantiates a new [Vector3] where every position is set to zero.
  const factory Vector3.zero() = _Vector3Zero;

  double get x;
  double get y;
  double get z;

  // Vector2 xyz swizzles: x first
  Vector2 get xx;
  Vector2 get xy;
  Vector2 get xz;

  // Vector2 xyz swizzles: y first
  Vector2 get yx;
  Vector2 get yy;
  Vector2 get yz;

  // Vector2 xyz swizzles: z first
  Vector2 get zx;
  Vector2 get zy;
  Vector2 get zz;

  // Vector3 xyz swizzles: x first
  Vector3 get xxx;
  Vector3 get xxy;
  Vector3 get xxz;
  Vector3 get xyx;
  Vector3 get xyy;
  Vector3 get xyz;
  Vector3 get xzx;
  Vector3 get xzy;
  Vector3 get xzz;

  // Vector3 xyz swizzles: y first
  Vector3 get yxx;
  Vector3 get yxy;
  Vector3 get yxz;
  Vector3 get yyx;
  Vector3 get yyy;
  Vector3 get yyz;
  Vector3 get yzx;
  Vector3 get yzy;
  Vector3 get yzz;

  // Vector3 xyz swizzles: z first
  Vector3 get zxx;
  Vector3 get zxy;
  Vector3 get zxz;
  Vector3 get zyx;
  Vector3 get zyy;
  Vector3 get zyz;
  Vector3 get zzx;
  Vector3 get zzy;
  Vector3 get zzz;

  // Vector4 xyz swizzles: x first
  Vector4 get xxxx;
  Vector4 get xxxy;
  Vector4 get xxxz;
  Vector4 get xxyx;
  Vector4 get xxyy;
  Vector4 get xxyz;
  Vector4 get xxzx;
  Vector4 get xxzy;
  Vector4 get xxzz;
  Vector4 get xyxx;
  Vector4 get xyxy;
  Vector4 get xyxz;
  Vector4 get xyyx;
  Vector4 get xyyy;
  Vector4 get xyyz;
  Vector4 get xyzx;
  Vector4 get xyzy;
  Vector4 get xyzz;
  Vector4 get xzxx;
  Vector4 get xzxy;
  Vector4 get xzxz;
  Vector4 get xzyx;
  Vector4 get xzyy;
  Vector4 get xzyz;
  Vector4 get xzzx;
  Vector4 get xzzy;
  Vector4 get xzzz;

  // Vector4 xyz swizzles: y first
  Vector4 get yxxx;
  Vector4 get yxxy;
  Vector4 get yxxz;
  Vector4 get yxyx;
  Vector4 get yxyy;
  Vector4 get yxyz;
  Vector4 get yxzx;
  Vector4 get yxzy;
  Vector4 get yxzz;
  Vector4 get yyxx;
  Vector4 get yyxy;
  Vector4 get yyxz;
  Vector4 get yyyx;
  Vector4 get yyyy;
  Vector4 get yyyz;
  Vector4 get yyzx;
  Vector4 get yyzy;
  Vector4 get yyzz;
  Vector4 get yzxx;
  Vector4 get yzxy;
  Vector4 get yzxz;
  Vector4 get yzyx;
  Vector4 get yzyy;
  Vector4 get yzyz;
  Vector4 get yzzx;
  Vector4 get yzzy;
  Vector4 get yzzz;

  // Vector4 xyz swizzles: z first
  Vector4 get zxxx;
  Vector4 get zxxy;
  Vector4 get zxxz;
  Vector4 get zxyx;
  Vector4 get zxyy;
  Vector4 get zxyz;
  Vector4 get zxzx;
  Vector4 get zxzy;
  Vector4 get zxzz;
  Vector4 get zyxx;
  Vector4 get zyxy;
  Vector4 get zyxz;
  Vector4 get zyyx;
  Vector4 get zyyy;
  Vector4 get zyyz;
  Vector4 get zyzx;
  Vector4 get zyzy;
  Vector4 get zyzz;
  Vector4 get zzxx;
  Vector4 get zzxy;
  Vector4 get zzxz;
  Vector4 get zzyx;
  Vector4 get zzyy;
  Vector4 get zzyz;
  Vector4 get zzzx;
  Vector4 get zzzy;
  Vector4 get zzzz;

  double get r;
  double get g;
  double get b;

  // Vector2 rgb swizzles: r first
  Vector2 get rr;
  Vector2 get rg;
  Vector2 get rb;

  // Vector2 rgb swizzles: g first
  Vector2 get gr;
  Vector2 get gg;
  Vector2 get gb;

  // Vector2 rgb swizzles: b first
  Vector2 get br;
  Vector2 get bg;
  Vector2 get bb;

  // Vector3 rgb swizzles: r first
  Vector3 get rrr;
  Vector3 get rrg;
  Vector3 get rrb;
  Vector3 get rgr;
  Vector3 get rgg;
  Vector3 get rgb;
  Vector3 get rbr;
  Vector3 get rbg;
  Vector3 get rbb;

  // Vector3 rgb swizzles: g first
  Vector3 get grr;
  Vector3 get grg;
  Vector3 get grb;
  Vector3 get ggr;
  Vector3 get ggg;
  Vector3 get ggb;
  Vector3 get gbr;
  Vector3 get gbg;
  Vector3 get gbb;

  // Vector3 rgb swizzles: b first
  Vector3 get brr;
  Vector3 get brg;
  Vector3 get brb;
  Vector3 get bgr;
  Vector3 get bgg;
  Vector3 get bgb;
  Vector3 get bbr;
  Vector3 get bbg;
  Vector3 get bbb;

  // Vector4 rgb swizzles: r first
  Vector4 get rrrr;
  Vector4 get rrrg;
  Vector4 get rrrb;
  Vector4 get rrgr;
  Vector4 get rrgg;
  Vector4 get rrgb;
  Vector4 get rrbr;
  Vector4 get rrbg;
  Vector4 get rrbb;
  Vector4 get rgrr;
  Vector4 get rgrg;
  Vector4 get rgrb;
  Vector4 get rggr;
  Vector4 get rggg;
  Vector4 get rggb;
  Vector4 get rgbr;
  Vector4 get rgbg;
  Vector4 get rgbb;
  Vector4 get rbrr;
  Vector4 get rbrg;
  Vector4 get rbrb;
  Vector4 get rbgr;
  Vector4 get rbgg;
  Vector4 get rbgb;
  Vector4 get rbbr;
  Vector4 get rbbg;
  Vector4 get rbbb;

  // Vector4 rgb swizzles: g first
  Vector4 get grrr;
  Vector4 get grrg;
  Vector4 get grrb;
  Vector4 get grgr;
  Vector4 get grgg;
  Vector4 get grgb;
  Vector4 get grbr;
  Vector4 get grbg;
  Vector4 get grbb;
  Vector4 get ggrr;
  Vector4 get ggrg;
  Vector4 get ggrb;
  Vector4 get gggr;
  Vector4 get gggg;
  Vector4 get gggb;
  Vector4 get ggbr;
  Vector4 get ggbg;
  Vector4 get ggbb;
  Vector4 get gbrr;
  Vector4 get gbrg;
  Vector4 get gbrb;
  Vector4 get gbgr;
  Vector4 get gbgg;
  Vector4 get gbgb;
  Vector4 get gbbr;
  Vector4 get gbbg;
  Vector4 get gbbb;

  // Vector4 rgb swizzles: b first
  Vector4 get brrr;
  Vector4 get brrg;
  Vector4 get brrb;
  Vector4 get brgr;
  Vector4 get brgg;
  Vector4 get brgb;
  Vector4 get brbr;
  Vector4 get brbg;
  Vector4 get brbb;
  Vector4 get bgrr;
  Vector4 get bgrg;
  Vector4 get bgrb;
  Vector4 get bggr;
  Vector4 get bggg;
  Vector4 get bggb;
  Vector4 get bgbr;
  Vector4 get bgbg;
  Vector4 get bgbb;
  Vector4 get bbrr;
  Vector4 get bbrg;
  Vector4 get bbrb;
  Vector4 get bbgr;
  Vector4 get bbgg;
  Vector4 get bbgb;
  Vector4 get bbbr;
  Vector4 get bbbg;
  Vector4 get bbbb;

  double get s;
  double get t;
  double get p;

  // Vector2 stp swizzles: s first
  Vector2 get ss;
  Vector2 get st;
  Vector2 get sp;

  // Vector2 stp swizzles: t first
  Vector2 get ts;
  Vector2 get tt;
  Vector2 get tp;

  // Vector2 stp swizzles: p first
  Vector2 get ps;
  Vector2 get pt;
  Vector2 get pp;

  // Vector3 stp swizzles: s first
  Vector3 get sss;
  Vector3 get sst;
  Vector3 get ssp;
  Vector3 get sts;
  Vector3 get stt;
  Vector3 get stp;
  Vector3 get sps;
  Vector3 get spt;
  Vector3 get spp;

  // Vector3 stp swizzles: t first
  Vector3 get tss;
  Vector3 get tst;
  Vector3 get tsp;
  Vector3 get tts;
  Vector3 get ttt;
  Vector3 get ttp;
  Vector3 get tps;
  Vector3 get tpt;
  Vector3 get tpp;

  // Vector3 stp swizzles: p first
  Vector3 get pss;
  Vector3 get pst;
  Vector3 get psp;
  Vector3 get pts;
  Vector3 get ptt;
  Vector3 get ptp;
  Vector3 get pps;
  Vector3 get ppt;
  Vector3 get ppp;

  // Vector4 stp swizzles: s first
  Vector4 get ssss;
  Vector4 get ssst;
  Vector4 get sssp;
  Vector4 get ssts;
  Vector4 get sstt;
  Vector4 get sstp;
  Vector4 get ssps;
  Vector4 get sspt;
  Vector4 get sspp;
  Vector4 get stss;
  Vector4 get stst;
  Vector4 get stsp;
  Vector4 get stts;
  Vector4 get sttt;
  Vector4 get sttp;
  Vector4 get stps;
  Vector4 get stpt;
  Vector4 get stpp;
  Vector4 get spss;
  Vector4 get spst;
  Vector4 get spsp;
  Vector4 get spts;
  Vector4 get sptt;
  Vector4 get sptp;
  Vector4 get spps;
  Vector4 get sppt;
  Vector4 get sppp;

  // Vector4 stp swizzles: t first
  Vector4 get tsss;
  Vector4 get tsst;
  Vector4 get tssp;
  Vector4 get tsts;
  Vector4 get tstt;
  Vector4 get tstp;
  Vector4 get tsps;
  Vector4 get tspt;
  Vector4 get tspp;
  Vector4 get ttss;
  Vector4 get ttst;
  Vector4 get ttsp;
  Vector4 get ttts;
  Vector4 get tttt;
  Vector4 get tttp;
  Vector4 get ttps;
  Vector4 get ttpt;
  Vector4 get ttpp;
  Vector4 get tpss;
  Vector4 get tpst;
  Vector4 get tpsp;
  Vector4 get tpts;
  Vector4 get tptt;
  Vector4 get tptp;
  Vector4 get tpps;
  Vector4 get tppt;
  Vector4 get tppp;

  // Vector4 stp swizzles: p first
  Vector4 get psss;
  Vector4 get psst;
  Vector4 get pssp;
  Vector4 get psts;
  Vector4 get pstt;
  Vector4 get pstp;
  Vector4 get psps;
  Vector4 get pspt;
  Vector4 get pspp;
  Vector4 get ptss;
  Vector4 get ptst;
  Vector4 get ptsp;
  Vector4 get ptts;
  Vector4 get pttt;
  Vector4 get pttp;
  Vector4 get ptps;
  Vector4 get ptpt;
  Vector4 get ptpp;
  Vector4 get ppss;
  Vector4 get ppst;
  Vector4 get ppsp;
  Vector4 get ppts;
  Vector4 get pptt;
  Vector4 get pptp;
  Vector4 get ppps;
  Vector4 get pppt;
  Vector4 get pppp;

  /// The magnitude of this [Vector3].
  double get magnitude;

  /// This [Vector3]'s unit vector.
  ///
  /// A [Vector3] with a [magnitude] of `1` that has the same direction as this
  /// [Vector3].
  Vector3 get unitVector;

  /// Whether or not this [Vector3] is a unit vector.
  bool get isUnit;

  /// Computes the dot product of this [Vector3] `A` and another [Vector3] [B].
  double dotProduct(Vector3 B);

  /// Computes the cross product of this [Vector3] `A` and another [Vector3]
  /// [B].
  Vector3 crossProduct(Vector3 B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index);
}

/// A column vector of length 3 (a 3 by 1 matrix).
class _Vector3 extends _VertexBase implements Vector3 {
  final double x;
  final double y;
  final double z;

  final int columnDimension = 1;

  final int rowDimension = 3;

  Float32List _storageInternal;

  double _squareSum;

  double _magnitude;

  Vector3 _unitVector;

  /// Instantiates a new [Vector3] with the specified values.
  _Vector3(this.x, this.y, this.z);

  Float32List get _storage {
    if (_storageInternal == null) {
      _storageInternal = new Float32List(3);
      _storageInternal[0] = x;
      _storageInternal[1] = y;
      _storageInternal[2] = z;
    }

    return _storageInternal;
  }

  // Vector2 xyz swizzles: x first
  Vector2 get xx => new Vector2(x, x);
  Vector2 get xy => new Vector2(x, y);
  Vector2 get xz => new Vector2(x, z);

  // Vector2 xyz swizzles: y first
  Vector2 get yx => new Vector2(y, x);
  Vector2 get yy => new Vector2(y, y);
  Vector2 get yz => new Vector2(y, z);

  // Vector2 xyz swizzles: z first
  Vector2 get zx => new Vector2(z, x);
  Vector2 get zy => new Vector2(z, y);
  Vector2 get zz => new Vector2(z, z);

  // Vector3 xyz swizzles: x first
  Vector3 get xxx => new Vector3(x, x, x);
  Vector3 get xxy => new Vector3(x, x, y);
  Vector3 get xxz => new Vector3(x, x, z);
  Vector3 get xyx => new Vector3(x, y, x);
  Vector3 get xyy => new Vector3(x, y, y);
  Vector3 get xyz => new Vector3(x, y, z);
  Vector3 get xzx => new Vector3(x, z, x);
  Vector3 get xzy => new Vector3(x, z, y);
  Vector3 get xzz => new Vector3(x, z, z);

  // Vector3 xyz swizzles: y first
  Vector3 get yxx => new Vector3(y, x, x);
  Vector3 get yxy => new Vector3(y, x, y);
  Vector3 get yxz => new Vector3(y, x, z);
  Vector3 get yyx => new Vector3(y, y, x);
  Vector3 get yyy => new Vector3(y, y, y);
  Vector3 get yyz => new Vector3(y, y, z);
  Vector3 get yzx => new Vector3(y, z, x);
  Vector3 get yzy => new Vector3(y, z, y);
  Vector3 get yzz => new Vector3(y, z, z);

  // Vector3 xyz swizzles: z first
  Vector3 get zxx => new Vector3(z, x, x);
  Vector3 get zxy => new Vector3(z, x, y);
  Vector3 get zxz => new Vector3(z, x, z);
  Vector3 get zyx => new Vector3(z, y, x);
  Vector3 get zyy => new Vector3(z, y, y);
  Vector3 get zyz => new Vector3(z, y, z);
  Vector3 get zzx => new Vector3(z, z, x);
  Vector3 get zzy => new Vector3(z, z, y);
  Vector3 get zzz => new Vector3(z, z, z);

  // Vector4 xyz swizzles: x first
  Vector4 get xxxx => new Vector4(x, x, x, x);
  Vector4 get xxxy => new Vector4(x, x, x, y);
  Vector4 get xxxz => new Vector4(x, x, x, z);
  Vector4 get xxyx => new Vector4(x, x, y, x);
  Vector4 get xxyy => new Vector4(x, x, y, y);
  Vector4 get xxyz => new Vector4(x, x, y, z);
  Vector4 get xxzx => new Vector4(x, x, z, x);
  Vector4 get xxzy => new Vector4(x, x, z, y);
  Vector4 get xxzz => new Vector4(x, x, z, z);
  Vector4 get xyxx => new Vector4(x, y, x, x);
  Vector4 get xyxy => new Vector4(x, y, x, y);
  Vector4 get xyxz => new Vector4(x, y, x, z);
  Vector4 get xyyx => new Vector4(x, y, y, x);
  Vector4 get xyyy => new Vector4(x, y, y, y);
  Vector4 get xyyz => new Vector4(x, y, y, z);
  Vector4 get xyzx => new Vector4(x, y, z, x);
  Vector4 get xyzy => new Vector4(x, y, z, y);
  Vector4 get xyzz => new Vector4(x, y, z, z);
  Vector4 get xzxx => new Vector4(x, z, x, x);
  Vector4 get xzxy => new Vector4(x, z, x, y);
  Vector4 get xzxz => new Vector4(x, z, x, z);
  Vector4 get xzyx => new Vector4(x, z, y, x);
  Vector4 get xzyy => new Vector4(x, z, y, y);
  Vector4 get xzyz => new Vector4(x, z, y, z);
  Vector4 get xzzx => new Vector4(x, z, z, x);
  Vector4 get xzzy => new Vector4(x, z, z, y);
  Vector4 get xzzz => new Vector4(x, z, z, z);

  // Vector4 xyz swizzles: y first
  Vector4 get yxxx => new Vector4(y, x, x, x);
  Vector4 get yxxy => new Vector4(y, x, x, y);
  Vector4 get yxxz => new Vector4(y, x, x, z);
  Vector4 get yxyx => new Vector4(y, x, y, x);
  Vector4 get yxyy => new Vector4(y, x, y, y);
  Vector4 get yxyz => new Vector4(y, x, y, z);
  Vector4 get yxzx => new Vector4(y, x, z, x);
  Vector4 get yxzy => new Vector4(y, x, z, y);
  Vector4 get yxzz => new Vector4(y, x, z, z);
  Vector4 get yyxx => new Vector4(y, y, x, x);
  Vector4 get yyxy => new Vector4(y, y, x, y);
  Vector4 get yyxz => new Vector4(y, y, x, z);
  Vector4 get yyyx => new Vector4(y, y, y, x);
  Vector4 get yyyy => new Vector4(y, y, y, y);
  Vector4 get yyyz => new Vector4(y, y, y, z);
  Vector4 get yyzx => new Vector4(y, y, z, x);
  Vector4 get yyzy => new Vector4(y, y, z, y);
  Vector4 get yyzz => new Vector4(y, y, z, z);
  Vector4 get yzxx => new Vector4(y, z, x, x);
  Vector4 get yzxy => new Vector4(y, z, x, y);
  Vector4 get yzxz => new Vector4(y, z, x, z);
  Vector4 get yzyx => new Vector4(y, z, y, x);
  Vector4 get yzyy => new Vector4(y, z, y, y);
  Vector4 get yzyz => new Vector4(y, z, y, z);
  Vector4 get yzzx => new Vector4(y, z, z, x);
  Vector4 get yzzy => new Vector4(y, z, z, y);
  Vector4 get yzzz => new Vector4(y, z, z, z);

  // Vector4 xyz swizzles: z first
  Vector4 get zxxx => new Vector4(z, x, x, x);
  Vector4 get zxxy => new Vector4(z, x, x, y);
  Vector4 get zxxz => new Vector4(z, x, x, z);
  Vector4 get zxyx => new Vector4(z, x, y, x);
  Vector4 get zxyy => new Vector4(z, x, y, y);
  Vector4 get zxyz => new Vector4(z, x, y, z);
  Vector4 get zxzx => new Vector4(z, x, z, x);
  Vector4 get zxzy => new Vector4(z, x, z, y);
  Vector4 get zxzz => new Vector4(z, x, z, z);
  Vector4 get zyxx => new Vector4(z, y, x, x);
  Vector4 get zyxy => new Vector4(z, y, x, y);
  Vector4 get zyxz => new Vector4(z, y, x, z);
  Vector4 get zyyx => new Vector4(z, y, y, x);
  Vector4 get zyyy => new Vector4(z, y, y, y);
  Vector4 get zyyz => new Vector4(z, y, y, z);
  Vector4 get zyzx => new Vector4(z, y, z, x);
  Vector4 get zyzy => new Vector4(z, y, z, y);
  Vector4 get zyzz => new Vector4(z, y, z, z);
  Vector4 get zzxx => new Vector4(z, z, x, x);
  Vector4 get zzxy => new Vector4(z, z, x, y);
  Vector4 get zzxz => new Vector4(z, z, x, z);
  Vector4 get zzyx => new Vector4(z, z, y, x);
  Vector4 get zzyy => new Vector4(z, z, y, y);
  Vector4 get zzyz => new Vector4(z, z, y, z);
  Vector4 get zzzx => new Vector4(z, z, z, x);
  Vector4 get zzzy => new Vector4(z, z, z, y);
  Vector4 get zzzz => new Vector4(z, z, z, z);

  double get r => x;
  double get g => y;
  double get b => z;

  // Vector2 rgb swizzles: r first
  Vector2 get rr => new Vector2(r, r);
  Vector2 get rg => new Vector2(r, g);
  Vector2 get rb => new Vector2(r, b);

  // Vector2 rgb swizzles: g first
  Vector2 get gr => new Vector2(g, r);
  Vector2 get gg => new Vector2(g, g);
  Vector2 get gb => new Vector2(g, b);

  // Vector2 rgb swizzles: b first
  Vector2 get br => new Vector2(b, r);
  Vector2 get bg => new Vector2(b, g);
  Vector2 get bb => new Vector2(b, b);

  // Vector3 rgb swizzles: r first
  Vector3 get rrr => new Vector3(r, r, r);
  Vector3 get rrg => new Vector3(r, r, g);
  Vector3 get rrb => new Vector3(r, r, b);
  Vector3 get rgr => new Vector3(r, g, r);
  Vector3 get rgg => new Vector3(r, g, g);
  Vector3 get rgb => new Vector3(r, g, b);
  Vector3 get rbr => new Vector3(r, b, r);
  Vector3 get rbg => new Vector3(r, b, g);
  Vector3 get rbb => new Vector3(r, b, b);

  // Vector3 rgb swizzles: g first
  Vector3 get grr => new Vector3(g, r, r);
  Vector3 get grg => new Vector3(g, r, g);
  Vector3 get grb => new Vector3(g, r, b);
  Vector3 get ggr => new Vector3(g, g, r);
  Vector3 get ggg => new Vector3(g, g, g);
  Vector3 get ggb => new Vector3(g, g, b);
  Vector3 get gbr => new Vector3(g, b, r);
  Vector3 get gbg => new Vector3(g, b, g);
  Vector3 get gbb => new Vector3(g, b, b);

  // Vector3 rgb swizzles: b first
  Vector3 get brr => new Vector3(b, r, r);
  Vector3 get brg => new Vector3(b, r, g);
  Vector3 get brb => new Vector3(b, r, b);
  Vector3 get bgr => new Vector3(b, g, r);
  Vector3 get bgg => new Vector3(b, g, g);
  Vector3 get bgb => new Vector3(b, g, b);
  Vector3 get bbr => new Vector3(b, b, r);
  Vector3 get bbg => new Vector3(b, b, g);
  Vector3 get bbb => new Vector3(b, b, b);

  // Vector4 rgb swizzles: r first
  Vector4 get rrrr => new Vector4(r, r, r, r);
  Vector4 get rrrg => new Vector4(r, r, r, g);
  Vector4 get rrrb => new Vector4(r, r, r, b);
  Vector4 get rrgr => new Vector4(r, r, g, r);
  Vector4 get rrgg => new Vector4(r, r, g, g);
  Vector4 get rrgb => new Vector4(r, r, g, b);
  Vector4 get rrbr => new Vector4(r, r, b, r);
  Vector4 get rrbg => new Vector4(r, r, b, g);
  Vector4 get rrbb => new Vector4(r, r, b, b);
  Vector4 get rgrr => new Vector4(r, g, r, r);
  Vector4 get rgrg => new Vector4(r, g, r, g);
  Vector4 get rgrb => new Vector4(r, g, r, b);
  Vector4 get rggr => new Vector4(r, g, g, r);
  Vector4 get rggg => new Vector4(r, g, g, g);
  Vector4 get rggb => new Vector4(r, g, g, b);
  Vector4 get rgbr => new Vector4(r, g, b, r);
  Vector4 get rgbg => new Vector4(r, g, b, g);
  Vector4 get rgbb => new Vector4(r, g, b, b);
  Vector4 get rbrr => new Vector4(r, b, r, r);
  Vector4 get rbrg => new Vector4(r, b, r, g);
  Vector4 get rbrb => new Vector4(r, b, r, b);
  Vector4 get rbgr => new Vector4(r, b, g, r);
  Vector4 get rbgg => new Vector4(r, b, g, g);
  Vector4 get rbgb => new Vector4(r, b, g, b);
  Vector4 get rbbr => new Vector4(r, b, b, r);
  Vector4 get rbbg => new Vector4(r, b, b, g);
  Vector4 get rbbb => new Vector4(r, b, b, b);

  // Vector4 rgb swizzles: g first
  Vector4 get grrr => new Vector4(g, r, r, r);
  Vector4 get grrg => new Vector4(g, r, r, g);
  Vector4 get grrb => new Vector4(g, r, r, b);
  Vector4 get grgr => new Vector4(g, r, g, r);
  Vector4 get grgg => new Vector4(g, r, g, g);
  Vector4 get grgb => new Vector4(g, r, g, b);
  Vector4 get grbr => new Vector4(g, r, b, r);
  Vector4 get grbg => new Vector4(g, r, b, g);
  Vector4 get grbb => new Vector4(g, r, b, b);
  Vector4 get ggrr => new Vector4(g, g, r, r);
  Vector4 get ggrg => new Vector4(g, g, r, g);
  Vector4 get ggrb => new Vector4(g, g, r, b);
  Vector4 get gggr => new Vector4(g, g, g, r);
  Vector4 get gggg => new Vector4(g, g, g, g);
  Vector4 get gggb => new Vector4(g, g, g, b);
  Vector4 get ggbr => new Vector4(g, g, b, r);
  Vector4 get ggbg => new Vector4(g, g, b, g);
  Vector4 get ggbb => new Vector4(g, g, b, b);
  Vector4 get gbrr => new Vector4(g, b, r, r);
  Vector4 get gbrg => new Vector4(g, b, r, g);
  Vector4 get gbrb => new Vector4(g, b, r, b);
  Vector4 get gbgr => new Vector4(g, b, g, r);
  Vector4 get gbgg => new Vector4(g, b, g, g);
  Vector4 get gbgb => new Vector4(g, b, g, b);
  Vector4 get gbbr => new Vector4(g, b, b, r);
  Vector4 get gbbg => new Vector4(g, b, b, g);
  Vector4 get gbbb => new Vector4(g, b, b, b);

  // Vector4 rgb swizzles: b first
  Vector4 get brrr => new Vector4(b, r, r, r);
  Vector4 get brrg => new Vector4(b, r, r, g);
  Vector4 get brrb => new Vector4(b, r, r, b);
  Vector4 get brgr => new Vector4(b, r, g, r);
  Vector4 get brgg => new Vector4(b, r, g, g);
  Vector4 get brgb => new Vector4(b, r, g, b);
  Vector4 get brbr => new Vector4(b, r, b, r);
  Vector4 get brbg => new Vector4(b, r, b, g);
  Vector4 get brbb => new Vector4(b, r, b, b);
  Vector4 get bgrr => new Vector4(b, g, r, r);
  Vector4 get bgrg => new Vector4(b, g, r, g);
  Vector4 get bgrb => new Vector4(b, g, r, b);
  Vector4 get bggr => new Vector4(b, g, g, r);
  Vector4 get bggg => new Vector4(b, g, g, g);
  Vector4 get bggb => new Vector4(b, g, g, b);
  Vector4 get bgbr => new Vector4(b, g, b, r);
  Vector4 get bgbg => new Vector4(b, g, b, g);
  Vector4 get bgbb => new Vector4(b, g, b, b);
  Vector4 get bbrr => new Vector4(b, b, r, r);
  Vector4 get bbrg => new Vector4(b, b, r, g);
  Vector4 get bbrb => new Vector4(b, b, r, b);
  Vector4 get bbgr => new Vector4(b, b, g, r);
  Vector4 get bbgg => new Vector4(b, b, g, g);
  Vector4 get bbgb => new Vector4(b, b, g, b);
  Vector4 get bbbr => new Vector4(b, b, b, r);
  Vector4 get bbbg => new Vector4(b, b, b, g);
  Vector4 get bbbb => new Vector4(b, b, b, b);

  double get s => x;
  double get t => y;
  double get p => z;

  // Vector2 stp swizzles: s first
  Vector2 get ss => new Vector2(s, s);
  Vector2 get st => new Vector2(s, t);
  Vector2 get sp => new Vector2(s, p);

  // Vector2 stp swizzles: t first
  Vector2 get ts => new Vector2(t, s);
  Vector2 get tt => new Vector2(t, t);
  Vector2 get tp => new Vector2(t, p);

  // Vector2 stp swizzles: p first
  Vector2 get ps => new Vector2(p, s);
  Vector2 get pt => new Vector2(p, t);
  Vector2 get pp => new Vector2(p, p);

  // Vector3 stp swizzles: s first
  Vector3 get sss => new Vector3(s, s, s);
  Vector3 get sst => new Vector3(s, s, t);
  Vector3 get ssp => new Vector3(s, s, p);
  Vector3 get sts => new Vector3(s, t, s);
  Vector3 get stt => new Vector3(s, t, t);
  Vector3 get stp => new Vector3(s, t, p);
  Vector3 get sps => new Vector3(s, p, s);
  Vector3 get spt => new Vector3(s, p, t);
  Vector3 get spp => new Vector3(s, p, p);

  // Vector3 stp swizzles: t first
  Vector3 get tss => new Vector3(t, s, s);
  Vector3 get tst => new Vector3(t, s, t);
  Vector3 get tsp => new Vector3(t, s, p);
  Vector3 get tts => new Vector3(t, t, s);
  Vector3 get ttt => new Vector3(t, t, t);
  Vector3 get ttp => new Vector3(t, t, p);
  Vector3 get tps => new Vector3(t, p, s);
  Vector3 get tpt => new Vector3(t, p, t);
  Vector3 get tpp => new Vector3(t, p, p);

  // Vector3 stp swizzles: p first
  Vector3 get pss => new Vector3(p, s, s);
  Vector3 get pst => new Vector3(p, s, t);
  Vector3 get psp => new Vector3(p, s, p);
  Vector3 get pts => new Vector3(p, t, s);
  Vector3 get ptt => new Vector3(p, t, t);
  Vector3 get ptp => new Vector3(p, t, p);
  Vector3 get pps => new Vector3(p, p, s);
  Vector3 get ppt => new Vector3(p, p, t);
  Vector3 get ppp => new Vector3(p, p, p);

  // Vector4 stp swizzles: s first
  Vector4 get ssss => new Vector4(s, s, s, s);
  Vector4 get ssst => new Vector4(s, s, s, t);
  Vector4 get sssp => new Vector4(s, s, s, p);
  Vector4 get ssts => new Vector4(s, s, t, s);
  Vector4 get sstt => new Vector4(s, s, t, t);
  Vector4 get sstp => new Vector4(s, s, t, p);
  Vector4 get ssps => new Vector4(s, s, p, s);
  Vector4 get sspt => new Vector4(s, s, p, t);
  Vector4 get sspp => new Vector4(s, s, p, p);
  Vector4 get stss => new Vector4(s, t, s, s);
  Vector4 get stst => new Vector4(s, t, s, t);
  Vector4 get stsp => new Vector4(s, t, s, p);
  Vector4 get stts => new Vector4(s, t, t, s);
  Vector4 get sttt => new Vector4(s, t, t, t);
  Vector4 get sttp => new Vector4(s, t, t, p);
  Vector4 get stps => new Vector4(s, t, p, s);
  Vector4 get stpt => new Vector4(s, t, p, t);
  Vector4 get stpp => new Vector4(s, t, p, p);
  Vector4 get spss => new Vector4(s, p, s, s);
  Vector4 get spst => new Vector4(s, p, s, t);
  Vector4 get spsp => new Vector4(s, p, s, p);
  Vector4 get spts => new Vector4(s, p, t, s);
  Vector4 get sptt => new Vector4(s, p, t, t);
  Vector4 get sptp => new Vector4(s, p, t, p);
  Vector4 get spps => new Vector4(s, p, p, s);
  Vector4 get sppt => new Vector4(s, p, p, t);
  Vector4 get sppp => new Vector4(s, p, p, p);

  // Vector4 stp swizzles: t first
  Vector4 get tsss => new Vector4(t, s, s, s);
  Vector4 get tsst => new Vector4(t, s, s, t);
  Vector4 get tssp => new Vector4(t, s, s, p);
  Vector4 get tsts => new Vector4(t, s, t, s);
  Vector4 get tstt => new Vector4(t, s, t, t);
  Vector4 get tstp => new Vector4(t, s, t, p);
  Vector4 get tsps => new Vector4(t, s, p, s);
  Vector4 get tspt => new Vector4(t, s, p, t);
  Vector4 get tspp => new Vector4(t, s, p, p);
  Vector4 get ttss => new Vector4(t, t, s, s);
  Vector4 get ttst => new Vector4(t, t, s, t);
  Vector4 get ttsp => new Vector4(t, t, s, p);
  Vector4 get ttts => new Vector4(t, t, t, s);
  Vector4 get tttt => new Vector4(t, t, t, t);
  Vector4 get tttp => new Vector4(t, t, t, p);
  Vector4 get ttps => new Vector4(t, t, p, s);
  Vector4 get ttpt => new Vector4(t, t, p, t);
  Vector4 get ttpp => new Vector4(t, t, p, p);
  Vector4 get tpss => new Vector4(t, p, s, s);
  Vector4 get tpst => new Vector4(t, p, s, t);
  Vector4 get tpsp => new Vector4(t, p, s, p);
  Vector4 get tpts => new Vector4(t, p, t, s);
  Vector4 get tptt => new Vector4(t, p, t, t);
  Vector4 get tptp => new Vector4(t, p, t, p);
  Vector4 get tpps => new Vector4(t, p, p, s);
  Vector4 get tppt => new Vector4(t, p, p, t);
  Vector4 get tppp => new Vector4(t, p, p, p);

  // Vector4 stp swizzles: p first
  Vector4 get psss => new Vector4(p, s, s, s);
  Vector4 get psst => new Vector4(p, s, s, t);
  Vector4 get pssp => new Vector4(p, s, s, p);
  Vector4 get psts => new Vector4(p, s, t, s);
  Vector4 get pstt => new Vector4(p, s, t, t);
  Vector4 get pstp => new Vector4(p, s, t, p);
  Vector4 get psps => new Vector4(p, s, p, s);
  Vector4 get pspt => new Vector4(p, s, p, t);
  Vector4 get pspp => new Vector4(p, s, p, p);
  Vector4 get ptss => new Vector4(p, t, s, s);
  Vector4 get ptst => new Vector4(p, t, s, t);
  Vector4 get ptsp => new Vector4(p, t, s, p);
  Vector4 get ptts => new Vector4(p, t, t, s);
  Vector4 get pttt => new Vector4(p, t, t, t);
  Vector4 get pttp => new Vector4(p, t, t, p);
  Vector4 get ptps => new Vector4(p, t, p, s);
  Vector4 get ptpt => new Vector4(p, t, p, t);
  Vector4 get ptpp => new Vector4(p, t, p, p);
  Vector4 get ppss => new Vector4(p, p, s, s);
  Vector4 get ppst => new Vector4(p, p, s, t);
  Vector4 get ppsp => new Vector4(p, p, s, p);
  Vector4 get ppts => new Vector4(p, p, t, s);
  Vector4 get pptt => new Vector4(p, p, t, t);
  Vector4 get pptp => new Vector4(p, p, t, p);
  Vector4 get ppps => new Vector4(p, p, p, s);
  Vector4 get pppt => new Vector4(p, p, p, t);
  Vector4 get pppp => new Vector4(p, p, p, p);

  double get magnitude {
    if (_magnitude == null) {
      _squareSum ??= x * x + y * y + z * z;

      if ((_squareSum - 1).abs() < 0.0001) {
        _magnitude = 1.0;
      } else {
        _magnitude = sqrt(_squareSum);
      }
    }

    return _magnitude;
  }

  Vector3 get unitVector {
    if (_unitVector == null) {
      if (_unitVector == null) {
        if (_magnitude != null) {
          if (_magnitude == 1.0) {
            _unitVector = new Vector3(x, y, z);
          } else {
            _unitVector =
                new Vector3(x / _magnitude, y / _magnitude, z / _magnitude);
          }
        } else {
          _squareSum ??= x * x + y * y + z * z;

          if ((_squareSum - 1).abs() < 0.0001) {
            _unitVector = new Vector3(x, y, z);
          } else {
            _magnitude ??= sqrt(_squareSum);

            _unitVector =
                new Vector3(x / _magnitude, y / _magnitude, z / _magnitude);
          }
        }
      }

      return _unitVector;
    }

    return _unitVector;
  }

  bool get isUnit {
    if (_magnitude != null) {
      return _magnitude == 1.0;
    } else {
      _squareSum ??= x * x + y * y + z * z;

      return (_squareSum - 1).abs() < 0.0001;
    }
  }

  Vector3 scalarProduct(num s) => new Vector3(x * s, y * s, z * s);

  Vector3 scalarDivision(num s) => new Vector3(x / s, y / s, z / s);

  Vector3 entrywiseSum(Matrix B) {
    if (B is Vector3) {
      return new Vector3(x + B.x, y + B.y, z + B.z);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector3(
          x + B.valueAt(0, 0), y + B.valueAt(1, 0), z + B.valueAt(2, 0));
    }
  }

  Vector3 entrywiseDifference(Matrix B) {
    if (B is Vector3) {
      return new Vector3(x - B.x, y - B.y, z - B.z);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector3(
          x - B.valueAt(0, 0), y - B.valueAt(1, 0), z - B.valueAt(2, 0));
    }
  }

  Vector3 entrywiseProduct(Matrix B) {
    if (B is Vector3) {
      return new Vector3(x * B.x, y * B.y, z * B.z);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector3(
          x * B.valueAt(0, 0), y * B.valueAt(1, 0), z * B.valueAt(2, 0));
    }
  }

  double dotProduct(Vector3 B) => x * B.x + y * B.y + z * B.z;

  Vector3 crossProduct(Vector3 B) => new Vector3(
        y * B.z - z * B.y,
        z * B.x - x * B.z,
        x * B.y - y * B.x,
      );

  Vector3 operator +(Matrix B) => entrywiseSum(B);

  Vector3 operator -(Matrix B) => entrywiseDifference(B);

  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 3);

    if (index == 0) {
      return x;
    } else if (index == 1) {
      return y;
    } else {
      return z;
    }
  }

  String toString() {
    return 'Vector3(${values.toString()})';
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector3 && other.x == x && other.y == y && other.z == z;

  int get hashCode => hash3(x, y, z);
}

class _Vector3Zero implements Vector3 {
  const _Vector3Zero();

  double get x => 0.0;
  double get y => 0.0;
  double get z => 0.0;

  // Vector2 xyz swizzles: x first
  Vector2 get xx => const Vector2.zero();
  Vector2 get xy => const Vector2.zero();
  Vector2 get xz => const Vector2.zero();

  // Vector2 xyz swizzles: y first
  Vector2 get yx => const Vector2.zero();
  Vector2 get yy => const Vector2.zero();
  Vector2 get yz => const Vector2.zero();

  // Vector2 xyz swizzles: z first
  Vector2 get zx => const Vector2.zero();
  Vector2 get zy => const Vector2.zero();
  Vector2 get zz => const Vector2.zero();

  // Vector3 xyz swizzles: x first
  Vector3 get xxx => const Vector3.zero();
  Vector3 get xxy => const Vector3.zero();
  Vector3 get xxz => const Vector3.zero();
  Vector3 get xyx => const Vector3.zero();
  Vector3 get xyy => const Vector3.zero();
  Vector3 get xyz => const Vector3.zero();
  Vector3 get xzx => const Vector3.zero();
  Vector3 get xzy => const Vector3.zero();
  Vector3 get xzz => const Vector3.zero();

  // Vector3 xyz swizzles: y first
  Vector3 get yxx => const Vector3.zero();
  Vector3 get yxy => const Vector3.zero();
  Vector3 get yxz => const Vector3.zero();
  Vector3 get yyx => const Vector3.zero();
  Vector3 get yyy => const Vector3.zero();
  Vector3 get yyz => const Vector3.zero();
  Vector3 get yzx => const Vector3.zero();
  Vector3 get yzy => const Vector3.zero();
  Vector3 get yzz => const Vector3.zero();

  // Vector3 xyz swizzles: z first
  Vector3 get zxx => const Vector3.zero();
  Vector3 get zxy => const Vector3.zero();
  Vector3 get zxz => const Vector3.zero();
  Vector3 get zyx => const Vector3.zero();
  Vector3 get zyy => const Vector3.zero();
  Vector3 get zyz => const Vector3.zero();
  Vector3 get zzx => const Vector3.zero();
  Vector3 get zzy => const Vector3.zero();
  Vector3 get zzz => const Vector3.zero();

  // Vector4 xyz swizzles: x first
  Vector4 get xxxx => const Vector4.zero();
  Vector4 get xxxy => const Vector4.zero();
  Vector4 get xxxz => const Vector4.zero();
  Vector4 get xxyx => const Vector4.zero();
  Vector4 get xxyy => const Vector4.zero();
  Vector4 get xxyz => const Vector4.zero();
  Vector4 get xxzx => const Vector4.zero();
  Vector4 get xxzy => const Vector4.zero();
  Vector4 get xxzz => const Vector4.zero();
  Vector4 get xyxx => const Vector4.zero();
  Vector4 get xyxy => const Vector4.zero();
  Vector4 get xyxz => const Vector4.zero();
  Vector4 get xyyx => const Vector4.zero();
  Vector4 get xyyy => const Vector4.zero();
  Vector4 get xyyz => const Vector4.zero();
  Vector4 get xyzx => const Vector4.zero();
  Vector4 get xyzy => const Vector4.zero();
  Vector4 get xyzz => const Vector4.zero();
  Vector4 get xzxx => const Vector4.zero();
  Vector4 get xzxy => const Vector4.zero();
  Vector4 get xzxz => const Vector4.zero();
  Vector4 get xzyx => const Vector4.zero();
  Vector4 get xzyy => const Vector4.zero();
  Vector4 get xzyz => const Vector4.zero();
  Vector4 get xzzx => const Vector4.zero();
  Vector4 get xzzy => const Vector4.zero();
  Vector4 get xzzz => const Vector4.zero();

  // Vector4 xyz swizzles: y first
  Vector4 get yxxx => const Vector4.zero();
  Vector4 get yxxy => const Vector4.zero();
  Vector4 get yxxz => const Vector4.zero();
  Vector4 get yxyx => const Vector4.zero();
  Vector4 get yxyy => const Vector4.zero();
  Vector4 get yxyz => const Vector4.zero();
  Vector4 get yxzx => const Vector4.zero();
  Vector4 get yxzy => const Vector4.zero();
  Vector4 get yxzz => const Vector4.zero();
  Vector4 get yyxx => const Vector4.zero();
  Vector4 get yyxy => const Vector4.zero();
  Vector4 get yyxz => const Vector4.zero();
  Vector4 get yyyx => const Vector4.zero();
  Vector4 get yyyy => const Vector4.zero();
  Vector4 get yyyz => const Vector4.zero();
  Vector4 get yyzx => const Vector4.zero();
  Vector4 get yyzy => const Vector4.zero();
  Vector4 get yyzz => const Vector4.zero();
  Vector4 get yzxx => const Vector4.zero();
  Vector4 get yzxy => const Vector4.zero();
  Vector4 get yzxz => const Vector4.zero();
  Vector4 get yzyx => const Vector4.zero();
  Vector4 get yzyy => const Vector4.zero();
  Vector4 get yzyz => const Vector4.zero();
  Vector4 get yzzx => const Vector4.zero();
  Vector4 get yzzy => const Vector4.zero();
  Vector4 get yzzz => const Vector4.zero();

  // Vector4 xyz swizzles: z first
  Vector4 get zxxx => const Vector4.zero();
  Vector4 get zxxy => const Vector4.zero();
  Vector4 get zxxz => const Vector4.zero();
  Vector4 get zxyx => const Vector4.zero();
  Vector4 get zxyy => const Vector4.zero();
  Vector4 get zxyz => const Vector4.zero();
  Vector4 get zxzx => const Vector4.zero();
  Vector4 get zxzy => const Vector4.zero();
  Vector4 get zxzz => const Vector4.zero();
  Vector4 get zyxx => const Vector4.zero();
  Vector4 get zyxy => const Vector4.zero();
  Vector4 get zyxz => const Vector4.zero();
  Vector4 get zyyx => const Vector4.zero();
  Vector4 get zyyy => const Vector4.zero();
  Vector4 get zyyz => const Vector4.zero();
  Vector4 get zyzx => const Vector4.zero();
  Vector4 get zyzy => const Vector4.zero();
  Vector4 get zyzz => const Vector4.zero();
  Vector4 get zzxx => const Vector4.zero();
  Vector4 get zzxy => const Vector4.zero();
  Vector4 get zzxz => const Vector4.zero();
  Vector4 get zzyx => const Vector4.zero();
  Vector4 get zzyy => const Vector4.zero();
  Vector4 get zzyz => const Vector4.zero();
  Vector4 get zzzx => const Vector4.zero();
  Vector4 get zzzy => const Vector4.zero();
  Vector4 get zzzz => const Vector4.zero();

  double get r => 0.0;
  double get g => 0.0;
  double get b => 0.0;

  // Vector2 rgb swizzles: r first
  Vector2 get rr => const Vector2.zero();
  Vector2 get rg => const Vector2.zero();
  Vector2 get rb => const Vector2.zero();

  // Vector2 rgb swizzles: g first
  Vector2 get gr => const Vector2.zero();
  Vector2 get gg => const Vector2.zero();
  Vector2 get gb => const Vector2.zero();

  // Vector2 rgb swizzles: b first
  Vector2 get br => const Vector2.zero();
  Vector2 get bg => const Vector2.zero();
  Vector2 get bb => const Vector2.zero();

  // Vector3 rgb swizzles: r first
  Vector3 get rrr => const Vector3.zero();
  Vector3 get rrg => const Vector3.zero();
  Vector3 get rrb => const Vector3.zero();
  Vector3 get rgr => const Vector3.zero();
  Vector3 get rgg => const Vector3.zero();
  Vector3 get rgb => const Vector3.zero();
  Vector3 get rbr => const Vector3.zero();
  Vector3 get rbg => const Vector3.zero();
  Vector3 get rbb => const Vector3.zero();

  // Vector3 rgb swizzles: g first
  Vector3 get grr => const Vector3.zero();
  Vector3 get grg => const Vector3.zero();
  Vector3 get grb => const Vector3.zero();
  Vector3 get ggr => const Vector3.zero();
  Vector3 get ggg => const Vector3.zero();
  Vector3 get ggb => const Vector3.zero();
  Vector3 get gbr => const Vector3.zero();
  Vector3 get gbg => const Vector3.zero();
  Vector3 get gbb => const Vector3.zero();

  // Vector3 rgb swizzles: b first
  Vector3 get brr => const Vector3.zero();
  Vector3 get brg => const Vector3.zero();
  Vector3 get brb => const Vector3.zero();
  Vector3 get bgr => const Vector3.zero();
  Vector3 get bgg => const Vector3.zero();
  Vector3 get bgb => const Vector3.zero();
  Vector3 get bbr => const Vector3.zero();
  Vector3 get bbg => const Vector3.zero();
  Vector3 get bbb => const Vector3.zero();

  // Vector4 rgb swizzles: r first
  Vector4 get rrrr => const Vector4.zero();
  Vector4 get rrrg => const Vector4.zero();
  Vector4 get rrrb => const Vector4.zero();
  Vector4 get rrgr => const Vector4.zero();
  Vector4 get rrgg => const Vector4.zero();
  Vector4 get rrgb => const Vector4.zero();
  Vector4 get rrbr => const Vector4.zero();
  Vector4 get rrbg => const Vector4.zero();
  Vector4 get rrbb => const Vector4.zero();
  Vector4 get rgrr => const Vector4.zero();
  Vector4 get rgrg => const Vector4.zero();
  Vector4 get rgrb => const Vector4.zero();
  Vector4 get rggr => const Vector4.zero();
  Vector4 get rggg => const Vector4.zero();
  Vector4 get rggb => const Vector4.zero();
  Vector4 get rgbr => const Vector4.zero();
  Vector4 get rgbg => const Vector4.zero();
  Vector4 get rgbb => const Vector4.zero();
  Vector4 get rbrr => const Vector4.zero();
  Vector4 get rbrg => const Vector4.zero();
  Vector4 get rbrb => const Vector4.zero();
  Vector4 get rbgr => const Vector4.zero();
  Vector4 get rbgg => const Vector4.zero();
  Vector4 get rbgb => const Vector4.zero();
  Vector4 get rbbr => const Vector4.zero();
  Vector4 get rbbg => const Vector4.zero();
  Vector4 get rbbb => const Vector4.zero();

  // Vector4 rgb swizzles: g first
  Vector4 get grrr => const Vector4.zero();
  Vector4 get grrg => const Vector4.zero();
  Vector4 get grrb => const Vector4.zero();
  Vector4 get grgr => const Vector4.zero();
  Vector4 get grgg => const Vector4.zero();
  Vector4 get grgb => const Vector4.zero();
  Vector4 get grbr => const Vector4.zero();
  Vector4 get grbg => const Vector4.zero();
  Vector4 get grbb => const Vector4.zero();
  Vector4 get ggrr => const Vector4.zero();
  Vector4 get ggrg => const Vector4.zero();
  Vector4 get ggrb => const Vector4.zero();
  Vector4 get gggr => const Vector4.zero();
  Vector4 get gggg => const Vector4.zero();
  Vector4 get gggb => const Vector4.zero();
  Vector4 get ggbr => const Vector4.zero();
  Vector4 get ggbg => const Vector4.zero();
  Vector4 get ggbb => const Vector4.zero();
  Vector4 get gbrr => const Vector4.zero();
  Vector4 get gbrg => const Vector4.zero();
  Vector4 get gbrb => const Vector4.zero();
  Vector4 get gbgr => const Vector4.zero();
  Vector4 get gbgg => const Vector4.zero();
  Vector4 get gbgb => const Vector4.zero();
  Vector4 get gbbr => const Vector4.zero();
  Vector4 get gbbg => const Vector4.zero();
  Vector4 get gbbb => const Vector4.zero();

  // Vector4 rgb swizzles: b first
  Vector4 get brrr => const Vector4.zero();
  Vector4 get brrg => const Vector4.zero();
  Vector4 get brrb => const Vector4.zero();
  Vector4 get brgr => const Vector4.zero();
  Vector4 get brgg => const Vector4.zero();
  Vector4 get brgb => const Vector4.zero();
  Vector4 get brbr => const Vector4.zero();
  Vector4 get brbg => const Vector4.zero();
  Vector4 get brbb => const Vector4.zero();
  Vector4 get bgrr => const Vector4.zero();
  Vector4 get bgrg => const Vector4.zero();
  Vector4 get bgrb => const Vector4.zero();
  Vector4 get bggr => const Vector4.zero();
  Vector4 get bggg => const Vector4.zero();
  Vector4 get bggb => const Vector4.zero();
  Vector4 get bgbr => const Vector4.zero();
  Vector4 get bgbg => const Vector4.zero();
  Vector4 get bgbb => const Vector4.zero();
  Vector4 get bbrr => const Vector4.zero();
  Vector4 get bbrg => const Vector4.zero();
  Vector4 get bbrb => const Vector4.zero();
  Vector4 get bbgr => const Vector4.zero();
  Vector4 get bbgg => const Vector4.zero();
  Vector4 get bbgb => const Vector4.zero();
  Vector4 get bbbr => const Vector4.zero();
  Vector4 get bbbg => const Vector4.zero();
  Vector4 get bbbb => const Vector4.zero();

  double get s => 0.0;
  double get t => 0.0;
  double get p => 0.0;

  // Vector2 stp swizzles: s first
  Vector2 get ss => const Vector2.zero();
  Vector2 get st => const Vector2.zero();
  Vector2 get sp => const Vector2.zero();

  // Vector2 stp swizzles: t first
  Vector2 get ts => const Vector2.zero();
  Vector2 get tt => const Vector2.zero();
  Vector2 get tp => const Vector2.zero();

  // Vector2 stp swizzles: p first
  Vector2 get ps => const Vector2.zero();
  Vector2 get pt => const Vector2.zero();
  Vector2 get pp => const Vector2.zero();

  // Vector3 stp swizzles: s first
  Vector3 get sss => const Vector3.zero();
  Vector3 get sst => const Vector3.zero();
  Vector3 get ssp => const Vector3.zero();
  Vector3 get sts => const Vector3.zero();
  Vector3 get stt => const Vector3.zero();
  Vector3 get stp => const Vector3.zero();
  Vector3 get sps => const Vector3.zero();
  Vector3 get spt => const Vector3.zero();
  Vector3 get spp => const Vector3.zero();

  // Vector3 stp swizzles: t first
  Vector3 get tss => const Vector3.zero();
  Vector3 get tst => const Vector3.zero();
  Vector3 get tsp => const Vector3.zero();
  Vector3 get tts => const Vector3.zero();
  Vector3 get ttt => const Vector3.zero();
  Vector3 get ttp => const Vector3.zero();
  Vector3 get tps => const Vector3.zero();
  Vector3 get tpt => const Vector3.zero();
  Vector3 get tpp => const Vector3.zero();

  // Vector3 stp swizzles: p first
  Vector3 get pss => const Vector3.zero();
  Vector3 get pst => const Vector3.zero();
  Vector3 get psp => const Vector3.zero();
  Vector3 get pts => const Vector3.zero();
  Vector3 get ptt => const Vector3.zero();
  Vector3 get ptp => const Vector3.zero();
  Vector3 get pps => const Vector3.zero();
  Vector3 get ppt => const Vector3.zero();
  Vector3 get ppp => const Vector3.zero();

  // Vector4 stp swizzles: s first
  Vector4 get ssss => const Vector4.zero();
  Vector4 get ssst => const Vector4.zero();
  Vector4 get sssp => const Vector4.zero();
  Vector4 get ssts => const Vector4.zero();
  Vector4 get sstt => const Vector4.zero();
  Vector4 get sstp => const Vector4.zero();
  Vector4 get ssps => const Vector4.zero();
  Vector4 get sspt => const Vector4.zero();
  Vector4 get sspp => const Vector4.zero();
  Vector4 get stss => const Vector4.zero();
  Vector4 get stst => const Vector4.zero();
  Vector4 get stsp => const Vector4.zero();
  Vector4 get stts => const Vector4.zero();
  Vector4 get sttt => const Vector4.zero();
  Vector4 get sttp => const Vector4.zero();
  Vector4 get stps => const Vector4.zero();
  Vector4 get stpt => const Vector4.zero();
  Vector4 get stpp => const Vector4.zero();
  Vector4 get spss => const Vector4.zero();
  Vector4 get spst => const Vector4.zero();
  Vector4 get spsp => const Vector4.zero();
  Vector4 get spts => const Vector4.zero();
  Vector4 get sptt => const Vector4.zero();
  Vector4 get sptp => const Vector4.zero();
  Vector4 get spps => const Vector4.zero();
  Vector4 get sppt => const Vector4.zero();
  Vector4 get sppp => const Vector4.zero();

  // Vector4 stp swizzles: t first
  Vector4 get tsss => const Vector4.zero();
  Vector4 get tsst => const Vector4.zero();
  Vector4 get tssp => const Vector4.zero();
  Vector4 get tsts => const Vector4.zero();
  Vector4 get tstt => const Vector4.zero();
  Vector4 get tstp => const Vector4.zero();
  Vector4 get tsps => const Vector4.zero();
  Vector4 get tspt => const Vector4.zero();
  Vector4 get tspp => const Vector4.zero();
  Vector4 get ttss => const Vector4.zero();
  Vector4 get ttst => const Vector4.zero();
  Vector4 get ttsp => const Vector4.zero();
  Vector4 get ttts => const Vector4.zero();
  Vector4 get tttt => const Vector4.zero();
  Vector4 get tttp => const Vector4.zero();
  Vector4 get ttps => const Vector4.zero();
  Vector4 get ttpt => const Vector4.zero();
  Vector4 get ttpp => const Vector4.zero();
  Vector4 get tpss => const Vector4.zero();
  Vector4 get tpst => const Vector4.zero();
  Vector4 get tpsp => const Vector4.zero();
  Vector4 get tpts => const Vector4.zero();
  Vector4 get tptt => const Vector4.zero();
  Vector4 get tptp => const Vector4.zero();
  Vector4 get tpps => const Vector4.zero();
  Vector4 get tppt => const Vector4.zero();
  Vector4 get tppp => const Vector4.zero();

  // Vector4 stp swizzles: p first
  Vector4 get psss => const Vector4.zero();
  Vector4 get psst => const Vector4.zero();
  Vector4 get pssp => const Vector4.zero();
  Vector4 get psts => const Vector4.zero();
  Vector4 get pstt => const Vector4.zero();
  Vector4 get pstp => const Vector4.zero();
  Vector4 get psps => const Vector4.zero();
  Vector4 get pspt => const Vector4.zero();
  Vector4 get pspp => const Vector4.zero();
  Vector4 get ptss => const Vector4.zero();
  Vector4 get ptst => const Vector4.zero();
  Vector4 get ptsp => const Vector4.zero();
  Vector4 get ptts => const Vector4.zero();
  Vector4 get pttt => const Vector4.zero();
  Vector4 get pttp => const Vector4.zero();
  Vector4 get ptps => const Vector4.zero();
  Vector4 get ptpt => const Vector4.zero();
  Vector4 get ptpp => const Vector4.zero();
  Vector4 get ppss => const Vector4.zero();
  Vector4 get ppst => const Vector4.zero();
  Vector4 get ppsp => const Vector4.zero();
  Vector4 get ppts => const Vector4.zero();
  Vector4 get pptt => const Vector4.zero();
  Vector4 get pptp => const Vector4.zero();
  Vector4 get ppps => const Vector4.zero();
  Vector4 get pppt => const Vector4.zero();
  Vector4 get pppp => const Vector4.zero();

  int get columnDimension => 1;

  int get rowDimension => 3;

  bool get isSquare => false;

  Iterable<double> get values => const [0.0, 0.0, 0.0];

  Iterable<double> get valuesColumnPacked => const [0.0, 0.0, 0.0];

  Iterable<double> get valuesRowPacked => const [0.0, 0.0, 0.0];

  Matrix get transpose =>
      new Matrix.fromList(const [0.0, 0.0, 0.0], rowDimension);

  double get determinant =>
      throw new UnsupportedError('Matrix must be square.');

  bool get isNonSingular =>
      throw new UnsupportedError('Matrix must be square.');

  Vector3 get inverse =>
      throw new UnsupportedError('This matrix is singular (has no inverse).');

  double get magnitude => 0.0;

  bool get isUnit => false;

  Vector3 get unitVector =>
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

  Vector3 scalarProduct(num s) => const Vector3.zero();

  Vector3 scalarDivision(num s) => const Vector3.zero();

  Vector3 entrywiseSum(Matrix B) {
    if (B is Vector3) {
      return new Vector3(B.x, B.y, B.z);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector3(B.valueAt(0, 0), B.valueAt(1, 0), B.valueAt(2, 0));
    }
  }

  Vector3 entrywiseDifference(Matrix B) {
    if (B is Vector3) {
      return new Vector3(B.x, B.y, B.z);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector3(B.valueAt(0, 0), B.valueAt(1, 0), B.valueAt(2, 0));
    }
  }

  Vector3 entrywiseProduct(Matrix B) {
    if (B is Vector3) {
      return const Vector3.zero();
    } else {
      _assertEqualDimensions(this, B);

      return const Vector3.zero();
    }
  }

  Matrix matrixProduct(Matrix B) {
    if (B.rowDimension != 1) {
      throw new ArgumentError('Matrix inner dimensions must agree.');
    }

    return new Matrix.zero(rowDimension, B.columnDimension);
  }

  double dotProduct(Vector3 B) => 0.0;

  Vector3 crossProduct(Vector3 B) => const Vector3.zero();

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

  Vector3 operator +(Matrix B) => entrywiseSum(B);

  Vector3 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 3);

    return 0.0;
  }

  String toString() {
    return 'Vector3(0.0, 0.0, 0.0)';
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector3 && other.x == x && other.y == y && other.z == z;

  int get hashCode => hash3(x, y, z);
}
