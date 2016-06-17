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

  /// The geometries that are currently provisioned for this context.
  Set<IndexGeometry> _provisionedGeometries = new Set();

  /// The programs that are currently provisioned for this context.
  Set<Program> _provisionedPrograms = new Set();

  /// The [AttributeDataTable] currently bound to the WebGL context.
  AttributeDataTable _boundAttributeDataTable;

  /// The [IndexList] currently bound to the WebGL context.
  IndexList _boundIndexList;

  /// Map from index lists to their associated index buffer objects (IBOs).
  Map<IndexList, WebGL.Buffer> _indexListIBOs = new Map();

  /// Map from attribute data tables to their associated vertex buffer objects
  /// (VBOs).
  Map<AttributeDataTable, WebGL.Buffer> _attributeDataTableVBOs = new Map();

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

  /// Map from [Program]s to their associated [_GLProgramInfo] for all currently
  /// provisioned programs for this context.
  Map<Program, _GLProgramInfo> _programGLProgramInfoMap = new Map();

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
  Map<WebGL.UniformLocation, VertexAttribute> _uniformValues = new Map();

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

  Iterable<IndexGeometry> get provisionedGeometries =>
      new UnmodifiableSetView(_provisionedGeometries);

  Iterable<Program> get provisionedPrograms =>
      new UnmodifiableSetView(_provisionedPrograms);

  void provisionGeometry(IndexGeometry geometry) {
    if (!_provisionedGeometries.contains(geometry)) {
      final indices = geometry.indices;

      if ((_indexListReferenceCounts[indices] ?? 0) >= 1) {
        _indexListReferenceCounts[indices] += 1;
      } else {
        final indexDataVBO = _context.createBuffer();
        final usage =
            indices.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

        _context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexDataVBO);
        _context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices.buffer, usage);
        _indexListIBOs[indices] = indexDataVBO;
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
          _attributeDataTableVBOs[table] = frameVBO;
          _attributeDataTableReferenceCounts[table] = 1;
        }
      });

      _provisionedGeometries.add(geometry);
    }
  }

  bool deprovisionGeometry(IndexGeometry geometry) {
    if (_provisionedGeometries.contains(geometry)) {
      final indices = geometry.indices;

      // When index geometry is detached but its index list is still used by
      // another index geometry, then the index list's index buffer object (IBO)
      // should not yet be deleted. The IBO is only deleted when the reference
      // count drops to 0.
      if (_indexListReferenceCounts[indices] > 1) {
        _indexListReferenceCounts[indices] -= 1;
      } else {
        _context.deleteBuffer(_indexListIBOs[indices]);
        _indexListIBOs.remove(geometry);
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
          _context.deleteBuffer(_attributeDataTableVBOs[frame]);
          _attributeDataTableVBOs.remove(frame);
          _attributeDataTableReferenceCounts.remove(frame);
        }
      });

      _provisionedGeometries.remove(geometry);

      return true;
    } else {
      return false;
    }
  }

  void provisionProgram(Program program) {
    if (!_provisionedPrograms.contains(program)) {
      final glProgramHandle = _context.createProgram();
      final vertexShader =
          _compileShader(WebGL.VERTEX_SHADER, program.vertexShaderSource);
      final fragmentShader =
          _compileShader(WebGL.FRAGMENT_SHADER, program.fragmentShaderSource);

      _context.attachShader(glProgramHandle, vertexShader);
      _context.attachShader(glProgramHandle, fragmentShader);
      _context.linkProgram(glProgramHandle);

      final success =
          _context.getProgramParameter(glProgramHandle, WebGL.LINK_STATUS);

      if (!success) {
        throw new ProgramLinkingError(
            _context.getProgramInfoLog(glProgramHandle));
      }

      _programGLProgramInfoMap[program] = new _GLProgramInfo(
          this, glProgramHandle, vertexShader, fragmentShader);
      _provisionedPrograms.add(program);
    }
  }

  bool deprovisionProgram(Program program) {
    if (_provisionedPrograms.contains(program)) {
      final glProgramInfo = _programGLProgramInfoMap[program];

      _context.deleteProgram(glProgramInfo.glProgramHandle);
      _context.deleteShader(glProgramInfo.glVertexShaderHandle);
      _context.deleteShader(glProgramInfo.glFragmentShaderHandle);

      _provisionedPrograms.remove(program);
      _programGLProgramInfoMap.remove(program);

      return true;
    } else {
      return false;
    }
  }

  void _bindAttributeData(AttributeDataTable attributeData) {
    if (attributeData != _boundAttributeDataTable) {
      _context.bindBuffer(
          WebGL.ARRAY_BUFFER, _attributeDataTableVBOs[attributeData]);
      _boundAttributeDataTable = attributeData;
    }
  }

  void _bindIndexData(IndexList indexData) {
    if (indexData != _boundIndexList) {
      _context.bindBuffer(
          WebGL.ELEMENT_ARRAY_BUFFER, _indexListIBOs[indexData]);
      _boundIndexList = indexData;
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
      _context.useProgram(_programGLProgramInfoMap[program].glProgramHandle);
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
    if (depthTest != null && !identical(depthTest, _depthTest)) {
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
    if (stencilTest != null && !identical(stencilTest, _stencilTest)) {
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
    if (blending != null && !identical(blending, _blending)) {
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
    if (colorMask != _colorMask) {
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

      _context.scissor(
          scissorBox.x, scissorBox.y, scissorBox.width, scissorBox.height);

      _scissorBox = scissorBox;
    } else if (scissorBox == null && _scissorTestEnabled) {
      _context.disable(WebGL.SCISSOR_TEST);
      _scissorTestEnabled = false;
    }
  }

  void _updateViewport(Region viewport) {
    if (viewport != null && viewport != _viewport) {
      _context.viewport(
          viewport.x, viewport.y, viewport.width, viewport.height);

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

  WebGL.Shader _compileShader(int type, String source) {
    final shader = _context.createShader(type);

    _context.shaderSource(shader, source);
    _context.compileShader(shader);

    final success = _context.getShaderParameter(shader, WebGL.COMPILE_STATUS);

    if (!success) {
      throw new ShaderCompilationError(
          type, source, _context.getShaderInfoLog(shader));
    }

    return shader;
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

class _GLProgramInfo {
  final RenderingContext context;

  final WebGL.Program glProgramHandle;

  final WebGL.Shader glVertexShaderHandle;

  final WebGL.Shader glFragmentShaderHandle;

  Map<String, int> _attributeLocationsByName;

  Map<String, WebGL.UniformLocation> _uniformLocationsByName;

  _GLProgramInfo(this.context, this.glProgramHandle, this.glVertexShaderHandle,
      this.glFragmentShaderHandle) {
    final glContext = context._context;

    // Create attribute name -> attribute location map
    final attributeLocationsByName = {};
    final activeAttributes =
        glContext.getProgramParameter(glProgramHandle, WebGL.ACTIVE_ATTRIBUTES);

    for (var i = 0; i < activeAttributes; i++) {
      final name = glContext.getActiveAttrib(glProgramHandle, i).name;
      final location = glContext.getAttribLocation(glProgramHandle, name);

      if (location != -1) {
        attributeLocationsByName[name] = location;
      }
    }

    _attributeLocationsByName =
        new UnmodifiableMapView(attributeLocationsByName);

    // Create uniform name -> uniform location map
    final uniformLocationsByName = {};
    final activeUniforms =
        glContext.getProgramParameter(glProgramHandle, WebGL.ACTIVE_UNIFORMS);

    for (var i = 0; i < activeUniforms; i++) {
      final name = glContext.getActiveUniform(glProgramHandle, i).name;
      final location = glContext.getUniformLocation(glProgramHandle, name);

      if (location != null) {
        uniformLocationsByName[name] = location;
      }
    }

    _uniformLocationsByName = new UnmodifiableMapView(uniformLocationsByName);
  }

  Map<String, int> get attributeLocationsByName => _attributeLocationsByName;

  Map<String, WebGL.UniformLocation> get uniformLocationsByName =>
      _uniformLocationsByName;
}
