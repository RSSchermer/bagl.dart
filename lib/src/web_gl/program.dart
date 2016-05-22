part of web_gl;

class Program {
  final RenderingContext context;

  final String vertexShaderSource;

  final String fragmentShaderSource;

  final WebGL.RenderingContext _context;

  final WebGL.Program _program;

  final Map<String, int> _attributeNameLocationMap = new Map();

  Program(RenderingContext context, this.vertexShaderSource,
      this.fragmentShaderSource)
      : context = context,
        _context = context._context,
        _program = context._context.createProgram() {
    final vertexShader =
        _compileShader(WebGL.VERTEX_SHADER, vertexShaderSource);
    final fragmentShader =
        _compileShader(WebGL.FRAGMENT_SHADER, fragmentShaderSource);

    _context.attachShader(_program, vertexShader);
    _context.attachShader(_program, fragmentShader);

    _context.linkProgram(_program);

    final success = _context.getProgramParameter(_program, WebGL.LINK_STATUS);

    if (!success) {
      throw new ProgramLinkingError(_context.getProgramInfoLog(_program));
    }
  }

  WebGL.Shader _compileShader(int type, String source) {
    final shader = _context.createShader(type);

    _context.shaderSource(shader, source);
    _context.compileShader(shader);

    final success = _context.getShaderParameter(shader, WebGL.COMPILE_STATUS);

    if (!success) {
      throw new ShaderCompilationError(
          type, source, _context.getShaderInfoLog(shader));
    }

    return shader;
  }

  int _getLocation(String attributeName) {
    if (_attributeNameLocationMap.containsKey(attributeName)) {
      return _attributeNameLocationMap[attributeName];
    } else {
      final location = _context.getAttribLocation(_program, attributeName);

      _attributeNameLocationMap[attributeName] = location;

      return location;
    }
  }
}
