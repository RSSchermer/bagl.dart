@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:bagl/bagl.dart';

import 'helpers.dart';

void main() {
  group('WebGL', () {
    group('resource provisioning', () {
      final canvas = document.querySelector('#main_canvas');
      final context = RenderingContext.forCanvas(canvas,
          preserveDrawingBuffer: true, antialias: false);

      const vertexShaderSource = """
        attribute vec2 position;
        attribute vec2 textureCoord;

        varying vec2 vTextureCoord;

        void main(void) {
          gl_Position = vec4(position, 0.0, 1.0);
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

      final program = const Program(vertexShaderSource, fragmentShaderSource);
      final attributeData = new AttributeDataTable.fromList(4, [
        0.0, 1.0, 0.5, 0.0,
        -1.0, -1.0, 0.0, 1.0,
        1.0, -1.0, 1.0, 1.0
      ]);

      final vertices = new VertexArray.fromAttributes({
        'position': new Vector2Attribute(attributeData),
        'textureCoord': new Vector2Attribute(attributeData, offset: 2)
      });

      final indices = new Index16List.fromList([1, 2, 0]);

      final triangles = new Triangles(vertices, indices: indices);
      final texture = new Texture2D.fromImageElement(
          document.querySelector('#checkerboard_color_gradient'));
      final sampler = new Sampler2D(texture);

      group('with autoProvisioning set to false', () {
        test('when resources are not provisioned for the attribute data `draw` throws a StateError', () {
          context.attributeDataResources.deprovisionFor(attributeData);
          context.indexDataResources.provisionFor(indices);
          context.programResources.provisionFor(program);
          context.textureResources.provisionFor(texture);

          expect(() {
            context.defaultFrame.draw(
                triangles, program, new Uniforms({'samplerA': sampler}),
                autoProvisioning: false);
          }, throwsStateError);
        });

        test('when resources are not provisioned for the index data `draw` throws a StateError', () {
          context.attributeDataResources.provisionFor(attributeData);
          context.indexDataResources.deprovisionFor(indices);
          context.programResources.provisionFor(program);
          context.textureResources.provisionFor(texture);

          expect(() {
            context.defaultFrame.draw(
                triangles, program, new Uniforms({'samplerA': sampler}),
                autoProvisioning: false);
          }, throwsStateError);
        });

        test('when resources are not provisioned for the program draw throws a StateError', () {
          context.attributeDataResources.provisionFor(attributeData);
          context.indexDataResources.provisionFor(indices);
          context.programResources.deprovisionFor(program);
          context.textureResources.provisionFor(texture);

          expect(() {
            context.defaultFrame.draw(
                triangles, program, new Uniforms({'samplerA': sampler}),
                autoProvisioning: false);
          }, throwsStateError);
        });

        test('when resources are not provisioned for the sampler draw throws a StateError', () {
          context.attributeDataResources.provisionFor(attributeData);
          context.indexDataResources.provisionFor(indices);
          context.programResources.provisionFor(program);
          context.textureResources.deprovisionFor(texture);

          expect(() {
            context.defaultFrame.draw(
                triangles, program, new Uniforms({'samplerA': sampler}),
                autoProvisioning: false);
          }, throwsStateError);
        });

        test('when all necessary resources are provisioned draws the correct frame', () {
          context.attributeDataResources.provisionFor(attributeData);
          context.indexDataResources.provisionFor(indices);
          context.programResources.provisionFor(program);
          context.textureResources.provisionFor(texture);

          context.defaultFrame.draw(
              triangles, program, new Uniforms({'samplerA': sampler}),
              autoProvisioning: false);

          expect(canvas,
              closeToImage(document.querySelector('#expected'), 0.005, 5));
        });
      });
    });
  });
}
