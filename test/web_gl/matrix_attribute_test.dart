@TestOn('browser')

import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'package:bagl/web_gl.dart';

void main() {
  group('WebGL', () {
    group('draw with vertices with a matrix attribute', () {
      var canvas = document.querySelector('#main_canvas');
      var context = RenderingContext.forCanvas(canvas, preserveDrawingBuffer: true);

      var vertexShaderSource = """
        attribute vec2 position;
        attribute mat4 translation;
        attribute vec3 color;

        varying vec3 vColor;

        void main(void) {
          gl_Position = translation * vec4(position, 0.0, 1.0);
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

      var program = new Program.fromSource(context, vertexShaderSource, fragmentShaderSource);

      var vertices = new VertexArray([
        new Vertex({
          'position': new Vector2(0.0, 0.5),
          'translation': new Matrix4(
              1.0, 0.0, 0.0, -0.5,
              0.0, 1.0, 0.0,  0.0,
              0.0, 0.0, 1.0,  0.0,
              0.0, 0.0, 0.0,  1.0
          ),
          'color': new Vector3(1.0, 0.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(-0.5, -0.5),
          'translation': new Matrix4(
              1.0, 0.0, 0.0, 0.0,
              0.0, 1.0, 0.0, 0.5,
              0.0, 0.0, 1.0, 0.0,
              0.0, 0.0, 0.0, 1.0
          ),
          'color': new Vector3(0.0, 1.0, 0.0)
        }),
        new Vertex({
          'position': new Vector2(0.5, -0.5),
          'translation': new Matrix4(
              1.0, 0.0, 0.0,  0.0,
              0.0, 1.0, 0.0, -0.5,
              0.0, 0.0, 1.0,  0.0,
              0.0, 0.0, 0.0,  1.0
          ),
          'color': new Vector3(0.0, 0.0, 1.0)
        })
      ]);

      var triangles = new Triangles(vertices, new IndexList.incrementing(3));

      context.defaultFrame.draw(triangles, program, {});

      test('draws the correct frame', () {
        expect(canvas.toDataUrl(), equals(document.querySelector('#expected').src));
      });
    });
  });
}
