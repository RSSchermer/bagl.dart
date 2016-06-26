@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

void main() {
  group('WebGL', () {
    group('draw with a Matrix3List uniform', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas, preserveDrawingBuffer: true);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute vec3 color;

        uniform mat3 translations[2];

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(translations[1] * translations[0] * vec3(position, 1.0), 1.0);
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

      final triangles = new Triangles(vertices, new IndexList.incrementing(3));

      context.defaultFrame.draw(triangles, program, {
        'translations': new Matrix3List.fromList([
          new Matrix3(
              1.0, 0.0, 0.25,
              0.0, 1.0, 0.25,
              0.0, 0.0, 1.0
          ),
          new Matrix3(
              1.0, 0.0,  0.25,
              0.0, 1.0, -0.5,
              0.0, 0.0,  1.0
          )
        ])
      });

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
