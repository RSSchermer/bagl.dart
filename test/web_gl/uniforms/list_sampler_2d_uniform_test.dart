@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

main() {
  group('WebGL', () {
    group('draw with a List<Sampler2D> uniform', () {
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

        uniform sampler2D samplers[2];

        void main(void) {
          vec4 color0 = texture2D(samplers[0], vec2(vTextureCoord.s, vTextureCoord.t));
          vec4 color1 = texture2D(samplers[1], vec2(vTextureCoord.s, vTextureCoord.t));
          gl_FragColor = 0.5 * (color0 + color1);
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
      final texture1 = new Texture2D.fromImageElement(
          document.querySelector('#texture_1'));
      final texture2 = new Texture2D.fromImageElement(
          document.querySelector('#texture_2'));
      final sampler1 = new Sampler2D(texture1);
      final sampler2 = new Sampler2D(texture2);

      context.defaultFrame.draw(triangles, program,
          {'samplers': <Sampler2D>[sampler1, sampler2]});

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
