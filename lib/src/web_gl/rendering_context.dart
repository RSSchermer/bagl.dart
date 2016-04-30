part of web_gl;

class RenderingContext {
  final CanvasElement canvas;

  WebGL.RenderingContext _context;

  Program _activeProgram;

  AttributeDataFrame _boundAttributeDataFrame;

  IndexGeometry _boundGeometry;

  Map<IndexGeometry, WebGL.Buffer> _geometryVBOMap = new Map();

  Map<AttributeDataFrame, WebGL.Buffer> _attributeDataFrameVBOMap = new Map();

  Map<AttributeDataFrame, int> _attributeDataFrameReferenceCounts = new Map();

  Map<int, VertexAttribute> _locationAttributeMap = new Map();

  Set<int> _enabledAttribLocations = new Set();

  RenderingContext(this.canvas, {
    bool alpha: true,
    bool depth: true,
    bool stencil: false,
    bool antialias: true,
    bool premultipliedAlpha: true,
    bool preserveDrawingBuffer: false,
    bool preferLowPowerToHighPerformance: false,
    bool failIfMajorPerformanceCaveat: false
  }) {
    _context = canvas.getContext('webgl', {
      'alpha': alpha,
      'depth': depth,
      'stencil': stencil,
      'antialias': antialias,
      'premultipliedAlpha': premultipliedAlpha,
      'preserveDrawingBuffer': preserveDrawingBuffer,
      'preferLowPowerToHighPerformance': preferLowPowerToHighPerformance,
      'failIfMajorPerformanceCaveat': failIfMajorPerformanceCaveat
    }) ?? canvas.getContext('experimental-webgl', {
      'alpha': alpha,
      'depth': depth,
      'stencil': stencil,
      'antialias': antialias,
      'premultipliedAlpha': premultipliedAlpha,
      'preserveDrawingBuffer': preserveDrawingBuffer,
      'preferLowPowerToHighPerformance': preferLowPowerToHighPerformance,
      'failIfMajorPerformanceCaveat': failIfMajorPerformanceCaveat
    });

    _context.clearColor(0.7, 0.7, 0.7, 1.0);
    _context.clear(WebGL.COLOR_BUFFER_BIT);
  }

  void attach(IndexGeometry geometry) {
    if (!isAttached(geometry)) {
      var geometryVBO = _context.createBuffer();
      var usage = geometry.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

      _context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, geometryVBO);
      _context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, geometry.indices, usage);
      _geometryVBOMap[geometry] = geometryVBO;

      geometry.vertices.attributeDataFrames.forEach((frame) {
        if ((_attributeDataFrameReferenceCounts[frame] ?? 0) >= 1) {
          _attributeDataFrameReferenceCounts[frame] += 1;
        } else {
          var frameVBO = _context.createBuffer();
          var usage = frame.isDynamic ? WebGL.DYNAMIC_DRAW : WebGL.STATIC_DRAW;

          _context.bindBuffer(WebGL.ARRAY_BUFFER, frameVBO);
          _context.bufferData(WebGL.ARRAY_BUFFER, frame.buffer, usage);
          _attributeDataFrameVBOMap[frame] = frameVBO;
          _attributeDataFrameReferenceCounts[frame] = 1;
        }
      });
    }
  }

  void detach(IndexGeometry geometry) {
    if (isAttached(geometry)) {
      _context.deleteBuffer(_geometryVBOMap[geometry]);
      _geometryVBOMap.remove(geometry);

      geometry.vertices.attributeDataFrames.forEach((frame) {
        if (_attributeDataFrameReferenceCounts[frame] > 1) {
          _attributeDataFrameReferenceCounts[frame] -= 1;
        } else {
          _context.deleteBuffer(_attributeDataFrameVBOMap[frame]);
          _attributeDataFrameVBOMap.remove(frame);
          _attributeDataFrameReferenceCounts.remove(frame);
        }
      });
    }
  }

  bool isAttached(IndexGeometry geometry) =>
      _geometryVBOMap.containsKey(geometry);

  void _bindAttributeDataFrame(AttributeDataFrame frame) {
    if (frame != _boundAttributeDataFrame) {
      _context.bindBuffer(WebGL.ARRAY_BUFFER, _attributeDataFrameVBOMap[frame]);
      _boundAttributeDataFrame = frame;
    }
  }

  void _bindGeometry(IndexGeometry geometry) {
    if (geometry != _boundGeometry) {
      _context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, _geometryVBOMap[geometry]);
      _boundGeometry = geometry;
    }
  }

  void _useProgram(Program program) {
    if (program != _activeProgram) {
      _context.useProgram(program._program);
      _activeProgram = program;
    }
  }
}
