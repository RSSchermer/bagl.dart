part of web_gl;

class ShaderCompilationError extends Error {
  final int shaderType;

  final String shaderSource;

  final String shaderLogInfo;

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

class ProgramLinkingError extends Error {
  final String programInfoLog;

  ProgramLinkingError(this.programInfoLog);

  String toString() => 'Failed to link program:\n$programInfoLog';
}
