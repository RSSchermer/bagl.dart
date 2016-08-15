import 'dart:html';
import 'dart:math';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  const vertexShaderSource = """
    attribute vec4 position;
    attribute vec3 color;

    uniform mat4 model;
    uniform mat4 view;
    uniform mat4 projection;

    varying vec3 vColor;

    void main(void) {
      gl_Position = projection * view * model * position;
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
      'position': new Vector4(-5.0, -5.0, -5.0, 1.0),
      'color': new Vector3(1.0, 0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, -5.0, 1.0),
      'color': new Vector3(0.0, 1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, -5.0, 1.0),
      'color': new Vector3(0.0, 0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, -5.0, 1.0),
      'color': new Vector3(1.0, 0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, -5.0, 5.0, 1.0),
      'color': new Vector3(0.0, 1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, 5.0, 1.0),
      'color': new Vector3(0.0, 0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, 5.0, 1.0),
      'color': new Vector3(1.0, 1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'color': new Vector3(1.0, 0.0, 1.0)
    })
  ]);

  var triangles = new Triangles(vertices, new IndexList.fromList([
    0, 2, 1, // Back
    1, 2, 3,
    0, 6, 2, // Left
    0, 4, 6,
    1, 3, 7, // Right
    1, 7, 5,
    2, 7, 3, // Top
    2, 6, 7,
    0, 1, 5, // Bottom
    0, 5, 4,
    4, 5, 7, // Front
    6, 4, 7
  ]));

  var projection = new Matrix4.perspective(0.3 * PI, 1.0, 1.0, 100.0);
  var view = new Matrix4.translation(0.0, 0.0, 30.0).inverse;

  update(num time) {
    var model = new Matrix4.rotationY(time / 1000) * new Matrix4.rotationX(time / 1000);

    context.defaultFrame.draw(triangles, program, {
      'model': model,
      'projection': projection,
      'view': view
    }, depthTest: const DepthTest());

    window.requestAnimationFrame(update);
  }

  window.requestAnimationFrame(update);
}
