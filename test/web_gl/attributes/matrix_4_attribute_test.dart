@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';

import '../helpers.dart';

void main() {
  group('WebGL', () {
    group('draw with vertices with a Matrix4 attribute', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute mat4 translation;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = translation * vec4(position, 0.0, 1.0);
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

      final vertices = new VertexArray([
        new Vertex({
          'position': new Vector2(0.0, 0.5),
          'translation': new Matrix4(1.0, 0.0, 0.0, -0.5, 0.0, 1.0, 0.0, 0.0,
              0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0),
          'color': new Vector3(1.0, 0.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(-0.5, -0.5),
          'translation': new Matrix4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.5,
              0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0),
          'color': new Vector3(0.0, 1.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(0.5, -0.5),
          'translation': new Matrix4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, -0.5,
              0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0),
          'color': new Vector3(0.0, 0.0, 1.0)
        })
      ]);

      final triangles = new Triangles(vertices);

      context.defaultFrame.draw(triangles, program, const Uniforms.empty());

      test('draws the correct frame', () {
        expect(canvas,
            closeToImage(document.querySelector('#expected'), 0.005, 5));
      });
    });
  });
}
