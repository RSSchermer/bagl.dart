part of web_gl;

/// Error thrown when a shader fails to compile.
class ShaderCompilationError extends Error {
  /// Integer indicating the shader's type.
  ///
  /// Either [WebGL.VERTEX_SHADER] or [WebGL.FRAGMENT_SHADER].
  final int shaderType;

  /// The source code for the shader.
  final String shaderSource;

  /// The shader info log.
  final String shaderLogInfo;

  /// Instantiates a new [ShaderCompilationError].
  ShaderCompilationError(
      this.shaderType, this.shaderSource, this.shaderLogInfo);

  String toString() {
    if (shaderType == WebGL.VERTEX_SHADER) {
      return 'Failed to compile vertex shader:\n$shaderLogInfo';
    } else if (shaderType == WebGL.FRAGMENT_SHADER) {
      return 'Failed to compile fragment shader:\n$shaderLogInfo';
    } else {
      return 'Failed to compile shader:\n$shaderLogInfo';
    }
  }
}

/// Error thrown when a shader program fails to link.
class ProgramLinkingError extends Error {
  /// The program info log.
  final String programInfoLog;

  /// Instantiates a new [ProgramLinkingError].
  ProgramLinkingError(this.programInfoLog);

  String toString() => 'Failed to link program:\n$programInfoLog';
}
