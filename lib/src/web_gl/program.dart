part of web_gl;

/// Links the programmable shader stages of the rendering pipeline.
class Program {
  /// The [RenderingContext] for which this [Program] is linked.
  final RenderingContext context;

  /// The [VertexShader] used by this [Program].
  final VertexShader vertexShader;

  /// The [FragmentShader] used by this [Program].
  final FragmentShader fragmentShader;

  final WebGL.RenderingContext _context;

  final WebGL.Program _program;

  final Map<String, int> _attributeNameLocationMap = new Map();

  final Map<String, WebGL.UniformLocation> _uniformNameLocationMap = new Map();

  /// Instantiates a new [Program] for the given [context] by linking the
  /// [vertexShader] and the [fragmentShader].
  ///
  /// Throws an [ArgumentError] if the [RenderingContext] for which the
  /// [vertexShader] is compiled does not match the [context].
  ///
  /// Throws an [ArgumentError] if the [RenderingContext] for which the
  /// [fragmentShader] is compiled does not match the [context].
  ///
  /// Throws a [ProgramLinkingError] if the [Program] fails to link.
  Program(RenderingContext context, this.vertexShader, this.fragmentShader)
      : context = context,
        _context = context._context,
        _program = context._context.createProgram() {
    if (vertexShader.context != context) {
      throw new ArgumentError('The vertex shader must be defined on the same '
          'rendering context as the program.');
    }

    if (fragmentShader.context != context) {
      throw new ArgumentError('The fragment shader must be defined on the same '
          'rendering context as the program.');
    }

    // Link program
    _context.attachShader(_program, vertexShader._shader);
    _context.attachShader(_program, fragmentShader._shader);

    _context.linkProgram(_program);

    final success = _context.getProgramParameter(_program, WebGL.LINK_STATUS);

    if (!success) {
      throw new ProgramLinkingError(_context.getProgramInfoLog(_program));
    }

    // Create uniform name -> uniform location map
    final activeUniforms =
        _context.getProgramParameter(_program, WebGL.ACTIVE_UNIFORMS);

    for (var i = 0; i < activeUniforms; i++) {
      final name = _context.getActiveUniform(_program, i).name;
      final location = _context.getUniformLocation(_program, name);

      if (location != null) {
        _uniformNameLocationMap[name] = location;
      }
    }
  }

  /// Instantiates a new [Program] for the given [context] from the
  /// [vertexShaderSource] string and the [fragmentShaderSource] string.
  ///
  /// A [VertexShader] is compiled from the [vertexShaderSource] string and a
  /// [FragmentShader] is compiled from the [fragmentShaderSource] string. The
  /// resulting shaders are then linked into a [Program].
  ///
  /// Throws an [ShaderCompilationError] if [vertexShaderSource] string fails
  /// to compile or if the [fragmentShaderSource] string fails to compile.
  ///
  /// Throws a [ProgramLinkingError] if the [Program] fails to link.
  factory Program.fromSource(RenderingContext context,
          String vertexShaderSource, String fragmentShaderSource) =>
      new Program(context, new VertexShader(context, vertexShaderSource),
          new FragmentShader(context, fragmentShaderSource));

  int _getAttributeLocation(String name) {
    if (_attributeNameLocationMap.containsKey(name)) {
      return _attributeNameLocationMap[name];
    } else {
      final location = _context.getAttribLocation(_program, name);

      _attributeNameLocationMap[name] = location;

      return location;
    }
  }
}
