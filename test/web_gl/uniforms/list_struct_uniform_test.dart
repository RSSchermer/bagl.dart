@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';

import '../helpers.dart';

void main() {
  group('WebGL', () {
    group('draw with a List<Struct> uniform', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute float colorPairIndex;
        
        varying float vColorPairIndex;

        void main(void) {
          gl_Position = vec4(position, 0.0, 1.0);
          vColorPairIndex = colorPairIndex;
        }
      """;

      const fragmentShaderSource = """
        precision mediump float;

        struct ColorPair {
          vec3 color1;
          vec3 color2;
        };

        uniform ColorPair colorPairs[2];
        
        varying float vColorPairIndex;

        void main(void) {
          ColorPair colors;

          for (int x = 0; x < 2; x++) {
            if (x == int(vColorPairIndex)) {
              colors = colorPairs[x];
              break;
            }
          }

          gl_FragColor = vec4(colors.color1 + colors.color2, 1.0);
        }
      """;

      const program = const Program(vertexShaderSource, fragmentShaderSource);

      final vertices = new VertexArray([
        new Vertex({
          'position': new Vector2(-0.5, 0.5),
          'colorPairIndex': 0.0
        }),
        new Vertex({
          'position': new Vector2(-1.0, -0.5),
          'colorPairIndex': 0.0
        }),
        new Vertex({
          'position': new Vector2(0.0, -0.5),
          'colorPairIndex': 0.0
        }),
        new Vertex({
          'position': new Vector2(0.5, -0.5),
          'colorPairIndex': 1.0
        }),
        new Vertex({
          'position': new Vector2(1.0, 0.5),
          'colorPairIndex': 1.0
        }),
        new Vertex({
          'position': new Vector2(0.0, 0.5),
          'colorPairIndex': 1.0
        })
      ]);

      final triangles = new Triangles(vertices, new IndexList.incrementing(6));

      context.defaultFrame.draw(triangles, program, {
        'colorPairs': <Struct>[
          new Struct({
            'color1': new Vector3(1.0, 0.0, 0.0),
            'color2': new Vector3(0.0, 1.0, 0.0)
          }),
          new Struct({
            'color1': new Vector3(1.0, 0.0, 0.0),
            'color2': new Vector3(0.0, 0.0, 1.0)
          })
        ]
      });

      test('draws the correct frame', () {
        expect(canvas,
            closeToImage(document.querySelector('#expected'), 0.005, 5));
      });
    });
  });
}
