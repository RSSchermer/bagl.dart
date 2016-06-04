part of web_gl;

/// Enumerates the functions [DepthTest] or a [StencilTest] can use to decide if
/// the test passes.
///
/// See the documentation for [DepthTest] and [StencilTest] for details on how
/// both these tests apply these functions.
enum TestFunction {
  equal,
  notEqual,
  less,
  greater,
  lessOrEqual,
  greaterOrEqual,
  neverPass,
  alwaysPass
}

/// Describes how the depth test should be performed.
///
/// In order to do a depth test, a [Frame] must have a depth buffer. A depth
/// buffer stores a depth value between `0.0` (close) and `1.0` (far) for each
/// fragment. Initially the depth value for each fragment is set to `1.0`. When
/// rendering to a [Frame] with no depth buffer attached, the depth test behaves
/// as though depth testing is disabled.
///
/// The depth test is performed for each fragment. The fragment's depth output
/// will be mapped onto the range defined by [rangeNear] and [rangeFar]. The
/// resulting depth value may then be compared to the depth buffer's current
/// depth value for this fragment using the [testFunction]. The [testFunction]
/// can be one of the following functions:
///
/// - `TestFunction.equal`: the test passes if the fragment's depth value is
///   equal to the depth buffer's current depth value for this fragment.
/// - `TestFunction.notEqual`: the test passes if the fragment's depth value is
///   not equal to the depth buffer's current depth value for this fragment.
/// - `TestFunction.less`: the test passes if the fragment's depth value is
///   smaller than the depth buffer's current depth value for this fragment.
/// - `TestFunction.greater`: the test passes if the fragment's depth value is
///   greater than the depth buffer's current depth value for this fragment.
/// - `TestFunction.lessOrEqual`: the test passes if the fragment's depth value
///   is smaller than or equal to the depth buffer's current depth value for
///   this fragment.
/// - `TestFunction.greaterOrEqual`: the test passes if the fragment's depth
///   value is greater than or equal to the depth buffer's current depth value
///   for this fragment.
/// - `TestFunction.neverPass`: the test never passes, regardless of how the
///   fragment's depth value compares to the depth buffer's current depth value
///   for this fragment.
/// - `TestFunction.alwaysPass`: the test always passes, regardless of how the
///   fragment's depth value compares to depth buffer's current depth value for
///   this fragment.
///
/// If the test fails, the fragment will be discarded. If the test passes and
/// [write] is `true`, then the depth buffer's depth value for this fragment
/// will be replaced with the new depth value.
class DepthTest {
  /// The [TestFunction] used to decide if the [DepthTest] passes or fails.
  ///
  /// Can be set to employ one of the following functions:
  ///
  /// - `TestFunction.equal`: the test passes if the fragment's depth value is
  ///   equal to the current depth value in the depth buffer.
  /// - `TestFunction.notEqual`: the test passes if the fragment's depth value
  ///   is not equal to the current depth value in the depth buffer.
  /// - `TestFunction.less`: the test passes if the fragment's depth value is
  ///   smaller than the current depth value in the depth buffer.
  /// - `TestFunction.greater`: the test passes if the fragment's depth value is
  ///   greater than the current depth value in the depth buffer.
  /// - `TestFunction.lessOrEqual`: the test passes if the fragment's depth
  ///   value is smaller than or equal to the current depth value in the depth
  ///   buffer.
  /// - `TestFunction.greaterOrEqual`: the test passes if the fragment's depth
  ///   value is greater than or equal to the current depth value in the depth
  ///   buffer.
  /// - `TestFunction.neverPass`: the test never passes, regardless of how the
  ///   fragment's depth value compares to the current depth value in the depth
  ///   buffer.
  /// - `TestFunction.alwaysPass`: the test always passes, regardless of how the
  ///   fragment's depth value compares to the current depth value in the depth
  ///   buffer.
  final TestFunction testFunction;

  /// Whether or not the depth buffer will be updated when the depth test
  /// passes.
  ///
  /// When set to `false`
  final bool write;

  final double rangeNear;

  final double rangeFar;

  const DepthTest(
      {this.testFunction: TestFunction.less,
      this.write: true,
      this.rangeNear: 0.0,
      this.rangeFar: 1.0});
}

enum BlendFactor {
  zero,
  one,
  sourceColor,
  oneMinusSourceColor,
  destinationColor,
  oneMinusDestinationColor,
  sourceAlpha,
  oneMinusSourceAlpha,
  destinationAlpha,
  oneMinusDestinationAlpha
}

enum BlendFunction { addition, subtraction, reverseSubtraction }

class Blend {
  final sourceColorFactor;

  final sourceAlphaFactor;

  final destColorFactor;

  final destAlphaFactor;

  final colorFunction;

  final alphaFunction;

  const Blend(
      {this.sourceColorFactor: BlendFactor.one,
      this.sourceAlphaFactor: BlendFactor.one,
      this.destColorFactor: BlendFactor.one,
      this.destAlphaFactor: BlendFactor.one,
      this.colorFunction: BlendFunction.addition,
      this.alphaFunction: BlendFunction.addition});
}

/// Enumerates the possible face-culling modes available.
///
/// A triangle is considered to have 2 sides or 'faces': a front-face and a
/// back-face. Which face is considered to be the front-face and which face is
/// considered to be the back-face, is determined by the [WindingOrder].
///
/// Triangles may be discarded based on their facing in a process known as
/// face-culling. A triangle is considered front-facing if it is oriented such
/// that the front-face is facing the 'camera'. A triangle is considered
/// back-facing if it is oriented such that the back-face is facing the camera.
/// There are 3 possible culling modes:
///
/// - [frontFaces]: front-facing triangles will be culled.
/// - [backFaces]: back-facing triangles will be culled.
/// - [frontAndBackFaces]: all triangles will be culled, regardless of their
///   facing.
///
/// Face culling is an optimization typically used when rendering closed
/// surfaces. It allows the back-end to discard triangles that would not have
/// been visible anyway, before the expensive rasterization and fragment shader
/// operations are performed. Consider a cube: it is made up of 12 triangles.
/// We orient all 12 triangles such that the front-face is facing outwards.
/// Note that by the definition of a closed surfaces, the back-faces of these
/// triangles will never be visible, unless the camera is placed inside the
/// cube. This means that all back-facing triangles can be safely culled to
/// improve rendering performance without altering the result.
enum CullingMode { frontFaces, backFaces, frontAndBackFaces }

/// Enumerates the possible winding orders for triangles.
///
/// A triangle is considered to have 2 sides or 'faces': a front-face and a
/// back-face. The winding order determines which face is considered the
/// front-face, and thus by extension which face is considered the back-face.
///
/// Each triangle is defined by 3 points: a first point (point `a`), a second
/// point (point `b`), and a third point (point `c`):
///
///     //
///     //        a
///     //       /\
///     //      /  \
///     //     /    \
///     //    /      \
///     //   /________\
///     //  c          b
///     //
///
/// In the above example we are looking at just one face of a triangle: the face
/// that is facing toward us. If we trace the outline of this triangle from
/// `a -> b -> c -> a`, we'll notice that we've following a clockwise path.
/// If the winding order is defined to be [clockwise], then we are looking at
/// the front-face of this triangle. If the winding order is defined to be
/// [counterClockwise], then we are looking at the back-face of this triangle.
enum WindingOrder { clockwise, counterClockwise }

class StencilTest {
  /// The [TestFunction] used by this [StencilTest] for front-facing fragments.
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [testBack] is used instead.
  final TestFunction testFront;

  /// The [StencilOperation] that will be performed when a front-facing fragment
  /// passes neither the [DepthTest], nor [testFront].
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [testBack] is used instead.
  final StencilOperation failOperationFront;

  /// The [StencilOperation] that will be performed when a front-facing fragment
  /// passes the [DepthTest], but fails [testFront].
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [testBack] is used instead.
  final StencilOperation passDepthFailOperationFront;

  /// The [StencilOperation] that will be performed when a front-facing fragment
  /// passes both the [DepthTest] and [testFront].
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [testBack] is used instead.
  final StencilOperation passOperationFront;

  /// The function that will be used by the stencil test to test back-facing
  /// fragments.
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [testFront] is used instead.
  final TestFunction testBack;

  /// The [StencilOperation] that will be performed when a back-facing fragment
  /// passes neither the [DepthTest], nor [testBack].
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [failOperationFront] is used instead.
  final StencilOperation failOperationBack;

  /// The [StencilOperation] that will be performed when a back-facing fragment
  /// passes the [DepthTest], but fails [testBack].
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [passDepthFailOperationFront] is used instead.
  final StencilOperation passDepthFailOperationBack;

  /// The [StencilOperation] that will be performed when a back-facing fragment
  /// passes both the [DepthTest] and [testBack].
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [passOperationFront] is used instead.
  final StencilOperation passOperationBack;

  final int referenceValue;

  final int testMask;

  final int writeMask;

  /// Instantiates a new [StencilTest].
  const StencilTest(
      {this.testFront: TestFunction.alwaysPass,
      this.failOperationFront: StencilOperation.keep,
      this.passDepthFailOperationFront: StencilOperation.keep,
      this.passOperationFront: StencilOperation.keep,
      this.testBack: TestFunction.alwaysPass,
      this.failOperationBack: StencilOperation.keep,
      this.passDepthFailOperationBack: StencilOperation.keep,
      this.passOperationBack: StencilOperation.keep,
      this.referenceValue: 0,
      this.testMask: 0xffffffff,
      this.writeMask: 0xffffffff});
}

/// Enumerates the operations that can be performed on a stencil fragment as a
/// result of the [StencilTest].
enum StencilOperation {
  keep,
  zero,
  replace,
  increment,
  wrappingIncrement,
  decrement,
  wrappingDecrement,
  invert
}

/// Specifies for each color components whether or not it can be written to the
/// color buffer.
///
/// Color consists of 4 individual components: a red component, a blue
/// component, a green component, and an alpha (opacity) component. Whether or
/// not these components can be written to the color buffer is controlled for
/// each component individually by [writeRed], [writeGreen], [writeBlue] and
/// [writeAlpha] respectively.
class ColorMask {
  /// Whether or not the red color component can be written to the color buffer.
  final bool writeRed;

  /// Whether or not the green color component can be written to the color
  /// buffer.
  final bool writeGreen;

  /// Whether or not the blue color component can be written to the color
  /// buffer.
  final bool writeBlue;

  /// Whether or not the alpha component can be written to the color buffer.
  final bool writeAlpha;

  /// Instantiates a new [ColorMask].
  const ColorMask(
      this.writeRed, this.writeGreen, this.writeBlue, this.writeAlpha);
}

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
