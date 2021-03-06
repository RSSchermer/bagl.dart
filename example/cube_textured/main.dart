import 'dart:html';
import 'dart:math';

import 'package:bagl/bagl.dart';

main() {
  var canvas = document.querySelector('#main_canvas');
  var context = RenderingContext.forCanvas(canvas);

  const vertexShaderSource = """
    attribute vec4 position;
    attribute vec2 textureCoord;

    uniform mat4 model;
    uniform mat4 view;
    uniform mat4 projection;

    varying vec2 vTextureCoord;

    void main(void) {
      gl_Position = projection * view * model * position;
      vTextureCoord = textureCoord;
    }
  """;

  const fragmentShaderSource = """
    precision mediump float;

    varying vec2 vTextureCoord;

    uniform sampler2D samplerA;

    void main(void) {
      gl_FragColor = texture2D(samplerA, vTextureCoord);
    }
  """;

  const program = const Program(vertexShaderSource, fragmentShaderSource);

  var vertices = new VertexArray([
    // Back
    new Vertex({
      'position': new Vector4(-5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),

    // Left
    new Vertex({
      'position': new Vector4(-5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),

    // Right
    new Vertex({
      'position': new Vector4(5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),

    // Top
    new Vertex({
      'position': new Vector4(-5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),

    // Bottom
    new Vertex({
      'position': new Vector4(-5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, -5.0, -5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),

    // Front
    new Vertex({
      'position': new Vector4(-5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 0.0)
    }),
    new Vertex({
      'position': new Vector4(-5.0, -5.0, 5.0, 1.0),
      'textureCoord': new Vector2(0.0, 1.0)
    }),
    new Vertex({
      'position': new Vector4(5.0, 5.0, 5.0, 1.0),
      'textureCoord': new Vector2(1.0, 0.0)
    })
  ]);

  var triangles = new Triangles(vertices);

  var model =
      new Matrix4.rotationY(0.25 * PI) * new Matrix4.rotationX(0.25 * PI);
  var projection = new Matrix4.perspective(0.3 * PI, 1.0, 1.0, 100.0);
  var view = new Matrix4.translation(0.0, 0.0, 20.0).inverse;

  var texture = new Texture2D.fromImageURL('checkerboard_color_gradient.png');
  var sampler = new Sampler2D(texture,
      minificationFilter: MinificationFilter.linearMipmapLinear,
      magnificationFilter: MagnificationFilter.linear);

  texture.asFuture().whenComplete(() {
    context.defaultFrame.draw(
        triangles,
        program,
        new Uniforms({
          'model': model,
          'projection': projection,
          'view': view,
          'samplerA': sampler
        }),
        depthTest: const DepthTest());
  });
}
