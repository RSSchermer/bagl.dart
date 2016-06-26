@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

main() {
  group('WebGL', () {
    group('draw with a Sampler2D uniform', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas, preserveDrawingBuffer: true, antialias: false);

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

      final program = const Program(vertexShaderSource, fragmentShaderSource);

      final vertices = new VertexArray([
        new Vertex({
          'position': new Vector2(0.0, 1.0),
          'textureCoord': new Vector2(0.5, 0.0)
        }),
        new Vertex({
          'position': new Vector2(-1.0, -1.0),
          'textureCoord': new Vector2(0.0, 1.0)
        }),
        new Vertex({
          'position': new Vector2(1.0, -1.0),
          'textureCoord': new Vector2(1.0, 1.0)
        })
      ]);

      final triangles = new Triangles(vertices, new IndexList.incrementing(3));
      final texture = new Texture2D.fromImageElement(
          document.querySelector('#checkerboard_color_gradient'));
      final sampler = new Sampler2D(texture);

      context.defaultFrame.draw(triangles, program, {'samplerA': sampler});

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
