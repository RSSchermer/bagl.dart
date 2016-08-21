part of rendering;

/// Links the programmable shader stages of the rendering pipeline.
class Program {
  /// The source code for the vertex shader used by this [Program].
  final String vertexShaderSource;

  /// The source code for the fragment shader used by this [Program].
  final String fragmentShaderSource;

  /// Instantiates a new [Program] from the [vertexShaderSource] string and the
  /// [fragmentShaderSource] string.
  const Program(this.vertexShaderSource, this.fragmentShaderSource);
}
