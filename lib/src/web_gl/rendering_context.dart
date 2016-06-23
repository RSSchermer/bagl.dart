part of web_gl;

/// BaGL rendering context for an HTML canvas element.
class RenderingContext {
  static Map<CanvasElement, RenderingContext> _canvasContextMap = new Map();

  /// The canvas element this rendering context is associated with.
  final CanvasElement canvas;

  Frame _defaultFrame;

  /// The WebGL rendering context associated with the [canvas].
  WebGL.RenderingContext _context;

  /// The geometry related resource provisioning manager for this
  /// [RenderingContext].
  _ContextGeometryResourceManager _geometryResources;

  /// The program related resource provisioning manager for this
  /// [RenderingContext].
  _ContextProgramResourceManager _programResources;

  /// The sampler related resource provisioning manager for this
  /// [RenderingContext].
  _ContextSamplerResourceManager _samplerResources;

  /// The shader program that is currently used by the WebGL context.
  Program _activeProgram;

  /// The frame that is currently bound to the WebGL context as the draw
  /// context.
  Frame _boundFrame;

  /// The [AttributeDataTable] currently bound to the WebGL context.
  AttributeDataTable _boundAttributeDataTable;

  /// The [IndexList] currently bound to the WebGL context.
  IndexList _boundIndexList;

  /// The [Sampler2D] currently bound to the WebGL context.
  Sampler _boundSampler2D;

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

  final int maxTextureUnits = 32;

  int _activeTextureUnit = 0;

  Queue<int> _recentlyUsedTextureUnits;

  BiMap<int, Sampler> _textureUnitsSamplers = new BiMap();

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

    _geometryResources = new _ContextGeometryResourceManager(this);
    _programResources = new _ContextProgramResourceManager(this);
    _samplerResources = new _ContextSamplerResourceManager(this);
    _defaultFrame = new Frame._default(this);
    _boundFrame = _defaultFrame;
    _recentlyUsedTextureUnits = new Queue.from(new List.generate(maxTextureUnits, (i) => i));
  }

  /// Retrieves a [RenderingContext] for the [canvas].
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

  /// The default [Frame] for this [RenderingContext].
  ///
  /// The default [Frame] is the [Frame] whose color output is displayed on the
  /// [canvas] associated with this [RenderingContext].
  Frame get defaultFrame => _defaultFrame;

  /// The geometries for which resources are currently provisioned for this
  /// [RenderingContext].
  Iterable<IndexGeometry> get provisionedGeometries =>
      _geometryResources.provisionedGeometries;

  /// The programs for which resources are currently provisioned for this
  /// [RenderingContext].
  Iterable<Program> get provisionedPrograms =>
      _programResources.provisionedPrograms;

  /// Deprovisions the resources associated with the [geometry].
  ///
  /// Frees each resource associated with the [geometry], unless the [geometry]
  /// shares the resource with another currently provisioned geometry. Returns
  /// `true` if resources were provisioned for the [geometry], `false`
  /// otherwise.
  bool deprovisionGeometry(IndexGeometry geometry) =>
      _geometryResources.deprovision(geometry);

  /// Deprovisions the resources associated with the [program].
  ///
  /// Frees all resources associated with the [program]. Returns `true` if
  /// resources were provisioned for the [program], `false` otherwise.
  bool deprovisionProgram(Program program) =>
      _programResources.deprovision(program);

  void _bindAttributeDataTable(AttributeDataTable attributeDataTable) {
    if (attributeDataTable != _boundAttributeDataTable) {
      if (attributeDataTable == null) {
        _context.bindBuffer(WebGL.ARRAY_BUFFER, null);
      } else {
        _context.bindBuffer(
            WebGL.ARRAY_BUFFER, _geometryResources.getVBO(attributeDataTable));
      }

      _boundAttributeDataTable = attributeDataTable;
    }
  }

  void _bindIndexList(IndexList indexList) {
    if (indexList != _boundIndexList) {
      if (indexList == null) {
        _context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, null);
      } else {
        _context.bindBuffer(
            WebGL.ELEMENT_ARRAY_BUFFER, _geometryResources.getIBO(indexList));
      }

      _boundIndexList = indexList;
    }
  }

  void _bindSampler2D(Sampler2D sampler) {
    if (sampler != _boundSampler2D) {
      if (sampler == null) {
        _context.bindTexture(WebGL.TEXTURE_2D, null);
      } else {
        _context.bindTexture(
            WebGL.TEXTURE_2D, _samplerResources.getTO(sampler));
      }

      _boundSampler2D = sampler;
      _textureUnitsSamplers[_activeTextureUnit] = sampler;
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
      _context
          .useProgram(_programResources.getGLProgram(program).glProgramObject);
      _activeProgram = program;
    }
  }

  void _updateActiveTextureUnit(int unit) {
    if (unit != _activeTextureUnit) {
      _context.activeTexture(WebGL.TEXTURE0 + unit);
      _activeTextureUnit = unit;
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
}
