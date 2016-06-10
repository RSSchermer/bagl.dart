part of web_gl;

/// BaGL rendering context for an HTML canvas element.
class RenderingContext {
  static Map<CanvasElement, RenderingContext> _canvasContextMap = new Map();

  /// The canvas element this rendering context is associated with.
  final CanvasElement canvas;

  Frame _defaultFrame;

  /// The WebGL rendering context associated with the [canvas].
  WebGL.RenderingContext _context;

  /// The frame that is currently bound to the WebGL context as the draw
  /// context.
  Frame _boundFrame;

  /// The shader program that is currently used by the WebGL context.
  Program _activeProgram;

  /// The geometries attached to this context.
  Set<IndexGeometry> _attachedGeometries = new Set();

  /// The [AttributeDataTable] currently bound to the WebGL context.
  AttributeDataTable _boundAttributeData;

  /// The [IndexList] currently bound to the WebGL context.
  IndexList _boundIndexData;

  /// Map from index lists to their associated index buffer objects.
  Map<IndexList, WebGL.Buffer> _indexDataIBOMap = new Map();

  /// Map from attribute data tables to their associated vertex buffer objects.
  Map<AttributeDataTable, WebGL.Buffer> _attributeDataVBOMap = new Map();

  /// Map to keep track of reference counts for index lists.
  ///
  /// An [IndexList] may be used by multiple geometries attached to this
  /// context. If 3 different geometries use the same [IndexList], then the
  /// reference count for that [IndexList] will be 3.
  Map<IndexList, int> _indexListReferenceCounts = new Map();

  /// Map to keep track of reference counts for attribute data tables.
  ///
  /// An [AttributeDataTable] may be used by multiple geometries attached to
  /// this context. If 3 different geometries use the same [AttributeDataTable],
  /// then the reference count for that [AttributeDataTable] will be 3.
  Map<AttributeDataTable, int> _attributeDataTableReferenceCounts = new Map();

  /// Map from shader program attribute locations to the [VertexAttribute]
  /// currently bound to this location.
  ///
  /// Used to verify if the vertexAttribPointer needs to be changed or if the
  /// vertexAttribPointer is already set up correctly.
  Map<int, VertexAttribute> _locationAttributeMap = new Map();

  /// Map from shader program uniform locations to the values currently bound to
  /// these locations.
  ///
  /// Used to verify if the value bound to a uniform location needs to be
  /// changed.
  Map<WebGL.UniformLocation, VertexAttribute> _uniformValueMap = new Map();

  /// The shader program attribute locations that are currently enabled.
  Set<int> _enabledAttributeLocations = new Set();

  /// The value that is currently set as the clearColor on the WebGL context.
  Vector4 _clearColor = new Vector4.zero();

  /// The value that is currently set as the clearDepth on the WebGL context.
  double _clearDepth = 1.0;

  /// The value that is currently set as the clearStencil on the WebGL context.
  int _clearStencil = 0;

  /// Whether or not depth testing is currently enabled.
  bool _depthTestEnabled = false;

  /// The currently active depth test instructions.
  DepthTest _depthTest = const DepthTest(
      testFunction: TestFunction.less,
      rangeNear: 0.0,
      rangeFar: 1.0,
      write: true);

  /// Whether or not stencil testing is currently enabled.
  bool _stencilTestEnabled = false;

  /// The currently active stencil test instructions.
  StencilTest _stencilTest = const StencilTest(
      testFunctionFront: TestFunction.alwaysPass,
      failOperationFront: StencilOperation.keep,
      passDepthFailOperationFront: StencilOperation.keep,
      passOperationFront: StencilOperation.keep,
      testFunctionBack: TestFunction.alwaysPass,
      failOperationBack: StencilOperation.keep,
      passDepthFailOperationBack: StencilOperation.keep,
      passOperationBack: StencilOperation.keep,
      referenceValue: 0,
      testMask: 0xfffffff,
      writeMask: 0xfffffff);

  /// Whether or not blending is currently enabled.
  bool _blendingEnabled = false;

  /// The currently active blending instructions.
  Blending _blending = const Blending(
      sourceColorFactor: BlendingFactor.one,
      sourceAlphaFactor: BlendingFactor.one,
      destinationColorFactor: BlendingFactor.one,
      destinationAlphaFactor: BlendingFactor.one,
      colorFunction: BlendingFunction.addition,
      alphaFunction: BlendingFunction.addition);

  /// Whether or not face culling is currently enabled.
  bool _faceCullingEnabled = false;

  /// The currently used face culling mode.
  CullingMode _faceCulling;

  /// The current winding order for front faces.
  WindingOrder _frontFace = WindingOrder.counterClockwise;

  /// The currently used color mask.
  ColorMask _colorMask = const ColorMask(true, true, true, true);

  /// The value that is currently set as the lineWidth on the WebGL context.
  num _lineWidth = 1;

  /// Whether or not the scissor test is enabled.
  bool _scissorTestEnabled = false;

  /// The region currently used for scissor testing.
  Region _scissorBox;

  /// The region currently used as the viewport.
  Region _viewport;

  /// Whether or not dithering is currently enabled.
  bool _dithering = true;

  RenderingContext._internal(this.canvas,
      {bool alpha: true,
      bool depth: true,
      bool stencil: false,
      bool antialias: true,
      bool premultipliedAlpha: true,
      bool preserveDrawingBuffer: false,
      bool preferLowPowerToHighPerformance: false,
      bool failIfMajorPerformanceCaveat: false}) {
    _context = canvas.getContext('webgl', {
          'alpha': alpha,
          'depth': depth,
          'stencil': stencil,
          'antialias': antialias,
          'premultipliedAlpha': premultipliedAlpha,
          'preserveDrawingBuffer': preserveDrawingBuffer,
          'preferLowPowerToHighPerformance': preferLowPowerToHighPerformance,
          'failIfMajorPerformanceCaveat': failIfMajorPerformanceCaveat
        }) ??
        canvas.getContext('experimental-webgl', {
          'alpha': alpha,
          'depth': depth,
          'stencil': stencil,
          'antialias': antialias,
          'premultipliedAlpha': premultipliedAlpha,
          'preserveDrawingBuffer': preserveDrawingBuffer,
          'preferLowPowerToHighPerformance': preferLowPowerToHighPerformance,
          'failIfMajorPerformanceCaveat': failIfMajorPerformanceCaveat
        });

    _defaultFrame = new Frame._default(this);
    _boundFrame = _defaultFrame;
  }

  static RenderingContext forCanvas(CanvasElement canvas,
      {bool alpha: true,
      bool depth: true,
      bool stencil: false,
      bool antialias: true,
      bool premultipliedAlpha: true,
      bool preserveDrawingBuffer: false,
      bool preferLowPowerToHighPerformance: false,
      bool failIfMajorPerformanceCaveat: false}) {
    if (RenderingContext._canvasContextMap.containsKey(canvas)) {
      return RenderingContext._canvasContextMap[canvas];
    } else {
      final context = new RenderingContext._internal(canvas,
          alpha: alpha,
          depth: depth,
          stencil: stencil,
          antialias: antialias,
          premultipliedAlpha: premultipliedAlpha,
          preserveDrawingBuffer: preserveDrawingBuffer,
          preferLowPowerToHighPerformance: preferLowPowerToHighPerformance,
          failIfMajorPerformanceCaveat: failIfMajorPerformanceCaveat);

      RenderingContext._canvasContextMap[canvas] = context;

      return context;
    }
  }

  Frame get defaultFrame => _defaultFrame;

  void attach(IndexGeometry geometry) {
    if (!isAttached(geometry)) {
      final indices = geometry.indices;

      if ((_indexListReferenceCounts[indices] ?? 0) >= 1) {
        _indexListReferenceCounts[indices] += 1;
      } else {
        final indexDataVBO = _context.createBuffer();
        final usage =
            indices.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

        _context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexDataVBO);
        _context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices.buffer, usage);
        _indexDataIBOMap[indices] = indexDataVBO;
        _indexListReferenceCounts[indices] = 1;
      }

      geometry.vertices.attributeDataTables.forEach((table) {
        if ((_attributeDataTableReferenceCounts[table] ?? 0) >= 1) {
          _attributeDataTableReferenceCounts[table] += 1;
        } else {
          var frameVBO = _context.createBuffer();
          var usage = table.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

          _context.bindBuffer(WebGL.ARRAY_BUFFER, frameVBO);
          _context.bufferData(WebGL.ARRAY_BUFFER, table.buffer, usage);
          _attributeDataVBOMap[table] = frameVBO;
          _attributeDataTableReferenceCounts[table] = 1;
        }
      });

      _attachedGeometries.add(geometry);
    }
  }

  void detach(IndexGeometry geometry) {
    if (isAttached(geometry)) {
      final indices = geometry.indices;

      // When index geometry is detached but its index list is still used by
      // another index geometry, then the index list's index buffer object (IBO)
      // should not yet be deleted. The IBO is only deleted when the reference
      // count drops to 0.
      if (_indexListReferenceCounts[indices] > 1) {
        _indexListReferenceCounts[indices] -= 1;
      } else {
        _context.deleteBuffer(_indexDataIBOMap[indices]);
        _indexDataIBOMap.remove(geometry);
        _indexListReferenceCounts.remove(indices);
      }

      geometry.vertices.attributeDataTables.forEach((frame) {
        // When geometry is detached but an attribute data table is still used
        // by another geometry, then the attribute data table's vertex buffer
        // object (VBO) should not yet be deleted. The VBO is only deleted when
        // the reference count drops to 0.
        if (_attributeDataTableReferenceCounts[frame] > 1) {
          _attributeDataTableReferenceCounts[frame] -= 1;
        } else {
          _context.deleteBuffer(_attributeDataVBOMap[frame]);
          _attributeDataVBOMap.remove(frame);
          _attributeDataTableReferenceCounts.remove(frame);
        }
      });

      _attachedGeometries.remove(geometry);
    }
  }

  bool isAttached(IndexGeometry geometry) =>
      _attachedGeometries.contains(geometry);

  void _bindAttributeData(AttributeDataTable attributeData) {
    if (attributeData != _boundAttributeData) {
      _context.bindBuffer(
          WebGL.ARRAY_BUFFER, _attributeDataVBOMap[attributeData]);
      _boundAttributeData = attributeData;
    }
  }

  void _bindIndexData(IndexList indexData) {
    if (indexData != _boundIndexData) {
      _context.bindBuffer(
          WebGL.ELEMENT_ARRAY_BUFFER, _indexDataIBOMap[indexData]);
      _boundIndexData = indexData;
    }
  }

  void _bindFrame(Frame frame) {
    if (frame != _boundFrame) {
      if (frame == defaultFrame) {
        _context.bindFramebuffer(WebGL.FRAMEBUFFER, null);
      } else {
        _context.bindFramebuffer(WebGL.FRAMEBUFFER, frame._framebufferObject);
      }

      _boundFrame = frame;
    }
  }

  void _useProgram(Program program) {
    if (program != _activeProgram) {
      _context.useProgram(program._program);
      _activeProgram = program;
    }
  }

  void _updateClearColor(Vector4 color) {
    if (color != _clearColor) {
      _context.clearColor(color.r, color.g, color.b, color.a);
      _clearColor = color;
    }
  }

  void _updateClearDepth(double depth) {
    if (depth != _clearDepth) {
      _context.clearDepth(depth);
      _clearDepth = depth;
    }
  }

  void _updateClearStencil(int stencil) {
    if (stencil != _clearStencil) {
      _context.clearStencil(stencil);
      _clearStencil = stencil;
    }
  }

  void _updateDepthTest(DepthTest depthTest) {
    if (depthTest != null && depthTest != _depthTest) {
      if (!_depthTestEnabled) {
        _context.enable(WebGL.DEPTH_TEST);
        _depthTestEnabled = true;
      }

      if (depthTest.testFunction != _depthTest.testFunction) {
        _context.depthFunc(_testFunctionMap[depthTest.testFunction]);
      }

      if (depthTest.rangeNear != _depthTest.rangeNear ||
          depthTest.rangeFar != _depthTest.rangeFar) {
        _context.depthRange(depthTest.rangeNear, depthTest.rangeFar);
      }

      if (depthTest.write != _depthTest.write) {
        _context.depthMask(depthTest.write);
      }

      _depthTest = depthTest;
    } else if (depthTest == null && _depthTestEnabled) {
      _context.disable(WebGL.DEPTH_TEST);
      _depthTestEnabled = false;
    }
  }

  void _updateStencilTest(StencilTest stencilTest) {
    if (stencilTest != null && stencilTest != _stencilTest) {
      if (!_stencilTestEnabled) {
        _context.enable(WebGL.STENCIL_TEST);
        _stencilTestEnabled = true;
      }

      if (stencilTest.testFunctionFront != _stencilTest.testFunctionFront ||
          stencilTest.referenceValue != _stencilTest.referenceValue ||
          stencilTest.testMask != _stencilTest.testMask) {
        _context.stencilFuncSeparate(
            WebGL.FRONT,
            _testFunctionMap[stencilTest.testFunctionFront],
            stencilTest.referenceValue,
            stencilTest.testMask);
      }

      if (stencilTest.testFunctionBack != _stencilTest.testFunctionBack ||
          stencilTest.referenceValue != _stencilTest.referenceValue ||
          stencilTest.testMask != _stencilTest.testMask) {
        _context.stencilFuncSeparate(
            WebGL.BACK,
            _testFunctionMap[stencilTest.testFunctionBack],
            stencilTest.referenceValue,
            stencilTest.testMask);
      }

      if (stencilTest.failOperationFront != _stencilTest.failOperationFront ||
          stencilTest.passDepthFailOperationFront !=
              _stencilTest.passDepthFailOperationFront ||
          stencilTest.passOperationFront != _stencilTest.passOperationFront) {
        _context.stencilOpSeparate(
            WebGL.FRONT,
            _stencilOperationMap[stencilTest.failOperationFront],
            _stencilOperationMap[stencilTest.passDepthFailOperationFront],
            _stencilOperationMap[stencilTest.passOperationFront]);
      }

      if (stencilTest.failOperationBack != _stencilTest.failOperationBack ||
          stencilTest.passDepthFailOperationBack !=
              _stencilTest.passDepthFailOperationBack ||
          stencilTest.passOperationBack != _stencilTest.passOperationBack) {
        _context.stencilOpSeparate(
            WebGL.BACK,
            _stencilOperationMap[stencilTest.failOperationBack],
            _stencilOperationMap[stencilTest.passDepthFailOperationBack],
            _stencilOperationMap[stencilTest.passOperationBack]);
      }

      if (stencilTest.writeMask != _stencilTest.writeMask) {
        _context.stencilMask(stencilTest.writeMask);
      }

      _stencilTest = stencilTest;
    } else if (stencilTest == null && _stencilTestEnabled) {
      _context.disable(WebGL.STENCIL_TEST);
      _stencilTestEnabled = false;
    }
  }

  void _updateBlending(Blending blending) {
    if (blending != null && blending != _blending) {
      if (!_blendingEnabled) {
        _context.enable(WebGL.BLEND);
        _blendingEnabled = true;
      }

      if (blending.colorFunction != _blending.colorFunction ||
          blending.alphaFunction != _blending.alphaFunction) {
        _context.blendEquationSeparate(
            _blendingFunctionMap[blending.colorFunction],
            _blendingFunctionMap[blending.alphaFunction]);
      }

      if (blending.sourceColorFactor != _blending.sourceColorFactor ||
          blending.sourceAlphaFactor != _blending.sourceAlphaFactor ||
          blending.destinationColorFactor != _blending.destinationColorFactor ||
          blending.destinationAlphaFactor != _blending.destinationAlphaFactor) {
        _context.blendFuncSeparate(
            _blendingFactorMap[blending.sourceColorFactor],
            _blendingFactorMap[blending.destinationColorFactor],
            _blendingFactorMap[blending.sourceAlphaFactor],
            _blendingFactorMap[blending.destinationAlphaFactor]);
      }

      _blending = blending;
    } else if (blending == null && _blendingEnabled) {
      _context.disable(WebGL.BLEND);
      _blendingEnabled = false;
    }
  }

  void _updateFaceCulling(CullingMode faceCulling) {
    if (faceCulling != null && faceCulling != _faceCulling) {
      if (!_faceCullingEnabled) {
        _context.enable(WebGL.CULL_FACE);
        _faceCullingEnabled = true;
      }

      _context.cullFace(_cullingModeMap[faceCulling]);
      _faceCulling = faceCulling;
    } else if (faceCulling == null && _faceCullingEnabled) {
      _context.disable(WebGL.CULL_FACE);
      _faceCullingEnabled = false;
    }
  }

  void _updateFrontFace(WindingOrder frontFace) {
    if (frontFace != _frontFace) {
      _context.frontFace(_windingOrderMap[frontFace]);
      _frontFace = frontFace;
    }
  }

  void _updateColorMask(ColorMask colorMask) {
    if (colorMask != _colorMask &&
        (colorMask.writeRed != _colorMask.writeRed ||
            colorMask.writeGreen != _colorMask.writeGreen ||
            colorMask.writeBlue != _colorMask.writeBlue ||
            colorMask.writeAlpha != _colorMask.writeAlpha)) {
      _context.colorMask(colorMask.writeRed, colorMask.writeGreen,
          colorMask.writeBlue, colorMask.writeAlpha);
    }

    _colorMask = colorMask;
  }

  void _updateLineWidth(num lineWidth) {
    if (lineWidth != _lineWidth) {
      _context.lineWidth(lineWidth);
      _lineWidth = lineWidth;
    }
  }

  void _updateScissorBox(Region scissorBox) {
    if (scissorBox != null && scissorBox != _scissorBox) {
      if (!_scissorTestEnabled) {
        _context.enable(WebGL.SCISSOR_TEST);
        _scissorTestEnabled = true;
      }

      if (_scissorBox == null ||
          scissorBox.x != _scissorBox.x ||
          scissorBox.y != _scissorBox.y ||
          scissorBox.width != _scissorBox.width ||
          scissorBox.height != _scissorBox.height) {
        _context.scissor(
            scissorBox.x, scissorBox.y, scissorBox.width, scissorBox.height);
      }

      _scissorBox = scissorBox;
    } else if (scissorBox == null && _scissorTestEnabled) {
      _context.disable(WebGL.SCISSOR_TEST);
      _scissorTestEnabled = false;
    }
  }

  void _updateViewport(Region viewport) {
    if (viewport != null && viewport != _viewport) {
      if (viewport.x != _viewport.x ||
          viewport.y != _viewport.y ||
          viewport.width != _viewport.width ||
          viewport.height != _viewport.height) {
        _context.viewport(
            viewport.x, viewport.y, viewport.width, viewport.height);
      }

      _viewport = viewport;
    }
  }

  void _updateDithering(bool dithering) {
    if (dithering != _dithering) {
      if (dithering = true) {
        _context.enable(WebGL.DITHER);
      } else {
        _context.disable(WebGL.DITHER);
      }

      _dithering = dithering;
    }
  }
}

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
