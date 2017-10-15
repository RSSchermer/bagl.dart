part of bagl.math;

/// A column vector of length 4 (a 4 by 1 matrix).
abstract class Vector4 implements Matrix {
  /// Instantiates a new [Vector3] with the specified values.
  factory Vector4(x, y, z, w) = _Vector4;

  /// Instantiates a new [Vector3] from the given list.
  ///
  /// Throws an [ArgumentError] if the length does the list does not equal 3.
  factory Vector4.fromList(List<double> values) {
    if (values.length != 4) {
      throw new ArgumentError(
          'A list of length 4 required to instantiate a Vector4.');
    }

    return new Vector4(values[0], values[1], values[2], values[3]);
  }

  /// Instantiates a new [Vector4] where every position is set to the specified
  /// value.
  factory Vector4.constant(double value) =>
      new _Vector4(value, value, value, value);

  /// Instantiates a new [Vector4] where every position is set to zero.
  const factory Vector4.zero() = _Vector4Zero;

  double get x;
  double get y;
  double get z;
  double get w;

  // Vector2 xyzw swizzles: x first
  Vector2 get xx;
  Vector2 get xy;
  Vector2 get xz;
  Vector2 get xw;

  // Vector2 xyzw swizzles: y first
  Vector2 get yx;
  Vector2 get yy;
  Vector2 get yz;
  Vector2 get yw;

  // Vector2 xyzw swizzles: z first
  Vector2 get zx;
  Vector2 get zy;
  Vector2 get zz;
  Vector2 get zw;

  // Vector2 xyzw swizzles: w first
  Vector2 get wx;
  Vector2 get wy;
  Vector2 get wz;
  Vector2 get ww;

  // Vector3 xyzw swizzles: x first
  Vector3 get xxx;
  Vector3 get xxy;
  Vector3 get xxz;
  Vector3 get xxw;
  Vector3 get xyx;
  Vector3 get xyy;
  Vector3 get xyz;
  Vector3 get xyw;
  Vector3 get xzx;
  Vector3 get xzy;
  Vector3 get xzz;
  Vector3 get xzw;
  Vector3 get xwx;
  Vector3 get xwy;
  Vector3 get xwz;
  Vector3 get xww;

  // Vector3 xyzw swizzles: y first
  Vector3 get yxx;
  Vector3 get yxy;
  Vector3 get yxz;
  Vector3 get yxw;
  Vector3 get yyx;
  Vector3 get yyy;
  Vector3 get yyz;
  Vector3 get yyw;
  Vector3 get yzx;
  Vector3 get yzy;
  Vector3 get yzz;
  Vector3 get yzw;
  Vector3 get ywx;
  Vector3 get ywy;
  Vector3 get ywz;
  Vector3 get yww;

  // Vector3 xyzw swizzles: z first
  Vector3 get zxx;
  Vector3 get zxy;
  Vector3 get zxz;
  Vector3 get zxw;
  Vector3 get zyx;
  Vector3 get zyy;
  Vector3 get zyz;
  Vector3 get zyw;
  Vector3 get zzx;
  Vector3 get zzy;
  Vector3 get zzz;
  Vector3 get zzw;
  Vector3 get zwx;
  Vector3 get zwy;
  Vector3 get zwz;
  Vector3 get zww;

  // Vector3 xyzw swizzles: w first
  Vector3 get wxx;
  Vector3 get wxy;
  Vector3 get wxz;
  Vector3 get wxw;
  Vector3 get wyx;
  Vector3 get wyy;
  Vector3 get wyz;
  Vector3 get wyw;
  Vector3 get wzx;
  Vector3 get wzy;
  Vector3 get wzz;
  Vector3 get wzw;
  Vector3 get wwx;
  Vector3 get wwy;
  Vector3 get wwz;
  Vector3 get www;

  // Vector4 xyzw swizzles: x first
  Vector4 get xxxx;
  Vector4 get xxxy;
  Vector4 get xxxz;
  Vector4 get xxxw;
  Vector4 get xxyx;
  Vector4 get xxyy;
  Vector4 get xxyz;
  Vector4 get xxyw;
  Vector4 get xxzx;
  Vector4 get xxzy;
  Vector4 get xxzz;
  Vector4 get xxzw;
  Vector4 get xxwx;
  Vector4 get xxwy;
  Vector4 get xxwz;
  Vector4 get xxww;
  Vector4 get xyxx;
  Vector4 get xyxy;
  Vector4 get xyxz;
  Vector4 get xyxw;
  Vector4 get xyyx;
  Vector4 get xyyy;
  Vector4 get xyyz;
  Vector4 get xyyw;
  Vector4 get xyzx;
  Vector4 get xyzy;
  Vector4 get xyzz;
  Vector4 get xyzw;
  Vector4 get xywx;
  Vector4 get xywy;
  Vector4 get xywz;
  Vector4 get xyww;
  Vector4 get xzxx;
  Vector4 get xzxy;
  Vector4 get xzxz;
  Vector4 get xzxw;
  Vector4 get xzyx;
  Vector4 get xzyy;
  Vector4 get xzyz;
  Vector4 get xzyw;
  Vector4 get xzzx;
  Vector4 get xzzy;
  Vector4 get xzzz;
  Vector4 get xzzw;
  Vector4 get xzwx;
  Vector4 get xzwy;
  Vector4 get xzwz;
  Vector4 get xzww;
  Vector4 get xwxx;
  Vector4 get xwxy;
  Vector4 get xwxz;
  Vector4 get xwxw;
  Vector4 get xwyx;
  Vector4 get xwyy;
  Vector4 get xwyz;
  Vector4 get xwyw;
  Vector4 get xwzx;
  Vector4 get xwzy;
  Vector4 get xwzz;
  Vector4 get xwzw;
  Vector4 get xwwx;
  Vector4 get xwwy;
  Vector4 get xwwz;
  Vector4 get xwww;

  // Vector4 xyzw swizzles: y first
  Vector4 get yxxx;
  Vector4 get yxxy;
  Vector4 get yxxz;
  Vector4 get yxxw;
  Vector4 get yxyx;
  Vector4 get yxyy;
  Vector4 get yxyz;
  Vector4 get yxyw;
  Vector4 get yxzx;
  Vector4 get yxzy;
  Vector4 get yxzz;
  Vector4 get yxzw;
  Vector4 get yxwx;
  Vector4 get yxwy;
  Vector4 get yxwz;
  Vector4 get yxww;
  Vector4 get yyxx;
  Vector4 get yyxy;
  Vector4 get yyxz;
  Vector4 get yyxw;
  Vector4 get yyyx;
  Vector4 get yyyy;
  Vector4 get yyyz;
  Vector4 get yyyw;
  Vector4 get yyzx;
  Vector4 get yyzy;
  Vector4 get yyzz;
  Vector4 get yyzw;
  Vector4 get yywx;
  Vector4 get yywy;
  Vector4 get yywz;
  Vector4 get yyww;
  Vector4 get yzxx;
  Vector4 get yzxy;
  Vector4 get yzxz;
  Vector4 get yzxw;
  Vector4 get yzyx;
  Vector4 get yzyy;
  Vector4 get yzyz;
  Vector4 get yzyw;
  Vector4 get yzzx;
  Vector4 get yzzy;
  Vector4 get yzzz;
  Vector4 get yzzw;
  Vector4 get yzwx;
  Vector4 get yzwy;
  Vector4 get yzwz;
  Vector4 get yzww;
  Vector4 get ywxx;
  Vector4 get ywxy;
  Vector4 get ywxz;
  Vector4 get ywxw;
  Vector4 get ywyx;
  Vector4 get ywyy;
  Vector4 get ywyz;
  Vector4 get ywyw;
  Vector4 get ywzx;
  Vector4 get ywzy;
  Vector4 get ywzz;
  Vector4 get ywzw;
  Vector4 get ywwx;
  Vector4 get ywwy;
  Vector4 get ywwz;
  Vector4 get ywww;

  // Vector4 xyzw swizzles: z first
  Vector4 get zxxx;
  Vector4 get zxxy;
  Vector4 get zxxz;
  Vector4 get zxxw;
  Vector4 get zxyx;
  Vector4 get zxyy;
  Vector4 get zxyz;
  Vector4 get zxyw;
  Vector4 get zxzx;
  Vector4 get zxzy;
  Vector4 get zxzz;
  Vector4 get zxzw;
  Vector4 get zxwx;
  Vector4 get zxwy;
  Vector4 get zxwz;
  Vector4 get zxww;
  Vector4 get zyxx;
  Vector4 get zyxy;
  Vector4 get zyxz;
  Vector4 get zyxw;
  Vector4 get zyyx;
  Vector4 get zyyy;
  Vector4 get zyyz;
  Vector4 get zyyw;
  Vector4 get zyzx;
  Vector4 get zyzy;
  Vector4 get zyzz;
  Vector4 get zyzw;
  Vector4 get zywx;
  Vector4 get zywy;
  Vector4 get zywz;
  Vector4 get zyww;
  Vector4 get zzxx;
  Vector4 get zzxy;
  Vector4 get zzxz;
  Vector4 get zzxw;
  Vector4 get zzyx;
  Vector4 get zzyy;
  Vector4 get zzyz;
  Vector4 get zzyw;
  Vector4 get zzzx;
  Vector4 get zzzy;
  Vector4 get zzzz;
  Vector4 get zzzw;
  Vector4 get zzwx;
  Vector4 get zzwy;
  Vector4 get zzwz;
  Vector4 get zzww;
  Vector4 get zwxx;
  Vector4 get zwxy;
  Vector4 get zwxz;
  Vector4 get zwxw;
  Vector4 get zwyx;
  Vector4 get zwyy;
  Vector4 get zwyz;
  Vector4 get zwyw;
  Vector4 get zwzx;
  Vector4 get zwzy;
  Vector4 get zwzz;
  Vector4 get zwzw;
  Vector4 get zwwx;
  Vector4 get zwwy;
  Vector4 get zwwz;
  Vector4 get zwww;

  // Vector4 xyzw swizzles: w first
  Vector4 get wxxx;
  Vector4 get wxxy;
  Vector4 get wxxz;
  Vector4 get wxxw;
  Vector4 get wxyx;
  Vector4 get wxyy;
  Vector4 get wxyz;
  Vector4 get wxyw;
  Vector4 get wxzx;
  Vector4 get wxzy;
  Vector4 get wxzz;
  Vector4 get wxzw;
  Vector4 get wxwx;
  Vector4 get wxwy;
  Vector4 get wxwz;
  Vector4 get wxww;
  Vector4 get wyxx;
  Vector4 get wyxy;
  Vector4 get wyxz;
  Vector4 get wyxw;
  Vector4 get wyyx;
  Vector4 get wyyy;
  Vector4 get wyyz;
  Vector4 get wyyw;
  Vector4 get wyzx;
  Vector4 get wyzy;
  Vector4 get wyzz;
  Vector4 get wyzw;
  Vector4 get wywx;
  Vector4 get wywy;
  Vector4 get wywz;
  Vector4 get wyww;
  Vector4 get wzxx;
  Vector4 get wzxy;
  Vector4 get wzxz;
  Vector4 get wzxw;
  Vector4 get wzyx;
  Vector4 get wzyy;
  Vector4 get wzyz;
  Vector4 get wzyw;
  Vector4 get wzzx;
  Vector4 get wzzy;
  Vector4 get wzzz;
  Vector4 get wzzw;
  Vector4 get wzwx;
  Vector4 get wzwy;
  Vector4 get wzwz;
  Vector4 get wzww;
  Vector4 get wwxx;
  Vector4 get wwxy;
  Vector4 get wwxz;
  Vector4 get wwxw;
  Vector4 get wwyx;
  Vector4 get wwyy;
  Vector4 get wwyz;
  Vector4 get wwyw;
  Vector4 get wwzx;
  Vector4 get wwzy;
  Vector4 get wwzz;
  Vector4 get wwzw;
  Vector4 get wwwx;
  Vector4 get wwwy;
  Vector4 get wwwz;
  Vector4 get wwww;

  double get r;
  double get g;
  double get b;
  double get a;

  // Vector2 rgba swizzles: r first
  Vector2 get rr;
  Vector2 get rg;
  Vector2 get rb;
  Vector2 get ra;

  // Vector2 rgba swizzles: g first
  Vector2 get gr;
  Vector2 get gg;
  Vector2 get gb;
  Vector2 get ga;

  // Vector2 rgba swizzles: b first
  Vector2 get br;
  Vector2 get bg;
  Vector2 get bb;
  Vector2 get ba;

  // Vector2 rgba swizzles: a first
  Vector2 get ar;
  Vector2 get ag;
  Vector2 get ab;
  Vector2 get aa;

  // Vector3 rgba swizzles: r first
  Vector3 get rrr;
  Vector3 get rrg;
  Vector3 get rrb;
  Vector3 get rra;
  Vector3 get rgr;
  Vector3 get rgg;
  Vector3 get rgb;
  Vector3 get rga;
  Vector3 get rbr;
  Vector3 get rbg;
  Vector3 get rbb;
  Vector3 get rba;
  Vector3 get rar;
  Vector3 get rag;
  Vector3 get rab;
  Vector3 get raa;

  // Vector3 rgba swizzles: g first
  Vector3 get grr;
  Vector3 get grg;
  Vector3 get grb;
  Vector3 get gra;
  Vector3 get ggr;
  Vector3 get ggg;
  Vector3 get ggb;
  Vector3 get gga;
  Vector3 get gbr;
  Vector3 get gbg;
  Vector3 get gbb;
  Vector3 get gba;
  Vector3 get gar;
  Vector3 get gag;
  Vector3 get gab;
  Vector3 get gaa;

  // Vector3 rgba swizzles: b first
  Vector3 get brr;
  Vector3 get brg;
  Vector3 get brb;
  Vector3 get bra;
  Vector3 get bgr;
  Vector3 get bgg;
  Vector3 get bgb;
  Vector3 get bga;
  Vector3 get bbr;
  Vector3 get bbg;
  Vector3 get bbb;
  Vector3 get bba;
  Vector3 get bar;
  Vector3 get bag;
  Vector3 get bab;
  Vector3 get baa;

  // Vector3 rgba swizzles: a first
  Vector3 get arr;
  Vector3 get arg;
  Vector3 get arb;
  Vector3 get ara;
  Vector3 get agr;
  Vector3 get agg;
  Vector3 get agb;
  Vector3 get aga;
  Vector3 get abr;
  Vector3 get abg;
  Vector3 get abb;
  Vector3 get aba;
  Vector3 get aar;
  Vector3 get aag;
  Vector3 get aab;
  Vector3 get aaa;

  // Vector4 rgba swizzles: r first
  Vector4 get rrrr;
  Vector4 get rrrg;
  Vector4 get rrrb;
  Vector4 get rrra;
  Vector4 get rrgr;
  Vector4 get rrgg;
  Vector4 get rrgb;
  Vector4 get rrga;
  Vector4 get rrbr;
  Vector4 get rrbg;
  Vector4 get rrbb;
  Vector4 get rrba;
  Vector4 get rrar;
  Vector4 get rrag;
  Vector4 get rrab;
  Vector4 get rraa;
  Vector4 get rgrr;
  Vector4 get rgrg;
  Vector4 get rgrb;
  Vector4 get rgra;
  Vector4 get rggr;
  Vector4 get rggg;
  Vector4 get rggb;
  Vector4 get rgga;
  Vector4 get rgbr;
  Vector4 get rgbg;
  Vector4 get rgbb;
  Vector4 get rgba;
  Vector4 get rgar;
  Vector4 get rgag;
  Vector4 get rgab;
  Vector4 get rgaa;
  Vector4 get rbrr;
  Vector4 get rbrg;
  Vector4 get rbrb;
  Vector4 get rbra;
  Vector4 get rbgr;
  Vector4 get rbgg;
  Vector4 get rbgb;
  Vector4 get rbga;
  Vector4 get rbbr;
  Vector4 get rbbg;
  Vector4 get rbbb;
  Vector4 get rbba;
  Vector4 get rbar;
  Vector4 get rbag;
  Vector4 get rbab;
  Vector4 get rbaa;
  Vector4 get rarr;
  Vector4 get rarg;
  Vector4 get rarb;
  Vector4 get rara;
  Vector4 get ragr;
  Vector4 get ragg;
  Vector4 get ragb;
  Vector4 get raga;
  Vector4 get rabr;
  Vector4 get rabg;
  Vector4 get rabb;
  Vector4 get raba;
  Vector4 get raar;
  Vector4 get raag;
  Vector4 get raab;
  Vector4 get raaa;

  // Vector4 rgba swizzles: g first
  Vector4 get grrr;
  Vector4 get grrg;
  Vector4 get grrb;
  Vector4 get grra;
  Vector4 get grgr;
  Vector4 get grgg;
  Vector4 get grgb;
  Vector4 get grga;
  Vector4 get grbr;
  Vector4 get grbg;
  Vector4 get grbb;
  Vector4 get grba;
  Vector4 get grar;
  Vector4 get grag;
  Vector4 get grab;
  Vector4 get graa;
  Vector4 get ggrr;
  Vector4 get ggrg;
  Vector4 get ggrb;
  Vector4 get ggra;
  Vector4 get gggr;
  Vector4 get gggg;
  Vector4 get gggb;
  Vector4 get ggga;
  Vector4 get ggbr;
  Vector4 get ggbg;
  Vector4 get ggbb;
  Vector4 get ggba;
  Vector4 get ggar;
  Vector4 get ggag;
  Vector4 get ggab;
  Vector4 get ggaa;
  Vector4 get gbrr;
  Vector4 get gbrg;
  Vector4 get gbrb;
  Vector4 get gbra;
  Vector4 get gbgr;
  Vector4 get gbgg;
  Vector4 get gbgb;
  Vector4 get gbga;
  Vector4 get gbbr;
  Vector4 get gbbg;
  Vector4 get gbbb;
  Vector4 get gbba;
  Vector4 get gbar;
  Vector4 get gbag;
  Vector4 get gbab;
  Vector4 get gbaa;
  Vector4 get garr;
  Vector4 get garg;
  Vector4 get garb;
  Vector4 get gara;
  Vector4 get gagr;
  Vector4 get gagg;
  Vector4 get gagb;
  Vector4 get gaga;
  Vector4 get gabr;
  Vector4 get gabg;
  Vector4 get gabb;
  Vector4 get gaba;
  Vector4 get gaar;
  Vector4 get gaag;
  Vector4 get gaab;
  Vector4 get gaaa;

  // Vector4 rgba swizzles: b first
  Vector4 get brrr;
  Vector4 get brrg;
  Vector4 get brrb;
  Vector4 get brra;
  Vector4 get brgr;
  Vector4 get brgg;
  Vector4 get brgb;
  Vector4 get brga;
  Vector4 get brbr;
  Vector4 get brbg;
  Vector4 get brbb;
  Vector4 get brba;
  Vector4 get brar;
  Vector4 get brag;
  Vector4 get brab;
  Vector4 get braa;
  Vector4 get bgrr;
  Vector4 get bgrg;
  Vector4 get bgrb;
  Vector4 get bgra;
  Vector4 get bggr;
  Vector4 get bggg;
  Vector4 get bggb;
  Vector4 get bgga;
  Vector4 get bgbr;
  Vector4 get bgbg;
  Vector4 get bgbb;
  Vector4 get bgba;
  Vector4 get bgar;
  Vector4 get bgag;
  Vector4 get bgab;
  Vector4 get bgaa;
  Vector4 get bbrr;
  Vector4 get bbrg;
  Vector4 get bbrb;
  Vector4 get bbra;
  Vector4 get bbgr;
  Vector4 get bbgg;
  Vector4 get bbgb;
  Vector4 get bbga;
  Vector4 get bbbr;
  Vector4 get bbbg;
  Vector4 get bbbb;
  Vector4 get bbba;
  Vector4 get bbar;
  Vector4 get bbag;
  Vector4 get bbab;
  Vector4 get bbaa;
  Vector4 get barr;
  Vector4 get barg;
  Vector4 get barb;
  Vector4 get bara;
  Vector4 get bagr;
  Vector4 get bagg;
  Vector4 get bagb;
  Vector4 get baga;
  Vector4 get babr;
  Vector4 get babg;
  Vector4 get babb;
  Vector4 get baba;
  Vector4 get baar;
  Vector4 get baag;
  Vector4 get baab;
  Vector4 get baaa;

  // Vector4 rgba swizzles: a first
  Vector4 get arrr;
  Vector4 get arrg;
  Vector4 get arrb;
  Vector4 get arra;
  Vector4 get argr;
  Vector4 get argg;
  Vector4 get argb;
  Vector4 get arga;
  Vector4 get arbr;
  Vector4 get arbg;
  Vector4 get arbb;
  Vector4 get arba;
  Vector4 get arar;
  Vector4 get arag;
  Vector4 get arab;
  Vector4 get araa;
  Vector4 get agrr;
  Vector4 get agrg;
  Vector4 get agrb;
  Vector4 get agra;
  Vector4 get aggr;
  Vector4 get aggg;
  Vector4 get aggb;
  Vector4 get agga;
  Vector4 get agbr;
  Vector4 get agbg;
  Vector4 get agbb;
  Vector4 get agba;
  Vector4 get agar;
  Vector4 get agag;
  Vector4 get agab;
  Vector4 get agaa;
  Vector4 get abrr;
  Vector4 get abrg;
  Vector4 get abrb;
  Vector4 get abra;
  Vector4 get abgr;
  Vector4 get abgg;
  Vector4 get abgb;
  Vector4 get abga;
  Vector4 get abbr;
  Vector4 get abbg;
  Vector4 get abbb;
  Vector4 get abba;
  Vector4 get abar;
  Vector4 get abag;
  Vector4 get abab;
  Vector4 get abaa;
  Vector4 get aarr;
  Vector4 get aarg;
  Vector4 get aarb;
  Vector4 get aara;
  Vector4 get aagr;
  Vector4 get aagg;
  Vector4 get aagb;
  Vector4 get aaga;
  Vector4 get aabr;
  Vector4 get aabg;
  Vector4 get aabb;
  Vector4 get aaba;
  Vector4 get aaar;
  Vector4 get aaag;
  Vector4 get aaab;
  Vector4 get aaaa;

  double get s;
  double get t;
  double get p;
  double get q;

  // Vector2 stpq swizzles: s first
  Vector2 get ss;
  Vector2 get st;
  Vector2 get sp;
  Vector2 get sq;

  // Vector2 stpq swizzles: t first
  Vector2 get ts;
  Vector2 get tt;
  Vector2 get tp;
  Vector2 get tq;

  // Vector2 stpq swizzles: p first
  Vector2 get ps;
  Vector2 get pt;
  Vector2 get pp;
  Vector2 get pq;

  // Vector2 stpq swizzles: q first
  Vector2 get qs;
  Vector2 get qt;
  Vector2 get qp;
  Vector2 get qq;

  // Vector3 stpq swizzles: s first
  Vector3 get sss;
  Vector3 get sst;
  Vector3 get ssp;
  Vector3 get ssq;
  Vector3 get sts;
  Vector3 get stt;
  Vector3 get stp;
  Vector3 get stq;
  Vector3 get sps;
  Vector3 get spt;
  Vector3 get spp;
  Vector3 get spq;
  Vector3 get sqs;
  Vector3 get sqt;
  Vector3 get sqp;
  Vector3 get sqq;

  // Vector3 stpq swizzles: t first
  Vector3 get tss;
  Vector3 get tst;
  Vector3 get tsp;
  Vector3 get tsq;
  Vector3 get tts;
  Vector3 get ttt;
  Vector3 get ttp;
  Vector3 get ttq;
  Vector3 get tps;
  Vector3 get tpt;
  Vector3 get tpp;
  Vector3 get tpq;
  Vector3 get tqs;
  Vector3 get tqt;
  Vector3 get tqp;
  Vector3 get tqq;

  // Vector3 stpq swizzles: p first
  Vector3 get pss;
  Vector3 get pst;
  Vector3 get psp;
  Vector3 get psq;
  Vector3 get pts;
  Vector3 get ptt;
  Vector3 get ptp;
  Vector3 get ptq;
  Vector3 get pps;
  Vector3 get ppt;
  Vector3 get ppp;
  Vector3 get ppq;
  Vector3 get pqs;
  Vector3 get pqt;
  Vector3 get pqp;
  Vector3 get pqq;

  // Vector3 stpq swizzles: q first
  Vector3 get qss;
  Vector3 get qst;
  Vector3 get qsp;
  Vector3 get qsq;
  Vector3 get qts;
  Vector3 get qtt;
  Vector3 get qtp;
  Vector3 get qtq;
  Vector3 get qps;
  Vector3 get qpt;
  Vector3 get qpp;
  Vector3 get qpq;
  Vector3 get qqs;
  Vector3 get qqt;
  Vector3 get qqp;
  Vector3 get qqq;

  // Vector4 stpq swizzles: s first
  Vector4 get ssss;
  Vector4 get ssst;
  Vector4 get sssp;
  Vector4 get sssq;
  Vector4 get ssts;
  Vector4 get sstt;
  Vector4 get sstp;
  Vector4 get sstq;
  Vector4 get ssps;
  Vector4 get sspt;
  Vector4 get sspp;
  Vector4 get sspq;
  Vector4 get ssqs;
  Vector4 get ssqt;
  Vector4 get ssqp;
  Vector4 get ssqq;
  Vector4 get stss;
  Vector4 get stst;
  Vector4 get stsp;
  Vector4 get stsq;
  Vector4 get stts;
  Vector4 get sttt;
  Vector4 get sttp;
  Vector4 get sttq;
  Vector4 get stps;
  Vector4 get stpt;
  Vector4 get stpp;
  Vector4 get stpq;
  Vector4 get stqs;
  Vector4 get stqt;
  Vector4 get stqp;
  Vector4 get stqq;
  Vector4 get spss;
  Vector4 get spst;
  Vector4 get spsp;
  Vector4 get spsq;
  Vector4 get spts;
  Vector4 get sptt;
  Vector4 get sptp;
  Vector4 get sptq;
  Vector4 get spps;
  Vector4 get sppt;
  Vector4 get sppp;
  Vector4 get sppq;
  Vector4 get spqs;
  Vector4 get spqt;
  Vector4 get spqp;
  Vector4 get spqq;
  Vector4 get sqss;
  Vector4 get sqst;
  Vector4 get sqsp;
  Vector4 get sqsq;
  Vector4 get sqts;
  Vector4 get sqtt;
  Vector4 get sqtp;
  Vector4 get sqtq;
  Vector4 get sqps;
  Vector4 get sqpt;
  Vector4 get sqpp;
  Vector4 get sqpq;
  Vector4 get sqqs;
  Vector4 get sqqt;
  Vector4 get sqqp;
  Vector4 get sqqq;

  // Vector4 stpq swizzles: t first
  Vector4 get tsss;
  Vector4 get tsst;
  Vector4 get tssp;
  Vector4 get tssq;
  Vector4 get tsts;
  Vector4 get tstt;
  Vector4 get tstp;
  Vector4 get tstq;
  Vector4 get tsps;
  Vector4 get tspt;
  Vector4 get tspp;
  Vector4 get tspq;
  Vector4 get tsqs;
  Vector4 get tsqt;
  Vector4 get tsqp;
  Vector4 get tsqq;
  Vector4 get ttss;
  Vector4 get ttst;
  Vector4 get ttsp;
  Vector4 get ttsq;
  Vector4 get ttts;
  Vector4 get tttt;
  Vector4 get tttp;
  Vector4 get tttq;
  Vector4 get ttps;
  Vector4 get ttpt;
  Vector4 get ttpp;
  Vector4 get ttpq;
  Vector4 get ttqs;
  Vector4 get ttqt;
  Vector4 get ttqp;
  Vector4 get ttqq;
  Vector4 get tpss;
  Vector4 get tpst;
  Vector4 get tpsp;
  Vector4 get tpsq;
  Vector4 get tpts;
  Vector4 get tptt;
  Vector4 get tptp;
  Vector4 get tptq;
  Vector4 get tpps;
  Vector4 get tppt;
  Vector4 get tppp;
  Vector4 get tppq;
  Vector4 get tpqs;
  Vector4 get tpqt;
  Vector4 get tpqp;
  Vector4 get tpqq;
  Vector4 get tqss;
  Vector4 get tqst;
  Vector4 get tqsp;
  Vector4 get tqsq;
  Vector4 get tqts;
  Vector4 get tqtt;
  Vector4 get tqtp;
  Vector4 get tqtq;
  Vector4 get tqps;
  Vector4 get tqpt;
  Vector4 get tqpp;
  Vector4 get tqpq;
  Vector4 get tqqs;
  Vector4 get tqqt;
  Vector4 get tqqp;
  Vector4 get tqqq;

  // Vector4 stpq swizzles: p first
  Vector4 get psss;
  Vector4 get psst;
  Vector4 get pssp;
  Vector4 get pssq;
  Vector4 get psts;
  Vector4 get pstt;
  Vector4 get pstp;
  Vector4 get pstq;
  Vector4 get psps;
  Vector4 get pspt;
  Vector4 get pspp;
  Vector4 get pspq;
  Vector4 get psqs;
  Vector4 get psqt;
  Vector4 get psqp;
  Vector4 get psqq;
  Vector4 get ptss;
  Vector4 get ptst;
  Vector4 get ptsp;
  Vector4 get ptsq;
  Vector4 get ptts;
  Vector4 get pttt;
  Vector4 get pttp;
  Vector4 get pttq;
  Vector4 get ptps;
  Vector4 get ptpt;
  Vector4 get ptpp;
  Vector4 get ptpq;
  Vector4 get ptqs;
  Vector4 get ptqt;
  Vector4 get ptqp;
  Vector4 get ptqq;
  Vector4 get ppss;
  Vector4 get ppst;
  Vector4 get ppsp;
  Vector4 get ppsq;
  Vector4 get ppts;
  Vector4 get pptt;
  Vector4 get pptp;
  Vector4 get pptq;
  Vector4 get ppps;
  Vector4 get pppt;
  Vector4 get pppp;
  Vector4 get pppq;
  Vector4 get ppqs;
  Vector4 get ppqt;
  Vector4 get ppqp;
  Vector4 get ppqq;
  Vector4 get pqss;
  Vector4 get pqst;
  Vector4 get pqsp;
  Vector4 get pqsq;
  Vector4 get pqts;
  Vector4 get pqtt;
  Vector4 get pqtp;
  Vector4 get pqtq;
  Vector4 get pqps;
  Vector4 get pqpt;
  Vector4 get pqpp;
  Vector4 get pqpq;
  Vector4 get pqqs;
  Vector4 get pqqt;
  Vector4 get pqqp;
  Vector4 get pqqq;

  // Vector4 stpq swizzles: q first
  Vector4 get qsss;
  Vector4 get qsst;
  Vector4 get qssp;
  Vector4 get qssq;
  Vector4 get qsts;
  Vector4 get qstt;
  Vector4 get qstp;
  Vector4 get qstq;
  Vector4 get qsps;
  Vector4 get qspt;
  Vector4 get qspp;
  Vector4 get qspq;
  Vector4 get qsqs;
  Vector4 get qsqt;
  Vector4 get qsqp;
  Vector4 get qsqq;
  Vector4 get qtss;
  Vector4 get qtst;
  Vector4 get qtsp;
  Vector4 get qtsq;
  Vector4 get qtts;
  Vector4 get qttt;
  Vector4 get qttp;
  Vector4 get qttq;
  Vector4 get qtps;
  Vector4 get qtpt;
  Vector4 get qtpp;
  Vector4 get qtpq;
  Vector4 get qtqs;
  Vector4 get qtqt;
  Vector4 get qtqp;
  Vector4 get qtqq;
  Vector4 get qpss;
  Vector4 get qpst;
  Vector4 get qpsp;
  Vector4 get qpsq;
  Vector4 get qpts;
  Vector4 get qptt;
  Vector4 get qptp;
  Vector4 get qptq;
  Vector4 get qpps;
  Vector4 get qppt;
  Vector4 get qppp;
  Vector4 get qppq;
  Vector4 get qpqs;
  Vector4 get qpqt;
  Vector4 get qpqp;
  Vector4 get qpqq;
  Vector4 get qqss;
  Vector4 get qqst;
  Vector4 get qqsp;
  Vector4 get qqsq;
  Vector4 get qqts;
  Vector4 get qqtt;
  Vector4 get qqtp;
  Vector4 get qqtq;
  Vector4 get qqps;
  Vector4 get qqpt;
  Vector4 get qqpp;
  Vector4 get qqpq;
  Vector4 get qqqs;
  Vector4 get qqqt;
  Vector4 get qqqp;
  Vector4 get qqqq;

  /// The magnitude of this [Vector4].
  double get magnitude;

  /// This [Vector4]'s unit vector.
  ///
  /// A [Vector4] with a [magnitude] of `1` that has the same direction as this
  /// [Vector4].
  Vector4 get unitVector;

  /// Whether or not this [Vector4] is a unit vector.
  bool get isUnit;

  /// Computes the dot product of this [Vector4] `A` and another [Vector4] [B].
  double dotProduct(Vector4 B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index);
}

/// A column vector of length 4 (a 4 by 1 matrix).
class _Vector4 extends _VertexBase implements Vector4 {
  final double x;
  final double y;
  final double z;
  final double w;

  final int columnDimension = 1;

  final int rowDimension = 4;

  Float32List _storageInternal;

  double _squareSum;

  double _magnitude;

  Vector4 _unitVector;

  /// Instantiates a new [Vector4] with the specified values.
  _Vector4(this.x, this.y, this.z, this.w);

  Float32List get _storage {
    if (_storageInternal == null) {
      _storageInternal = new Float32List(4);
      _storageInternal[0] = x;
      _storageInternal[1] = y;
      _storageInternal[2] = z;
      _storageInternal[3] = w;
    }

    return _storageInternal;
  }

  // Vector2 xyzw swizzles: x first
  Vector2 get xx => new Vector2(x, x);
  Vector2 get xy => new Vector2(x, y);
  Vector2 get xz => new Vector2(x, z);
  Vector2 get xw => new Vector2(x, w);

  // Vector2 xyzw swizzles: y first
  Vector2 get yx => new Vector2(y, x);
  Vector2 get yy => new Vector2(y, y);
  Vector2 get yz => new Vector2(y, z);
  Vector2 get yw => new Vector2(y, w);

  // Vector2 xyzw swizzles: z first
  Vector2 get zx => new Vector2(z, x);
  Vector2 get zy => new Vector2(z, y);
  Vector2 get zz => new Vector2(z, z);
  Vector2 get zw => new Vector2(z, w);

  // Vector2 xyzw swizzles: w first
  Vector2 get wx => new Vector2(w, x);
  Vector2 get wy => new Vector2(w, y);
  Vector2 get wz => new Vector2(w, z);
  Vector2 get ww => new Vector2(w, w);

  // Vector3 xyzw swizzles: x first
  Vector3 get xxx => new Vector3(x, x, x);
  Vector3 get xxy => new Vector3(x, x, y);
  Vector3 get xxz => new Vector3(x, x, z);
  Vector3 get xxw => new Vector3(x, x, w);
  Vector3 get xyx => new Vector3(x, y, x);
  Vector3 get xyy => new Vector3(x, y, y);
  Vector3 get xyz => new Vector3(x, y, z);
  Vector3 get xyw => new Vector3(x, y, w);
  Vector3 get xzx => new Vector3(x, z, x);
  Vector3 get xzy => new Vector3(x, z, y);
  Vector3 get xzz => new Vector3(x, z, z);
  Vector3 get xzw => new Vector3(x, z, w);
  Vector3 get xwx => new Vector3(x, w, x);
  Vector3 get xwy => new Vector3(x, w, y);
  Vector3 get xwz => new Vector3(x, w, z);
  Vector3 get xww => new Vector3(x, w, w);

  // Vector3 xyzw swizzles: y first
  Vector3 get yxx => new Vector3(y, x, x);
  Vector3 get yxy => new Vector3(y, x, y);
  Vector3 get yxz => new Vector3(y, x, z);
  Vector3 get yxw => new Vector3(y, x, w);
  Vector3 get yyx => new Vector3(y, y, x);
  Vector3 get yyy => new Vector3(y, y, y);
  Vector3 get yyz => new Vector3(y, y, z);
  Vector3 get yyw => new Vector3(y, y, w);
  Vector3 get yzx => new Vector3(y, z, x);
  Vector3 get yzy => new Vector3(y, z, y);
  Vector3 get yzz => new Vector3(y, z, z);
  Vector3 get yzw => new Vector3(y, z, w);
  Vector3 get ywx => new Vector3(y, w, x);
  Vector3 get ywy => new Vector3(y, w, y);
  Vector3 get ywz => new Vector3(y, w, z);
  Vector3 get yww => new Vector3(y, w, w);

  // Vector3 xyzw swizzles: z first
  Vector3 get zxx => new Vector3(z, x, x);
  Vector3 get zxy => new Vector3(z, x, y);
  Vector3 get zxz => new Vector3(z, x, z);
  Vector3 get zxw => new Vector3(z, x, w);
  Vector3 get zyx => new Vector3(z, y, x);
  Vector3 get zyy => new Vector3(z, y, y);
  Vector3 get zyz => new Vector3(z, y, z);
  Vector3 get zyw => new Vector3(z, y, w);
  Vector3 get zzx => new Vector3(z, z, x);
  Vector3 get zzy => new Vector3(z, z, y);
  Vector3 get zzz => new Vector3(z, z, z);
  Vector3 get zzw => new Vector3(z, z, w);
  Vector3 get zwx => new Vector3(z, w, x);
  Vector3 get zwy => new Vector3(z, w, y);
  Vector3 get zwz => new Vector3(z, w, z);
  Vector3 get zww => new Vector3(z, w, w);

  // Vector3 xyzw swizzles: w first
  Vector3 get wxx => new Vector3(w, x, x);
  Vector3 get wxy => new Vector3(w, x, y);
  Vector3 get wxz => new Vector3(w, x, z);
  Vector3 get wxw => new Vector3(w, x, w);
  Vector3 get wyx => new Vector3(w, y, x);
  Vector3 get wyy => new Vector3(w, y, y);
  Vector3 get wyz => new Vector3(w, y, z);
  Vector3 get wyw => new Vector3(w, y, w);
  Vector3 get wzx => new Vector3(w, z, x);
  Vector3 get wzy => new Vector3(w, z, y);
  Vector3 get wzz => new Vector3(w, z, z);
  Vector3 get wzw => new Vector3(w, z, w);
  Vector3 get wwx => new Vector3(w, w, x);
  Vector3 get wwy => new Vector3(w, w, y);
  Vector3 get wwz => new Vector3(w, w, z);
  Vector3 get www => new Vector3(w, w, w);

  // Vector4 xyzw swizzles: x first
  Vector4 get xxxx => new Vector4(x, x, x, x);
  Vector4 get xxxy => new Vector4(x, x, x, y);
  Vector4 get xxxz => new Vector4(x, x, x, z);
  Vector4 get xxxw => new Vector4(x, x, x, w);
  Vector4 get xxyx => new Vector4(x, x, y, x);
  Vector4 get xxyy => new Vector4(x, x, y, y);
  Vector4 get xxyz => new Vector4(x, x, y, z);
  Vector4 get xxyw => new Vector4(x, x, y, w);
  Vector4 get xxzx => new Vector4(x, x, z, x);
  Vector4 get xxzy => new Vector4(x, x, z, y);
  Vector4 get xxzz => new Vector4(x, x, z, z);
  Vector4 get xxzw => new Vector4(x, x, z, w);
  Vector4 get xxwx => new Vector4(x, x, w, x);
  Vector4 get xxwy => new Vector4(x, x, w, y);
  Vector4 get xxwz => new Vector4(x, x, w, z);
  Vector4 get xxww => new Vector4(x, x, w, w);
  Vector4 get xyxx => new Vector4(x, y, x, x);
  Vector4 get xyxy => new Vector4(x, y, x, y);
  Vector4 get xyxz => new Vector4(x, y, x, z);
  Vector4 get xyxw => new Vector4(x, y, x, w);
  Vector4 get xyyx => new Vector4(x, y, y, x);
  Vector4 get xyyy => new Vector4(x, y, y, y);
  Vector4 get xyyz => new Vector4(x, y, y, z);
  Vector4 get xyyw => new Vector4(x, y, y, w);
  Vector4 get xyzx => new Vector4(x, y, z, x);
  Vector4 get xyzy => new Vector4(x, y, z, y);
  Vector4 get xyzz => new Vector4(x, y, z, z);
  Vector4 get xyzw => new Vector4(x, y, z, w);
  Vector4 get xywx => new Vector4(x, y, w, x);
  Vector4 get xywy => new Vector4(x, y, w, y);
  Vector4 get xywz => new Vector4(x, y, w, z);
  Vector4 get xyww => new Vector4(x, y, w, w);
  Vector4 get xzxx => new Vector4(x, z, x, x);
  Vector4 get xzxy => new Vector4(x, z, x, y);
  Vector4 get xzxz => new Vector4(x, z, x, z);
  Vector4 get xzxw => new Vector4(x, z, x, w);
  Vector4 get xzyx => new Vector4(x, z, y, x);
  Vector4 get xzyy => new Vector4(x, z, y, y);
  Vector4 get xzyz => new Vector4(x, z, y, z);
  Vector4 get xzyw => new Vector4(x, z, y, w);
  Vector4 get xzzx => new Vector4(x, z, z, x);
  Vector4 get xzzy => new Vector4(x, z, z, y);
  Vector4 get xzzz => new Vector4(x, z, z, z);
  Vector4 get xzzw => new Vector4(x, z, z, w);
  Vector4 get xzwx => new Vector4(x, z, w, x);
  Vector4 get xzwy => new Vector4(x, z, w, y);
  Vector4 get xzwz => new Vector4(x, z, w, z);
  Vector4 get xzww => new Vector4(x, z, w, w);
  Vector4 get xwxx => new Vector4(x, w, x, x);
  Vector4 get xwxy => new Vector4(x, w, x, y);
  Vector4 get xwxz => new Vector4(x, w, x, z);
  Vector4 get xwxw => new Vector4(x, w, x, w);
  Vector4 get xwyx => new Vector4(x, w, y, x);
  Vector4 get xwyy => new Vector4(x, w, y, y);
  Vector4 get xwyz => new Vector4(x, w, y, z);
  Vector4 get xwyw => new Vector4(x, w, y, w);
  Vector4 get xwzx => new Vector4(x, w, z, x);
  Vector4 get xwzy => new Vector4(x, w, z, y);
  Vector4 get xwzz => new Vector4(x, w, z, z);
  Vector4 get xwzw => new Vector4(x, w, z, w);
  Vector4 get xwwx => new Vector4(x, w, w, x);
  Vector4 get xwwy => new Vector4(x, w, w, y);
  Vector4 get xwwz => new Vector4(x, w, w, z);
  Vector4 get xwww => new Vector4(x, w, w, w);

  // Vector4 xyzw swizzles: y first
  Vector4 get yxxx => new Vector4(y, x, x, x);
  Vector4 get yxxy => new Vector4(y, x, x, y);
  Vector4 get yxxz => new Vector4(y, x, x, z);
  Vector4 get yxxw => new Vector4(y, x, x, w);
  Vector4 get yxyx => new Vector4(y, x, y, x);
  Vector4 get yxyy => new Vector4(y, x, y, y);
  Vector4 get yxyz => new Vector4(y, x, y, z);
  Vector4 get yxyw => new Vector4(y, x, y, w);
  Vector4 get yxzx => new Vector4(y, x, z, x);
  Vector4 get yxzy => new Vector4(y, x, z, y);
  Vector4 get yxzz => new Vector4(y, x, z, z);
  Vector4 get yxzw => new Vector4(y, x, z, w);
  Vector4 get yxwx => new Vector4(y, x, w, x);
  Vector4 get yxwy => new Vector4(y, x, w, y);
  Vector4 get yxwz => new Vector4(y, x, w, z);
  Vector4 get yxww => new Vector4(y, x, w, w);
  Vector4 get yyxx => new Vector4(y, y, x, x);
  Vector4 get yyxy => new Vector4(y, y, x, y);
  Vector4 get yyxz => new Vector4(y, y, x, z);
  Vector4 get yyxw => new Vector4(y, y, x, w);
  Vector4 get yyyx => new Vector4(y, y, y, x);
  Vector4 get yyyy => new Vector4(y, y, y, y);
  Vector4 get yyyz => new Vector4(y, y, y, z);
  Vector4 get yyyw => new Vector4(y, y, y, w);
  Vector4 get yyzx => new Vector4(y, y, z, x);
  Vector4 get yyzy => new Vector4(y, y, z, y);
  Vector4 get yyzz => new Vector4(y, y, z, z);
  Vector4 get yyzw => new Vector4(y, y, z, w);
  Vector4 get yywx => new Vector4(y, y, w, x);
  Vector4 get yywy => new Vector4(y, y, w, y);
  Vector4 get yywz => new Vector4(y, y, w, z);
  Vector4 get yyww => new Vector4(y, y, w, w);
  Vector4 get yzxx => new Vector4(y, z, x, x);
  Vector4 get yzxy => new Vector4(y, z, x, y);
  Vector4 get yzxz => new Vector4(y, z, x, z);
  Vector4 get yzxw => new Vector4(y, z, x, w);
  Vector4 get yzyx => new Vector4(y, z, y, x);
  Vector4 get yzyy => new Vector4(y, z, y, y);
  Vector4 get yzyz => new Vector4(y, z, y, z);
  Vector4 get yzyw => new Vector4(y, z, y, w);
  Vector4 get yzzx => new Vector4(y, z, z, x);
  Vector4 get yzzy => new Vector4(y, z, z, y);
  Vector4 get yzzz => new Vector4(y, z, z, z);
  Vector4 get yzzw => new Vector4(y, z, z, w);
  Vector4 get yzwx => new Vector4(y, z, w, x);
  Vector4 get yzwy => new Vector4(y, z, w, y);
  Vector4 get yzwz => new Vector4(y, z, w, z);
  Vector4 get yzww => new Vector4(y, z, w, w);
  Vector4 get ywxx => new Vector4(y, w, x, x);
  Vector4 get ywxy => new Vector4(y, w, x, y);
  Vector4 get ywxz => new Vector4(y, w, x, z);
  Vector4 get ywxw => new Vector4(y, w, x, w);
  Vector4 get ywyx => new Vector4(y, w, y, x);
  Vector4 get ywyy => new Vector4(y, w, y, y);
  Vector4 get ywyz => new Vector4(y, w, y, z);
  Vector4 get ywyw => new Vector4(y, w, y, w);
  Vector4 get ywzx => new Vector4(y, w, z, x);
  Vector4 get ywzy => new Vector4(y, w, z, y);
  Vector4 get ywzz => new Vector4(y, w, z, z);
  Vector4 get ywzw => new Vector4(y, w, z, w);
  Vector4 get ywwx => new Vector4(y, w, w, x);
  Vector4 get ywwy => new Vector4(y, w, w, y);
  Vector4 get ywwz => new Vector4(y, w, w, z);
  Vector4 get ywww => new Vector4(y, w, w, w);

  // Vector4 xyzw swizzles: z first
  Vector4 get zxxx => new Vector4(z, x, x, x);
  Vector4 get zxxy => new Vector4(z, x, x, y);
  Vector4 get zxxz => new Vector4(z, x, x, z);
  Vector4 get zxxw => new Vector4(z, x, x, w);
  Vector4 get zxyx => new Vector4(z, x, y, x);
  Vector4 get zxyy => new Vector4(z, x, y, y);
  Vector4 get zxyz => new Vector4(z, x, y, z);
  Vector4 get zxyw => new Vector4(z, x, y, w);
  Vector4 get zxzx => new Vector4(z, x, z, x);
  Vector4 get zxzy => new Vector4(z, x, z, y);
  Vector4 get zxzz => new Vector4(z, x, z, z);
  Vector4 get zxzw => new Vector4(z, x, z, w);
  Vector4 get zxwx => new Vector4(z, x, w, x);
  Vector4 get zxwy => new Vector4(z, x, w, y);
  Vector4 get zxwz => new Vector4(z, x, w, z);
  Vector4 get zxww => new Vector4(z, x, w, w);
  Vector4 get zyxx => new Vector4(z, y, x, x);
  Vector4 get zyxy => new Vector4(z, y, x, y);
  Vector4 get zyxz => new Vector4(z, y, x, z);
  Vector4 get zyxw => new Vector4(z, y, x, w);
  Vector4 get zyyx => new Vector4(z, y, y, x);
  Vector4 get zyyy => new Vector4(z, y, y, y);
  Vector4 get zyyz => new Vector4(z, y, y, z);
  Vector4 get zyyw => new Vector4(z, y, y, w);
  Vector4 get zyzx => new Vector4(z, y, z, x);
  Vector4 get zyzy => new Vector4(z, y, z, y);
  Vector4 get zyzz => new Vector4(z, y, z, z);
  Vector4 get zyzw => new Vector4(z, y, z, w);
  Vector4 get zywx => new Vector4(z, y, w, x);
  Vector4 get zywy => new Vector4(z, y, w, y);
  Vector4 get zywz => new Vector4(z, y, w, z);
  Vector4 get zyww => new Vector4(z, y, w, w);
  Vector4 get zzxx => new Vector4(z, z, x, x);
  Vector4 get zzxy => new Vector4(z, z, x, y);
  Vector4 get zzxz => new Vector4(z, z, x, z);
  Vector4 get zzxw => new Vector4(z, z, x, w);
  Vector4 get zzyx => new Vector4(z, z, y, x);
  Vector4 get zzyy => new Vector4(z, z, y, y);
  Vector4 get zzyz => new Vector4(z, z, y, z);
  Vector4 get zzyw => new Vector4(z, z, y, w);
  Vector4 get zzzx => new Vector4(z, z, z, x);
  Vector4 get zzzy => new Vector4(z, z, z, y);
  Vector4 get zzzz => new Vector4(z, z, z, z);
  Vector4 get zzzw => new Vector4(z, z, z, w);
  Vector4 get zzwx => new Vector4(z, z, w, x);
  Vector4 get zzwy => new Vector4(z, z, w, y);
  Vector4 get zzwz => new Vector4(z, z, w, z);
  Vector4 get zzww => new Vector4(z, z, w, w);
  Vector4 get zwxx => new Vector4(z, w, x, x);
  Vector4 get zwxy => new Vector4(z, w, x, y);
  Vector4 get zwxz => new Vector4(z, w, x, z);
  Vector4 get zwxw => new Vector4(z, w, x, w);
  Vector4 get zwyx => new Vector4(z, w, y, x);
  Vector4 get zwyy => new Vector4(z, w, y, y);
  Vector4 get zwyz => new Vector4(z, w, y, z);
  Vector4 get zwyw => new Vector4(z, w, y, w);
  Vector4 get zwzx => new Vector4(z, w, z, x);
  Vector4 get zwzy => new Vector4(z, w, z, y);
  Vector4 get zwzz => new Vector4(z, w, z, z);
  Vector4 get zwzw => new Vector4(z, w, z, w);
  Vector4 get zwwx => new Vector4(z, w, w, x);
  Vector4 get zwwy => new Vector4(z, w, w, y);
  Vector4 get zwwz => new Vector4(z, w, w, z);
  Vector4 get zwww => new Vector4(z, w, w, w);

  // Vector4 xyzw swizzles: w first
  Vector4 get wxxx => new Vector4(w, x, x, x);
  Vector4 get wxxy => new Vector4(w, x, x, y);
  Vector4 get wxxz => new Vector4(w, x, x, z);
  Vector4 get wxxw => new Vector4(w, x, x, w);
  Vector4 get wxyx => new Vector4(w, x, y, x);
  Vector4 get wxyy => new Vector4(w, x, y, y);
  Vector4 get wxyz => new Vector4(w, x, y, z);
  Vector4 get wxyw => new Vector4(w, x, y, w);
  Vector4 get wxzx => new Vector4(w, x, z, x);
  Vector4 get wxzy => new Vector4(w, x, z, y);
  Vector4 get wxzz => new Vector4(w, x, z, z);
  Vector4 get wxzw => new Vector4(w, x, z, w);
  Vector4 get wxwx => new Vector4(w, x, w, x);
  Vector4 get wxwy => new Vector4(w, x, w, y);
  Vector4 get wxwz => new Vector4(w, x, w, z);
  Vector4 get wxww => new Vector4(w, x, w, w);
  Vector4 get wyxx => new Vector4(w, y, x, x);
  Vector4 get wyxy => new Vector4(w, y, x, y);
  Vector4 get wyxz => new Vector4(w, y, x, z);
  Vector4 get wyxw => new Vector4(w, y, x, w);
  Vector4 get wyyx => new Vector4(w, y, y, x);
  Vector4 get wyyy => new Vector4(w, y, y, y);
  Vector4 get wyyz => new Vector4(w, y, y, z);
  Vector4 get wyyw => new Vector4(w, y, y, w);
  Vector4 get wyzx => new Vector4(w, y, z, x);
  Vector4 get wyzy => new Vector4(w, y, z, y);
  Vector4 get wyzz => new Vector4(w, y, z, z);
  Vector4 get wyzw => new Vector4(w, y, z, w);
  Vector4 get wywx => new Vector4(w, y, w, x);
  Vector4 get wywy => new Vector4(w, y, w, y);
  Vector4 get wywz => new Vector4(w, y, w, z);
  Vector4 get wyww => new Vector4(w, y, w, w);
  Vector4 get wzxx => new Vector4(w, z, x, x);
  Vector4 get wzxy => new Vector4(w, z, x, y);
  Vector4 get wzxz => new Vector4(w, z, x, z);
  Vector4 get wzxw => new Vector4(w, z, x, w);
  Vector4 get wzyx => new Vector4(w, z, y, x);
  Vector4 get wzyy => new Vector4(w, z, y, y);
  Vector4 get wzyz => new Vector4(w, z, y, z);
  Vector4 get wzyw => new Vector4(w, z, y, w);
  Vector4 get wzzx => new Vector4(w, z, z, x);
  Vector4 get wzzy => new Vector4(w, z, z, y);
  Vector4 get wzzz => new Vector4(w, z, z, z);
  Vector4 get wzzw => new Vector4(w, z, z, w);
  Vector4 get wzwx => new Vector4(w, z, w, x);
  Vector4 get wzwy => new Vector4(w, z, w, y);
  Vector4 get wzwz => new Vector4(w, z, w, z);
  Vector4 get wzww => new Vector4(w, z, w, w);
  Vector4 get wwxx => new Vector4(w, w, x, x);
  Vector4 get wwxy => new Vector4(w, w, x, y);
  Vector4 get wwxz => new Vector4(w, w, x, z);
  Vector4 get wwxw => new Vector4(w, w, x, w);
  Vector4 get wwyx => new Vector4(w, w, y, x);
  Vector4 get wwyy => new Vector4(w, w, y, y);
  Vector4 get wwyz => new Vector4(w, w, y, z);
  Vector4 get wwyw => new Vector4(w, w, y, w);
  Vector4 get wwzx => new Vector4(w, w, z, x);
  Vector4 get wwzy => new Vector4(w, w, z, y);
  Vector4 get wwzz => new Vector4(w, w, z, z);
  Vector4 get wwzw => new Vector4(w, w, z, w);
  Vector4 get wwwx => new Vector4(w, w, w, x);
  Vector4 get wwwy => new Vector4(w, w, w, y);
  Vector4 get wwwz => new Vector4(w, w, w, z);
  Vector4 get wwww => new Vector4(w, w, w, w);

  double get r => x;
  double get g => y;
  double get b => z;
  double get a => w;

  // Vector2 rgba swizzles: r first
  Vector2 get rr => new Vector2(r, r);
  Vector2 get rg => new Vector2(r, g);
  Vector2 get rb => new Vector2(r, b);
  Vector2 get ra => new Vector2(r, a);

  // Vector2 rgba swizzles: g first
  Vector2 get gr => new Vector2(g, r);
  Vector2 get gg => new Vector2(g, g);
  Vector2 get gb => new Vector2(g, b);
  Vector2 get ga => new Vector2(g, a);

  // Vector2 rgba swizzles: b first
  Vector2 get br => new Vector2(b, r);
  Vector2 get bg => new Vector2(b, g);
  Vector2 get bb => new Vector2(b, b);
  Vector2 get ba => new Vector2(b, a);

  // Vector2 rgba swizzles: a first
  Vector2 get ar => new Vector2(a, r);
  Vector2 get ag => new Vector2(a, g);
  Vector2 get ab => new Vector2(a, b);
  Vector2 get aa => new Vector2(a, a);

  // Vector3 rgba swizzles: r first
  Vector3 get rrr => new Vector3(r, r, r);
  Vector3 get rrg => new Vector3(r, r, g);
  Vector3 get rrb => new Vector3(r, r, b);
  Vector3 get rra => new Vector3(r, r, a);
  Vector3 get rgr => new Vector3(r, g, r);
  Vector3 get rgg => new Vector3(r, g, g);
  Vector3 get rgb => new Vector3(r, g, b);
  Vector3 get rga => new Vector3(r, g, a);
  Vector3 get rbr => new Vector3(r, b, r);
  Vector3 get rbg => new Vector3(r, b, g);
  Vector3 get rbb => new Vector3(r, b, b);
  Vector3 get rba => new Vector3(r, b, a);
  Vector3 get rar => new Vector3(r, a, r);
  Vector3 get rag => new Vector3(r, a, g);
  Vector3 get rab => new Vector3(r, a, b);
  Vector3 get raa => new Vector3(r, a, a);

  // Vector3 rgba swizzles: g first
  Vector3 get grr => new Vector3(g, r, r);
  Vector3 get grg => new Vector3(g, r, g);
  Vector3 get grb => new Vector3(g, r, b);
  Vector3 get gra => new Vector3(g, r, a);
  Vector3 get ggr => new Vector3(g, g, r);
  Vector3 get ggg => new Vector3(g, g, g);
  Vector3 get ggb => new Vector3(g, g, b);
  Vector3 get gga => new Vector3(g, g, a);
  Vector3 get gbr => new Vector3(g, b, r);
  Vector3 get gbg => new Vector3(g, b, g);
  Vector3 get gbb => new Vector3(g, b, b);
  Vector3 get gba => new Vector3(g, b, a);
  Vector3 get gar => new Vector3(g, a, r);
  Vector3 get gag => new Vector3(g, a, g);
  Vector3 get gab => new Vector3(g, a, b);
  Vector3 get gaa => new Vector3(g, a, a);

  // Vector3 rgba swizzles: b first
  Vector3 get brr => new Vector3(b, r, r);
  Vector3 get brg => new Vector3(b, r, g);
  Vector3 get brb => new Vector3(b, r, b);
  Vector3 get bra => new Vector3(b, r, a);
  Vector3 get bgr => new Vector3(b, g, r);
  Vector3 get bgg => new Vector3(b, g, g);
  Vector3 get bgb => new Vector3(b, g, b);
  Vector3 get bga => new Vector3(b, g, a);
  Vector3 get bbr => new Vector3(b, b, r);
  Vector3 get bbg => new Vector3(b, b, g);
  Vector3 get bbb => new Vector3(b, b, b);
  Vector3 get bba => new Vector3(b, b, a);
  Vector3 get bar => new Vector3(b, a, r);
  Vector3 get bag => new Vector3(b, a, g);
  Vector3 get bab => new Vector3(b, a, b);
  Vector3 get baa => new Vector3(b, a, a);

  // Vector3 rgba swizzles: a first
  Vector3 get arr => new Vector3(a, r, r);
  Vector3 get arg => new Vector3(a, r, g);
  Vector3 get arb => new Vector3(a, r, b);
  Vector3 get ara => new Vector3(a, r, a);
  Vector3 get agr => new Vector3(a, g, r);
  Vector3 get agg => new Vector3(a, g, g);
  Vector3 get agb => new Vector3(a, g, b);
  Vector3 get aga => new Vector3(a, g, a);
  Vector3 get abr => new Vector3(a, b, r);
  Vector3 get abg => new Vector3(a, b, g);
  Vector3 get abb => new Vector3(a, b, b);
  Vector3 get aba => new Vector3(a, b, a);
  Vector3 get aar => new Vector3(a, a, r);
  Vector3 get aag => new Vector3(a, a, g);
  Vector3 get aab => new Vector3(a, a, b);
  Vector3 get aaa => new Vector3(a, a, a);

  // Vector4 rgba swizzles: r first
  Vector4 get rrrr => new Vector4(r, r, r, r);
  Vector4 get rrrg => new Vector4(r, r, r, g);
  Vector4 get rrrb => new Vector4(r, r, r, b);
  Vector4 get rrra => new Vector4(r, r, r, a);
  Vector4 get rrgr => new Vector4(r, r, g, r);
  Vector4 get rrgg => new Vector4(r, r, g, g);
  Vector4 get rrgb => new Vector4(r, r, g, b);
  Vector4 get rrga => new Vector4(r, r, g, a);
  Vector4 get rrbr => new Vector4(r, r, b, r);
  Vector4 get rrbg => new Vector4(r, r, b, g);
  Vector4 get rrbb => new Vector4(r, r, b, b);
  Vector4 get rrba => new Vector4(r, r, b, a);
  Vector4 get rrar => new Vector4(r, r, a, r);
  Vector4 get rrag => new Vector4(r, r, a, g);
  Vector4 get rrab => new Vector4(r, r, a, b);
  Vector4 get rraa => new Vector4(r, r, a, a);
  Vector4 get rgrr => new Vector4(r, g, r, r);
  Vector4 get rgrg => new Vector4(r, g, r, g);
  Vector4 get rgrb => new Vector4(r, g, r, b);
  Vector4 get rgra => new Vector4(r, g, r, a);
  Vector4 get rggr => new Vector4(r, g, g, r);
  Vector4 get rggg => new Vector4(r, g, g, g);
  Vector4 get rggb => new Vector4(r, g, g, b);
  Vector4 get rgga => new Vector4(r, g, g, a);
  Vector4 get rgbr => new Vector4(r, g, b, r);
  Vector4 get rgbg => new Vector4(r, g, b, g);
  Vector4 get rgbb => new Vector4(r, g, b, b);
  Vector4 get rgba => new Vector4(r, g, b, a);
  Vector4 get rgar => new Vector4(r, g, a, r);
  Vector4 get rgag => new Vector4(r, g, a, g);
  Vector4 get rgab => new Vector4(r, g, a, b);
  Vector4 get rgaa => new Vector4(r, g, a, a);
  Vector4 get rbrr => new Vector4(r, b, r, r);
  Vector4 get rbrg => new Vector4(r, b, r, g);
  Vector4 get rbrb => new Vector4(r, b, r, b);
  Vector4 get rbra => new Vector4(r, b, r, a);
  Vector4 get rbgr => new Vector4(r, b, g, r);
  Vector4 get rbgg => new Vector4(r, b, g, g);
  Vector4 get rbgb => new Vector4(r, b, g, b);
  Vector4 get rbga => new Vector4(r, b, g, a);
  Vector4 get rbbr => new Vector4(r, b, b, r);
  Vector4 get rbbg => new Vector4(r, b, b, g);
  Vector4 get rbbb => new Vector4(r, b, b, b);
  Vector4 get rbba => new Vector4(r, b, b, a);
  Vector4 get rbar => new Vector4(r, b, a, r);
  Vector4 get rbag => new Vector4(r, b, a, g);
  Vector4 get rbab => new Vector4(r, b, a, b);
  Vector4 get rbaa => new Vector4(r, b, a, a);
  Vector4 get rarr => new Vector4(r, a, r, r);
  Vector4 get rarg => new Vector4(r, a, r, g);
  Vector4 get rarb => new Vector4(r, a, r, b);
  Vector4 get rara => new Vector4(r, a, r, a);
  Vector4 get ragr => new Vector4(r, a, g, r);
  Vector4 get ragg => new Vector4(r, a, g, g);
  Vector4 get ragb => new Vector4(r, a, g, b);
  Vector4 get raga => new Vector4(r, a, g, a);
  Vector4 get rabr => new Vector4(r, a, b, r);
  Vector4 get rabg => new Vector4(r, a, b, g);
  Vector4 get rabb => new Vector4(r, a, b, b);
  Vector4 get raba => new Vector4(r, a, b, a);
  Vector4 get raar => new Vector4(r, a, a, r);
  Vector4 get raag => new Vector4(r, a, a, g);
  Vector4 get raab => new Vector4(r, a, a, b);
  Vector4 get raaa => new Vector4(r, a, a, a);

  // Vector4 rgba swizzles: g first
  Vector4 get grrr => new Vector4(g, r, r, r);
  Vector4 get grrg => new Vector4(g, r, r, g);
  Vector4 get grrb => new Vector4(g, r, r, b);
  Vector4 get grra => new Vector4(g, r, r, a);
  Vector4 get grgr => new Vector4(g, r, g, r);
  Vector4 get grgg => new Vector4(g, r, g, g);
  Vector4 get grgb => new Vector4(g, r, g, b);
  Vector4 get grga => new Vector4(g, r, g, a);
  Vector4 get grbr => new Vector4(g, r, b, r);
  Vector4 get grbg => new Vector4(g, r, b, g);
  Vector4 get grbb => new Vector4(g, r, b, b);
  Vector4 get grba => new Vector4(g, r, b, a);
  Vector4 get grar => new Vector4(g, r, a, r);
  Vector4 get grag => new Vector4(g, r, a, g);
  Vector4 get grab => new Vector4(g, r, a, b);
  Vector4 get graa => new Vector4(g, r, a, a);
  Vector4 get ggrr => new Vector4(g, g, r, r);
  Vector4 get ggrg => new Vector4(g, g, r, g);
  Vector4 get ggrb => new Vector4(g, g, r, b);
  Vector4 get ggra => new Vector4(g, g, r, a);
  Vector4 get gggr => new Vector4(g, g, g, r);
  Vector4 get gggg => new Vector4(g, g, g, g);
  Vector4 get gggb => new Vector4(g, g, g, b);
  Vector4 get ggga => new Vector4(g, g, g, a);
  Vector4 get ggbr => new Vector4(g, g, b, r);
  Vector4 get ggbg => new Vector4(g, g, b, g);
  Vector4 get ggbb => new Vector4(g, g, b, b);
  Vector4 get ggba => new Vector4(g, g, b, a);
  Vector4 get ggar => new Vector4(g, g, a, r);
  Vector4 get ggag => new Vector4(g, g, a, g);
  Vector4 get ggab => new Vector4(g, g, a, b);
  Vector4 get ggaa => new Vector4(g, g, a, a);
  Vector4 get gbrr => new Vector4(g, b, r, r);
  Vector4 get gbrg => new Vector4(g, b, r, g);
  Vector4 get gbrb => new Vector4(g, b, r, b);
  Vector4 get gbra => new Vector4(g, b, r, a);
  Vector4 get gbgr => new Vector4(g, b, g, r);
  Vector4 get gbgg => new Vector4(g, b, g, g);
  Vector4 get gbgb => new Vector4(g, b, g, b);
  Vector4 get gbga => new Vector4(g, b, g, a);
  Vector4 get gbbr => new Vector4(g, b, b, r);
  Vector4 get gbbg => new Vector4(g, b, b, g);
  Vector4 get gbbb => new Vector4(g, b, b, b);
  Vector4 get gbba => new Vector4(g, b, b, a);
  Vector4 get gbar => new Vector4(g, b, a, r);
  Vector4 get gbag => new Vector4(g, b, a, g);
  Vector4 get gbab => new Vector4(g, b, a, b);
  Vector4 get gbaa => new Vector4(g, b, a, a);
  Vector4 get garr => new Vector4(g, a, r, r);
  Vector4 get garg => new Vector4(g, a, r, g);
  Vector4 get garb => new Vector4(g, a, r, b);
  Vector4 get gara => new Vector4(g, a, r, a);
  Vector4 get gagr => new Vector4(g, a, g, r);
  Vector4 get gagg => new Vector4(g, a, g, g);
  Vector4 get gagb => new Vector4(g, a, g, b);
  Vector4 get gaga => new Vector4(g, a, g, a);
  Vector4 get gabr => new Vector4(g, a, b, r);
  Vector4 get gabg => new Vector4(g, a, b, g);
  Vector4 get gabb => new Vector4(g, a, b, b);
  Vector4 get gaba => new Vector4(g, a, b, a);
  Vector4 get gaar => new Vector4(g, a, a, r);
  Vector4 get gaag => new Vector4(g, a, a, g);
  Vector4 get gaab => new Vector4(g, a, a, b);
  Vector4 get gaaa => new Vector4(g, a, a, a);

  // Vector4 rgba swizzles: b first
  Vector4 get brrr => new Vector4(b, r, r, r);
  Vector4 get brrg => new Vector4(b, r, r, g);
  Vector4 get brrb => new Vector4(b, r, r, b);
  Vector4 get brra => new Vector4(b, r, r, a);
  Vector4 get brgr => new Vector4(b, r, g, r);
  Vector4 get brgg => new Vector4(b, r, g, g);
  Vector4 get brgb => new Vector4(b, r, g, b);
  Vector4 get brga => new Vector4(b, r, g, a);
  Vector4 get brbr => new Vector4(b, r, b, r);
  Vector4 get brbg => new Vector4(b, r, b, g);
  Vector4 get brbb => new Vector4(b, r, b, b);
  Vector4 get brba => new Vector4(b, r, b, a);
  Vector4 get brar => new Vector4(b, r, a, r);
  Vector4 get brag => new Vector4(b, r, a, g);
  Vector4 get brab => new Vector4(b, r, a, b);
  Vector4 get braa => new Vector4(b, r, a, a);
  Vector4 get bgrr => new Vector4(b, g, r, r);
  Vector4 get bgrg => new Vector4(b, g, r, g);
  Vector4 get bgrb => new Vector4(b, g, r, b);
  Vector4 get bgra => new Vector4(b, g, r, a);
  Vector4 get bggr => new Vector4(b, g, g, r);
  Vector4 get bggg => new Vector4(b, g, g, g);
  Vector4 get bggb => new Vector4(b, g, g, b);
  Vector4 get bgga => new Vector4(b, g, g, a);
  Vector4 get bgbr => new Vector4(b, g, b, r);
  Vector4 get bgbg => new Vector4(b, g, b, g);
  Vector4 get bgbb => new Vector4(b, g, b, b);
  Vector4 get bgba => new Vector4(b, g, b, a);
  Vector4 get bgar => new Vector4(b, g, a, r);
  Vector4 get bgag => new Vector4(b, g, a, g);
  Vector4 get bgab => new Vector4(b, g, a, b);
  Vector4 get bgaa => new Vector4(b, g, a, a);
  Vector4 get bbrr => new Vector4(b, b, r, r);
  Vector4 get bbrg => new Vector4(b, b, r, g);
  Vector4 get bbrb => new Vector4(b, b, r, b);
  Vector4 get bbra => new Vector4(b, b, r, a);
  Vector4 get bbgr => new Vector4(b, b, g, r);
  Vector4 get bbgg => new Vector4(b, b, g, g);
  Vector4 get bbgb => new Vector4(b, b, g, b);
  Vector4 get bbga => new Vector4(b, b, g, a);
  Vector4 get bbbr => new Vector4(b, b, b, r);
  Vector4 get bbbg => new Vector4(b, b, b, g);
  Vector4 get bbbb => new Vector4(b, b, b, b);
  Vector4 get bbba => new Vector4(b, b, b, a);
  Vector4 get bbar => new Vector4(b, b, a, r);
  Vector4 get bbag => new Vector4(b, b, a, g);
  Vector4 get bbab => new Vector4(b, b, a, b);
  Vector4 get bbaa => new Vector4(b, b, a, a);
  Vector4 get barr => new Vector4(b, a, r, r);
  Vector4 get barg => new Vector4(b, a, r, g);
  Vector4 get barb => new Vector4(b, a, r, b);
  Vector4 get bara => new Vector4(b, a, r, a);
  Vector4 get bagr => new Vector4(b, a, g, r);
  Vector4 get bagg => new Vector4(b, a, g, g);
  Vector4 get bagb => new Vector4(b, a, g, b);
  Vector4 get baga => new Vector4(b, a, g, a);
  Vector4 get babr => new Vector4(b, a, b, r);
  Vector4 get babg => new Vector4(b, a, b, g);
  Vector4 get babb => new Vector4(b, a, b, b);
  Vector4 get baba => new Vector4(b, a, b, a);
  Vector4 get baar => new Vector4(b, a, a, r);
  Vector4 get baag => new Vector4(b, a, a, g);
  Vector4 get baab => new Vector4(b, a, a, b);
  Vector4 get baaa => new Vector4(b, a, a, a);

  // Vector4 rgba swizzles: a first
  Vector4 get arrr => new Vector4(a, r, r, r);
  Vector4 get arrg => new Vector4(a, r, r, g);
  Vector4 get arrb => new Vector4(a, r, r, b);
  Vector4 get arra => new Vector4(a, r, r, a);
  Vector4 get argr => new Vector4(a, r, g, r);
  Vector4 get argg => new Vector4(a, r, g, g);
  Vector4 get argb => new Vector4(a, r, g, b);
  Vector4 get arga => new Vector4(a, r, g, a);
  Vector4 get arbr => new Vector4(a, r, b, r);
  Vector4 get arbg => new Vector4(a, r, b, g);
  Vector4 get arbb => new Vector4(a, r, b, b);
  Vector4 get arba => new Vector4(a, r, b, a);
  Vector4 get arar => new Vector4(a, r, a, r);
  Vector4 get arag => new Vector4(a, r, a, g);
  Vector4 get arab => new Vector4(a, r, a, b);
  Vector4 get araa => new Vector4(a, r, a, a);
  Vector4 get agrr => new Vector4(a, g, r, r);
  Vector4 get agrg => new Vector4(a, g, r, g);
  Vector4 get agrb => new Vector4(a, g, r, b);
  Vector4 get agra => new Vector4(a, g, r, a);
  Vector4 get aggr => new Vector4(a, g, g, r);
  Vector4 get aggg => new Vector4(a, g, g, g);
  Vector4 get aggb => new Vector4(a, g, g, b);
  Vector4 get agga => new Vector4(a, g, g, a);
  Vector4 get agbr => new Vector4(a, g, b, r);
  Vector4 get agbg => new Vector4(a, g, b, g);
  Vector4 get agbb => new Vector4(a, g, b, b);
  Vector4 get agba => new Vector4(a, g, b, a);
  Vector4 get agar => new Vector4(a, g, a, r);
  Vector4 get agag => new Vector4(a, g, a, g);
  Vector4 get agab => new Vector4(a, g, a, b);
  Vector4 get agaa => new Vector4(a, g, a, a);
  Vector4 get abrr => new Vector4(a, b, r, r);
  Vector4 get abrg => new Vector4(a, b, r, g);
  Vector4 get abrb => new Vector4(a, b, r, b);
  Vector4 get abra => new Vector4(a, b, r, a);
  Vector4 get abgr => new Vector4(a, b, g, r);
  Vector4 get abgg => new Vector4(a, b, g, g);
  Vector4 get abgb => new Vector4(a, b, g, b);
  Vector4 get abga => new Vector4(a, b, g, a);
  Vector4 get abbr => new Vector4(a, b, b, r);
  Vector4 get abbg => new Vector4(a, b, b, g);
  Vector4 get abbb => new Vector4(a, b, b, b);
  Vector4 get abba => new Vector4(a, b, b, a);
  Vector4 get abar => new Vector4(a, b, a, r);
  Vector4 get abag => new Vector4(a, b, a, g);
  Vector4 get abab => new Vector4(a, b, a, b);
  Vector4 get abaa => new Vector4(a, b, a, a);
  Vector4 get aarr => new Vector4(a, a, r, r);
  Vector4 get aarg => new Vector4(a, a, r, g);
  Vector4 get aarb => new Vector4(a, a, r, b);
  Vector4 get aara => new Vector4(a, a, r, a);
  Vector4 get aagr => new Vector4(a, a, g, r);
  Vector4 get aagg => new Vector4(a, a, g, g);
  Vector4 get aagb => new Vector4(a, a, g, b);
  Vector4 get aaga => new Vector4(a, a, g, a);
  Vector4 get aabr => new Vector4(a, a, b, r);
  Vector4 get aabg => new Vector4(a, a, b, g);
  Vector4 get aabb => new Vector4(a, a, b, b);
  Vector4 get aaba => new Vector4(a, a, b, a);
  Vector4 get aaar => new Vector4(a, a, a, r);
  Vector4 get aaag => new Vector4(a, a, a, g);
  Vector4 get aaab => new Vector4(a, a, a, b);
  Vector4 get aaaa => new Vector4(a, a, a, a);

  double get s => x;
  double get t => y;
  double get p => z;
  double get q => w;

  // Vector2 stpq swizzles: s first
  Vector2 get ss => new Vector2(s, s);
  Vector2 get st => new Vector2(s, t);
  Vector2 get sp => new Vector2(s, p);
  Vector2 get sq => new Vector2(s, q);

  // Vector2 stpq swizzles: t first
  Vector2 get ts => new Vector2(t, s);
  Vector2 get tt => new Vector2(t, t);
  Vector2 get tp => new Vector2(t, p);
  Vector2 get tq => new Vector2(t, q);

  // Vector2 stpq swizzles: p first
  Vector2 get ps => new Vector2(p, s);
  Vector2 get pt => new Vector2(p, t);
  Vector2 get pp => new Vector2(p, p);
  Vector2 get pq => new Vector2(p, q);

  // Vector2 stpq swizzles: q first
  Vector2 get qs => new Vector2(q, s);
  Vector2 get qt => new Vector2(q, t);
  Vector2 get qp => new Vector2(q, p);
  Vector2 get qq => new Vector2(q, q);

  // Vector3 stpq swizzles: s first
  Vector3 get sss => new Vector3(s, s, s);
  Vector3 get sst => new Vector3(s, s, t);
  Vector3 get ssp => new Vector3(s, s, p);
  Vector3 get ssq => new Vector3(s, s, q);
  Vector3 get sts => new Vector3(s, t, s);
  Vector3 get stt => new Vector3(s, t, t);
  Vector3 get stp => new Vector3(s, t, p);
  Vector3 get stq => new Vector3(s, t, q);
  Vector3 get sps => new Vector3(s, p, s);
  Vector3 get spt => new Vector3(s, p, t);
  Vector3 get spp => new Vector3(s, p, p);
  Vector3 get spq => new Vector3(s, p, q);
  Vector3 get sqs => new Vector3(s, q, s);
  Vector3 get sqt => new Vector3(s, q, t);
  Vector3 get sqp => new Vector3(s, q, p);
  Vector3 get sqq => new Vector3(s, q, q);

  // Vector3 stpq swizzles: t first
  Vector3 get tss => new Vector3(t, s, s);
  Vector3 get tst => new Vector3(t, s, t);
  Vector3 get tsp => new Vector3(t, s, p);
  Vector3 get tsq => new Vector3(t, s, q);
  Vector3 get tts => new Vector3(t, t, s);
  Vector3 get ttt => new Vector3(t, t, t);
  Vector3 get ttp => new Vector3(t, t, p);
  Vector3 get ttq => new Vector3(t, t, q);
  Vector3 get tps => new Vector3(t, p, s);
  Vector3 get tpt => new Vector3(t, p, t);
  Vector3 get tpp => new Vector3(t, p, p);
  Vector3 get tpq => new Vector3(t, p, q);
  Vector3 get tqs => new Vector3(t, q, s);
  Vector3 get tqt => new Vector3(t, q, t);
  Vector3 get tqp => new Vector3(t, q, p);
  Vector3 get tqq => new Vector3(t, q, q);

  // Vector3 stpq swizzles: p first
  Vector3 get pss => new Vector3(p, s, s);
  Vector3 get pst => new Vector3(p, s, t);
  Vector3 get psp => new Vector3(p, s, p);
  Vector3 get psq => new Vector3(p, s, q);
  Vector3 get pts => new Vector3(p, t, s);
  Vector3 get ptt => new Vector3(p, t, t);
  Vector3 get ptp => new Vector3(p, t, p);
  Vector3 get ptq => new Vector3(p, t, q);
  Vector3 get pps => new Vector3(p, p, s);
  Vector3 get ppt => new Vector3(p, p, t);
  Vector3 get ppp => new Vector3(p, p, p);
  Vector3 get ppq => new Vector3(p, p, q);
  Vector3 get pqs => new Vector3(p, q, s);
  Vector3 get pqt => new Vector3(p, q, t);
  Vector3 get pqp => new Vector3(p, q, p);
  Vector3 get pqq => new Vector3(p, q, q);

  // Vector3 stpq swizzles: q first
  Vector3 get qss => new Vector3(q, s, s);
  Vector3 get qst => new Vector3(q, s, t);
  Vector3 get qsp => new Vector3(q, s, p);
  Vector3 get qsq => new Vector3(q, s, q);
  Vector3 get qts => new Vector3(q, t, s);
  Vector3 get qtt => new Vector3(q, t, t);
  Vector3 get qtp => new Vector3(q, t, p);
  Vector3 get qtq => new Vector3(q, t, q);
  Vector3 get qps => new Vector3(q, p, s);
  Vector3 get qpt => new Vector3(q, p, t);
  Vector3 get qpp => new Vector3(q, p, p);
  Vector3 get qpq => new Vector3(q, p, q);
  Vector3 get qqs => new Vector3(q, q, s);
  Vector3 get qqt => new Vector3(q, q, t);
  Vector3 get qqp => new Vector3(q, q, p);
  Vector3 get qqq => new Vector3(q, q, q);

  // Vector4 stpq swizzles: s first
  Vector4 get ssss => new Vector4(s, s, s, s);
  Vector4 get ssst => new Vector4(s, s, s, t);
  Vector4 get sssp => new Vector4(s, s, s, p);
  Vector4 get sssq => new Vector4(s, s, s, q);
  Vector4 get ssts => new Vector4(s, s, t, s);
  Vector4 get sstt => new Vector4(s, s, t, t);
  Vector4 get sstp => new Vector4(s, s, t, p);
  Vector4 get sstq => new Vector4(s, s, t, q);
  Vector4 get ssps => new Vector4(s, s, p, s);
  Vector4 get sspt => new Vector4(s, s, p, t);
  Vector4 get sspp => new Vector4(s, s, p, p);
  Vector4 get sspq => new Vector4(s, s, p, q);
  Vector4 get ssqs => new Vector4(s, s, q, s);
  Vector4 get ssqt => new Vector4(s, s, q, t);
  Vector4 get ssqp => new Vector4(s, s, q, p);
  Vector4 get ssqq => new Vector4(s, s, q, q);
  Vector4 get stss => new Vector4(s, t, s, s);
  Vector4 get stst => new Vector4(s, t, s, t);
  Vector4 get stsp => new Vector4(s, t, s, p);
  Vector4 get stsq => new Vector4(s, t, s, q);
  Vector4 get stts => new Vector4(s, t, t, s);
  Vector4 get sttt => new Vector4(s, t, t, t);
  Vector4 get sttp => new Vector4(s, t, t, p);
  Vector4 get sttq => new Vector4(s, t, t, q);
  Vector4 get stps => new Vector4(s, t, p, s);
  Vector4 get stpt => new Vector4(s, t, p, t);
  Vector4 get stpp => new Vector4(s, t, p, p);
  Vector4 get stpq => new Vector4(s, t, p, q);
  Vector4 get stqs => new Vector4(s, t, q, s);
  Vector4 get stqt => new Vector4(s, t, q, t);
  Vector4 get stqp => new Vector4(s, t, q, p);
  Vector4 get stqq => new Vector4(s, t, q, q);
  Vector4 get spss => new Vector4(s, p, s, s);
  Vector4 get spst => new Vector4(s, p, s, t);
  Vector4 get spsp => new Vector4(s, p, s, p);
  Vector4 get spsq => new Vector4(s, p, s, q);
  Vector4 get spts => new Vector4(s, p, t, s);
  Vector4 get sptt => new Vector4(s, p, t, t);
  Vector4 get sptp => new Vector4(s, p, t, p);
  Vector4 get sptq => new Vector4(s, p, t, q);
  Vector4 get spps => new Vector4(s, p, p, s);
  Vector4 get sppt => new Vector4(s, p, p, t);
  Vector4 get sppp => new Vector4(s, p, p, p);
  Vector4 get sppq => new Vector4(s, p, p, q);
  Vector4 get spqs => new Vector4(s, p, q, s);
  Vector4 get spqt => new Vector4(s, p, q, t);
  Vector4 get spqp => new Vector4(s, p, q, p);
  Vector4 get spqq => new Vector4(s, p, q, q);
  Vector4 get sqss => new Vector4(s, q, s, s);
  Vector4 get sqst => new Vector4(s, q, s, t);
  Vector4 get sqsp => new Vector4(s, q, s, p);
  Vector4 get sqsq => new Vector4(s, q, s, q);
  Vector4 get sqts => new Vector4(s, q, t, s);
  Vector4 get sqtt => new Vector4(s, q, t, t);
  Vector4 get sqtp => new Vector4(s, q, t, p);
  Vector4 get sqtq => new Vector4(s, q, t, q);
  Vector4 get sqps => new Vector4(s, q, p, s);
  Vector4 get sqpt => new Vector4(s, q, p, t);
  Vector4 get sqpp => new Vector4(s, q, p, p);
  Vector4 get sqpq => new Vector4(s, q, p, q);
  Vector4 get sqqs => new Vector4(s, q, q, s);
  Vector4 get sqqt => new Vector4(s, q, q, t);
  Vector4 get sqqp => new Vector4(s, q, q, p);
  Vector4 get sqqq => new Vector4(s, q, q, q);

  // Vector4 stpq swizzles: t first
  Vector4 get tsss => new Vector4(t, s, s, s);
  Vector4 get tsst => new Vector4(t, s, s, t);
  Vector4 get tssp => new Vector4(t, s, s, p);
  Vector4 get tssq => new Vector4(t, s, s, q);
  Vector4 get tsts => new Vector4(t, s, t, s);
  Vector4 get tstt => new Vector4(t, s, t, t);
  Vector4 get tstp => new Vector4(t, s, t, p);
  Vector4 get tstq => new Vector4(t, s, t, q);
  Vector4 get tsps => new Vector4(t, s, p, s);
  Vector4 get tspt => new Vector4(t, s, p, t);
  Vector4 get tspp => new Vector4(t, s, p, p);
  Vector4 get tspq => new Vector4(t, s, p, q);
  Vector4 get tsqs => new Vector4(t, s, q, s);
  Vector4 get tsqt => new Vector4(t, s, q, t);
  Vector4 get tsqp => new Vector4(t, s, q, p);
  Vector4 get tsqq => new Vector4(t, s, q, q);
  Vector4 get ttss => new Vector4(t, t, s, s);
  Vector4 get ttst => new Vector4(t, t, s, t);
  Vector4 get ttsp => new Vector4(t, t, s, p);
  Vector4 get ttsq => new Vector4(t, t, s, q);
  Vector4 get ttts => new Vector4(t, t, t, s);
  Vector4 get tttt => new Vector4(t, t, t, t);
  Vector4 get tttp => new Vector4(t, t, t, p);
  Vector4 get tttq => new Vector4(t, t, t, q);
  Vector4 get ttps => new Vector4(t, t, p, s);
  Vector4 get ttpt => new Vector4(t, t, p, t);
  Vector4 get ttpp => new Vector4(t, t, p, p);
  Vector4 get ttpq => new Vector4(t, t, p, q);
  Vector4 get ttqs => new Vector4(t, t, q, s);
  Vector4 get ttqt => new Vector4(t, t, q, t);
  Vector4 get ttqp => new Vector4(t, t, q, p);
  Vector4 get ttqq => new Vector4(t, t, q, q);
  Vector4 get tpss => new Vector4(t, p, s, s);
  Vector4 get tpst => new Vector4(t, p, s, t);
  Vector4 get tpsp => new Vector4(t, p, s, p);
  Vector4 get tpsq => new Vector4(t, p, s, q);
  Vector4 get tpts => new Vector4(t, p, t, s);
  Vector4 get tptt => new Vector4(t, p, t, t);
  Vector4 get tptp => new Vector4(t, p, t, p);
  Vector4 get tptq => new Vector4(t, p, t, q);
  Vector4 get tpps => new Vector4(t, p, p, s);
  Vector4 get tppt => new Vector4(t, p, p, t);
  Vector4 get tppp => new Vector4(t, p, p, p);
  Vector4 get tppq => new Vector4(t, p, p, q);
  Vector4 get tpqs => new Vector4(t, p, q, s);
  Vector4 get tpqt => new Vector4(t, p, q, t);
  Vector4 get tpqp => new Vector4(t, p, q, p);
  Vector4 get tpqq => new Vector4(t, p, q, q);
  Vector4 get tqss => new Vector4(t, q, s, s);
  Vector4 get tqst => new Vector4(t, q, s, t);
  Vector4 get tqsp => new Vector4(t, q, s, p);
  Vector4 get tqsq => new Vector4(t, q, s, q);
  Vector4 get tqts => new Vector4(t, q, t, s);
  Vector4 get tqtt => new Vector4(t, q, t, t);
  Vector4 get tqtp => new Vector4(t, q, t, p);
  Vector4 get tqtq => new Vector4(t, q, t, q);
  Vector4 get tqps => new Vector4(t, q, p, s);
  Vector4 get tqpt => new Vector4(t, q, p, t);
  Vector4 get tqpp => new Vector4(t, q, p, p);
  Vector4 get tqpq => new Vector4(t, q, p, q);
  Vector4 get tqqs => new Vector4(t, q, q, s);
  Vector4 get tqqt => new Vector4(t, q, q, t);
  Vector4 get tqqp => new Vector4(t, q, q, p);
  Vector4 get tqqq => new Vector4(t, q, q, q);

  // Vector4 stpq swizzles: p first
  Vector4 get psss => new Vector4(p, s, s, s);
  Vector4 get psst => new Vector4(p, s, s, t);
  Vector4 get pssp => new Vector4(p, s, s, p);
  Vector4 get pssq => new Vector4(p, s, s, q);
  Vector4 get psts => new Vector4(p, s, t, s);
  Vector4 get pstt => new Vector4(p, s, t, t);
  Vector4 get pstp => new Vector4(p, s, t, p);
  Vector4 get pstq => new Vector4(p, s, t, q);
  Vector4 get psps => new Vector4(p, s, p, s);
  Vector4 get pspt => new Vector4(p, s, p, t);
  Vector4 get pspp => new Vector4(p, s, p, p);
  Vector4 get pspq => new Vector4(p, s, p, q);
  Vector4 get psqs => new Vector4(p, s, q, s);
  Vector4 get psqt => new Vector4(p, s, q, t);
  Vector4 get psqp => new Vector4(p, s, q, p);
  Vector4 get psqq => new Vector4(p, s, q, q);
  Vector4 get ptss => new Vector4(p, t, s, s);
  Vector4 get ptst => new Vector4(p, t, s, t);
  Vector4 get ptsp => new Vector4(p, t, s, p);
  Vector4 get ptsq => new Vector4(p, t, s, q);
  Vector4 get ptts => new Vector4(p, t, t, s);
  Vector4 get pttt => new Vector4(p, t, t, t);
  Vector4 get pttp => new Vector4(p, t, t, p);
  Vector4 get pttq => new Vector4(p, t, t, q);
  Vector4 get ptps => new Vector4(p, t, p, s);
  Vector4 get ptpt => new Vector4(p, t, p, t);
  Vector4 get ptpp => new Vector4(p, t, p, p);
  Vector4 get ptpq => new Vector4(p, t, p, q);
  Vector4 get ptqs => new Vector4(p, t, q, s);
  Vector4 get ptqt => new Vector4(p, t, q, t);
  Vector4 get ptqp => new Vector4(p, t, q, p);
  Vector4 get ptqq => new Vector4(p, t, q, q);
  Vector4 get ppss => new Vector4(p, p, s, s);
  Vector4 get ppst => new Vector4(p, p, s, t);
  Vector4 get ppsp => new Vector4(p, p, s, p);
  Vector4 get ppsq => new Vector4(p, p, s, q);
  Vector4 get ppts => new Vector4(p, p, t, s);
  Vector4 get pptt => new Vector4(p, p, t, t);
  Vector4 get pptp => new Vector4(p, p, t, p);
  Vector4 get pptq => new Vector4(p, p, t, q);
  Vector4 get ppps => new Vector4(p, p, p, s);
  Vector4 get pppt => new Vector4(p, p, p, t);
  Vector4 get pppp => new Vector4(p, p, p, p);
  Vector4 get pppq => new Vector4(p, p, p, q);
  Vector4 get ppqs => new Vector4(p, p, q, s);
  Vector4 get ppqt => new Vector4(p, p, q, t);
  Vector4 get ppqp => new Vector4(p, p, q, p);
  Vector4 get ppqq => new Vector4(p, p, q, q);
  Vector4 get pqss => new Vector4(p, q, s, s);
  Vector4 get pqst => new Vector4(p, q, s, t);
  Vector4 get pqsp => new Vector4(p, q, s, p);
  Vector4 get pqsq => new Vector4(p, q, s, q);
  Vector4 get pqts => new Vector4(p, q, t, s);
  Vector4 get pqtt => new Vector4(p, q, t, t);
  Vector4 get pqtp => new Vector4(p, q, t, p);
  Vector4 get pqtq => new Vector4(p, q, t, q);
  Vector4 get pqps => new Vector4(p, q, p, s);
  Vector4 get pqpt => new Vector4(p, q, p, t);
  Vector4 get pqpp => new Vector4(p, q, p, p);
  Vector4 get pqpq => new Vector4(p, q, p, q);
  Vector4 get pqqs => new Vector4(p, q, q, s);
  Vector4 get pqqt => new Vector4(p, q, q, t);
  Vector4 get pqqp => new Vector4(p, q, q, p);
  Vector4 get pqqq => new Vector4(p, q, q, q);

  // Vector4 stpq swizzles: q first
  Vector4 get qsss => new Vector4(q, s, s, s);
  Vector4 get qsst => new Vector4(q, s, s, t);
  Vector4 get qssp => new Vector4(q, s, s, p);
  Vector4 get qssq => new Vector4(q, s, s, q);
  Vector4 get qsts => new Vector4(q, s, t, s);
  Vector4 get qstt => new Vector4(q, s, t, t);
  Vector4 get qstp => new Vector4(q, s, t, p);
  Vector4 get qstq => new Vector4(q, s, t, q);
  Vector4 get qsps => new Vector4(q, s, p, s);
  Vector4 get qspt => new Vector4(q, s, p, t);
  Vector4 get qspp => new Vector4(q, s, p, p);
  Vector4 get qspq => new Vector4(q, s, p, q);
  Vector4 get qsqs => new Vector4(q, s, q, s);
  Vector4 get qsqt => new Vector4(q, s, q, t);
  Vector4 get qsqp => new Vector4(q, s, q, p);
  Vector4 get qsqq => new Vector4(q, s, q, q);
  Vector4 get qtss => new Vector4(q, t, s, s);
  Vector4 get qtst => new Vector4(q, t, s, t);
  Vector4 get qtsp => new Vector4(q, t, s, p);
  Vector4 get qtsq => new Vector4(q, t, s, q);
  Vector4 get qtts => new Vector4(q, t, t, s);
  Vector4 get qttt => new Vector4(q, t, t, t);
  Vector4 get qttp => new Vector4(q, t, t, p);
  Vector4 get qttq => new Vector4(q, t, t, q);
  Vector4 get qtps => new Vector4(q, t, p, s);
  Vector4 get qtpt => new Vector4(q, t, p, t);
  Vector4 get qtpp => new Vector4(q, t, p, p);
  Vector4 get qtpq => new Vector4(q, t, p, q);
  Vector4 get qtqs => new Vector4(q, t, q, s);
  Vector4 get qtqt => new Vector4(q, t, q, t);
  Vector4 get qtqp => new Vector4(q, t, q, p);
  Vector4 get qtqq => new Vector4(q, t, q, q);
  Vector4 get qpss => new Vector4(q, p, s, s);
  Vector4 get qpst => new Vector4(q, p, s, t);
  Vector4 get qpsp => new Vector4(q, p, s, p);
  Vector4 get qpsq => new Vector4(q, p, s, q);
  Vector4 get qpts => new Vector4(q, p, t, s);
  Vector4 get qptt => new Vector4(q, p, t, t);
  Vector4 get qptp => new Vector4(q, p, t, p);
  Vector4 get qptq => new Vector4(q, p, t, q);
  Vector4 get qpps => new Vector4(q, p, p, s);
  Vector4 get qppt => new Vector4(q, p, p, t);
  Vector4 get qppp => new Vector4(q, p, p, p);
  Vector4 get qppq => new Vector4(q, p, p, q);
  Vector4 get qpqs => new Vector4(q, p, q, s);
  Vector4 get qpqt => new Vector4(q, p, q, t);
  Vector4 get qpqp => new Vector4(q, p, q, p);
  Vector4 get qpqq => new Vector4(q, p, q, q);
  Vector4 get qqss => new Vector4(q, q, s, s);
  Vector4 get qqst => new Vector4(q, q, s, t);
  Vector4 get qqsp => new Vector4(q, q, s, p);
  Vector4 get qqsq => new Vector4(q, q, s, q);
  Vector4 get qqts => new Vector4(q, q, t, s);
  Vector4 get qqtt => new Vector4(q, q, t, t);
  Vector4 get qqtp => new Vector4(q, q, t, p);
  Vector4 get qqtq => new Vector4(q, q, t, q);
  Vector4 get qqps => new Vector4(q, q, p, s);
  Vector4 get qqpt => new Vector4(q, q, p, t);
  Vector4 get qqpp => new Vector4(q, q, p, p);
  Vector4 get qqpq => new Vector4(q, q, p, q);
  Vector4 get qqqs => new Vector4(q, q, q, s);
  Vector4 get qqqt => new Vector4(q, q, q, t);
  Vector4 get qqqp => new Vector4(q, q, q, p);
  Vector4 get qqqq => new Vector4(q, q, q, q);

  double get magnitude {
    if (_magnitude == null) {
      _squareSum ??= x * x + y * y + z * z + w * w;

      if ((_squareSum - 1).abs() < 0.0001) {
        _magnitude = 1.0;
      } else {
        _magnitude = sqrt(_squareSum);
      }
    }

    return _magnitude;
  }

  Vector4 get unitVector {
    if (_unitVector == null) {
      if (_unitVector == null) {
        if (_magnitude != null) {
          if (_magnitude == 1.0) {
            _unitVector = new Vector4(x, y, z, w);
          } else {
            _unitVector = new Vector4(
                x / _magnitude, y / _magnitude, z / _magnitude, w / _magnitude);
          }
        } else {
          _squareSum ??= x * x + y * y + z * z + w * w;

          if ((_squareSum - 1).abs() < 0.0001) {
            _unitVector = new Vector4(x, y, z, w);
          } else {
            _magnitude ??= sqrt(_squareSum);

            _unitVector = new Vector4(
                x / _magnitude, y / _magnitude, z / _magnitude, w / _magnitude);
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
      _squareSum ??= x * x + y * y + z * z + w * w;

      return (_squareSum - 1).abs() < 0.0001;
    }
  }

  Vector4 scalarProduct(num s) => new Vector4(x * s, y * s, z * s, w * s);

  Vector4 scalarDivision(num s) => new Vector4(x / s, y / s, z / s, w / s);

  Vector4 entrywiseSum(Matrix B) {
    if (B is Vector4) {
      return new Vector4(x + B.x, y + B.y, z + B.z, w + B.w);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector4(x + B.valueAt(0, 0), y + B.valueAt(1, 0),
          z + B.valueAt(2, 0), w + B.valueAt(3, 0));
    }
  }

  Vector4 entrywiseDifference(Matrix B) {
    if (B is Vector4) {
      return new Vector4(x - B.x, y - B.y, z - B.z, w - B.w);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector4(x - B.valueAt(0, 0), y - B.valueAt(1, 0),
          z - B.valueAt(2, 0), w - B.valueAt(3, 0));
    }
  }

  Vector4 entrywiseProduct(Matrix B) {
    if (B is Vector4) {
      return new Vector4(x * B.x, y * B.y, z * B.z, w * B.w);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector4(x * B.valueAt(0, 0), y * B.valueAt(1, 0),
          z * B.valueAt(2, 0), w * B.valueAt(3, 0));
    }
  }

  double dotProduct(Vector4 B) => x * B.x + y * B.y + z * B.z + w * B.w;

  Vector4 operator +(Matrix B) => entrywiseSum(B);

  Vector4 operator -(Matrix B) => entrywiseDifference(B);

  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 4);

    if (index == 0) {
      return x;
    } else if (index == 1) {
      return y;
    } else if (index == 2) {
      return z;
    } else {
      return w;
    }
  }

  String toString() {
    return 'Vector4($x, $y, $z, $w)';
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector4 &&
          other.x == x &&
          other.y == y &&
          other.z == z &&
          other.w == w;

  int get hashCode => hash4(x, y, z, w);
}

class _Vector4Zero implements Vector4 {
  const _Vector4Zero();

  double get x => 0.0;
  double get y => 0.0;
  double get z => 0.0;
  double get w => 0.0;

  // Vector2 xyzw swizzles: x first
  Vector2 get xx => const Vector2.zero();
  Vector2 get xy => const Vector2.zero();
  Vector2 get xz => const Vector2.zero();
  Vector2 get xw => const Vector2.zero();

  // Vector2 xyzw swizzles: y first
  Vector2 get yx => const Vector2.zero();
  Vector2 get yy => const Vector2.zero();
  Vector2 get yz => const Vector2.zero();
  Vector2 get yw => const Vector2.zero();

  // Vector2 xyzw swizzles: z first
  Vector2 get zx => const Vector2.zero();
  Vector2 get zy => const Vector2.zero();
  Vector2 get zz => const Vector2.zero();
  Vector2 get zw => const Vector2.zero();

  // Vector2 xyzw swizzles: w first
  Vector2 get wx => const Vector2.zero();
  Vector2 get wy => const Vector2.zero();
  Vector2 get wz => const Vector2.zero();
  Vector2 get ww => const Vector2.zero();

  // Vector3 xyzw swizzles: x first
  Vector3 get xxx => const Vector3.zero();
  Vector3 get xxy => const Vector3.zero();
  Vector3 get xxz => const Vector3.zero();
  Vector3 get xxw => const Vector3.zero();
  Vector3 get xyx => const Vector3.zero();
  Vector3 get xyy => const Vector3.zero();
  Vector3 get xyz => const Vector3.zero();
  Vector3 get xyw => const Vector3.zero();
  Vector3 get xzx => const Vector3.zero();
  Vector3 get xzy => const Vector3.zero();
  Vector3 get xzz => const Vector3.zero();
  Vector3 get xzw => const Vector3.zero();
  Vector3 get xwx => const Vector3.zero();
  Vector3 get xwy => const Vector3.zero();
  Vector3 get xwz => const Vector3.zero();
  Vector3 get xww => const Vector3.zero();

  // Vector3 xyzw swizzles: y first
  Vector3 get yxx => const Vector3.zero();
  Vector3 get yxy => const Vector3.zero();
  Vector3 get yxz => const Vector3.zero();
  Vector3 get yxw => const Vector3.zero();
  Vector3 get yyx => const Vector3.zero();
  Vector3 get yyy => const Vector3.zero();
  Vector3 get yyz => const Vector3.zero();
  Vector3 get yyw => const Vector3.zero();
  Vector3 get yzx => const Vector3.zero();
  Vector3 get yzy => const Vector3.zero();
  Vector3 get yzz => const Vector3.zero();
  Vector3 get yzw => const Vector3.zero();
  Vector3 get ywx => const Vector3.zero();
  Vector3 get ywy => const Vector3.zero();
  Vector3 get ywz => const Vector3.zero();
  Vector3 get yww => const Vector3.zero();

  // Vector3 xyzw swizzles: z first
  Vector3 get zxx => const Vector3.zero();
  Vector3 get zxy => const Vector3.zero();
  Vector3 get zxz => const Vector3.zero();
  Vector3 get zxw => const Vector3.zero();
  Vector3 get zyx => const Vector3.zero();
  Vector3 get zyy => const Vector3.zero();
  Vector3 get zyz => const Vector3.zero();
  Vector3 get zyw => const Vector3.zero();
  Vector3 get zzx => const Vector3.zero();
  Vector3 get zzy => const Vector3.zero();
  Vector3 get zzz => const Vector3.zero();
  Vector3 get zzw => const Vector3.zero();
  Vector3 get zwx => const Vector3.zero();
  Vector3 get zwy => const Vector3.zero();
  Vector3 get zwz => const Vector3.zero();
  Vector3 get zww => const Vector3.zero();

  // Vector3 xyzw swizzles: w first
  Vector3 get wxx => const Vector3.zero();
  Vector3 get wxy => const Vector3.zero();
  Vector3 get wxz => const Vector3.zero();
  Vector3 get wxw => const Vector3.zero();
  Vector3 get wyx => const Vector3.zero();
  Vector3 get wyy => const Vector3.zero();
  Vector3 get wyz => const Vector3.zero();
  Vector3 get wyw => const Vector3.zero();
  Vector3 get wzx => const Vector3.zero();
  Vector3 get wzy => const Vector3.zero();
  Vector3 get wzz => const Vector3.zero();
  Vector3 get wzw => const Vector3.zero();
  Vector3 get wwx => const Vector3.zero();
  Vector3 get wwy => const Vector3.zero();
  Vector3 get wwz => const Vector3.zero();
  Vector3 get www => const Vector3.zero();

  // Vector4 xyzw swizzles: x first
  Vector4 get xxxx => const Vector4.zero();
  Vector4 get xxxy => const Vector4.zero();
  Vector4 get xxxz => const Vector4.zero();
  Vector4 get xxxw => const Vector4.zero();
  Vector4 get xxyx => const Vector4.zero();
  Vector4 get xxyy => const Vector4.zero();
  Vector4 get xxyz => const Vector4.zero();
  Vector4 get xxyw => const Vector4.zero();
  Vector4 get xxzx => const Vector4.zero();
  Vector4 get xxzy => const Vector4.zero();
  Vector4 get xxzz => const Vector4.zero();
  Vector4 get xxzw => const Vector4.zero();
  Vector4 get xxwx => const Vector4.zero();
  Vector4 get xxwy => const Vector4.zero();
  Vector4 get xxwz => const Vector4.zero();
  Vector4 get xxww => const Vector4.zero();
  Vector4 get xyxx => const Vector4.zero();
  Vector4 get xyxy => const Vector4.zero();
  Vector4 get xyxz => const Vector4.zero();
  Vector4 get xyxw => const Vector4.zero();
  Vector4 get xyyx => const Vector4.zero();
  Vector4 get xyyy => const Vector4.zero();
  Vector4 get xyyz => const Vector4.zero();
  Vector4 get xyyw => const Vector4.zero();
  Vector4 get xyzx => const Vector4.zero();
  Vector4 get xyzy => const Vector4.zero();
  Vector4 get xyzz => const Vector4.zero();
  Vector4 get xyzw => const Vector4.zero();
  Vector4 get xywx => const Vector4.zero();
  Vector4 get xywy => const Vector4.zero();
  Vector4 get xywz => const Vector4.zero();
  Vector4 get xyww => const Vector4.zero();
  Vector4 get xzxx => const Vector4.zero();
  Vector4 get xzxy => const Vector4.zero();
  Vector4 get xzxz => const Vector4.zero();
  Vector4 get xzxw => const Vector4.zero();
  Vector4 get xzyx => const Vector4.zero();
  Vector4 get xzyy => const Vector4.zero();
  Vector4 get xzyz => const Vector4.zero();
  Vector4 get xzyw => const Vector4.zero();
  Vector4 get xzzx => const Vector4.zero();
  Vector4 get xzzy => const Vector4.zero();
  Vector4 get xzzz => const Vector4.zero();
  Vector4 get xzzw => const Vector4.zero();
  Vector4 get xzwx => const Vector4.zero();
  Vector4 get xzwy => const Vector4.zero();
  Vector4 get xzwz => const Vector4.zero();
  Vector4 get xzww => const Vector4.zero();
  Vector4 get xwxx => const Vector4.zero();
  Vector4 get xwxy => const Vector4.zero();
  Vector4 get xwxz => const Vector4.zero();
  Vector4 get xwxw => const Vector4.zero();
  Vector4 get xwyx => const Vector4.zero();
  Vector4 get xwyy => const Vector4.zero();
  Vector4 get xwyz => const Vector4.zero();
  Vector4 get xwyw => const Vector4.zero();
  Vector4 get xwzx => const Vector4.zero();
  Vector4 get xwzy => const Vector4.zero();
  Vector4 get xwzz => const Vector4.zero();
  Vector4 get xwzw => const Vector4.zero();
  Vector4 get xwwx => const Vector4.zero();
  Vector4 get xwwy => const Vector4.zero();
  Vector4 get xwwz => const Vector4.zero();
  Vector4 get xwww => const Vector4.zero();

  // Vector4 xyzw swizzles: y first
  Vector4 get yxxx => const Vector4.zero();
  Vector4 get yxxy => const Vector4.zero();
  Vector4 get yxxz => const Vector4.zero();
  Vector4 get yxxw => const Vector4.zero();
  Vector4 get yxyx => const Vector4.zero();
  Vector4 get yxyy => const Vector4.zero();
  Vector4 get yxyz => const Vector4.zero();
  Vector4 get yxyw => const Vector4.zero();
  Vector4 get yxzx => const Vector4.zero();
  Vector4 get yxzy => const Vector4.zero();
  Vector4 get yxzz => const Vector4.zero();
  Vector4 get yxzw => const Vector4.zero();
  Vector4 get yxwx => const Vector4.zero();
  Vector4 get yxwy => const Vector4.zero();
  Vector4 get yxwz => const Vector4.zero();
  Vector4 get yxww => const Vector4.zero();
  Vector4 get yyxx => const Vector4.zero();
  Vector4 get yyxy => const Vector4.zero();
  Vector4 get yyxz => const Vector4.zero();
  Vector4 get yyxw => const Vector4.zero();
  Vector4 get yyyx => const Vector4.zero();
  Vector4 get yyyy => const Vector4.zero();
  Vector4 get yyyz => const Vector4.zero();
  Vector4 get yyyw => const Vector4.zero();
  Vector4 get yyzx => const Vector4.zero();
  Vector4 get yyzy => const Vector4.zero();
  Vector4 get yyzz => const Vector4.zero();
  Vector4 get yyzw => const Vector4.zero();
  Vector4 get yywx => const Vector4.zero();
  Vector4 get yywy => const Vector4.zero();
  Vector4 get yywz => const Vector4.zero();
  Vector4 get yyww => const Vector4.zero();
  Vector4 get yzxx => const Vector4.zero();
  Vector4 get yzxy => const Vector4.zero();
  Vector4 get yzxz => const Vector4.zero();
  Vector4 get yzxw => const Vector4.zero();
  Vector4 get yzyx => const Vector4.zero();
  Vector4 get yzyy => const Vector4.zero();
  Vector4 get yzyz => const Vector4.zero();
  Vector4 get yzyw => const Vector4.zero();
  Vector4 get yzzx => const Vector4.zero();
  Vector4 get yzzy => const Vector4.zero();
  Vector4 get yzzz => const Vector4.zero();
  Vector4 get yzzw => const Vector4.zero();
  Vector4 get yzwx => const Vector4.zero();
  Vector4 get yzwy => const Vector4.zero();
  Vector4 get yzwz => const Vector4.zero();
  Vector4 get yzww => const Vector4.zero();
  Vector4 get ywxx => const Vector4.zero();
  Vector4 get ywxy => const Vector4.zero();
  Vector4 get ywxz => const Vector4.zero();
  Vector4 get ywxw => const Vector4.zero();
  Vector4 get ywyx => const Vector4.zero();
  Vector4 get ywyy => const Vector4.zero();
  Vector4 get ywyz => const Vector4.zero();
  Vector4 get ywyw => const Vector4.zero();
  Vector4 get ywzx => const Vector4.zero();
  Vector4 get ywzy => const Vector4.zero();
  Vector4 get ywzz => const Vector4.zero();
  Vector4 get ywzw => const Vector4.zero();
  Vector4 get ywwx => const Vector4.zero();
  Vector4 get ywwy => const Vector4.zero();
  Vector4 get ywwz => const Vector4.zero();
  Vector4 get ywww => const Vector4.zero();

  // Vector4 xyzw swizzles: z first
  Vector4 get zxxx => const Vector4.zero();
  Vector4 get zxxy => const Vector4.zero();
  Vector4 get zxxz => const Vector4.zero();
  Vector4 get zxxw => const Vector4.zero();
  Vector4 get zxyx => const Vector4.zero();
  Vector4 get zxyy => const Vector4.zero();
  Vector4 get zxyz => const Vector4.zero();
  Vector4 get zxyw => const Vector4.zero();
  Vector4 get zxzx => const Vector4.zero();
  Vector4 get zxzy => const Vector4.zero();
  Vector4 get zxzz => const Vector4.zero();
  Vector4 get zxzw => const Vector4.zero();
  Vector4 get zxwx => const Vector4.zero();
  Vector4 get zxwy => const Vector4.zero();
  Vector4 get zxwz => const Vector4.zero();
  Vector4 get zxww => const Vector4.zero();
  Vector4 get zyxx => const Vector4.zero();
  Vector4 get zyxy => const Vector4.zero();
  Vector4 get zyxz => const Vector4.zero();
  Vector4 get zyxw => const Vector4.zero();
  Vector4 get zyyx => const Vector4.zero();
  Vector4 get zyyy => const Vector4.zero();
  Vector4 get zyyz => const Vector4.zero();
  Vector4 get zyyw => const Vector4.zero();
  Vector4 get zyzx => const Vector4.zero();
  Vector4 get zyzy => const Vector4.zero();
  Vector4 get zyzz => const Vector4.zero();
  Vector4 get zyzw => const Vector4.zero();
  Vector4 get zywx => const Vector4.zero();
  Vector4 get zywy => const Vector4.zero();
  Vector4 get zywz => const Vector4.zero();
  Vector4 get zyww => const Vector4.zero();
  Vector4 get zzxx => const Vector4.zero();
  Vector4 get zzxy => const Vector4.zero();
  Vector4 get zzxz => const Vector4.zero();
  Vector4 get zzxw => const Vector4.zero();
  Vector4 get zzyx => const Vector4.zero();
  Vector4 get zzyy => const Vector4.zero();
  Vector4 get zzyz => const Vector4.zero();
  Vector4 get zzyw => const Vector4.zero();
  Vector4 get zzzx => const Vector4.zero();
  Vector4 get zzzy => const Vector4.zero();
  Vector4 get zzzz => const Vector4.zero();
  Vector4 get zzzw => const Vector4.zero();
  Vector4 get zzwx => const Vector4.zero();
  Vector4 get zzwy => const Vector4.zero();
  Vector4 get zzwz => const Vector4.zero();
  Vector4 get zzww => const Vector4.zero();
  Vector4 get zwxx => const Vector4.zero();
  Vector4 get zwxy => const Vector4.zero();
  Vector4 get zwxz => const Vector4.zero();
  Vector4 get zwxw => const Vector4.zero();
  Vector4 get zwyx => const Vector4.zero();
  Vector4 get zwyy => const Vector4.zero();
  Vector4 get zwyz => const Vector4.zero();
  Vector4 get zwyw => const Vector4.zero();
  Vector4 get zwzx => const Vector4.zero();
  Vector4 get zwzy => const Vector4.zero();
  Vector4 get zwzz => const Vector4.zero();
  Vector4 get zwzw => const Vector4.zero();
  Vector4 get zwwx => const Vector4.zero();
  Vector4 get zwwy => const Vector4.zero();
  Vector4 get zwwz => const Vector4.zero();
  Vector4 get zwww => const Vector4.zero();

  // Vector4 xyzw swizzles: w first
  Vector4 get wxxx => const Vector4.zero();
  Vector4 get wxxy => const Vector4.zero();
  Vector4 get wxxz => const Vector4.zero();
  Vector4 get wxxw => const Vector4.zero();
  Vector4 get wxyx => const Vector4.zero();
  Vector4 get wxyy => const Vector4.zero();
  Vector4 get wxyz => const Vector4.zero();
  Vector4 get wxyw => const Vector4.zero();
  Vector4 get wxzx => const Vector4.zero();
  Vector4 get wxzy => const Vector4.zero();
  Vector4 get wxzz => const Vector4.zero();
  Vector4 get wxzw => const Vector4.zero();
  Vector4 get wxwx => const Vector4.zero();
  Vector4 get wxwy => const Vector4.zero();
  Vector4 get wxwz => const Vector4.zero();
  Vector4 get wxww => const Vector4.zero();
  Vector4 get wyxx => const Vector4.zero();
  Vector4 get wyxy => const Vector4.zero();
  Vector4 get wyxz => const Vector4.zero();
  Vector4 get wyxw => const Vector4.zero();
  Vector4 get wyyx => const Vector4.zero();
  Vector4 get wyyy => const Vector4.zero();
  Vector4 get wyyz => const Vector4.zero();
  Vector4 get wyyw => const Vector4.zero();
  Vector4 get wyzx => const Vector4.zero();
  Vector4 get wyzy => const Vector4.zero();
  Vector4 get wyzz => const Vector4.zero();
  Vector4 get wyzw => const Vector4.zero();
  Vector4 get wywx => const Vector4.zero();
  Vector4 get wywy => const Vector4.zero();
  Vector4 get wywz => const Vector4.zero();
  Vector4 get wyww => const Vector4.zero();
  Vector4 get wzxx => const Vector4.zero();
  Vector4 get wzxy => const Vector4.zero();
  Vector4 get wzxz => const Vector4.zero();
  Vector4 get wzxw => const Vector4.zero();
  Vector4 get wzyx => const Vector4.zero();
  Vector4 get wzyy => const Vector4.zero();
  Vector4 get wzyz => const Vector4.zero();
  Vector4 get wzyw => const Vector4.zero();
  Vector4 get wzzx => const Vector4.zero();
  Vector4 get wzzy => const Vector4.zero();
  Vector4 get wzzz => const Vector4.zero();
  Vector4 get wzzw => const Vector4.zero();
  Vector4 get wzwx => const Vector4.zero();
  Vector4 get wzwy => const Vector4.zero();
  Vector4 get wzwz => const Vector4.zero();
  Vector4 get wzww => const Vector4.zero();
  Vector4 get wwxx => const Vector4.zero();
  Vector4 get wwxy => const Vector4.zero();
  Vector4 get wwxz => const Vector4.zero();
  Vector4 get wwxw => const Vector4.zero();
  Vector4 get wwyx => const Vector4.zero();
  Vector4 get wwyy => const Vector4.zero();
  Vector4 get wwyz => const Vector4.zero();
  Vector4 get wwyw => const Vector4.zero();
  Vector4 get wwzx => const Vector4.zero();
  Vector4 get wwzy => const Vector4.zero();
  Vector4 get wwzz => const Vector4.zero();
  Vector4 get wwzw => const Vector4.zero();
  Vector4 get wwwx => const Vector4.zero();
  Vector4 get wwwy => const Vector4.zero();
  Vector4 get wwwz => const Vector4.zero();
  Vector4 get wwww => const Vector4.zero();

  double get r => 0.0;
  double get g => 0.0;
  double get b => 0.0;
  double get a => 0.0;

  // Vector2 rgba swizzles: r first
  Vector2 get rr => const Vector2.zero();
  Vector2 get rg => const Vector2.zero();
  Vector2 get rb => const Vector2.zero();
  Vector2 get ra => const Vector2.zero();

  // Vector2 rgba swizzles: g first
  Vector2 get gr => const Vector2.zero();
  Vector2 get gg => const Vector2.zero();
  Vector2 get gb => const Vector2.zero();
  Vector2 get ga => const Vector2.zero();

  // Vector2 rgba swizzles: b first
  Vector2 get br => const Vector2.zero();
  Vector2 get bg => const Vector2.zero();
  Vector2 get bb => const Vector2.zero();
  Vector2 get ba => const Vector2.zero();

  // Vector2 rgba swizzles: a first
  Vector2 get ar => const Vector2.zero();
  Vector2 get ag => const Vector2.zero();
  Vector2 get ab => const Vector2.zero();
  Vector2 get aa => const Vector2.zero();

  // Vector3 rgba swizzles: r first
  Vector3 get rrr => const Vector3.zero();
  Vector3 get rrg => const Vector3.zero();
  Vector3 get rrb => const Vector3.zero();
  Vector3 get rra => const Vector3.zero();
  Vector3 get rgr => const Vector3.zero();
  Vector3 get rgg => const Vector3.zero();
  Vector3 get rgb => const Vector3.zero();
  Vector3 get rga => const Vector3.zero();
  Vector3 get rbr => const Vector3.zero();
  Vector3 get rbg => const Vector3.zero();
  Vector3 get rbb => const Vector3.zero();
  Vector3 get rba => const Vector3.zero();
  Vector3 get rar => const Vector3.zero();
  Vector3 get rag => const Vector3.zero();
  Vector3 get rab => const Vector3.zero();
  Vector3 get raa => const Vector3.zero();

  // Vector3 rgba swizzles: g first
  Vector3 get grr => const Vector3.zero();
  Vector3 get grg => const Vector3.zero();
  Vector3 get grb => const Vector3.zero();
  Vector3 get gra => const Vector3.zero();
  Vector3 get ggr => const Vector3.zero();
  Vector3 get ggg => const Vector3.zero();
  Vector3 get ggb => const Vector3.zero();
  Vector3 get gga => const Vector3.zero();
  Vector3 get gbr => const Vector3.zero();
  Vector3 get gbg => const Vector3.zero();
  Vector3 get gbb => const Vector3.zero();
  Vector3 get gba => const Vector3.zero();
  Vector3 get gar => const Vector3.zero();
  Vector3 get gag => const Vector3.zero();
  Vector3 get gab => const Vector3.zero();
  Vector3 get gaa => const Vector3.zero();

  // Vector3 rgba swizzles: b first
  Vector3 get brr => const Vector3.zero();
  Vector3 get brg => const Vector3.zero();
  Vector3 get brb => const Vector3.zero();
  Vector3 get bra => const Vector3.zero();
  Vector3 get bgr => const Vector3.zero();
  Vector3 get bgg => const Vector3.zero();
  Vector3 get bgb => const Vector3.zero();
  Vector3 get bga => const Vector3.zero();
  Vector3 get bbr => const Vector3.zero();
  Vector3 get bbg => const Vector3.zero();
  Vector3 get bbb => const Vector3.zero();
  Vector3 get bba => const Vector3.zero();
  Vector3 get bar => const Vector3.zero();
  Vector3 get bag => const Vector3.zero();
  Vector3 get bab => const Vector3.zero();
  Vector3 get baa => const Vector3.zero();

  // Vector3 rgba swizzles: a first
  Vector3 get arr => const Vector3.zero();
  Vector3 get arg => const Vector3.zero();
  Vector3 get arb => const Vector3.zero();
  Vector3 get ara => const Vector3.zero();
  Vector3 get agr => const Vector3.zero();
  Vector3 get agg => const Vector3.zero();
  Vector3 get agb => const Vector3.zero();
  Vector3 get aga => const Vector3.zero();
  Vector3 get abr => const Vector3.zero();
  Vector3 get abg => const Vector3.zero();
  Vector3 get abb => const Vector3.zero();
  Vector3 get aba => const Vector3.zero();
  Vector3 get aar => const Vector3.zero();
  Vector3 get aag => const Vector3.zero();
  Vector3 get aab => const Vector3.zero();
  Vector3 get aaa => const Vector3.zero();

  // Vector4 rgba swizzles: r first
  Vector4 get rrrr => const Vector4.zero();
  Vector4 get rrrg => const Vector4.zero();
  Vector4 get rrrb => const Vector4.zero();
  Vector4 get rrra => const Vector4.zero();
  Vector4 get rrgr => const Vector4.zero();
  Vector4 get rrgg => const Vector4.zero();
  Vector4 get rrgb => const Vector4.zero();
  Vector4 get rrga => const Vector4.zero();
  Vector4 get rrbr => const Vector4.zero();
  Vector4 get rrbg => const Vector4.zero();
  Vector4 get rrbb => const Vector4.zero();
  Vector4 get rrba => const Vector4.zero();
  Vector4 get rrar => const Vector4.zero();
  Vector4 get rrag => const Vector4.zero();
  Vector4 get rrab => const Vector4.zero();
  Vector4 get rraa => const Vector4.zero();
  Vector4 get rgrr => const Vector4.zero();
  Vector4 get rgrg => const Vector4.zero();
  Vector4 get rgrb => const Vector4.zero();
  Vector4 get rgra => const Vector4.zero();
  Vector4 get rggr => const Vector4.zero();
  Vector4 get rggg => const Vector4.zero();
  Vector4 get rggb => const Vector4.zero();
  Vector4 get rgga => const Vector4.zero();
  Vector4 get rgbr => const Vector4.zero();
  Vector4 get rgbg => const Vector4.zero();
  Vector4 get rgbb => const Vector4.zero();
  Vector4 get rgba => const Vector4.zero();
  Vector4 get rgar => const Vector4.zero();
  Vector4 get rgag => const Vector4.zero();
  Vector4 get rgab => const Vector4.zero();
  Vector4 get rgaa => const Vector4.zero();
  Vector4 get rbrr => const Vector4.zero();
  Vector4 get rbrg => const Vector4.zero();
  Vector4 get rbrb => const Vector4.zero();
  Vector4 get rbra => const Vector4.zero();
  Vector4 get rbgr => const Vector4.zero();
  Vector4 get rbgg => const Vector4.zero();
  Vector4 get rbgb => const Vector4.zero();
  Vector4 get rbga => const Vector4.zero();
  Vector4 get rbbr => const Vector4.zero();
  Vector4 get rbbg => const Vector4.zero();
  Vector4 get rbbb => const Vector4.zero();
  Vector4 get rbba => const Vector4.zero();
  Vector4 get rbar => const Vector4.zero();
  Vector4 get rbag => const Vector4.zero();
  Vector4 get rbab => const Vector4.zero();
  Vector4 get rbaa => const Vector4.zero();
  Vector4 get rarr => const Vector4.zero();
  Vector4 get rarg => const Vector4.zero();
  Vector4 get rarb => const Vector4.zero();
  Vector4 get rara => const Vector4.zero();
  Vector4 get ragr => const Vector4.zero();
  Vector4 get ragg => const Vector4.zero();
  Vector4 get ragb => const Vector4.zero();
  Vector4 get raga => const Vector4.zero();
  Vector4 get rabr => const Vector4.zero();
  Vector4 get rabg => const Vector4.zero();
  Vector4 get rabb => const Vector4.zero();
  Vector4 get raba => const Vector4.zero();
  Vector4 get raar => const Vector4.zero();
  Vector4 get raag => const Vector4.zero();
  Vector4 get raab => const Vector4.zero();
  Vector4 get raaa => const Vector4.zero();

  // Vector4 rgba swizzles: g first
  Vector4 get grrr => const Vector4.zero();
  Vector4 get grrg => const Vector4.zero();
  Vector4 get grrb => const Vector4.zero();
  Vector4 get grra => const Vector4.zero();
  Vector4 get grgr => const Vector4.zero();
  Vector4 get grgg => const Vector4.zero();
  Vector4 get grgb => const Vector4.zero();
  Vector4 get grga => const Vector4.zero();
  Vector4 get grbr => const Vector4.zero();
  Vector4 get grbg => const Vector4.zero();
  Vector4 get grbb => const Vector4.zero();
  Vector4 get grba => const Vector4.zero();
  Vector4 get grar => const Vector4.zero();
  Vector4 get grag => const Vector4.zero();
  Vector4 get grab => const Vector4.zero();
  Vector4 get graa => const Vector4.zero();
  Vector4 get ggrr => const Vector4.zero();
  Vector4 get ggrg => const Vector4.zero();
  Vector4 get ggrb => const Vector4.zero();
  Vector4 get ggra => const Vector4.zero();
  Vector4 get gggr => const Vector4.zero();
  Vector4 get gggg => const Vector4.zero();
  Vector4 get gggb => const Vector4.zero();
  Vector4 get ggga => const Vector4.zero();
  Vector4 get ggbr => const Vector4.zero();
  Vector4 get ggbg => const Vector4.zero();
  Vector4 get ggbb => const Vector4.zero();
  Vector4 get ggba => const Vector4.zero();
  Vector4 get ggar => const Vector4.zero();
  Vector4 get ggag => const Vector4.zero();
  Vector4 get ggab => const Vector4.zero();
  Vector4 get ggaa => const Vector4.zero();
  Vector4 get gbrr => const Vector4.zero();
  Vector4 get gbrg => const Vector4.zero();
  Vector4 get gbrb => const Vector4.zero();
  Vector4 get gbra => const Vector4.zero();
  Vector4 get gbgr => const Vector4.zero();
  Vector4 get gbgg => const Vector4.zero();
  Vector4 get gbgb => const Vector4.zero();
  Vector4 get gbga => const Vector4.zero();
  Vector4 get gbbr => const Vector4.zero();
  Vector4 get gbbg => const Vector4.zero();
  Vector4 get gbbb => const Vector4.zero();
  Vector4 get gbba => const Vector4.zero();
  Vector4 get gbar => const Vector4.zero();
  Vector4 get gbag => const Vector4.zero();
  Vector4 get gbab => const Vector4.zero();
  Vector4 get gbaa => const Vector4.zero();
  Vector4 get garr => const Vector4.zero();
  Vector4 get garg => const Vector4.zero();
  Vector4 get garb => const Vector4.zero();
  Vector4 get gara => const Vector4.zero();
  Vector4 get gagr => const Vector4.zero();
  Vector4 get gagg => const Vector4.zero();
  Vector4 get gagb => const Vector4.zero();
  Vector4 get gaga => const Vector4.zero();
  Vector4 get gabr => const Vector4.zero();
  Vector4 get gabg => const Vector4.zero();
  Vector4 get gabb => const Vector4.zero();
  Vector4 get gaba => const Vector4.zero();
  Vector4 get gaar => const Vector4.zero();
  Vector4 get gaag => const Vector4.zero();
  Vector4 get gaab => const Vector4.zero();
  Vector4 get gaaa => const Vector4.zero();

  // Vector4 rgba swizzles: b first
  Vector4 get brrr => const Vector4.zero();
  Vector4 get brrg => const Vector4.zero();
  Vector4 get brrb => const Vector4.zero();
  Vector4 get brra => const Vector4.zero();
  Vector4 get brgr => const Vector4.zero();
  Vector4 get brgg => const Vector4.zero();
  Vector4 get brgb => const Vector4.zero();
  Vector4 get brga => const Vector4.zero();
  Vector4 get brbr => const Vector4.zero();
  Vector4 get brbg => const Vector4.zero();
  Vector4 get brbb => const Vector4.zero();
  Vector4 get brba => const Vector4.zero();
  Vector4 get brar => const Vector4.zero();
  Vector4 get brag => const Vector4.zero();
  Vector4 get brab => const Vector4.zero();
  Vector4 get braa => const Vector4.zero();
  Vector4 get bgrr => const Vector4.zero();
  Vector4 get bgrg => const Vector4.zero();
  Vector4 get bgrb => const Vector4.zero();
  Vector4 get bgra => const Vector4.zero();
  Vector4 get bggr => const Vector4.zero();
  Vector4 get bggg => const Vector4.zero();
  Vector4 get bggb => const Vector4.zero();
  Vector4 get bgga => const Vector4.zero();
  Vector4 get bgbr => const Vector4.zero();
  Vector4 get bgbg => const Vector4.zero();
  Vector4 get bgbb => const Vector4.zero();
  Vector4 get bgba => const Vector4.zero();
  Vector4 get bgar => const Vector4.zero();
  Vector4 get bgag => const Vector4.zero();
  Vector4 get bgab => const Vector4.zero();
  Vector4 get bgaa => const Vector4.zero();
  Vector4 get bbrr => const Vector4.zero();
  Vector4 get bbrg => const Vector4.zero();
  Vector4 get bbrb => const Vector4.zero();
  Vector4 get bbra => const Vector4.zero();
  Vector4 get bbgr => const Vector4.zero();
  Vector4 get bbgg => const Vector4.zero();
  Vector4 get bbgb => const Vector4.zero();
  Vector4 get bbga => const Vector4.zero();
  Vector4 get bbbr => const Vector4.zero();
  Vector4 get bbbg => const Vector4.zero();
  Vector4 get bbbb => const Vector4.zero();
  Vector4 get bbba => const Vector4.zero();
  Vector4 get bbar => const Vector4.zero();
  Vector4 get bbag => const Vector4.zero();
  Vector4 get bbab => const Vector4.zero();
  Vector4 get bbaa => const Vector4.zero();
  Vector4 get barr => const Vector4.zero();
  Vector4 get barg => const Vector4.zero();
  Vector4 get barb => const Vector4.zero();
  Vector4 get bara => const Vector4.zero();
  Vector4 get bagr => const Vector4.zero();
  Vector4 get bagg => const Vector4.zero();
  Vector4 get bagb => const Vector4.zero();
  Vector4 get baga => const Vector4.zero();
  Vector4 get babr => const Vector4.zero();
  Vector4 get babg => const Vector4.zero();
  Vector4 get babb => const Vector4.zero();
  Vector4 get baba => const Vector4.zero();
  Vector4 get baar => const Vector4.zero();
  Vector4 get baag => const Vector4.zero();
  Vector4 get baab => const Vector4.zero();
  Vector4 get baaa => const Vector4.zero();

  // Vector4 rgba swizzles: a first
  Vector4 get arrr => const Vector4.zero();
  Vector4 get arrg => const Vector4.zero();
  Vector4 get arrb => const Vector4.zero();
  Vector4 get arra => const Vector4.zero();
  Vector4 get argr => const Vector4.zero();
  Vector4 get argg => const Vector4.zero();
  Vector4 get argb => const Vector4.zero();
  Vector4 get arga => const Vector4.zero();
  Vector4 get arbr => const Vector4.zero();
  Vector4 get arbg => const Vector4.zero();
  Vector4 get arbb => const Vector4.zero();
  Vector4 get arba => const Vector4.zero();
  Vector4 get arar => const Vector4.zero();
  Vector4 get arag => const Vector4.zero();
  Vector4 get arab => const Vector4.zero();
  Vector4 get araa => const Vector4.zero();
  Vector4 get agrr => const Vector4.zero();
  Vector4 get agrg => const Vector4.zero();
  Vector4 get agrb => const Vector4.zero();
  Vector4 get agra => const Vector4.zero();
  Vector4 get aggr => const Vector4.zero();
  Vector4 get aggg => const Vector4.zero();
  Vector4 get aggb => const Vector4.zero();
  Vector4 get agga => const Vector4.zero();
  Vector4 get agbr => const Vector4.zero();
  Vector4 get agbg => const Vector4.zero();
  Vector4 get agbb => const Vector4.zero();
  Vector4 get agba => const Vector4.zero();
  Vector4 get agar => const Vector4.zero();
  Vector4 get agag => const Vector4.zero();
  Vector4 get agab => const Vector4.zero();
  Vector4 get agaa => const Vector4.zero();
  Vector4 get abrr => const Vector4.zero();
  Vector4 get abrg => const Vector4.zero();
  Vector4 get abrb => const Vector4.zero();
  Vector4 get abra => const Vector4.zero();
  Vector4 get abgr => const Vector4.zero();
  Vector4 get abgg => const Vector4.zero();
  Vector4 get abgb => const Vector4.zero();
  Vector4 get abga => const Vector4.zero();
  Vector4 get abbr => const Vector4.zero();
  Vector4 get abbg => const Vector4.zero();
  Vector4 get abbb => const Vector4.zero();
  Vector4 get abba => const Vector4.zero();
  Vector4 get abar => const Vector4.zero();
  Vector4 get abag => const Vector4.zero();
  Vector4 get abab => const Vector4.zero();
  Vector4 get abaa => const Vector4.zero();
  Vector4 get aarr => const Vector4.zero();
  Vector4 get aarg => const Vector4.zero();
  Vector4 get aarb => const Vector4.zero();
  Vector4 get aara => const Vector4.zero();
  Vector4 get aagr => const Vector4.zero();
  Vector4 get aagg => const Vector4.zero();
  Vector4 get aagb => const Vector4.zero();
  Vector4 get aaga => const Vector4.zero();
  Vector4 get aabr => const Vector4.zero();
  Vector4 get aabg => const Vector4.zero();
  Vector4 get aabb => const Vector4.zero();
  Vector4 get aaba => const Vector4.zero();
  Vector4 get aaar => const Vector4.zero();
  Vector4 get aaag => const Vector4.zero();
  Vector4 get aaab => const Vector4.zero();
  Vector4 get aaaa => const Vector4.zero();

  double get s => 0.0;
  double get t => 0.0;
  double get p => 0.0;
  double get q => 0.0;

  // Vector2 stpq swizzles: s first
  Vector2 get ss => const Vector2.zero();
  Vector2 get st => const Vector2.zero();
  Vector2 get sp => const Vector2.zero();
  Vector2 get sq => const Vector2.zero();

  // Vector2 stpq swizzles: t first
  Vector2 get ts => const Vector2.zero();
  Vector2 get tt => const Vector2.zero();
  Vector2 get tp => const Vector2.zero();
  Vector2 get tq => const Vector2.zero();

  // Vector2 stpq swizzles: p first
  Vector2 get ps => const Vector2.zero();
  Vector2 get pt => const Vector2.zero();
  Vector2 get pp => const Vector2.zero();
  Vector2 get pq => const Vector2.zero();

  // Vector2 stpq swizzles: q first
  Vector2 get qs => const Vector2.zero();
  Vector2 get qt => const Vector2.zero();
  Vector2 get qp => const Vector2.zero();
  Vector2 get qq => const Vector2.zero();

  // Vector3 stpq swizzles: s first
  Vector3 get sss => const Vector3.zero();
  Vector3 get sst => const Vector3.zero();
  Vector3 get ssp => const Vector3.zero();
  Vector3 get ssq => const Vector3.zero();
  Vector3 get sts => const Vector3.zero();
  Vector3 get stt => const Vector3.zero();
  Vector3 get stp => const Vector3.zero();
  Vector3 get stq => const Vector3.zero();
  Vector3 get sps => const Vector3.zero();
  Vector3 get spt => const Vector3.zero();
  Vector3 get spp => const Vector3.zero();
  Vector3 get spq => const Vector3.zero();
  Vector3 get sqs => const Vector3.zero();
  Vector3 get sqt => const Vector3.zero();
  Vector3 get sqp => const Vector3.zero();
  Vector3 get sqq => const Vector3.zero();

  // Vector3 stpq swizzles: t first
  Vector3 get tss => const Vector3.zero();
  Vector3 get tst => const Vector3.zero();
  Vector3 get tsp => const Vector3.zero();
  Vector3 get tsq => const Vector3.zero();
  Vector3 get tts => const Vector3.zero();
  Vector3 get ttt => const Vector3.zero();
  Vector3 get ttp => const Vector3.zero();
  Vector3 get ttq => const Vector3.zero();
  Vector3 get tps => const Vector3.zero();
  Vector3 get tpt => const Vector3.zero();
  Vector3 get tpp => const Vector3.zero();
  Vector3 get tpq => const Vector3.zero();
  Vector3 get tqs => const Vector3.zero();
  Vector3 get tqt => const Vector3.zero();
  Vector3 get tqp => const Vector3.zero();
  Vector3 get tqq => const Vector3.zero();

  // Vector3 stpq swizzles: p first
  Vector3 get pss => const Vector3.zero();
  Vector3 get pst => const Vector3.zero();
  Vector3 get psp => const Vector3.zero();
  Vector3 get psq => const Vector3.zero();
  Vector3 get pts => const Vector3.zero();
  Vector3 get ptt => const Vector3.zero();
  Vector3 get ptp => const Vector3.zero();
  Vector3 get ptq => const Vector3.zero();
  Vector3 get pps => const Vector3.zero();
  Vector3 get ppt => const Vector3.zero();
  Vector3 get ppp => const Vector3.zero();
  Vector3 get ppq => const Vector3.zero();
  Vector3 get pqs => const Vector3.zero();
  Vector3 get pqt => const Vector3.zero();
  Vector3 get pqp => const Vector3.zero();
  Vector3 get pqq => const Vector3.zero();

  // Vector3 stpq swizzles: q first
  Vector3 get qss => const Vector3.zero();
  Vector3 get qst => const Vector3.zero();
  Vector3 get qsp => const Vector3.zero();
  Vector3 get qsq => const Vector3.zero();
  Vector3 get qts => const Vector3.zero();
  Vector3 get qtt => const Vector3.zero();
  Vector3 get qtp => const Vector3.zero();
  Vector3 get qtq => const Vector3.zero();
  Vector3 get qps => const Vector3.zero();
  Vector3 get qpt => const Vector3.zero();
  Vector3 get qpp => const Vector3.zero();
  Vector3 get qpq => const Vector3.zero();
  Vector3 get qqs => const Vector3.zero();
  Vector3 get qqt => const Vector3.zero();
  Vector3 get qqp => const Vector3.zero();
  Vector3 get qqq => const Vector3.zero();

  // Vector4 stpq swizzles: s first
  Vector4 get ssss => const Vector4.zero();
  Vector4 get ssst => const Vector4.zero();
  Vector4 get sssp => const Vector4.zero();
  Vector4 get sssq => const Vector4.zero();
  Vector4 get ssts => const Vector4.zero();
  Vector4 get sstt => const Vector4.zero();
  Vector4 get sstp => const Vector4.zero();
  Vector4 get sstq => const Vector4.zero();
  Vector4 get ssps => const Vector4.zero();
  Vector4 get sspt => const Vector4.zero();
  Vector4 get sspp => const Vector4.zero();
  Vector4 get sspq => const Vector4.zero();
  Vector4 get ssqs => const Vector4.zero();
  Vector4 get ssqt => const Vector4.zero();
  Vector4 get ssqp => const Vector4.zero();
  Vector4 get ssqq => const Vector4.zero();
  Vector4 get stss => const Vector4.zero();
  Vector4 get stst => const Vector4.zero();
  Vector4 get stsp => const Vector4.zero();
  Vector4 get stsq => const Vector4.zero();
  Vector4 get stts => const Vector4.zero();
  Vector4 get sttt => const Vector4.zero();
  Vector4 get sttp => const Vector4.zero();
  Vector4 get sttq => const Vector4.zero();
  Vector4 get stps => const Vector4.zero();
  Vector4 get stpt => const Vector4.zero();
  Vector4 get stpp => const Vector4.zero();
  Vector4 get stpq => const Vector4.zero();
  Vector4 get stqs => const Vector4.zero();
  Vector4 get stqt => const Vector4.zero();
  Vector4 get stqp => const Vector4.zero();
  Vector4 get stqq => const Vector4.zero();
  Vector4 get spss => const Vector4.zero();
  Vector4 get spst => const Vector4.zero();
  Vector4 get spsp => const Vector4.zero();
  Vector4 get spsq => const Vector4.zero();
  Vector4 get spts => const Vector4.zero();
  Vector4 get sptt => const Vector4.zero();
  Vector4 get sptp => const Vector4.zero();
  Vector4 get sptq => const Vector4.zero();
  Vector4 get spps => const Vector4.zero();
  Vector4 get sppt => const Vector4.zero();
  Vector4 get sppp => const Vector4.zero();
  Vector4 get sppq => const Vector4.zero();
  Vector4 get spqs => const Vector4.zero();
  Vector4 get spqt => const Vector4.zero();
  Vector4 get spqp => const Vector4.zero();
  Vector4 get spqq => const Vector4.zero();
  Vector4 get sqss => const Vector4.zero();
  Vector4 get sqst => const Vector4.zero();
  Vector4 get sqsp => const Vector4.zero();
  Vector4 get sqsq => const Vector4.zero();
  Vector4 get sqts => const Vector4.zero();
  Vector4 get sqtt => const Vector4.zero();
  Vector4 get sqtp => const Vector4.zero();
  Vector4 get sqtq => const Vector4.zero();
  Vector4 get sqps => const Vector4.zero();
  Vector4 get sqpt => const Vector4.zero();
  Vector4 get sqpp => const Vector4.zero();
  Vector4 get sqpq => const Vector4.zero();
  Vector4 get sqqs => const Vector4.zero();
  Vector4 get sqqt => const Vector4.zero();
  Vector4 get sqqp => const Vector4.zero();
  Vector4 get sqqq => const Vector4.zero();

  // Vector4 stpq swizzles: t first
  Vector4 get tsss => const Vector4.zero();
  Vector4 get tsst => const Vector4.zero();
  Vector4 get tssp => const Vector4.zero();
  Vector4 get tssq => const Vector4.zero();
  Vector4 get tsts => const Vector4.zero();
  Vector4 get tstt => const Vector4.zero();
  Vector4 get tstp => const Vector4.zero();
  Vector4 get tstq => const Vector4.zero();
  Vector4 get tsps => const Vector4.zero();
  Vector4 get tspt => const Vector4.zero();
  Vector4 get tspp => const Vector4.zero();
  Vector4 get tspq => const Vector4.zero();
  Vector4 get tsqs => const Vector4.zero();
  Vector4 get tsqt => const Vector4.zero();
  Vector4 get tsqp => const Vector4.zero();
  Vector4 get tsqq => const Vector4.zero();
  Vector4 get ttss => const Vector4.zero();
  Vector4 get ttst => const Vector4.zero();
  Vector4 get ttsp => const Vector4.zero();
  Vector4 get ttsq => const Vector4.zero();
  Vector4 get ttts => const Vector4.zero();
  Vector4 get tttt => const Vector4.zero();
  Vector4 get tttp => const Vector4.zero();
  Vector4 get tttq => const Vector4.zero();
  Vector4 get ttps => const Vector4.zero();
  Vector4 get ttpt => const Vector4.zero();
  Vector4 get ttpp => const Vector4.zero();
  Vector4 get ttpq => const Vector4.zero();
  Vector4 get ttqs => const Vector4.zero();
  Vector4 get ttqt => const Vector4.zero();
  Vector4 get ttqp => const Vector4.zero();
  Vector4 get ttqq => const Vector4.zero();
  Vector4 get tpss => const Vector4.zero();
  Vector4 get tpst => const Vector4.zero();
  Vector4 get tpsp => const Vector4.zero();
  Vector4 get tpsq => const Vector4.zero();
  Vector4 get tpts => const Vector4.zero();
  Vector4 get tptt => const Vector4.zero();
  Vector4 get tptp => const Vector4.zero();
  Vector4 get tptq => const Vector4.zero();
  Vector4 get tpps => const Vector4.zero();
  Vector4 get tppt => const Vector4.zero();
  Vector4 get tppp => const Vector4.zero();
  Vector4 get tppq => const Vector4.zero();
  Vector4 get tpqs => const Vector4.zero();
  Vector4 get tpqt => const Vector4.zero();
  Vector4 get tpqp => const Vector4.zero();
  Vector4 get tpqq => const Vector4.zero();
  Vector4 get tqss => const Vector4.zero();
  Vector4 get tqst => const Vector4.zero();
  Vector4 get tqsp => const Vector4.zero();
  Vector4 get tqsq => const Vector4.zero();
  Vector4 get tqts => const Vector4.zero();
  Vector4 get tqtt => const Vector4.zero();
  Vector4 get tqtp => const Vector4.zero();
  Vector4 get tqtq => const Vector4.zero();
  Vector4 get tqps => const Vector4.zero();
  Vector4 get tqpt => const Vector4.zero();
  Vector4 get tqpp => const Vector4.zero();
  Vector4 get tqpq => const Vector4.zero();
  Vector4 get tqqs => const Vector4.zero();
  Vector4 get tqqt => const Vector4.zero();
  Vector4 get tqqp => const Vector4.zero();
  Vector4 get tqqq => const Vector4.zero();

  // Vector4 stpq swizzles: p first
  Vector4 get psss => const Vector4.zero();
  Vector4 get psst => const Vector4.zero();
  Vector4 get pssp => const Vector4.zero();
  Vector4 get pssq => const Vector4.zero();
  Vector4 get psts => const Vector4.zero();
  Vector4 get pstt => const Vector4.zero();
  Vector4 get pstp => const Vector4.zero();
  Vector4 get pstq => const Vector4.zero();
  Vector4 get psps => const Vector4.zero();
  Vector4 get pspt => const Vector4.zero();
  Vector4 get pspp => const Vector4.zero();
  Vector4 get pspq => const Vector4.zero();
  Vector4 get psqs => const Vector4.zero();
  Vector4 get psqt => const Vector4.zero();
  Vector4 get psqp => const Vector4.zero();
  Vector4 get psqq => const Vector4.zero();
  Vector4 get ptss => const Vector4.zero();
  Vector4 get ptst => const Vector4.zero();
  Vector4 get ptsp => const Vector4.zero();
  Vector4 get ptsq => const Vector4.zero();
  Vector4 get ptts => const Vector4.zero();
  Vector4 get pttt => const Vector4.zero();
  Vector4 get pttp => const Vector4.zero();
  Vector4 get pttq => const Vector4.zero();
  Vector4 get ptps => const Vector4.zero();
  Vector4 get ptpt => const Vector4.zero();
  Vector4 get ptpp => const Vector4.zero();
  Vector4 get ptpq => const Vector4.zero();
  Vector4 get ptqs => const Vector4.zero();
  Vector4 get ptqt => const Vector4.zero();
  Vector4 get ptqp => const Vector4.zero();
  Vector4 get ptqq => const Vector4.zero();
  Vector4 get ppss => const Vector4.zero();
  Vector4 get ppst => const Vector4.zero();
  Vector4 get ppsp => const Vector4.zero();
  Vector4 get ppsq => const Vector4.zero();
  Vector4 get ppts => const Vector4.zero();
  Vector4 get pptt => const Vector4.zero();
  Vector4 get pptp => const Vector4.zero();
  Vector4 get pptq => const Vector4.zero();
  Vector4 get ppps => const Vector4.zero();
  Vector4 get pppt => const Vector4.zero();
  Vector4 get pppp => const Vector4.zero();
  Vector4 get pppq => const Vector4.zero();
  Vector4 get ppqs => const Vector4.zero();
  Vector4 get ppqt => const Vector4.zero();
  Vector4 get ppqp => const Vector4.zero();
  Vector4 get ppqq => const Vector4.zero();
  Vector4 get pqss => const Vector4.zero();
  Vector4 get pqst => const Vector4.zero();
  Vector4 get pqsp => const Vector4.zero();
  Vector4 get pqsq => const Vector4.zero();
  Vector4 get pqts => const Vector4.zero();
  Vector4 get pqtt => const Vector4.zero();
  Vector4 get pqtp => const Vector4.zero();
  Vector4 get pqtq => const Vector4.zero();
  Vector4 get pqps => const Vector4.zero();
  Vector4 get pqpt => const Vector4.zero();
  Vector4 get pqpp => const Vector4.zero();
  Vector4 get pqpq => const Vector4.zero();
  Vector4 get pqqs => const Vector4.zero();
  Vector4 get pqqt => const Vector4.zero();
  Vector4 get pqqp => const Vector4.zero();
  Vector4 get pqqq => const Vector4.zero();

  // Vector4 stpq swizzles: q first
  Vector4 get qsss => const Vector4.zero();
  Vector4 get qsst => const Vector4.zero();
  Vector4 get qssp => const Vector4.zero();
  Vector4 get qssq => const Vector4.zero();
  Vector4 get qsts => const Vector4.zero();
  Vector4 get qstt => const Vector4.zero();
  Vector4 get qstp => const Vector4.zero();
  Vector4 get qstq => const Vector4.zero();
  Vector4 get qsps => const Vector4.zero();
  Vector4 get qspt => const Vector4.zero();
  Vector4 get qspp => const Vector4.zero();
  Vector4 get qspq => const Vector4.zero();
  Vector4 get qsqs => const Vector4.zero();
  Vector4 get qsqt => const Vector4.zero();
  Vector4 get qsqp => const Vector4.zero();
  Vector4 get qsqq => const Vector4.zero();
  Vector4 get qtss => const Vector4.zero();
  Vector4 get qtst => const Vector4.zero();
  Vector4 get qtsp => const Vector4.zero();
  Vector4 get qtsq => const Vector4.zero();
  Vector4 get qtts => const Vector4.zero();
  Vector4 get qttt => const Vector4.zero();
  Vector4 get qttp => const Vector4.zero();
  Vector4 get qttq => const Vector4.zero();
  Vector4 get qtps => const Vector4.zero();
  Vector4 get qtpt => const Vector4.zero();
  Vector4 get qtpp => const Vector4.zero();
  Vector4 get qtpq => const Vector4.zero();
  Vector4 get qtqs => const Vector4.zero();
  Vector4 get qtqt => const Vector4.zero();
  Vector4 get qtqp => const Vector4.zero();
  Vector4 get qtqq => const Vector4.zero();
  Vector4 get qpss => const Vector4.zero();
  Vector4 get qpst => const Vector4.zero();
  Vector4 get qpsp => const Vector4.zero();
  Vector4 get qpsq => const Vector4.zero();
  Vector4 get qpts => const Vector4.zero();
  Vector4 get qptt => const Vector4.zero();
  Vector4 get qptp => const Vector4.zero();
  Vector4 get qptq => const Vector4.zero();
  Vector4 get qpps => const Vector4.zero();
  Vector4 get qppt => const Vector4.zero();
  Vector4 get qppp => const Vector4.zero();
  Vector4 get qppq => const Vector4.zero();
  Vector4 get qpqs => const Vector4.zero();
  Vector4 get qpqt => const Vector4.zero();
  Vector4 get qpqp => const Vector4.zero();
  Vector4 get qpqq => const Vector4.zero();
  Vector4 get qqss => const Vector4.zero();
  Vector4 get qqst => const Vector4.zero();
  Vector4 get qqsp => const Vector4.zero();
  Vector4 get qqsq => const Vector4.zero();
  Vector4 get qqts => const Vector4.zero();
  Vector4 get qqtt => const Vector4.zero();
  Vector4 get qqtp => const Vector4.zero();
  Vector4 get qqtq => const Vector4.zero();
  Vector4 get qqps => const Vector4.zero();
  Vector4 get qqpt => const Vector4.zero();
  Vector4 get qqpp => const Vector4.zero();
  Vector4 get qqpq => const Vector4.zero();
  Vector4 get qqqs => const Vector4.zero();
  Vector4 get qqqt => const Vector4.zero();
  Vector4 get qqqp => const Vector4.zero();
  Vector4 get qqqq => const Vector4.zero();

  int get columnDimension => 1;

  int get rowDimension => 4;

  bool get isSquare => false;

  Iterable<double> get values => const [0.0, 0.0, 0.0, 0.0];

  Iterable<double> get valuesColumnPacked => const [0.0, 0.0, 0.0, 0.0];

  Iterable<double> get valuesRowPacked => const [0.0, 0.0, 0.0, 0.0];

  Matrix get transpose =>
      new Matrix.fromList(const [0.0, 0.0, 0.0, 0.0], rowDimension);

  double get determinant =>
      throw new UnsupportedError('Matrix must be square.');

  bool get isNonSingular =>
      throw new UnsupportedError('Matrix must be square.');

  Vector4 get inverse =>
      throw new UnsupportedError('This matrix is singular (has no inverse).');

  double get magnitude => 0.0;

  bool get isUnit => false;

  Vector4 get unitVector =>
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

  Vector4 scalarProduct(num s) => const Vector4.zero();

  Vector4 scalarDivision(num s) => const Vector4.zero();

  Vector4 entrywiseSum(Matrix B) {
    if (B is Vector4) {
      return new Vector4(B.x, B.y, B.z, B.w);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector4(
          B.valueAt(0, 0), B.valueAt(1, 0), B.valueAt(2, 0), B.valueAt(3, 0));
    }
  }

  Vector4 entrywiseDifference(Matrix B) {
    if (B is Vector4) {
      return new Vector4(B.x, B.y, B.z, B.w);
    } else {
      _assertEqualDimensions(this, B);

      return new Vector4(
          B.valueAt(0, 0), B.valueAt(1, 0), B.valueAt(2, 0), B.valueAt(3, 0));
    }
  }

  Vector4 entrywiseProduct(Matrix B) {
    if (B is Vector4) {
      return const Vector4.zero();
    } else {
      _assertEqualDimensions(this, B);

      return const Vector4.zero();
    }
  }

  Matrix matrixProduct(Matrix B) {
    if (B.rowDimension != 1) {
      throw new ArgumentError('Matrix inner dimensions must agree.');
    }

    return new Matrix.zero(rowDimension, B.columnDimension);
  }

  double dotProduct(Vector4 B) => 0.0;

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

  Vector4 operator +(Matrix B) => entrywiseSum(B);

  Vector4 operator -(Matrix B) => entrywiseDifference(B);

  /// Returns the value at the [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  double operator [](int index) {
    RangeError.checkValidIndex(index, this, 'index', 4);

    return 0.0;
  }

  String toString() {
    return 'Vector4(0.0, 0.0, 0.0, 0.0)';
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector4 &&
          other.x == x &&
          other.y == y &&
          other.z == z &&
          other.w == w;

  int get hashCode => hash4(x, y, z, w);
}
