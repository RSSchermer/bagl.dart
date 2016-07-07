part of rendering;

/// Manages the provisioning and deprovisioning of program related resources for
/// a [RendingContext].
class _ContextProgramResourceManager {
  /// The [RenderingContext] managed by this [_ContextProgramResourceManager].
  final RenderingContext context;

  final WebGL.RenderingContext _context;

  /// The programs for which resources are currently provisioned.
  Set<Program> _provisionedPrograms = new Set();

  /// Map from [Program]s to their associated [_GLProgram] for all currently
  /// provisioned programs.
  Map<Program, _GLProgram> _glProgramByProgram = new Map();

  /// Instantiates a new [_ContextProgramResourceManager] for the [context].
  _ContextProgramResourceManager(RenderingContext context)
      : context = context,
        _context = context._context;

  Iterable<Program> get provisionedPrograms =>
      new UnmodifiableSetView(_provisionedPrograms);

  /// Provisions resources for the [program].
  ///
  /// Compiles and links the [program]'s shaders. If resources were already
  /// provisioned previously for the [program], then these resources will be
  /// reused.
  ///
  /// Throws a [ShaderCompilationError] if the [program]'s vertex shader or
  /// fragment shader fails to compile.
  ///
  /// Throws a [ProgramLinkingError] if the [program] fails to link.
  void provision(Program program) {
    if (!_provisionedPrograms.contains(program)) {
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

      _glProgramByProgram[program] = new _GLProgram(
          context, program, glProgramHandle, vertexShader, fragmentShader);
      _provisionedPrograms.add(program);
    }
  }

  /// Deprovisions the resources associated with the [program].
  ///
  /// Frees all resources associated with the [program]. Returns `true` if
  /// resources were provisioned for the [program], `false` otherwise.
  bool deprovision(Program program) {
    if (_provisionedPrograms.contains(program)) {
      final glProgramInfo = _glProgramByProgram[program];

      _context.deleteProgram(glProgramInfo.glProgramObject);
      _context.deleteShader(glProgramInfo.glVertexShaderObject);
      _context.deleteShader(glProgramInfo.glFragmentShaderObject);

      _provisionedPrograms.remove(program);
      _glProgramByProgram.remove(program);

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
  _GLProgram getGLProgram(Program program) => _glProgramByProgram[program];

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
