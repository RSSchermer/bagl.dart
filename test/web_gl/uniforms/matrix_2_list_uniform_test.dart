@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';

import '../helpers.dart';

void main() {
  group('WebGL', () {
    group('draw with a Matrix2List uniform', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute vec3 color;

        uniform mat2 rotations[2];

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(rotations[1] * rotations[0] * position, 0.0, 1.0);
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

      final triangles = new Triangles(vertices);

      context.defaultFrame.draw(triangles, program, new Uniforms({
        'rotations': new Matrix2List.fromList([
          new Matrix2(0.0, -1.0, 1.0, 0.0),
          new Matrix2(-1.0, 0.0, 0.0, -1.0)
        ])
      }));

      test('draws the correct frame', () {
        expect(canvas,
            closeToImage(document.querySelector('#expected'), 0.005, 5));
      });
    });
  });
}
