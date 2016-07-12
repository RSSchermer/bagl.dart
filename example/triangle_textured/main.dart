import 'dart:html';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  const vertexShaderSource = """
    attribute vec2 position;
    attribute vec2 textureCoord;

    varying vec2 vTextureCoord;

    void main(void) {
      gl_Position = vec4(position, 0.0, 1.0);
      vTextureCoord = textureCoord;
    }
  """;

  const fragmentShaderSource = """
    precision mediump float;

    varying vec2 vTextureCoord;

    uniform sampler2D samplerA;

    void main(void) {
      gl_FragColor = texture2D(samplerA, vec2(vTextureCoord.s, vTextureCoord.t));
    }
  """;

  var program = const Program(vertexShaderSource, fragmentShaderSource);

  var vertices = new VertexArray([
    new Vertex({
      'position': new Vector2(0.0, 0.5),
      'textureCoord': new Vector2(0.5, 0.0)
    }),
    new Vertex({
      'position': new Vector2(-0.5, -0.5),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector2(0.5, -0.5),
      'textureCoord': new Vector2(1.0, 1.0)
    })
  ]);

  var triangles = new Triangles(vertices, new IndexList.incrementing(3));
  var texture = new Texture2D.fromImageURL('checkerboard_color_gradient.png');
  var sampler = new Sampler2D(texture,
      minificationFilter: MinificationFilter.linearMipmapLinear,
      magnificationFilter: MagnificationFilter.linear);

  texture.asFuture().whenComplete(() {
    context.defaultFrame.draw(triangles, program, {'samplerA': sampler});
  });
}
