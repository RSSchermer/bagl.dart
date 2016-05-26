part of web_gl;

abstract class Shader {
  RenderingContext get context;

  String get source;
}

class VertexShader extends Shader {
  final RenderingContext context;

  final String source;

  WebGL.Shader _shader;

  VertexShader(this.context, this.source) {
    _shader = context._context.createShader(WebGL.VERTEX_SHADER);

    context._context.shaderSource(_shader, source);
    context._context.compileShader(_shader);

    final success =
        context._context.getShaderParameter(_shader, WebGL.COMPILE_STATUS);

    if (!success) {
      throw new ShaderCompilationError(WebGL.VERTEX_SHADER, source,
          context._context.getShaderInfoLog(_shader));
    }
  }
}

class FragmentShader extends Shader {
  final RenderingContext context;

  final String source;

  WebGL.Shader _shader;

  FragmentShader(this.context, this.source) {
    _shader = context._context.createShader(WebGL.FRAGMENT_SHADER);

    context._context.shaderSource(_shader, source);
    context._context.compileShader(_shader);

    final success =
        context._context.getShaderParameter(_shader, WebGL.COMPILE_STATUS);

    if (!success) {
      throw new ShaderCompilationError(WebGL.FRAGMENT_SHADER, source,
          context._context.getShaderInfoLog(_shader));
    }
  }
}
