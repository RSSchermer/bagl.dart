part of rendering;

/// BaGL WebGL rendering context for an HTML canvas element.
///
/// A [RenderingContext] manages the state of the rendering backend for the
/// [canvas] with which it is associated. It has a [defaultFrame] whose color
/// buffer is displayed on the [canvas]. See [RenderingContext.forCanvas] for
/// details on how to retrieve a [RenderingContext] for a canvas element.
class RenderingContext {
  static Expando<RenderingContext> _canvasContext = new Expando();

  /// The canvas element this rendering context is associated with.
  final CanvasElement canvas;

  /// Manages the provisioning and deprovisioning of geometry related GPU
  /// resources for this [RenderingContext].
  ContextGeometryResources geometryResources;

  /// Manages the provisioning and deprovisioning of program related GPU
  /// resources for this [RenderingContext].
  ContextProgramResources programResources;

  /// Manages the provisioning and deprovisioning of sampler related GPU
  /// resources for this [RenderingContext].
  ContextSamplerResources samplerResources;

  /// The default [Frame] for this [RenderingContext].
  ///
  /// This [Frame]'s color buffer is displayed on the [canvas].
  Frame _defaultFrame;

  /// The WebGL rendering context associated with the [canvas].
  WebGL.RenderingContext _context;

  /// Memoizes the extensions supported by this [RenderContext].
  Set<String> _supportedExtensions;

  /// Caches the extension objects for previously requested extensions.
  Map<String, Object> _extensionCache = {};

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

  /// The shader program attribute locations that are currently enabled.
  Set<int> _enabledAttributeLocations = new Set();

  /// The maximum number of texture units available in this context.
  ///
  /// At most this number of [Sampler] uniforms can be used in a single draw
  /// call.
  final int maxTextureUnits = 32;

  /// The index of the currently active texture unit.
  int _activeTextureUnit = 0;

  /// Tracks which texture units have been used more recently.
  ///
  /// The first value in this [Queue] is the most recently used texture unit,
  /// the last value is the least recently used texture unit.
  Queue<int> _recentlyUsedTextureUnits;

  /// A map from texture unit indices to the [Sampler]s currently bound to these
  /// units.
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
      write: true,
      polygonOffset: const PolygonOffset(0.0, 0.0));

  /// Whether or not polygon offsetting is currently enabled.
  bool _polygonOffsetEnabled = false;

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

    geometryResources = new ContextGeometryResources._internal(this);
    programResources = new ContextProgramResources._internal(this);
    samplerResources = new ContextSamplerResources._internal(this);
    _defaultFrame = new Frame._default(this);
    _boundFrame = _defaultFrame;
    _recentlyUsedTextureUnits =
        new Queue.from(new List.generate(maxTextureUnits, (i) => i));
  }

  /// Retrieves a [RenderingContext] for the [canvas].
  ///
  /// The following optional arguments may be specified:
  ///
  /// - [alpha]: If `true`, then the [defaultFrame]'s drawing buffer has an
  ///   alpha channel for the purposes of performing OpenGL destination alpha
  ///   operations and compositing with the page. If the value is false, no
  ///   alpha buffer is available. Defaults to `true`.
  /// - [depth]: If `true`, then the [defaultFrame] has a depth buffer of at
  ///   least 16 bits. If `false`, then no depth buffer is available. Defaults
  ///   to `true`.
  /// - [stencil]: If `true`, then the [defaultFrame] has a stencil buffer of at
  ///   least 8 bits. If `false`, then no depth buffer is available. Defaults to
  ///   `false`.
  /// - [antialias]: If `true` and the rendering backend supports antialiasing,
  ///   then it will perform antialiasing using its choice of technique
  ///   (multisample/supersample) and quality. If `false` or the rendering
  ///   backend does not support antialiasing, no antialiasing is performed.
  ///   Defaults to `true`.
  /// - [premultipliedAlpha]: If `true`, then the page compositor will assume
  ///   the [defaultFrame]'s color buffer contains colors with premultiplied
  ///   alpha. If `false`, then the page compositor will assume that colors in
  ///   the drawing buffer are not premultiplied. This option is ignored if
  ///   [alpha] is `false`. Defaults to `true`.
  /// - [preserveDrawingBuffer]: If `false`, then once the [defaultFrame]'s
  ///   color buffer is presented to the page compositor, all of the
  ///   [defaultFrame]'s output buffers will be cleared. If `true`, then the
  ///   buffers will not be cleared and will preserve their values until cleared
  ///   explicitly by one of the clear methods. Defaults to `false`.
  /// - [preferLowPowerToHighPerformance]: Provides a hint to the rendering
  ///   backend on whether or not to optimize for power consumption or
  ///   performance. Defaults to `false`.
  /// - [failIfMajorPerformanceCaveat]: If `true`, then context creation will
  ///   fail if the implementation determines that the performance of the
  ///   created WebGL context would be dramatically lower than that of a native
  ///   application making equivalent OpenGL calls. Defaults to `false`.
  ///
  /// Options are only applied the first time a context is retrieved for the
  /// [canvas]. On subsequent retrievals the options are ignored.
  static RenderingContext forCanvas(CanvasElement canvas,
      {bool alpha: true,
      bool depth: true,
      bool stencil: false,
      bool antialias: true,
      bool premultipliedAlpha: true,
      bool preserveDrawingBuffer: false,
      bool preferLowPowerToHighPerformance: false,
      bool failIfMajorPerformanceCaveat: false}) {
    final canvasContext = RenderingContext._canvasContext[canvas];

    if (canvasContext != null) {
      return canvasContext;
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

      RenderingContext._canvasContext[canvas] = context;

      return context;
    }
  }

  /// The default [Frame] for this [RenderingContext].
  ///
  /// The default [Frame] is the [Frame] whose color output is displayed on the
  /// [canvas] associated with this [RenderingContext].
  Frame get defaultFrame => _defaultFrame;

  /// The names of the extensions available in this [RenderingContext].
  Iterable<String> get supportedExtensions {
    _supportedExtensions ??= _context.getSupportedExtensions().toSet();

    return _supportedExtensions;
  }

  /// Enables and returns an extension object if an extension named
  /// [extensionName] is supported by this [RenderingContext], or returns `null`
  /// otherwise.
  ///
  /// See [supportedExtensions] for the list of the extensions that are
  /// available in this [RenderingContext].
  Object requestExtension(String extensionName) {
    final cached = _extensionCache[extensionName];

    if (cached != null) {
      return cached;
    } else {
      final extensionObject = _context.getExtension(extensionName);

      _extensionCache[extensionName] = extensionObject;

      return extensionObject;
    }
  }

  void _bindAttributeDataTable(AttributeDataTable attributeDataTable) {
    if (attributeDataTable != _boundAttributeDataTable) {
      if (attributeDataTable == null) {
        _context.bindBuffer(WebGL.ARRAY_BUFFER, null);
      } else {
        _context.bindBuffer(
            WebGL.ARRAY_BUFFER, geometryResources._getVBO(attributeDataTable));
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
            WebGL.ELEMENT_ARRAY_BUFFER, geometryResources._getIBO(indexList));
      }

      _boundIndexList = indexList;
    }
  }

  void _bindSampler2D(Sampler2D sampler) {
    if (sampler != _boundSampler2D && sampler != null) {
      if (_textureUnitsSamplers.containsValue(sampler)) {
        final unit = _textureUnitsSamplers.inverse[sampler];

        if (unit != _activeTextureUnit) {
          _updateActiveTextureUnit(unit);
        }

        _recentlyUsedTextureUnits
          ..remove(unit)
          ..addFirst(unit);
      } else {
        final unit = _recentlyUsedTextureUnits.last;

        _updateActiveTextureUnit(unit);

        _context.bindTexture(
            WebGL.TEXTURE_2D, samplerResources._getTO(sampler));

        _textureUnitsSamplers[unit] = sampler;

        _recentlyUsedTextureUnits
          ..removeLast()
          ..addFirst(unit);
      }

      _boundSampler2D = sampler;
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
          .useProgram(programResources._getGLProgram(program).glProgramObject);
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
    if (depthTest != null) {
      if (!_depthTestEnabled) {
        _context.enable(WebGL.DEPTH_TEST);
        _depthTestEnabled = true;
      }

      if (!identical(depthTest, _depthTest)) {
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

        if (depthTest.polygonOffset != _depthTest.polygonOffset) {
          if (depthTest.polygonOffset != null) {
            if (!_polygonOffsetEnabled) {
              _context.enable(WebGL.POLYGON_OFFSET_FILL);

              _polygonOffsetEnabled = true;
            }

            _context.polygonOffset(
                depthTest.polygonOffset.factor, depthTest.polygonOffset.units);
          } else if (_polygonOffsetEnabled) {
            _context.disable(WebGL.POLYGON_OFFSET_FILL);

            _polygonOffsetEnabled = false;
          }
        }

        _depthTest = depthTest;
      }
    } else if (depthTest == null && _depthTestEnabled) {
      _context.disable(WebGL.DEPTH_TEST);
      _depthTestEnabled = false;
    }
  }

  void _updateStencilTest(StencilTest stencilTest) {
    if (stencilTest != null) {
      if (!_stencilTestEnabled) {
        _context.enable(WebGL.STENCIL_TEST);
        _stencilTestEnabled = true;
      }

      if (!identical(stencilTest, _stencilTest)) {
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
      }
    } else if (stencilTest == null && _stencilTestEnabled) {
      _context.disable(WebGL.STENCIL_TEST);
      _stencilTestEnabled = false;
    }
  }

  void _updateBlending(Blending blending) {
    if (blending != null) {
      if (!_blendingEnabled) {
        _context.enable(WebGL.BLEND);
        _blendingEnabled = true;
      }

      if (!identical(blending, _blending)) {
        if (blending.colorFunction != _blending.colorFunction ||
            blending.alphaFunction != _blending.alphaFunction) {
          _context.blendEquationSeparate(
              _blendingFunctionMap[blending.colorFunction],
              _blendingFunctionMap[blending.alphaFunction]);
        }

        if (blending.sourceColorFactor != _blending.sourceColorFactor ||
            blending.sourceAlphaFactor != _blending.sourceAlphaFactor ||
            blending.destinationColorFactor !=
                _blending.destinationColorFactor ||
            blending.destinationAlphaFactor !=
                _blending.destinationAlphaFactor) {
          _context.blendFuncSeparate(
              _blendingFactorMap[blending.sourceColorFactor],
              _blendingFactorMap[blending.destinationColorFactor],
              _blendingFactorMap[blending.sourceAlphaFactor],
              _blendingFactorMap[blending.destinationAlphaFactor]);
        }

        _blending = blending;
      }
    } else if (blending == null && _blendingEnabled) {
      _context.disable(WebGL.BLEND);
      _blendingEnabled = false;
    }
  }

  void _updateFaceCulling(CullingMode faceCulling) {
    if (faceCulling != null) {
      if (!_faceCullingEnabled) {
        _context.enable(WebGL.CULL_FACE);
        _faceCullingEnabled = true;
      }

      if (faceCulling != _faceCulling) {
        _context.cullFace(_cullingModeMap[faceCulling]);
        _faceCulling = faceCulling;
      }
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
    if (scissorBox != null) {
      if (!_scissorTestEnabled) {
        _context.enable(WebGL.SCISSOR_TEST);
        _scissorTestEnabled = true;
      }

      if (scissorBox != _scissorBox) {
        _context.scissor(
            scissorBox.x, scissorBox.y, scissorBox.width, scissorBox.height);

        _scissorBox = scissorBox;
      }
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
