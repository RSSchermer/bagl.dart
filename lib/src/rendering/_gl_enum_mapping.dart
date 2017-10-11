part of bagl.rendering;

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

const Map<MinificationFilter, int> _minificationFilterMap = const {
  MinificationFilter.linear: WebGL.LINEAR,
  MinificationFilter.nearest: WebGL.NEAREST,
  MinificationFilter.linearMipmapLinear: WebGL.LINEAR_MIPMAP_LINEAR,
  MinificationFilter.linearMipMapNearest: WebGL.LINEAR_MIPMAP_NEAREST,
  MinificationFilter.nearestMipmapLinear: WebGL.NEAREST_MIPMAP_LINEAR,
  MinificationFilter.nearestMipmapNearest: WebGL.NEAREST_MIPMAP_NEAREST
};

const Map<MagnificationFilter, int> _magnificationFilterMap = const {
  MagnificationFilter.linear: WebGL.LINEAR,
  MagnificationFilter.nearest: WebGL.NEAREST
};

const Map<PixelFormat, int> _pixelFormatMap = const {
  PixelFormat.RGB: WebGL.RGB,
  PixelFormat.RGBA: WebGL.RGBA,
  PixelFormat.luminance: WebGL.LUMINANCE,
  PixelFormat.luminanceAlpha: WebGL.LUMINANCE_ALPHA,
  PixelFormat.alpha: WebGL.ALPHA
};

const Map<PixelType, int> _pixelTypeMap = const {
  PixelType.unsignedByte: WebGL.UNSIGNED_BYTE,
  PixelType.unsignedShort_5_6_5: WebGL.UNSIGNED_SHORT_5_6_5,
  PixelType.unsignedShort_4_4_4_4: WebGL.UNSIGNED_SHORT_4_4_4_4,
  PixelType.unsignedShort_5_5_5_1: WebGL.UNSIGNED_SHORT_5_5_5_1
};

const Map<Wrapping, int> _wrappingMap = const {
  Wrapping.repeat: WebGL.REPEAT,
  Wrapping.mirroredRepeat: WebGL.MIRRORED_REPEAT,
  Wrapping.clampToEdge: WebGL.CLAMP_TO_EDGE
};

const Map<RenderBufferFormat, int> _renderBufferFormatMap = const {
  RenderBufferFormat.RGBA_4: WebGL.RGBA4,
  RenderBufferFormat.RGB_5_6_5: WebGL.RGB565,
  RenderBufferFormat.RGB_5_A_1: WebGL.RGB5_A1,
  RenderBufferFormat.depth_component_16: WebGL.DEPTH_COMPONENT16,
  RenderBufferFormat.stencil_index_8: WebGL.STENCIL_INDEX8,
  RenderBufferFormat.depth_stencil: WebGL.DEPTH_STENCIL
};

const Map<AttributeDataType, int> _attributeDataTypeMap = const {
  AttributeDataType.byte: WebGL.BYTE,
  AttributeDataType.short: WebGL.SHORT,
  AttributeDataType.unsignedByte: WebGL.UNSIGNED_BYTE,
  AttributeDataType.unsignedShort: WebGL.UNSIGNED_SHORT,
  AttributeDataType.float: WebGL.FLOAT
};
