import 'dart:html';
import 'dart:math';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  const vertexShaderSource = """
    attribute vec2 position;
    attribute vec3 color;

    uniform float scale;

    varying vec3 vColor;

    void main(void) {
      gl_Position = vec4(scale * position, 0.0, 1.0);
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

  var program = const Program(vertexShaderSource, fragmentShaderSource);

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

  update(num time) {
    context.defaultFrame
        .draw(triangles, program, new Uniforms({'scale': sin(time / 1000)}));

    window.requestAnimationFrame(update);
  }

  window.requestAnimationFrame(update);
}
