import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/vertex_data.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main () {
  group('BufferedVertexCollection', () {
    group('default constructor', () {
      test('throws an ArgumentError if vertices have differing numbers of attributes', () {
        expect(() => new BufferedVertexCollection([
          new Vertex({
            'position': new Vector2(0.0, 1.0),
            'color': new Vector3(1.0, 0.0, 0.0)
          }),
          new Vertex({
            'position': new Vector2(-1.0, -1.0),
            'color': new Vector3(0.0, 1.0, 0.0),
            'alpha': 0.8
          })
        ]), throwsArgumentError);
      });

      test('throws an ArgumentError if the attribute names of vertices do not match', () {
        expect(() => new BufferedVertexCollection([
          new Vertex({
            'position': new Vector2(0.0, 1.0),
            'color': new Vector3(1.0, 0.0, 0.0)
          }),
          new Vertex({
            'position': new Vector2(-1.0, -1.0),
            'colour': new Vector3(0.0, 1.0, 0.0)
          })
        ]), throwsArgumentError);
      });

      test('throws an ArgumentError if two vertices use a different value type for the same attribute', () {
        expect(() => new BufferedVertexCollection([
          new Vertex({
            'position': new Vector2(0.0, 1.0),
            'color': new Vector3(1.0, 0.0, 0.0)
          }),
          new Vertex({
            'position': new Vector3(-1.0, -1.0, 0.0),
            'color': new Vector3(0.0, 1.0, 0.0)
          })
        ]), throwsArgumentError);
      });

      group('with valid vertices', () {
        final vertices = new BufferedVertexCollection([
          new Vertex({
            'position': new Vector2(0.0, 1.0),
            'color': new Vector3(1.0, 0.0, 0.0)
          }),
          new Vertex({
            'position': new Vector2(-1.0, -1.0),
            'color': new Vector3(0.0, 1.0, 0.0)
          }),
          new Vertex({
            'position': new Vector2(1.0, -1.0),
            'color': new Vector3(0.0, 0.0, 1.0)
          })
        ]);

        test('returns a collection with the correct length', () {
          expect(vertices.length, equals(3));
        });

        test('returns a collection with the correct attributes', () {
          expect(vertices.attributes.keys, unorderedEquals(['position', 'color']));
        });

        test('returns a collection backed by a single attribute data frame with the correct row length', () {
          final frames = vertices.attributes.values.map((a) => a.frame).toSet();

          expect(frames.length, equals(1));
          expect(frames.first.rowLength, equals(5));
        });
      });
    });

    group('fromAttributeData', () {
      final positionData = new AttributeDataFrame(2, [
        0.0,  0.5,
        -0.5, -0.5,
        0.5, -0.5
      ]);
      final colorData = new AttributeDataFrame(3, [
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
      ]);
      final interleavedAttributeData = positionData.interleavedWith(colorData);

      test('throws an ArgumentError if the attributes are defined on frames of differening lengths', () {
        final shortColorData = new AttributeDataFrame(3, [
          1.0, 0.0, 0.0,
          0.0, 1.0, 0.0
        ]);

        expect(() => new BufferedVertexCollection.fromAttributeData({
          'position': new Vector2Attribute(positionData),
          'color': new Vector3Attribute(shortColorData)
        }), throwsArgumentError);
      });

      group('from 2 frames of equal length', () {
        final vertices = new BufferedVertexCollection.fromAttributeData({
          'position': new Vector2Attribute(positionData),
          'color': new Vector3Attribute(colorData)
        });

        test('instantiates a new vertex collection with 2 frames', () {
          expect(vertices.attributeDataFrames.length, equals(2));
        });

        test('instantiates a new vertex collection with the correct length', () {
          expect(vertices.length, equals(3));
        });
      });

      group('from 1 interleaved frame', () {
        final vertices = new BufferedVertexCollection.fromAttributeData({
          'position': new Vector2Attribute(interleavedAttributeData),
          'color': new Vector3Attribute(interleavedAttributeData, offset: 2)
        });

        test('instantiates a new vertex collection with 1 frames', () {
          expect(vertices.attributeDataFrames.length, equals(1));
        });

        test('instantiates a new vertex collection with the correct length', () {
          expect(vertices.length, equals(3));
        });
      });
    });

    group('instance with 1 interleaved attribute data frame', () {
      final attributeData = new AttributeDataFrame(5, [
         // Position    // Color
         0.0,  0.5,     1.0, 0.0, 0.0,
        -0.5, -0.5,     0.0, 1.0, 0.0,
         0.5, -0.5,     0.0, 0.0, 1.0
      ]);

      var vertices = new BufferedVertexCollection.fromAttributeData({
        'position': new Vector2Attribute(attributeData),
        'color': new Vector3Attribute(attributeData, offset: 2)
      });

      group('attributeNames', () {
        test('returns the correct attribute names', () {
          expect(vertices.attributeNames, unorderedEquals(['position', 'color']));
        });
      });

      group('hasAttribute', () {
        test('returns true if the attribute is present', () {
          expect(vertices.hasAttribute('position'), isTrue);
        });

        test('returns false if the attribute is not present', () {
          expect(vertices.hasAttribute('normal'), isFalse);
        });
      });

      group('elementAt', () {
        test('throws a RangeError if the index < 0', () {
          expect(() => vertices.elementAt(-1), throwsRangeError);
        });

        test('throws a RangeError if the index >= length', () {
          expect(() => vertices.elementAt(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          final third = vertices.elementAt(2);

          expect(third.vertexCollection, equals(vertices));
          expect(third.index, equals(2));
        });
      });

      group('indexOf', () {
        test('returns -1 if the vertex is not in the collection', () {
          final other = new BufferedVertexCollection.fromAttributeData({
            'position': new Vector2Attribute(attributeData),
            'color': new Vector3Attribute(attributeData, offset: 2)
          });
          final otherVertex = other.elementAt(1);

          expect(vertices.indexOf(otherVertex), equals(-1));
        });

        test('returns the correct index if the vertex is in the collection', () {
          final second = vertices.elementAt(1);

          expect(vertices.indexOf(second), equals(1));
        });
      });

      group('subCollection', () {
        test('throws a RangeError if start < 0', () {
          expect(() => vertices.subCollection(-1), throwsRangeError);
        });

        test('throws a RangeError if start >= length', () {
          expect(() => vertices.subCollection(3), throwsRangeError);
        });

        test('throws a RangeError if end < start', () {
          expect(() => vertices.subCollection(1, 0), throwsRangeError);
        });

        test('throws a RangeError if end > length', () {
          expect(() => vertices.subCollection(1, 4), throwsRangeError);
        });

        group('without an end specified', () {
          final subCollection = vertices.subCollection(1);

          test('returns a new collection with the correct length', () {
            expect(subCollection.length, equals(2));
          });

          test('returns a new collection with the correct attributes', () {
            expect(subCollection.attributeNames, unorderedEquals(['position', 'color']));
            expect(subCollection.attributes['position'].frame, equals(subCollection.attributes['color'].frame));
            expect(subCollection.attributes['position'].frame.rowLength, equals(5));
          });
        });

        group('with an end specified', () {
          final subCollection = vertices.subCollection(1, 2);

          test('returns a new collection with the correct length', () {
            expect(subCollection.length, equals(1));
          });

          test('returns a new collection with the correct attributes', () {
            expect(subCollection.attributeNames, unorderedEquals(['position', 'color']));
            expect(subCollection.attributes['position'].frame, equals(subCollection.attributes['color'].frame));
            expect(subCollection.attributes['position'].frame.rowLength, equals(5));
          });
        });
      });

      group('[] operator', () {
        test('throws a RangeError if the index < 0', () {
          expect(() => vertices[-1], throwsRangeError);
        });

        test('throws a RangeError if the index >= length', () {
          expect(() => vertices[3], throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          final third = vertices[2];

          expect(third.vertexCollection, equals(vertices));
          expect(third.index, equals(2));
        });
      });
    });

    group('instance with 2 seperate attribute data frames', () {
      final positionData = new AttributeDataFrame(2, [
        0.0,  0.5,
        -0.5, -0.5,
        0.5, -0.5
      ]);
      final colorData = new AttributeDataFrame(3, [
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
      ]);
      final vertices = new BufferedVertexCollection.fromAttributeData({
        'position': new Vector2Attribute(positionData),
        'color': new Vector3Attribute(colorData)
      });

      group('subCollection', () {
        group('without an end specified', () {
          final subCollection = vertices.subCollection(1);

          test('returns a new collection with the correct length', () {
            expect(subCollection.length, equals(2));
          });

          test('returns a new collection with the correct attributes', () {
            expect(subCollection.attributeNames, unorderedEquals(['position', 'color']));
            expect(subCollection.attributes['position'].frame.rowLength, equals(2));
            expect(subCollection.attributes['color'].frame.rowLength, equals(3));
          });
        });

        group('with an end specified', () {
          final subCollection = vertices.subCollection(1, 2);

          test('returns a new collection with the correct length', () {
            expect(subCollection.length, equals(1));
          });

          test('returns a new collection with the correct attributes', () {
            expect(subCollection.attributeNames, unorderedEquals(['position', 'color']));
            expect(subCollection.attributes['position'].frame.rowLength, equals(2));
            expect(subCollection.attributes['color'].frame.rowLength, equals(3));
          });
        });
      });
    });
  });
}
