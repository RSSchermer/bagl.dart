part of math;

/// A column vector of length 3 (a 3 by 1 matrix).
class Vector3 extends _VertexBase implements Matrix {
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
  Vector3(this.x, this.y, this.z);

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
  Vector3.constant(double value)
      : x = value,
        y = value,
        z = value;

  /// Instantiates a new [Vector3] where every position is set to zero.
  Vector3.zero()
      : x = 0.0,
        y = 0.0,
        z = 0.0;

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

  /// The magnitude of this [Vector3].
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

  /// This [Vector3]'s unit vector.
  ///
  /// A [Vector3] with a [magnitude] of `1` that has the same direction as this
  /// [Vector3].
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

  /// Whether or not this [Vector3] is a unit vector.
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

  /// Computes the dot product of this [Vector3] `A` and another [Vector3] [B].
  double dotProduct(Vector3 B) => x * B.x + y * B.y + z * B.z;

  /// Computes the cross product of this [Vector3] `A` and another [Vector3]
  /// [B].
  Vector3 crossProduct(Vector3 B) => new Vector3(
        y * B.z - z * B.y,
        z * B.x - x * B.z,
        x * B.y - y * B.x,
      );

  Vector3 operator +(Matrix B) => entrywiseSum(B);

  Vector3 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
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

  bool operator ==(Object other) => identical(this, other) || other is Vector3 && other.x == x && other.y == y && other.z == z;

  int get hashCode => hash3(x, y, z);
}
