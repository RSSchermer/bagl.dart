part of web_gl;

const Map<Topology, int> _topologyMap = const {
  Topology.points: WebGL.POINTS,
  Topology.lines: WebGL.LINES,
  Topology.lineStrip: WebGL.LINE_STRIP,
  Topology.lineLoop: WebGL.LINE_LOOP,
  Topology.triangles: WebGL.TRIANGLES,
  Topology.triangleStrip: WebGL.TRIANGLE_STRIP,
  Topology.triangleFan: WebGL.TRIANGLE_FAN
};

const Map<TestFunction, int> _testFunctionMap = const {
  TestFunction.equal: WebGL.EQUAL,
  TestFunction.notEqual: WebGL.NOTEQUAL,
  TestFunction.less: WebGL.LESS,
  TestFunction.greater: WebGL.GREATER,
  TestFunction.lessOrEqual: WebGL.LEQUAL,
  TestFunction.greaterOrEqual: WebGL.GEQUAL,
  TestFunction.neverPass: WebGL.NEVER,
  TestFunction.alwaysPass: WebGL.ALWAYS
};

const Map<StencilOperation, int> _stencilOperationMap = const {
  StencilOperation.keep: WebGL.KEEP,
  StencilOperation.zero: WebGL.ZERO,
  StencilOperation.replace: WebGL.REPLACE,
  StencilOperation.increment: WebGL.INCR,
  StencilOperation.wrappingIncrement: WebGL.INCR_WRAP,
  StencilOperation.decrement: WebGL.DECR,
  StencilOperation.wrappingDecrement: WebGL.DECR_WRAP,
  StencilOperation.invert: WebGL.INVERT
};

const Map<BlendingFunction, int> _blendingFunctionMap = const {
  BlendingFunction.addition: WebGL.FUNC_ADD,
  BlendingFunction.subtraction: WebGL.FUNC_SUBTRACT,
  BlendingFunction.reverseSubtraction: WebGL.FUNC_REVERSE_SUBTRACT
};

const Map<BlendingFactor, int> _blendingFactorMap = const {
  BlendingFactor.zero: WebGL.ZERO,
  BlendingFactor.one: WebGL.ONE,
  BlendingFactor.sourceColor: WebGL.SRC_COLOR,
  BlendingFactor.oneMinusSourceColor: WebGL.ONE_MINUS_SRC_COLOR,
  BlendingFactor.destinationColor: WebGL.DST_COLOR,
  BlendingFactor.oneMinusDestinationColor: WebGL.ONE_MINUS_DST_COLOR,
  BlendingFactor.sourceAlpha: WebGL.SRC_ALPHA,
  BlendingFactor.oneMinusSourceAlpha: WebGL.ONE_MINUS_SRC_ALPHA,
  BlendingFactor.destinationAlpha: WebGL.DST_ALPHA,
  BlendingFactor.oneMinusDestinationAlpha: WebGL.ONE_MINUS_DST_ALPHA,
  BlendingFactor.sourceAlphaSaturate: WebGL.SRC_ALPHA_SATURATE
};

const Map<CullingMode, int> _cullingModeMap = const {
  CullingMode.frontFaces: WebGL.FRONT,
  CullingMode.backFaces: WebGL.BACK,
  CullingMode.frontAndBackFaces: WebGL.FRONT_AND_BACK
};

const Map<WindingOrder, int> _windingOrderMap = const {
  WindingOrder.clockwise: WebGL.CW,
  WindingOrder.counterClockwise: WebGL.CCW
};
