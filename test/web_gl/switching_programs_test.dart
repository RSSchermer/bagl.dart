@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';

import 'helpers.dart';

void main() {
  group('WebGL', () {
    group('multiple draw calls with different program', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      final vertexShader1Source = """
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(position, 0., 1.);
          vColor = color;
        }
      """;

      final vertexShader2Source = """
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(position, 0.0, 1.0);
          vColor = vec3(1., 1., 1.) - color;
        }
      """;

      const fragmentShaderSource = """
        precision mediump float;

        varying vec3 vColor;

        void main(void) {
          gl_FragColor = vec4(vColor, 1.0);
        }
      """;

      final program1 = new Program(vertexShader1Source, fragmentShaderSource);
      final program2 = new Program(vertexShader2Source, fragmentShaderSource);

      final vertices = new VertexArray([
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
        }),
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
          new Triangles(vertices, indices: new Index16List.fromList([0, 1, 2]));
      final triangles2 =
          new Triangles(vertices, indices: new Index16List.fromList([3, 4, 5]));

      context.defaultFrame.draw(triangles1, program1, const Uniforms.empty());
      context.defaultFrame.draw(triangles2, program2, const Uniforms.empty());

      test('draws the correct frame', () {
        expect(canvas,
            closeToImage(document.querySelector('#expected'), 0.005, 5));
      });
    });
  });
}
