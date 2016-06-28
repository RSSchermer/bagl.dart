@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

import 'helpers.dart';

void main() {
  group('WebGL', () {
    group('multiple draw calls with different vertex arrays', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(position, 0.0, 1.0);
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

      final vertices1 = new VertexArray([
        new Vertex({
          'position': new Vector2(-0.5, 0.5),
          'color': new Vector3(1.0, 0.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(-1.0, -0.5),
          'color': new Vector3(0.0, 1.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(0.0, -0.5),
          'color': new Vector3(0.0, 0.0, 1.0)
        })
      ]);

      final vertices2 = new VertexArray([
        new Vertex({
          'position': new Vector2(0.5, -0.5),
          'color': new Vector3(1.0, 0.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(1.0, 0.5),
          'color': new Vector3(0.0, 1.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(0.0, 0.5),
          'color': new Vector3(0.0, 0.0, 1.0)
        })
      ]);

      final triangles1 =
          new Triangles(vertices1, new IndexList.incrementing(3));
      final triangles2 =
          new Triangles(vertices2, new IndexList.incrementing(3));

      context.defaultFrame.draw(triangles1, program, {});
      context.defaultFrame.draw(triangles2, program, {});

      test('draws the correct frame', () {
        expect(canvas,
            closeToImage(document.querySelector('#expected'), 0.005, 5));
      });
    });
  });
}
