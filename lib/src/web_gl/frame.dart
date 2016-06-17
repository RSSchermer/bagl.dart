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

  /// Draws the [geometry] using the [program] and the [uniforms].
  ///
  /// Sets up the rendering pipeline to use the [program]. Each of the
  /// [program]'s active uniform variables is looked up by name in the
  /// [uniforms] map and set to the specified value. Valid value types for
  /// uniform values are: [bool], [int], [double], [Vector2], [Vector3],
  /// [Vector4], [Matrix2], [Matrix3], [Matrix4], [Int32List], [Float32List],
  /// [Vector2List], [Vector3List], [Vector4List], [Matrix2List], [Matrix3List],
  /// [Matrix4List], [Sampler2D], [SamplerCube].
  ///
  /// The rendering process may be further configured with the following
  /// optional parameters:
  ///
  /// - [depthTest]: instructs the rendering back-end on how the depth test
  ///   should be performed, see the documentation for [DepthTest] for details.
  ///   Defaults to `null`, in which case depth testing will be disabled.
  /// - [stencilTest]: instructs the rendering back-end on how the stencil test
  ///   should be performed, see the documentation for [StencilTest] for
  ///   details. Defaults to `null`, in which case stencil testing will be
  ///   disabled.
  /// - [blending]: instructs the rendering back-end on how blending should be
  ///   performed, see the documentation for [Blending] for details. Defaults to
  ///   `null`, in which case blending will be disabled.
  /// - [faceCulling]: sets the [CullingMode] that will be used for face
  ///   culling. Defaults to `null`, in which case face culling will be
  ///   disabled.
  /// - [frontFace]: sets the [WindingOrder] that will be used to determine
  ///   which of a triangle primitive's 2 faces is the front face. Defaults to
  ///   `WindingOrder.counterClockwise`.
  /// - [colorMask]: specifies which color color components can be written to
  ///   the color attachment. See [ColorMask] for details. By default all color
  ///   components will be written to the color attachment.
  /// - [lineWidth]: sets the width with which [Line] primitives will be drawn.
  ///   Defaults to `1`.
  /// - [scissorBox]: fragments outside the given [Region] will be discarded by
  ///   the scissor test. Defaults to `null`, in which case scissor testing will
  ///   be disabled.
  /// - [viewport]: sets the viewport to the given region of this [Frame].
  ///   Defaults to `null`, in which case the viewport is set to cover the frame
  ///   exactly.
  /// - [dithering]: whether or not dithering will be performed before writing
  ///   color components or indices to the color buffer. Defaults to `true`.
  /// - [attributeNameMap]: may be used to map the [geometry]'s attributes to
  ///   different attribute names in case the [geometry]'s attribute names do
  ///   not match the attribute names used by the rendering program.
  ///
  /// Finally, the thus configured rendering pipeline is used to process the
  /// [geometry], updating this [Frame]'s relevant output buffers accordingly.
  ///
  /// Throws a [ShaderCompilationError] if the [program]'s vertex shader or
  /// fragment shader fails to compile.
  ///
  /// Throws a [ProgramLinkingError] if the [program] fails to link.
  ///
  /// Throws an [ArgumentError] if one of the [geometry]'s vertex attributes
  /// has no matching active attribute in the [program].
  ///
  /// Throws an [ArgumentError] if a uniform variable is active in the
  /// [program], but no [value] with a matching name is found in the [uniforms]
  /// map.
  ///
  /// Throws an [ArgumentError] if a uniform value is provided by the [uniforms]
  /// map, but no matching uniform variable is active in the [program].
  ///
  /// Throws an [ArgumentError] if one of the uniform values provided in the
  /// [uniforms] map is not of a valid type ([bool], [int], [double], [Vector2],
  /// [Vector3], [Vector4], [Matrix2], [Matrix3], [Matrix4], [Int32List],
  /// [Float32List], [Vector2List], [Vector3List], [Vector4List], [Matrix2List],
  /// [Matrix3List], [Matrix4List], [Sampler2D], [SamplerCube]).
  void draw(
      IndexGeometry geometry, Program program, Map<String, dynamic> uniforms,
      {DepthTest depthTest: null,
      StencilTest stencilTest: null,
      Blending blending: null,
      CullingMode faceCulling: null,
      WindingOrder frontFace: WindingOrder.counterClockwise,
      ColorMask colorMask: const ColorMask(true, true, true, true),
      num lineWidth: 1,
      Region scissorBox: null,
      Region viewport: null,
      bool dithering: true,
      Map<String, String> attributeNameMap: const {}}) {
    context.provisionGeometry(geometry);
    context.provisionProgram(program);
    context._useProgram(program);

    final glProgramInfo = context._programGLProgramInfoMap[program];

    final unusedAttribLocations = context._enabledAttributeLocations.toSet();

    // Enable vertex attributes and adjust vertex attribute pointers if
    // necessary
    geometry.vertices.attributes.forEach((name, attribute) {
      name = attributeNameMap[name] ?? name;
      final columnCount = attribute.columnCount;
      final columnSize = attribute.columnSize;
      final startLocation = glProgramInfo.attributeLocationsByName[name];
      final table = attribute.attributeDataTable;
      final stride = table.elementSizeInBytes;

      if (startLocation == null) {
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
    final missingUniforms = glProgramInfo.uniformLocationsByName.keys.toSet();

    uniforms.forEach((name, value) {
      final location = glProgramInfo.uniformLocationsByName[name];

      if (location == null) {
        throw new ArgumentError('A value was provided for a uniform named '
            '"$name", but no active uniform with that name was found in the '
            'current shader program.');
      }

      if (context._uniformValues[location] != value) {
        if (value is bool) {
          _context.uniform1i(location, value ? 1 : 0);
        } else if (value is int) {
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
              'types are: bool, int, double, Vector2, Vector3, Vector4, '
              'Matrix2, Matrix3, Matrix4, Int32List, Float32List, Vector2List, '
              'Vector3List, Vector4List, Matrix2List, Matrix3List, '
              'Matrix4List, Sampler2D, SamplerCube.');
        }
      }

      context._uniformValues[location] = value;
      missingUniforms.remove(name);
    });

    if (missingUniforms.isNotEmpty) {
      throw new ArgumentError('No value was provided for the uniform named '
          '"${missingUniforms.first}". Values must be provided for all '
          'uniforms.');
    }

    // Set the remaining draw options
    context._updateDepthTest(depthTest);
    context._updateStencilTest(stencilTest);
    context._updateBlending(blending);
    context._updateFaceCulling(faceCulling);
    context._updateFrontFace(frontFace);
    context._updateColorMask(colorMask);
    context._updateLineWidth(lineWidth);
    context._updateScissorBox(scissorBox);
    context._updateViewport(viewport ?? new Region(0, 0, width, height));
    context._updateDithering(dithering);

    // Draw elements to this frame
    context._bindFrame(this);
    context._bindIndexData(geometry.indices);
    _context.drawElements(_topologyMap[geometry.topology], geometry.indexCount,
        WebGL.UNSIGNED_SHORT, geometry.offset * IndexList.BYTES_PER_ELEMENT);
  }

  /// Resets this [Frame]'s color attachment to the specified [color] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearColor(Vector4 color, [Region region]) {
    context._updateClearColor(color);
    context._updateScissorBox(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT);
  }

  /// Resets this [Frame]'s depth attachment to the specified [depth] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearDepth(double depth, [Region region]) {
    context._updateClearDepth(depth);
    context._updateScissorBox(region);
    _context.clear(WebGL.DEPTH_BUFFER_BIT);
  }

  /// Resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearStencil(int stencil, [Region region]) {
    context._updateClearStencil(stencil);
    context._updateScissorBox(region);
    _context.clear(WebGL.STENCIL_BUFFER_BIT);
  }

  /// Resets this [Frame]'s color and depth attachments.
  ///
  /// Resets this [Frame]'s color attachment to the specified [color] value and
  /// resets this [Frame]'s depth attachment to the specified [depth] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearColorAndDepth(Vector4 color, double depth, [Region region]) {
    context._updateClearColor(color);
    context._updateClearDepth(depth);
    context._updateScissorBox(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT & WebGL.DEPTH_BUFFER_BIT);
  }

  /// Resets this [Frame]'s color and stencil attachments.
  ///
  /// Resets this [Frame]'s color attachment to the specified [color] value and
  /// resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearColorAndStencil(Vector4 color, int stencil, [Region region]) {
    context._updateClearColor(color);
    context._updateClearStencil(stencil);
    context._updateScissorBox(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT & WebGL.STENCIL_BUFFER_BIT);
  }

  /// Resets this [Frame]'s depth and stencil attachments.
  ///
  /// Resets this [Frame]'s depth attachment to the specified [depth] value and
  /// resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearDepthAndStencil(double depth, int stencil, [Region region]) {
    context._updateClearDepth(depth);
    context._updateClearStencil(stencil);
    context._updateScissorBox(region);
    _context.clear(WebGL.DEPTH_BUFFER_BIT & WebGL.STENCIL_BUFFER_BIT);
  }

  /// Resets all of this [Frame]'s output attachments.
  ///
  /// Resets this [Frame]'s color attachment to the specified [color] value,
  /// resets this [Frame]'s depth attachment to the specified [depth] value and
  /// resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearAll(Vector4 color, double depth, int stencil, [Region region]) {
    context._updateClearColor(color);
    context._updateClearDepth(depth);
    context._updateClearStencil(stencil);
    context._updateScissorBox(region);
    _context.clear(WebGL.COLOR_BUFFER_BIT &
        WebGL.DEPTH_BUFFER_BIT &
        WebGL.STENCIL_BUFFER_BIT);
  }
}
