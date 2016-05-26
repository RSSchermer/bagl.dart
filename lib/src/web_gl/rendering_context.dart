part of web_gl;

/// BaGL rendering context for an HTML canvas element.
class RenderingContext {
  static Map<CanvasElement, RenderingContext> _canvasContextMap = new Map();

  /// The canvas element this rendering context is associated with.
  final CanvasElement canvas;

  /// The WebGL rendering context associated with the [canvas].
  WebGL.RenderingContext _context;

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

  /// The shader program attribute locations that are currently enabled.
  Set<int> _enabledAttributeLocations = new Set();

  /// The value that is currently set as the clearColor on the WebGL context.
  Vector4 _clearColor = new Vector4.zero();

  /// The value that is currently set as the clearDepth on the WebGL context.
  double _clearDepth = 1.0;

  /// The value that is currently set as the clearStencil on the WebGL context.
  int _clearStencil = 0;

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

  void clear({Vector4 color, double depth, int stencil}) {
    var mask = 0;

    if (color != null) {
      if (color != _clearColor) {
        _context.clearColor(color.r, color.g, color.b, color.a);
        _clearColor = color;
      }

      mask &= WebGL.COLOR_BUFFER_BIT;
    }

    if (depth != null) {
      if (depth != _clearDepth) {
        _context.clearDepth(depth);
        _clearDepth = depth;
      }

      mask &= WebGL.DEPTH_BUFFER_BIT;
    }

    if (stencil != null) {
      if (stencil != _clearStencil) {
        _context.clearStencil(stencil);
        _clearStencil = stencil;
      }

      mask &= WebGL.STENCIL_BUFFER_BIT;
    }

    if (mask != 0) {
      _context.clear(mask);
    }
  }

  void draw(IndexGeometry geometry, Program program,
      {Map<String, String> attributeNameMap}) {
    attributeNameMap ??= new Map();

    attach(geometry);
    _useProgram(program);

    final unusedAttribLocations = _enabledAttributeLocations.toSet();

    // Enable vertex attributes and adjust vertex attribute pointers if
    // necessary
    geometry.vertices.attributes.forEach((name, attribute) {
      final columnCount = attribute.columnCount;
      final columnSize = attribute.columnSize;
      final startLocation =
          program._getLocation(attributeNameMap[name] ?? name);
      final table = attribute.attributeDataTable;
      final stride = table.elementSizeInBytes;

      for (var i = 0; i < columnCount; i++) {
        var location = startLocation + i;

        // If the attribute bound to the location is null or an attribute other
        // than the current attribute, set up a new vertex attribute pointer.
        if (_locationAttributeMap[location] != attribute) {
          var offset = attribute.offsetInBytes + i * columnSize * 4;

          _bindAttributeData(table);
          _context.vertexAttribPointer(
              location, columnSize, WebGL.FLOAT, false, stride, offset);

          _locationAttributeMap[location] = attribute;
        }

        if (!_enabledAttributeLocations.contains(location)) {
          _context.enableVertexAttribArray(location);
          _enabledAttributeLocations.add(location);
        }

        unusedAttribLocations.remove(location);
      }
    });

    // Disable unused attribute positions
    for (var position in unusedAttribLocations) {
      _context.disableVertexAttribArray(position);
      _enabledAttributeLocations.remove(position);
    }

    // Set up uniforms

    // Draw elements
    _bindIndexData(geometry.indices);
    _context.drawElements(_topologyMap[geometry.topology], geometry.indexCount,
        WebGL.UNSIGNED_SHORT, geometry.offset * IndexList.BYTES_PER_ELEMENT);
  }

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

  void _useProgram(Program program) {
    if (program != _activeProgram) {
      _context.useProgram(program._program);
      _activeProgram = program;
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
