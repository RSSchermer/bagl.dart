part of rendering;

/// Rectangular pixel surface onto which geometry primitives can be drawn.
///
/// Pixels can be drawn on the [Frame] by passing geometry primitives to the
/// rendering pipeline using the [draw] method. The rendering pipeline will
/// process these primitives and update the [Frame]'s color, depth and stencil
/// output attachments. The methods [clearColor], [clearDepth], [clearStencil],
/// [clearColorAndDepth], [clearColorAndStencil], [clearDepthAndStencil] and
/// [clearAll] may be used to reset (regions of) the [Frame]'s output
/// attachments.
class Frame {
  /// The [RenderingContext] with which this [Frame] is associated.
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
  /// [Vector4], [Matrix2], [Matrix3], [Matrix4], [Sampler2D], [Struct],
  /// [Int32List], [Float32List], [Vector2List], [Vector3List], [Vector4List],
  /// [Matrix2List], [Matrix3List], [Matrix4List], [List]<[Sampler2D]>,
  /// [List]<[Struct]>.
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
  /// - [attributeNameMap]: may be used to map the [program]'s attributes to
  ///   different attribute names in case the [program]'s attribute names do
  ///   not match the attribute names used by the [geometry].
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
  /// [Vector3], [Vector4], [Matrix2], [Matrix3], [Matrix4], [Sampler2D],
  /// [Struct], [Int32List], [Float32List], [Vector2List], [Vector3List],
  /// [Vector4List], [Matrix2List], [Matrix3List], [Matrix4List],
  /// [List]<[Sampler2D]>, [List]<[Struct]>).
  ///
  /// Throws an [ArgumentError] if more [Sampler] type uniforms are provided
  /// than [context.maxTextureUnits].
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
    context.geometryResources.provisionFor(geometry);
    context.programResources.provisionFor(program);
    context._useProgram(program);

    final glProgram = context.programResources._getGLProgram(program);
    final unusedAttribLocations = context._enabledAttributeLocations.toSet();

    // Enable vertex attributes and adjust vertex attribute pointers if
    // necessary
    glProgram.attributeInfoByName.forEach((name, attributeInfo) {
      final mappedName = attributeNameMap[name] ?? name;
      final attribute = geometry.vertices.attributes[mappedName];

      if (attribute == null) {
        throw new ArgumentError('The geometry does not define an attribute '
            'matching the "$name" attribute on the shader program.');
      }

      // TODO: add check to see if attributeInfo.type matches attribute?

      final columnCount = attribute.columnCount;
      final columnSize = attribute.columnSize;
      final table = attribute.attributeDataTable;
      final stride = table.elementSizeInBytes;
      final startLocation = attributeInfo.location;

      for (var i = 0; i < columnCount; i++) {
        var location = startLocation + i;

        // If the attribute bound to the location is null or an attribute other
        // than the current attribute, set up a new vertex attribute pointer.
        if (context._locationAttributeMap[location] != attribute) {
          var offset = attribute.offsetInBytes + i * columnSize * 4;

          context._bindAttributeDataTable(table);
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
    final missingUniforms = glProgram.uniformInfoByName.keys.toSet();
    var samplerCount = 0;

    uniforms.forEach((name, value) {
      glProgram.bindUniformValue(name, value);

      if (value is Struct) {
        for (var member in value.members) {
          missingUniforms.remove("$name.$member");
        }
      } else if (value is List<Struct>) {
        for (var i = 0; i < value.length; i++) {
          for (var member in value[i].members) {
            missingUniforms.remove("$name[$i].$member");
          }
        }
      } else {
        missingUniforms.remove(name);
      }

      if (value is Sampler) {
        samplerCount++;
      }
    });

    if (missingUniforms.isNotEmpty) {
      throw new ArgumentError('No value was provided for the uniform named '
          '"${missingUniforms.first}". Values must be provided for all '
          'active uniforms.');
    }

    if (samplerCount > context.maxTextureUnits) {
      throw new ArgumentError('Tried to bind $samplerCount sampler uniforms, '
          'but the current context only supports ${context.maxTextureUnits}.');
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
    context._bindIndexList(geometry.indices);
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
