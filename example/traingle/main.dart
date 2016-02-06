import 'dart:html';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = new WebGLRenderingContext(canvas);

  var vertices = new BufferedVertexCollection([
    new Vertex({
      'position': new Vector2(0.0, 1.0),
      'color': new Vector3(1.0, 0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector2(-1.0, -1.0),
      'color': new Vector3(0.0, 1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector2(1.0, -1.0),
      'color': new Vector3(0.0, 0.0, 1.0)
    })
  ]);

  var triangles = new Triangles(vertices);

  var vertexShaderSource = """
    asdf
    asdf
  """;
  var fragmentShaderSource = """
    asdf
    asdf
  """;

  var program = context.createProgram(vertexShaderSource, fragmentShaderSource);
}
