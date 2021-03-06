part of bagl.rendering;

/// Rectangular pixel surface onto which geometry primitives can be drawn.
///
/// Pixels can be drawn on the [Frame] by passing geometry primitives to the
/// rendering pipeline using the [draw] method. The rendering pipeline will
/// process these primitives and update the [Frame]'s color, depth and stencil
/// output attachments. The methods [clearColor], [clearDepth], [clearStencil],
/// [clearColorAndDepth], [clearColorAndStencil], [clearDepthAndStencil] and
/// [clearAll] may be used to reset (regions of) the [Frame]'s output
/// attachments.
abstract class Frame {
  /// The [RenderingContext] with which this [Frame] is associated.
  final RenderingContext context;

  WebGL.RenderingContext _context;

  Frame._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// This [Frame]'s width in pixels.
  int get width;

  /// This [Frame]'s height in pixels.
  int get height;

  /// Draws the [primitives] using the [program] and the [uniforms].
  ///
  /// Sets up the rendering pipeline to use the [program]. Each of the
  /// [program]'s active uniform variables is looked up by name in the
  /// [uniforms] map and set to the specified value. Valid value types for
  /// uniform values are: [bool], [int], [double], [Vector2], [Vector3],
  /// [Vector4], [Matrix2], [Matrix3], [Matrix4], [Sampler2D], [Struct],
  /// [Int32List], [Float32List], [Vector2List], [Vector3List], [Vector4List],
  /// [Matrix2List], [Matrix3List], [Matrix4List], [List]<[Sampler2D]>,
  /// [List]<[Struct]>. The value type must match the type specified for the
  /// uniform in the shader program.
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
  /// - [scissorBox]: fragments outside the given [Rectangle] will be discarded
  ///   by the scissor test. Defaults to `null`, in which case scissor testing
  ///   will be disabled.
  /// - [viewport]: sets the viewport to the given region of this [Frame].
  ///   Defaults to `null`, in which case the viewport is set to cover the frame
  ///   exactly.
  /// - [dithering]: whether or not dithering will be performed before writing
  ///   color components or indices to the color buffer. Defaults to `true`.
  /// - [attributeNameMap]: may be used to map the [program]'s attributes to
  ///   different attribute names in case the [program]'s attribute names do
  ///   not match the attribute names used by the [primitives].
  /// - [autoProvisioning]: whether or not the necessary GPU resources should
  ///   be provisioned automatically for the [primitives], the [program] and any
  ///   [Sampler] uniforms. If set to `false`, then the necessary resources
  ///   should be provisioned prior to the draw call, see
  ///   [context.geometryResources], [context.programResources] and
  ///   [context.textureResources]. Defaults to `true`.
  ///
  /// Finally, the thus configured rendering pipeline is used to process the
  /// [primitives], updating this [Frame]'s relevant output buffers accordingly.
  ///
  /// Throws a [ShaderCompilationError] if the [program]'s vertex shader or
  /// fragment shader fails to compile.
  ///
  /// Throws a [ProgramLinkingError] if the [program] fails to link.
  ///
  /// Throws an [ArgumentError] if one of the [primitives]'s vertex attributes
  /// has no matching active attribute in the [program].
  ///
  /// Throws an [Argument] if the [primitives] use a 32 bit index list
  /// ([Index32List]), but 32 bit indices are not supported by the [context].
  ///
  /// Throws an [ArgumentError] if a uniform variable is active in the
  /// [program], but no [value] with a matching name is found in the [uniforms]
  /// map.
  ///
  /// Throws an [ArgumentError] if one of the uniform values does not match the
  /// expected type in the shader program.
  ///
  /// Throws an [ArgumentError] if more [Sampler] type uniforms are provided
  /// than [context.maxTextureUnits].
  ///
  /// Throws a [StateError] if [autoProvisioning] is `false` and not all of the
  /// required geometry, program or sampler resources have been provisioned.
  void draw(PrimitiveSource primitives, Program program, Uniforms uniforms,
      {DepthTest depthTest: null,
      StencilTest stencilTest: null,
      Blending blending: null,
      CullingMode faceCulling: null,
      WindingOrder frontFace: WindingOrder.counterClockwise,
      ColorMask colorMask: const ColorMask(true, true, true, true),
      num lineWidth: 1,
      Rectangle<int> scissorBox: null,
      Rectangle<int> viewport: null,
      bool dithering: true,
      Map<String, String> attributeNameMap: const {},
      bool autoProvisioning: true}) {
    var glProgram = context.programResources._getGLProgram(program);

    if (glProgram == null) {
      if (autoProvisioning) {
        context.programResources.provisionFor(program);

        glProgram = context.programResources._getGLProgram(program);
      } else {
        throw new StateError('GPU resources have not yet been provisioned for '
            'the program and `autoProvisioning` was set to `false`. Provision '
            'resources with `context.programResources.provisionFor(program)` '
            'or set `autoProvisioning` to `true`.');
      }
    }

    context._useProgram(glProgram);

    final indexData = primitives.indices;

    var glIndexData = null;

    if (indexData != null) {
      final indexDataResources = context.indexDataResources;

      if (autoProvisioning) {
        indexDataResources.provisionFor(indexData);
      }

      glIndexData = indexDataResources._getGlIndexData(indexData);

      if (glIndexData == null) {
        throw new StateError('No resources have been provisioned for the '
            'index data for the primitives used in this draw call. Either set '
            '`autoProvisioning` to `true` or provision resources with '
            '`context.indexDataResources(data)` before making this draw call.');
      }
    }

    if (context._supportsVertexArrayObjects) {
      final vertexData = primitives.vertices;
      final glVao = glProgram.vertexDataVAOs[vertexData];

      if (glVao != null &&
          glVao.vertexData == vertexData &&
          glVao.vertexDataVersion == vertexData.version) {
        context._bindVertexArrayObject(glVao);

        if (glIndexData != glVao.glIndexData) {
          context._bindIndexData(glIndexData);

          glVao.glIndexData = glIndexData;
        }

        glVao.updateBuffers();
      } else {
        context._bindVertexArrayObject(null);
        context._bindAttributeData(null);
        context._bindIndexData(null);

        final vao = context._vaoExtension.createVertexArray();
        final glVAO = new _GLVertexArrayObject(vao, vertexData, glIndexData);

        context._vaoExtension.bindVertexArray(vao);

        if (glIndexData != null) {
          context._bindIndexData(glIndexData);
        }

        final attributes = glProgram.attributes;
        final attributesLength = attributes.length;
        final attributeDataResources = context.attributeDataResources;

        for (var i = 0; i < attributesLength; i++) {
          final attributeInfo = attributes[i];
          final mappedName =
              attributeNameMap[attributeInfo.name] ?? attributeInfo.name;
          final pointer = primitives.vertices.attributePointer(mappedName);

          if (pointer == null) {
            throw new ArgumentError('The geometry does not define an attribute '
                'matching the "${attributeInfo.name}" attribute on the shader '
                'program.');
          }

          // TODO: add check to see if attributeInfo.type matches attribute?

          final columnCount = pointer.columnCount;
          final columnSize = pointer.columnSize;
          final data = pointer.data;
          final stride = pointer.strideInBytes;
          final startLocation = attributeInfo.location;

          if (autoProvisioning) {
            attributeDataResources.provisionFor(data);
          }

          final glAttributeData =
              context.attributeDataResources._getGlAttributeData(data);

          if (glAttributeData == null) {
            throw new StateError('No resources have been provisioned for the '
                'attribute data on which the `$mappedName` attribute is '
                'defined. Either set `autoProvisioning` to `true` or provision '
                'resources with `context.attributeDataResources(data)` before '
                'making this draw call.');
          }

          for (var i = 0; i < columnCount; i++) {
            final location = startLocation + i;
            final offset = pointer.offsetInBytes + i * columnSize * 4;

            context._bindAttributeData(glAttributeData);
            _context.vertexAttribPointer(
                location,
                columnSize,
                _attributeDataTypeMap[data.type],
                pointer.normalize,
                stride,
                offset);
            _context.enableVertexAttribArray(location);
          }

          glVAO.dataSources.add(glAttributeData);
        }

        glProgram.vertexDataVAOs[vertexData] = glVAO;
        context._boundVertexArrayObject = glVAO;
      }
    } else {
      // TODO: find better way than creating a new set every time.
      final unusedAttribLocations = context._enabledAttributeLocations.toSet();

      // Enable vertex attributes and adjust vertex attribute pointers if
      // necessary

      final attributes = glProgram.attributes;
      final attributesLength = attributes.length;
      final attributeDataResources = context.attributeDataResources;

      for (var i = 0; i < attributesLength; i++) {
        final attributeInfo = attributes[i];
        final mappedName =
            attributeNameMap[attributeInfo.name] ?? attributeInfo.name;
        final pointer = primitives.vertices.attributePointer(mappedName);

        if (pointer == null) {
          throw new ArgumentError('The geometry does not define an attribute '
              'matching the "${attributeInfo.name}" attribute on the shader '
              'program.');
        }

        // TODO: add check to see if attributeInfo.type matches attribute?

        final columnCount = pointer.columnCount;
        final columnSize = pointer.columnSize;
        final data = pointer.data;
        final stride = pointer.strideInBytes;
        final startLocation = attributeInfo.location;

        if (autoProvisioning) {
          attributeDataResources.provisionFor(data);
        }

        final glAttributeData =
            context.attributeDataResources._getGlAttributeData(data);

        if (glAttributeData == null) {
          throw new StateError('No resources have been provisioned for the '
              'attribute data on which the `$mappedName` attribute is '
              'defined. Either set `autoProvisioning` to `true` or provision '
              'resources with `context.attributeDataResources(data)` before '
              'making this draw call.');
        }

        glAttributeData.updateBuffer();

        for (var i = 0; i < columnCount; i++) {
          var location = startLocation + i;

          // If the attribute bound to the location is null or an attribute
          // other than the current attribute, set up a new vertex attribute
          // pointer.
          if (context._locationAttributePointers[location] != pointer) {
            var offset = pointer.offsetInBytes + i * columnSize * 4;

            context._bindAttributeData(glAttributeData);
            _context.vertexAttribPointer(
                location,
                columnSize,
                _attributeDataTypeMap[data.type],
                pointer.normalize,
                stride,
                offset);

            context._locationAttributePointers[location] = pointer;
          }

          if (!context._enabledAttributeLocations.contains(location)) {
            _context.enableVertexAttribArray(location);
            context._enabledAttributeLocations.add(location);
          }

          unusedAttribLocations.remove(location);
        }
      }

      // Disable unused attribute positions
      for (var position in unusedAttribLocations) {
        _context.disableVertexAttribArray(position);
        context._enabledAttributeLocations.remove(position);
      }

      context._bindIndexData(glIndexData);
      glIndexData?.updateBuffer();
    }

    // Set uniform values
    final programUniforms = glProgram.uniforms;
    final programUniformsLength = programUniforms.length;

    for (var i = 0; i < programUniformsLength; i++) {
      final uniform = programUniforms[i];
      final value = uniforms[uniform.name];

      if (value == null) {
        throw new ArgumentError('No value was provided for the uniform named '
            '"${uniform.name}". Values must be provided for all active '
            'uniforms.');
      } else {
        uniform.bindValue(value, autoProvisioning);
      }
    }

    // Set the remaining draw options
    context._updateDepthTest(depthTest);
    context._updateStencilTest(stencilTest);
    context._updateBlending(blending);
    context._updateFaceCulling(faceCulling);
    context._updateFrontFace(frontFace);
    context._updateColorMask(colorMask);
    context._updateLineWidth(lineWidth);
    context._updateDithering(dithering);

    if (viewport == null) {
      context._updateViewport(0, 0, width, height);
    } else {
      context._updateViewport(viewport.left, height - viewport.bottom,
          viewport.width, viewport.height);
    }

    if (scissorBox == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(scissorBox.left, height - scissorBox.bottom,
          scissorBox.width, scissorBox.height);
      context._enableScissorTest();
    }

    if (glIndexData != null) {
      switch (indexData.type) {
        case IndexDataType.unsignedByte:
          _context.drawElements(_topologyMap[primitives.topology],
              primitives.count, WebGL.UNSIGNED_BYTE, primitives.offset * 8);

          break;
        case IndexDataType.unsignedShort:
          _context.drawElements(_topologyMap[primitives.topology],
              primitives.count, WebGL.UNSIGNED_SHORT, primitives.offset * 16);

          break;
        case IndexDataType.unsignedInt:
          if (context._supportsElementIndexUint == null) {
            context._supportsElementIndexUint =
                context.requestExtension('OES_element_index_uint') != null;
          }

          if (context._supportsElementIndexUint) {
            _context.drawElements(_topologyMap[primitives.topology],
                primitives.count, WebGL.UNSIGNED_INT, primitives.offset * 32);
          } else {
            throw new ArgumentError('The current context does not support 32 '
                'bit index lists.');
          }

          break;
      }
    } else {
      _context.drawArrays(_topologyMap[primitives.topology], primitives.offset,
          primitives.count);
    }
  }

  /// Resets this [Frame]'s color attachment to the specified [color] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearColor(Vector4 color, [Rectangle<int> region]) {
    context._updateClearColor(color);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

    _context.clear(WebGL.COLOR_BUFFER_BIT);
  }

  /// Resets this [Frame]'s depth attachment to the specified [depth] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearDepth(double depth, [Rectangle<int> region]) {
    context._updateClearDepth(depth);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

    _context.clear(WebGL.DEPTH_BUFFER_BIT);
  }

  /// Resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearStencil(int stencil, [Rectangle<int> region]) {
    context._updateClearStencil(stencil);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

    _context.clear(WebGL.STENCIL_BUFFER_BIT);
  }

  /// Resets this [Frame]'s color and depth attachments.
  ///
  /// Resets this [Frame]'s color attachment to the specified [color] value and
  /// resets this [Frame]'s depth attachment to the specified [depth] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearColorAndDepth(Vector4 color, double depth,
      [Rectangle<int> region]) {
    context._updateClearColor(color);
    context._updateClearDepth(depth);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

    _context.clear(WebGL.COLOR_BUFFER_BIT & WebGL.DEPTH_BUFFER_BIT);
  }

  /// Resets this [Frame]'s color and stencil attachments.
  ///
  /// Resets this [Frame]'s color attachment to the specified [color] value and
  /// resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearColorAndStencil(Vector4 color, int stencil,
      [Rectangle<int> region]) {
    context._updateClearColor(color);
    context._updateClearStencil(stencil);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

    _context.clear(WebGL.COLOR_BUFFER_BIT & WebGL.STENCIL_BUFFER_BIT);
  }

  /// Resets this [Frame]'s depth and stencil attachments.
  ///
  /// Resets this [Frame]'s depth attachment to the specified [depth] value and
  /// resets this [Frame]'s stencil attachment to the specified [stencil] value.
  ///
  /// Optionally a [region] may be specified, which restricts this clear
  /// operation to a rectangular area.
  void clearDepthAndStencil(double depth, int stencil,
      [Rectangle<int> region]) {
    context._updateClearDepth(depth);
    context._updateClearStencil(stencil);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

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
  void clearAll(Vector4 color, double depth, int stencil,
      [Rectangle<int> region]) {
    context._updateClearColor(color);
    context._updateClearDepth(depth);
    context._updateClearStencil(stencil);

    if (region == null) {
      context._disableScissorTest();
    } else {
      context._updateScissorBox(
          region.left, height - region.bottom, region.width, region.height);
      context._enableScissorTest();
    }

    _context.clear(WebGL.COLOR_BUFFER_BIT &
        WebGL.DEPTH_BUFFER_BIT &
        WebGL.STENCIL_BUFFER_BIT);
  }

  /// Reads the pixels currently in this [Frame]'s color buffer into a
  /// [Uint8List] where every 4 bytes represent the red, green, blue and alpha
  /// components of a pixel respectively.
  ///
  /// Optionally [viewport] may be specified to restrict the read to a
  /// sub-region of the color buffer.
  Uint8List readPixelsByteRGBA([Rectangle<int> viewport]) {
    var x, y, w, h;

    if (viewport != null) {
      x = viewport.left;
      y = height - viewport.top;
      w = viewport.width;
      h = viewport.height;
    } else {
      x = 0;
      y = 0;
      w = width;
      h = height;
    }

    final data = new Uint8List(w * h * 4);

    _context.readPixels(x, y, w, h, WebGL.RGBA, WebGL.UNSIGNED_BYTE, data);

    return data;
  }

  /// Reads the pixels currently in this [Frame]'s color buffer into a
  /// [Uint8List] where every 3 bytes represent the red, green and blue
  /// components of a pixel respectively.
  ///
  /// Optionally [viewport] may be specified to restrict the read to a
  /// sub-region of the color buffer.
  Uint8List readPixelsByteRGB([Rectangle<int> viewport]) {
    var x, y, w, h;

    if (viewport != null) {
      x = viewport.left;
      y = height - viewport.top;
      w = viewport.width;
      h = viewport.height;
    } else {
      x = 0;
      y = 0;
      w = width;
      h = height;
    }

    final data = new Uint8List(w * h * 3);

    _context.readPixels(x, y, w, h, WebGL.RGB, WebGL.UNSIGNED_BYTE, data);

    return data;
  }

  /// Reads the pixels currently in this [Frame]'s color buffer into a
  /// [Uint8List] where every byte represents the alpha component of a pixel.
  ///
  /// Optionally [viewport] may be specified to restrict the read to a
  /// sub-region of the color buffer.
  Uint8List readPixelsByteAlpha([Rectangle<int> viewport]) {
    var x, y, w, h;

    if (viewport != null) {
      x = viewport.left;
      y = height - viewport.top;
      w = viewport.width;
      h = viewport.height;
    } else {
      x = 0;
      y = 0;
      w = width;
      h = height;
    }

    final data = new Uint8List(w * h);

    _context.readPixels(x, y, w, h, WebGL.ALPHA, WebGL.UNSIGNED_BYTE, data);

    return data;
  }

  /// Reads the pixels currently in this [Frame]'s color buffer into a
  /// [Uint16List] where for every short, the first 5 bits represent the red
  /// component of a pixel, the next 5 bits represent the green component, the
  /// next 5 bits represent the blue component, and the last bit represents
  /// the alpha component.
  ///
  /// Optionally [viewport] may be specified to restrict the read to a
  /// sub-region of the color buffer.
  Uint16List readPixelsShortRGBA_5_5_5_1([Rectangle<int> viewport]) {
    var x, y, w, h;

    if (viewport != null) {
      x = viewport.left;
      y = height - viewport.top;
      w = viewport.width;
      h = viewport.height;
    } else {
      x = 0;
      y = 0;
      w = width;
      h = height;
    }

    final data = new Uint16List(w * h);

    _context.readPixels(
        x, y, w, h, WebGL.RGBA, WebGL.UNSIGNED_SHORT_5_5_5_1, data);

    return data;
  }

  /// Reads the pixels currently in this [Frame]'s color buffer into a
  /// [Uint16List] where for every short, the first 4 bits represent the red
  /// component of a pixel, the next 4 bits represent the green component, the
  /// next 4 bits represent the blue component, and the last 4 bits represent
  /// the alpha component.
  ///
  /// Optionally [viewport] may be specified to restrict the read to a
  /// sub-region of the color buffer.
  Uint16List readPixelsShortRGBA_4_4_4_4([Rectangle<int> viewport]) {
    var x, y, w, h;

    if (viewport != null) {
      x = viewport.left;
      y = height - viewport.top;
      w = viewport.width;
      h = viewport.height;
    } else {
      x = 0;
      y = 0;
      w = width;
      h = height;
    }

    final data = new Uint16List(w * h);

    _context.readPixels(
        x, y, w, h, WebGL.RGBA, WebGL.UNSIGNED_SHORT_4_4_4_4, data);

    return data;
  }

  /// Reads the pixels currently in this [Frame]'s color buffer into a
  /// [Uint16List] where for every short, the first 5 bits represent the red
  /// component of a pixel, the next 6 bits represent the green component, and
  /// the last 5 bits represent the blue component.
  ///
  /// Optionally [viewport] may be specified to restrict the read to a
  /// sub-region of the color buffer.
  Uint16List readPixelsShortRGB_5_6_5([Rectangle<int> viewport]) {
    var x, y, w, h;

    if (viewport != null) {
      x = viewport.left;
      y = height - viewport.top;
      w = viewport.width;
      h = viewport.height;
    } else {
      x = 0;
      y = 0;
      w = width;
      h = height;
    }

    final data = new Uint16List(w * h);

    _context.readPixels(
        x, y, w, h, WebGL.RGB, WebGL.UNSIGNED_SHORT_5_6_5, data);

    return data;
  }
}

class _DefaultFrame extends Frame {
  _DefaultFrame(RenderingContext context) : super._internal(context);

  int get width => context.canvas.width;
  int get height => context.canvas.height;

  void draw(PrimitiveSource primitives, Program program, Uniforms uniforms,
      {DepthTest depthTest: null,
      StencilTest stencilTest: null,
      Blending blending: null,
      CullingMode faceCulling: null,
      WindingOrder frontFace: WindingOrder.counterClockwise,
      ColorMask colorMask: const ColorMask(true, true, true, true),
      num lineWidth: 1,
      Rectangle<int> scissorBox: null,
      Rectangle<int> viewport: null,
      bool dithering: true,
      Map<String, String> attributeNameMap: const {},
      bool autoProvisioning: true}) {
    context._bindDefaultFrame();

    super.draw(primitives, program, uniforms,
        depthTest: depthTest,
        stencilTest: stencilTest,
        blending: blending,
        faceCulling: faceCulling,
        frontFace: frontFace,
        colorMask: colorMask,
        lineWidth: lineWidth,
        scissorBox: scissorBox,
        viewport: viewport,
        dithering: dithering,
        attributeNameMap: attributeNameMap,
        autoProvisioning: autoProvisioning);
  }

  void clearColor(Vector4 color, [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearColor(color, region);
  }

  void clearDepth(double depth, [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearDepth(depth, region);
  }

  void clearStencil(int stencil, [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearStencil(stencil, region);
  }

  void clearColorAndDepth(Vector4 color, double depth,
      [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearColorAndDepth(color, depth, region);
  }

  void clearColorAndStencil(Vector4 color, int stencil,
      [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearColorAndStencil(color, stencil, region);
  }

  void clearDepthAndStencil(double depth, int stencil,
      [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearDepthAndStencil(depth, stencil, region);
  }

  void clearAll(Vector4 color, double depth, int stencil,
      [Rectangle<int> region]) {
    context._bindDefaultFrame();

    super.clearAll(color, depth, stencil, region);
  }

  Uint8List readPixelsByteRGBA([Rectangle<int> viewport]) {
    context._bindDefaultFrame();

    return super.readPixelsByteRGBA(viewport);
  }

  Uint8List readPixelsByteRGB([Rectangle<int> viewport]) {
    context._bindDefaultFrame();

    return super.readPixelsByteRGB(viewport);
  }

  Uint8List readPixelsByteAlpha([Rectangle<int> viewport]) {
    context._bindDefaultFrame();

    return super.readPixelsByteAlpha(viewport);
  }

  Uint16List readPixelsShortRGBA_5_5_5_1([Rectangle<int> viewport]) {
    context._bindDefaultFrame();

    return super.readPixelsShortRGBA_5_5_5_1(viewport);
  }

  Uint16List readPixelsShortRGBA_4_4_4_4([Rectangle<int> viewport]) {
    context._bindDefaultFrame();

    return super.readPixelsShortRGBA_4_4_4_4(viewport);
  }

  Uint16List readPixelsShortRGB_5_6_5([Rectangle<int> viewport]) {
    context._bindDefaultFrame();

    return super.readPixelsShortRGB_5_6_5(viewport);
  }
}

class FrameBuffer extends Frame {
  /// The width of this [FrameBuffer] in pixels.
  final int width;

  /// The height of this [FrameBuffer] in pixels.
  final int height;

  // TODO: this api can be a lot nicer once union types come around by using
  // `Texture2D | RenderBuffer` for the attachment slots

  /// The [Texture] or [RenderBuffer] attached to this [FrameBuffer]'s color
  /// output channel.
  dynamic _colorAttachment;

  /// The [Texture] or [RenderBuffer] attached to the depth output channel.
  ///
  /// May be `null`. [FrameBuffer]s without a depth attachment can not perform
  /// a depth test.
  final dynamic depthAttachment;

  /// The [Texture] or [RenderBuffer] attached to the stencil output channel.
  ///
  /// May be `null`. [FrameBuffer]s without a stencil attachment can not perform
  /// a stencil test.
  final dynamic stencilAttachment;

  Map<RenderBuffer, WebGL.Renderbuffer> _renderBufferRBOs = {};

  WebGL.Framebuffer _framebufferObject;

  FrameBuffer(RenderingContext context, this.width, this.height,
      {dynamic colorAttachment, this.depthAttachment, this.stencilAttachment})
      : super._internal(context) {
    _colorAttachment = colorAttachment ??
        new RenderBuffer(RenderBufferFormat.RGBA_4, width, height);

    _framebufferObject = _context.createFramebuffer();

    context._bindFrameBuffer(this);

    if (colorAttachment is Texture2D) {
      if (colorAttachment.width != width) {
        throw new ArgumentError(
            'The color attachment\'s width (${colorAttachment.width}) must '
            'match the FrameBuffer\'s width ($width).');
      }

      if (colorAttachment.height != height) {
        throw new ArgumentError(
            'The color attachment\'s height (${colorAttachment.height}) must '
            'match the FrameBuffer\'s height ($height).');
      }

      context.textureResources.provisionFor(colorAttachment);
      context._bindTexture2D(colorAttachment);
      _context.framebufferTexture2D(
          WebGL.FRAMEBUFFER,
          WebGL.COLOR_ATTACHMENT0,
          WebGL.TEXTURE_2D,
          context.textureResources
              ._getGLTexture2D(colorAttachment)
              .glTextureObject,
          0);

      context._bindTexture2D(null);
    } else if (colorAttachment is RenderBuffer) {
      if (colorAttachment.width != width) {
        throw new ArgumentError(
            'The color attachment\'s width (${colorAttachment.width}) must '
            'match the FrameBuffer\'s width ($width).');
      }

      if (colorAttachment.height != height) {
        throw new ArgumentError(
            'The color attachment\'s height (${colorAttachment.height}) must '
            'match the FrameBuffer\'s height ($height).');
      }

      final rbo = _context.createRenderbuffer();

      _renderBufferRBOs[colorAttachment] = rbo;

      _context.bindRenderbuffer(WebGL.RENDERBUFFER, rbo);
      _context.renderbufferStorage(
          WebGL.RENDERBUFFER,
          _renderBufferFormatMap[colorAttachment.internalFormat],
          colorAttachment.width,
          colorAttachment.height);

      _context.framebufferRenderbuffer(
          WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0, WebGL.RENDERBUFFER, rbo);
    } else if (colorAttachment == null) {
      throw new ArgumentError(
          'A FrameBuffer\'s `colorAttachment0` must not be null.');
    } else {
      throw new ArgumentError(
          'A FrameBuffer\'s `colorAttachment0` must be a Texture2D or a '
          'RenderBuffer.');
    }

    if (depthAttachment is Texture2D) {
      if (depthAttachment.width != width) {
        throw new ArgumentError(
            'The depth attachment\'s width (${depthAttachment.width}) must '
            'match the FrameBuffer\'s width ($width).');
      }

      if (depthAttachment.height != height) {
        throw new ArgumentError(
            'The depth attachment\'s height (${depthAttachment.height}) must '
            'match the FrameBuffer\'s height ($height).');
      }

      context.textureResources.provisionFor(depthAttachment);
      context._bindTexture2D(depthAttachment);
      _context.framebufferTexture2D(
          WebGL.FRAMEBUFFER,
          WebGL.DEPTH_ATTACHMENT,
          WebGL.TEXTURE_2D,
          context.textureResources
              ._getGLTexture2D(depthAttachment)
              .glTextureObject,
          0);
      context._bindTexture2D(null);
    } else if (depthAttachment is RenderBuffer) {
      if (depthAttachment.width != width) {
        throw new ArgumentError(
            'The depth attachment\'s width (${depthAttachment.width}) must '
            'match the FrameBuffer\'s width ($width).');
      }

      if (depthAttachment.height != height) {
        throw new ArgumentError(
            'The depth attachment\'s height (${depthAttachment.height}) must '
            'match the FrameBuffer\'s height ($height).');
      }

      final rbo = _context.createRenderbuffer();

      _renderBufferRBOs[depthAttachment] = rbo;

      _context.bindRenderbuffer(WebGL.RENDERBUFFER, rbo);
      _context.renderbufferStorage(
          WebGL.RENDERBUFFER,
          _renderBufferFormatMap[depthAttachment.internalFormat],
          depthAttachment.width,
          depthAttachment.height);

      _context.framebufferRenderbuffer(
          WebGL.FRAMEBUFFER, WebGL.DEPTH_ATTACHMENT, WebGL.RENDERBUFFER, rbo);
    }

    if (stencilAttachment is Texture2D) {
      if (stencilAttachment.width != width) {
        throw new ArgumentError(
            'The stencil attachment\'s width (${stencilAttachment.width}) must '
            'match the FrameBuffer\'s width ($width).');
      }

      if (stencilAttachment.height != height) {
        throw new ArgumentError(
            'The stencil attachment\'s height (${stencilAttachment.height}) must '
            'match the FrameBuffer\'s height ($height).');
      }

      context.textureResources.provisionFor(stencilAttachment);
      context._bindTexture2D(stencilAttachment);
      _context.framebufferTexture2D(
          WebGL.FRAMEBUFFER,
          WebGL.DEPTH_ATTACHMENT,
          WebGL.TEXTURE_2D,
          context.textureResources
              ._getGLTexture2D(stencilAttachment)
              .glTextureObject,
          0);
      context._bindTexture2D(null);
    } else if (stencilAttachment is RenderBuffer) {
      if (stencilAttachment.width != width) {
        throw new ArgumentError(
            'The stencil attachment\'s width (${stencilAttachment.width}) must '
            'match the FrameBuffer\'s width ($width).');
      }

      if (stencilAttachment.height != height) {
        throw new ArgumentError(
            'The stencil attachment\'s height (${stencilAttachment.height}) '
            'must match the FrameBuffer\'s height ($height).');
      }

      final rbo = _context.createRenderbuffer();

      _renderBufferRBOs[stencilAttachment] = rbo;

      _context.bindRenderbuffer(WebGL.RENDERBUFFER, rbo);
      _context.renderbufferStorage(
          WebGL.RENDERBUFFER,
          _renderBufferFormatMap[stencilAttachment.internalFormat],
          depthAttachment.width,
          depthAttachment.height);

      _context.framebufferRenderbuffer(
          WebGL.FRAMEBUFFER, WebGL.DEPTH_ATTACHMENT, WebGL.RENDERBUFFER, rbo);
    }
  }

  /// The [Texture] or [RenderBuffer] attached to this [FrameBuffer]'s color
  /// output channel.
  dynamic get colorAttachment => _colorAttachment;

  void draw(PrimitiveSource primitives, Program program, Uniforms uniforms,
      {DepthTest depthTest: null,
      StencilTest stencilTest: null,
      Blending blending: null,
      CullingMode faceCulling: null,
      WindingOrder frontFace: WindingOrder.counterClockwise,
      ColorMask colorMask: const ColorMask(true, true, true, true),
      num lineWidth: 1,
      Rectangle<int> scissorBox: null,
      Rectangle<int> viewport: null,
      bool dithering: true,
      Map<String, String> attributeNameMap: const {},
      bool autoProvisioning: true}) {
    context._bindFrameBuffer(this);

    super.draw(primitives, program, uniforms,
        depthTest: depthTest,
        stencilTest: stencilTest,
        blending: blending,
        faceCulling: faceCulling,
        frontFace: frontFace,
        colorMask: colorMask,
        lineWidth: lineWidth,
        scissorBox: scissorBox,
        viewport: viewport,
        dithering: dithering,
        attributeNameMap: attributeNameMap,
        autoProvisioning: autoProvisioning);
  }

  void clearColor(Vector4 color, [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearColor(color, region);
  }

  void clearDepth(double depth, [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearDepth(depth, region);
  }

  void clearStencil(int stencil, [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearStencil(stencil, region);
  }

  void clearColorAndDepth(Vector4 color, double depth,
      [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearColorAndDepth(color, depth, region);
  }

  void clearColorAndStencil(Vector4 color, int stencil,
      [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearColorAndStencil(color, stencil, region);
  }

  void clearDepthAndStencil(double depth, int stencil,
      [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearDepthAndStencil(depth, stencil, region);
  }

  void clearAll(Vector4 color, double depth, int stencil,
      [Rectangle<int> region]) {
    context._bindFrameBuffer(this);

    super.clearAll(color, depth, stencil, region);
  }

  Uint8List readPixelsByteRGBA([Rectangle<int> viewport]) {
    context._bindFrameBuffer(this);

    return super.readPixelsByteRGBA(viewport);
  }

  Uint8List readPixelsByteRGB([Rectangle<int> viewport]) {
    context._bindFrameBuffer(this);

    return super.readPixelsByteRGB(viewport);
  }

  Uint8List readPixelsByteAlpha([Rectangle<int> viewport]) {
    context._bindFrameBuffer(this);

    return super.readPixelsByteAlpha(viewport);
  }

  Uint16List readPixelsShortRGBA_5_5_5_1([Rectangle<int> viewport]) {
    context._bindFrameBuffer(this);

    return super.readPixelsShortRGBA_5_5_5_1(viewport);
  }

  Uint16List readPixelsShortRGBA_4_4_4_4([Rectangle<int> viewport]) {
    context._bindFrameBuffer(this);

    return super.readPixelsShortRGBA_4_4_4_4(viewport);
  }

  Uint16List readPixelsShortRGB_5_6_5([Rectangle<int> viewport]) {
    context._bindFrameBuffer(this);

    return super.readPixelsShortRGB_5_6_5(viewport);
  }
}

class RenderBuffer {
  final RenderBufferFormat internalFormat;

  final int width;

  final int height;

  const RenderBuffer(this.internalFormat, this.width, this.height);
}

/// Enumerates the formats available for a [RenderBuffer].
enum RenderBufferFormat {
  RGBA_4,
  RGB_5_6_5,
  RGB_5_A_1,
  depth_component_16,
  stencil_index_8,
  depth_stencil
}
