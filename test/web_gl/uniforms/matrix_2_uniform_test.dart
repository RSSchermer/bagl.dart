@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

import '../helpers.dart';

void main() {
  group('WebGL', () {
    group('draw with a Matrix2 uniform', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute vec3 color;

        uniform mat2 rotation;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(rotation * position, 0.0, 1.0);
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

      context.defaultFrame.draw(
          triangles, program, {'rotation': new Matrix2(0.0, -1.0, 1.0, 0.0)});

      test('draws the correct frame', () {
        expect(canvas,
            closeToImage(document.querySelector('#expected'), 0.005, 5));
      });
    });
  });
}
