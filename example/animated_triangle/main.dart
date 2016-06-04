import 'dart:html';
import 'dart:math';

import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  var vertexShaderSource = """
    attribute vec2 position;
    attribute vec3 color;

    uniform float scale;

    varying vec3 vColor;

    void main(void) {
      gl_Position = vec4(scale * position, 0.0, 1.0);
      vColor = color;
    }
  """;

  var fragmentShaderSource = """
    precision mediump float;

    varying vec3 vColor;

    void main(void) {
      gl_FragColor = vec4(vColor, 1.0);
    }
  """;

  var program =
      new Program.fromSource(context, vertexShaderSource, fragmentShaderSource);

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

  var triangles = new Triangles(vertices, new IndexList.incrementing(3));

  update(num time) {
    context.defaultFrame.draw(triangles, program, {'scale': sin(time / 1000)});

    window.requestAnimationFrame(update);
  }

  window.requestAnimationFrame(update);
}
