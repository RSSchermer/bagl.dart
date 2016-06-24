@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

void main() {
  group('WebGL', () {
    group('draw with an attributeNameMap', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas, preserveDrawingBuffer: true);

      const vertexShaderSource = """
        attribute vec2 aPos;
        attribute vec3 aColor;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(aPos, 0.0, 1.0);
          vColor = aColor;
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

      final triangles = new Triangles(vertices, new IndexList.incrementing(6));

      context.defaultFrame.draw(triangles, program, {}, attributeNameMap: {
        'position': 'aPos',
        'color': 'aColor'
      });

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
