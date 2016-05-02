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

  void drawTriangles(Triangles triangles,
      {Map<String, String> attributeNameMap}) {
    attributeNameMap ??= new Map();

    context.attach(triangles);
    context._useProgram(this);

    final unusedAttribLocations = context._enabledAttribLocations.toSet();

    // Enable vertex attributes and adjust vertex attribute pointers if
    // necessary
    triangles.vertices.attributes.forEach((name, attribute) {
      final columnCount = attribute.columnCount;
      final columnSize = attribute.columnSize;
      final startingLocation = _getLocation(attributeNameMap[name] ?? name);
      final frame = attribute.frame;
      final stride = frame.elementSizeInBytes;

      for (var i = 0; i < columnCount; i++) {
        var location = startingLocation + i;

        // If the attribute bound to the location is null or an attribute other
        // than the current attribute, set up a new vertex attribute pointer.
        if (context._locationAttributeMap[location] != attribute) {
          var offset = attribute.offsetInBytes + i * columnSize * 4;

          context._bindAttributeDataFrame(frame);
          _context.vertexAttribPointer(
              location, columnSize, WebGL.FLOAT, false, stride, offset);

          context._locationAttributeMap[location] = attribute;
        }

        if (!context._enabledAttribLocations.contains(location)) {
          _context.enableVertexAttribArray(location);
          context._enabledAttribLocations.add(location);
        }

        unusedAttribLocations.remove(location);
      }
    });

    // Disable unused attribute positions
    for (var position in unusedAttribLocations) {
      _context.disableVertexAttribArray(position);
      context._enabledAttribLocations.remove(position);
    }

    // Set up uniforms

    // Draw elements
    context._bindGeometry(triangles);
    _context.drawElements(
        WebGL.TRIANGLES, triangles.indices.length, WebGL.UNSIGNED_SHORT, 0);
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

  _getLocation(String attributeName) {
    if (_attributeNameLocationMap.containsKey(attributeName)) {
      return _attributeNameLocationMap[attributeName];
    } else {
      final location = _context.getAttribLocation(_program, attributeName);

      _attributeNameLocationMap[attributeName] = location;

      return location;
    }
  }
}