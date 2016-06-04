part of web_gl;

class Program {
  final RenderingContext context;

  final VertexShader vertexShader;

  final FragmentShader fragmentShader;

  final WebGL.RenderingContext _context;

  final WebGL.Program _program;

  final Map<String, int> _attributeNameLocationMap = new Map();

  final Map<String, WebGL.UniformLocation> _uniformNameLocationMap = new Map();

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
