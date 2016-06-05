part of web_gl;

class Frame {
  /// The [RenderingContext] to which this [Frame] belongs.
  final RenderingContext context;

  WebGL.RenderingContext _context;

  WebGL.Framebuffer _framebufferObject;

  Frame._default(RenderingContext context)
      : context = context,
        _context = context._context;

  /// This [Frame]'s width in pixels.
  int get width => context.canvas.width;

  /// This [Frame]'s height in pixels.
  int get height => context.canvas.height;

  ///
  ///
  ///
  /// - [scissorBox]: fragments outside the given [Region] will not be updated
  ///   by this draw call.
  /// - [viewport]: primitives outside the given [Region] will be culled before
  ///   rasterization.
  void draw(
      IndexGeometry geometry, Program program, Map<String, dynamic> uniforms,
      {Map<String, String> attributeNameMap: const {},
      Blend blend: null,
      ColorMask colorMask: null,
      DepthTest depthTest: null,
      bool dithering: false,
      CullingMode faceCulling: null,
      WindingOrder frontFace: WindingOrder.counterClockwise,
      int lineWidth: 1,
      Region scissorBox: null,
      StencilTest stencilTest: null,
      Region viewport: null}) {
    if (program.context != context) {
      throw new ArgumentError('The context on which the program is defined '
          'does not match this frame\'s context.');
    }

    context.attach(geometry);
    context._useProgram(program);

    final unusedAttribLocations = context._enabledAttributeLocations.toSet();

    // Enable vertex attributes and adjust vertex attribute pointers if
    // necessary
    geometry.vertices.attributes.forEach((name, attribute) {
      name = attributeNameMap[name] ?? name;
      final columnCount = attribute.columnCount;
      final columnSize = attribute.columnSize;
      final startLocation = program._getAttributeLocation(name);
      final table = attribute.attributeDataTable;
      final stride = table.elementSizeInBytes;

      if (startLocation == -1) {
        throw new ArgumentError('No active attribute named "$name" was found '
            'in shader program.');
      }

      for (var i = 0; i < columnCount; i++) {
        var location = startLocation + i;

        // If the attribute bound to the location is null or an attribute other
        // than the current attribute, set up a new vertex attribute pointer.
        if (context._locationAttributeMap[location] != attribute) {
          var offset = attribute.offsetInBytes + i * columnSize * 4;

          context._bindAttributeData(table);
          _context.vertexAttribPointer(
              location, columnSize, WebGL.FLOAT, false, stride, offset);

          context._locationAttributeMap[location] = attribute;
        }

        if (!context._enabledAttributeLocations.contains(location)) {
          _context.enableVertexAttribArray(location);
          context._enabledAttributeLocations.add(location);
        }

        unusedAttribLocations.remove(location);
      }
    });

    // Disable unused attribute positions
    for (var position in unusedAttribLocations) {
      _context.disableVertexAttribArray(position);
      context._enabledAttributeLocations.remove(position);
    }

    // Set uniform values
    final missingUniforms = program._uniformNameLocationMap.keys.toSet();

    uniforms.forEach((name, value) {
      final location = program._uniformNameLocationMap[name];

      if (location == null) {
        throw new ArgumentError('A value was provided for a uniform named '
            '"$name", but no active uniform with that name was found in the '
            'current shader program.');
      }

      if (context._uniformValueMap[location] != value) {
        if (value is int) {
          _context.uniform1i(location, value);
        } else if (value is double) {
          _context.uniform1f(location, value);
        } else if (value is Vector2) {
          _context.uniform2f(location, value.x, value.y);
        } else if (value is Vector3) {
          _context.uniform3f(location, value.x, value.y, value.z);
        } else if (value is Vector4) {
          _context.uniform4f(location, value.x, value.y, value.z, value.w);
        } else if (value is Matrix2) {
          var columnPacked = new Float32List(4);

          columnPacked[0] = value.r0c0;
          columnPacked[1] = value.r1c0;
          columnPacked[2] = value.r0c1;
          columnPacked[3] = value.r1c1;

          _context.uniformMatrix2fv(location, false, columnPacked);
        } else if (value is Matrix3) {
          var columnPacked = new Float32List(9);

          columnPacked[0] = value.r0c0;
          columnPacked[1] = value.r1c0;
          columnPacked[2] = value.r2c0;
          columnPacked[3] = value.r0c1;
          columnPacked[4] = value.r1c1;
          columnPacked[5] = value.r2c1;
          columnPacked[6] = value.r0c2;
          columnPacked[7] = value.r1c2;
          columnPacked[8] = value.r2c2;

          _context.uniformMatrix2fv(location, false, columnPacked);
        } else if (value is Matrix4) {
          var columnPacked = new Float32List(16);

          columnPacked[0] = value.r0c0;
          columnPacked[1] = value.r1c0;
          columnPacked[2] = value.r2c0;
          columnPacked[3] = value.r3c0;
          columnPacked[4] = value.r0c1;
          columnPacked[5] = value.r1c1;
          columnPacked[6] = value.r2c1;
          columnPacked[7] = value.r3c1;
          columnPacked[8] = value.r0c2;
          columnPacked[9] = value.r1c2;
          columnPacked[10] = value.r2c2;
          columnPacked[11] = value.r3c2;
          columnPacked[12] = value.r0c3;
          columnPacked[13] = value.r1c3;
          columnPacked[14] = value.r2c3;
          columnPacked[15] = value.r3c3;

          _context.uniformMatrix2fv(location, false, columnPacked);
        } else if (value is Int32List) {
          _context.uniform1iv(location, value);
        } else if (value is Float32List) {
          _context.uniform2fv(location, value);
        } else if (value is Vector2List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 2);

          _context.uniform2fv(location, view);
        } else if (value is Vector3List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 3);

          _context.uniform3fv(location, view);
        } else if (value is Vector4List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 4);

          _context.uniform4fv(location, view);
        } else if (value is Matrix2List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 4);

          _context.uniformMatrix2fv(location, false, view);
        } else if (value is Matrix3List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 9);

          _context.uniformMatrix3fv(location, false, view);
        } else if (value is Matrix4List) {
          final view = new Float32List.view(
              value.buffer, value.offsetInBytes, value.length * 16);

          _context.uniformMatrix4fv(location, false, view);
        } else {
          new ArgumentError('The value provided for the uniform named "$name" '
              'is of an unsupported type (${value.runtimeType}). Supported '
              'types are: int, double, Vector2, Vector3, Vector4, Matrix2, '
              'Matrix3, Matrix4, Int32List, Float32List, Vector2List, '
              'Vector3List, Vector4List, Matrix2List, Matrix3List, '
              'Matrix4List, Sampler.');
        }
      }

      context._uniformValueMap[location] = value;
      missingUniforms.remove(name);
    });

    if (missingUniforms.isNotEmpty) {
      throw new ArgumentError('No value was provided for the uniform named '
          '"${missingUniforms.first}". Values must be provided for all '
          'uniforms.');
    }

    // Set the remaining draw options

    // Draw elements to this frame
    context._bindFrame(this);
    context._bindIndexData(geometry.indices);
    _context.drawElements(_topologyMap[geometry.topology], geometry.indexCount,
        WebGL.UNSIGNED_SHORT, geometry.offset * IndexList.BYTES_PER_ELEMENT);
  }

  void clearColor(Vector4 color, [Region region]) {
    context._updateClearColor(color);
    context._updateScissor(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT);
  }

  void clearDepth(double depth, [Region region]) {
    context._updateClearDepth(depth);
    context._updateScissor(region);
    _context.clear(WebGL.DEPTH_BUFFER_BIT);
  }

  void clearStencil(int stencil, [Region region]) {
    context._updateClearStencil(stencil);
    context._updateScissor(region);
    _context.clear(WebGL.STENCIL_BUFFER_BIT);
  }

  void clearColorAndDepth(Vector4 color, double depth, [Region region]) {
    context._updateClearColor(color);
    context._updateClearDepth(depth);
    context._updateScissor(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT & WebGL.DEPTH_BUFFER_BIT);
  }

  void clearColorAndStencil(Vector4 color, int stencil, [Region region]) {
    context._updateClearColor(color);
    context._updateClearStencil(stencil);
    context._updateScissor(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT & WebGL.STENCIL_BUFFER_BIT);
  }

  void clearDepthAndStencil(double depth, int stencil, [Region region]) {
    context._updateClearDepth(depth);
    context._updateClearStencil(stencil);
    context._updateScissor(region);
    _context.clear(WebGL.DEPTH_BUFFER_BIT & WebGL.STENCIL_BUFFER_BIT);
  }

  void clearAll(Vector4 color, double depth, int stencil, [Region region]) {
    context._updateClearColor(color);
    context._updateClearDepth(depth);
    context._updateClearStencil(stencil);
    context._updateScissor(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT &
        WebGL.DEPTH_BUFFER_BIT &
        WebGL.STENCIL_BUFFER_BIT);
  }
}
