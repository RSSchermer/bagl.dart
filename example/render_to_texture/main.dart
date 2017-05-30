import 'dart:html';
import 'dart:typed_data';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  const mainVertexShaderSource = """
    attribute vec2 position;
    attribute vec2 textureCoord;

    varying vec2 vTextureCoord;

    void main(void) {
      gl_Position = vec4(position, 0.0, 1.0);
      vTextureCoord = textureCoord;
    }
  """;

  const mainFragmentShaderSource = """
    precision mediump float;

    varying vec2 vTextureCoord;

    uniform sampler2D samplerA;

    void main(void) {
      gl_FragColor = texture2D(samplerA, vTextureCoord);
    }
  """;

  const bufferVertexShaderSource = """
    attribute vec2 position;
    
    void main(void) {
      gl_Position = vec4(position, 0.0, 1.0);
    }
  """;

  const bufferFragmentShaderSource = """
    precision mediump float;
    
    void main(void) {
      gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    }
  """;

  var mainProgram =
      const Program(mainVertexShaderSource, mainFragmentShaderSource);
  var bufferProgram = const Program(
      bufferVertexShaderSource, bufferFragmentShaderSource);

  var triangleVertices = new VertexArray([
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

  var lineVertices = new VertexArray([
    new Vertex({'position': new Vector2(-1.0, 1.0)}),
    new Vertex({'position': new Vector2(1.0, -1.0)}),
    new Vertex({'position': new Vector2(-1.0, -1.0)}),
    new Vertex({'position': new Vector2(1.0, 1.0)})
  ]);

  var triangles = new Triangles(triangleVertices);
  var lines = new Lines(lineVertices);

  var texture =
      new Texture2D(new Uint8ListImage.RGBA(128, 128, new Uint8List(65536)));
  var sampler = new Sampler2D(texture,
      minificationFilter: MinificationFilter.linearMipmapLinear,
      magnificationFilter: MagnificationFilter.linear);

  var frameBuffer =
      new FrameBuffer(context, 128, 128, colorAttachment: texture);

  frameBuffer.clearColor(new Vector4(0.0, 0.0, 1.0, 1.0));
  frameBuffer.draw(lines, bufferProgram, {}, lineWidth: 3);

  context.defaultFrame.draw(triangles, mainProgram, {'samplerA': sampler});
}
