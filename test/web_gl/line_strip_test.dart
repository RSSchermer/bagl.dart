@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

void main() {
  group('WebGL', () {
    group('draw LineStrip', () {
      var canvas = document.querySelector('#main_canvas');
      var context = RenderingContext.forCanvas(canvas, preserveDrawingBuffer: true);

      var vertexShaderSource = """
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(position, 0.0, 1.0);
          vColor = color;
        }
      """;

      var fragmentShaderSource = """
        precision mediump float;

        varying vec3 vColor;

        void main(void) {
          gl_FragColor = vec4(vColor, 1.0);
        }
      """;

      var program = new Program(vertexShaderSource, fragmentShaderSource);

      var vertices = new VertexArray([
        new Vertex({
          'position': new Vector2(-0.5, -0.5),
          'color': new Vector3(1.0, 0.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(-0.5, 0.5),
          'color': new Vector3(0.0, 1.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(0.5, 0.5),
          'color': new Vector3(1.0, 0.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(0.5, -0.5),
          'color': new Vector3(0.0, 0.0, 1.0)
        })
      ]);

      var triangles = new LineStrip(vertices, new IndexList.incrementing(4));

      context.defaultFrame.draw(triangles, program, {});

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
