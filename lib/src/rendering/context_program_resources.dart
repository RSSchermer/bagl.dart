part of bagl.rendering;

/// Manages the provisioning and deprovisioning of program related GPU resources
/// for a [RendingContext].
class ContextProgramResources {
  /// The [RenderingContext] with which these [ContextProgramResources] are
  /// associated.
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  /// Expands [Program]s with their associated [_GLProgram] for all currently
  /// provisioned programs.
  Expando<_GLProgram> _programGLProgram = new Expando();

  ContextProgramResources._internal(RenderingContext context)
      : context = context,
        _context = context._context;

  /// Returns whether or not GPU resources are currently being provisioned for
  /// the [program].
  bool areProvisionedFor(Program program) => _programGLProgram[program] != null;

  /// Provisions GPU resources for the [program].
  ///
  /// Compiles and links the [program]'s shaders. If resources were already
  /// provisioned previously for the [program], then these resources will be
  /// reused.
  ///
  /// Throws a [ShaderCompilationError] if the [program]'s vertex shader or
  /// fragment shader fails to compile.
  ///
  /// Throws a [ProgramLinkingError] if the [program] fails to link.
  void provisionFor(Program program) {
    if (!areProvisionedFor(program)) {
      final glProgramHandle = _context.createProgram();
      final vertexShader =
          _compileShader(WebGL.VERTEX_SHADER, program.vertexShaderSource);
      final fragmentShader =
          _compileShader(WebGL.FRAGMENT_SHADER, program.fragmentShaderSource);

      _context.attachShader(glProgramHandle, vertexShader);
      _context.attachShader(glProgramHandle, fragmentShader);
      _context.linkProgram(glProgramHandle);

      final success =
          _context.getProgramParameter(glProgramHandle, WebGL.LINK_STATUS);

      if (!success) {
        throw new ProgramLinkingError(
            _context.getProgramInfoLog(glProgramHandle));
      }

      _programGLProgram[program] = new _GLProgram(
          context, program, glProgramHandle, vertexShader, fragmentShader);
    }
  }

  /// Deprovisions the GPU resources associated with the [program].
  ///
  /// Frees all resources associated with the [program]. Returns `true` if
  /// resources were provisioned for the [program], `false` otherwise.
  bool deprovisionFor(Program program) {
    if (areProvisionedFor(program)) {
      final glProgramInfo = _programGLProgram[program];

      _context.deleteProgram(glProgramInfo.glProgramObject);
      _context.deleteShader(glProgramInfo.glVertexShaderObject);
      _context.deleteShader(glProgramInfo.glFragmentShaderObject);

      _programGLProgram[program] = null;

      return true;
    } else {
      return false;
    }
  }

  /// Returns the [_GLProgram] handle for the resources associated with the
  /// program.
  ///
  /// Returns the [_GLProgram] handle for the resources associated with the
  /// program if resources have been provisioned for the, or `null` if no
  /// resources have been provisioned yet.
  _GLProgram _getGLProgram(Program program) => _programGLProgram[program];

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
}
