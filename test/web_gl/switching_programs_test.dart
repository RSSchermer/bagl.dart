@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

void main() {
  group('WebGL', () {
    group('switching programs', () {
      var canvas = document.querySelector('#main_canvas');
      var context = new RenderingContext(canvas, preserveDrawingBuffer: true);

      var vertexShader1Source = """
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(position, 0., 1.);
          vColor = color;
        }
      """;

      var vertexShader2Source = """
        attribute vec2 position;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = vec4(position, 0., 1.);
          vColor = vec3(1., 1., 1.) - color;
        }
      """;

      var fragmentShaderSource = """
        precision mediump float;

        varying vec3 vColor;

        void main(void) {
          gl_FragColor = vec4(vColor, 1.);
        }
      """;

      var program1 = new Program(context, vertexShader1Source, fragmentShaderSource);
      var program2 = new Program(context, vertexShader2Source, fragmentShaderSource);

      var vertices = new VertexArray([
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

      var triangles1 = new Triangles(vertices, [0, 1, 2]);
      var triangles2 = new Triangles(vertices, [3, 4, 5]);

      program1.drawTriangles(triangles1);
      program2.drawTriangles(triangles2);

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
