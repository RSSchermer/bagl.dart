import 'dart:html';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  const vertexShaderSource = """
    attribute vec2 position;
    attribute vec3 color;

    varying vec3 vColor;

    void main(void) {
      gl_Position = vec4(position, 0.0, 1.0);
      vColor = color;
    }
  """;

  const fragmentShaderSource = """
    precision mediump float;

    varying vec3 vColor;

    void main(void) {
      gl_FragColor = vec4(vColor, 1.0);
    }
  """;

  const program = const Program(vertexShaderSource, fragmentShaderSource);

  var vertices = new VertexArray([
    new Vertex({
      'position': new Vector2(0.0, 0.5),
      'color': new Vector3(1.0, 0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector2(-0.5, -0.5),
      'color': new Vector3(0.0, 1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector2(0.5, -0.5),
      'color': new Vector3(0.0, 0.0, 1.0)
    })
  ]);

  var triangles = new Triangles(vertices);

  context.defaultFrame.draw(triangles, program, const Uniforms.empty());
}
