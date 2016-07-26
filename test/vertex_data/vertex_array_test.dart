import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/vertex.dart';
import 'package:bagl/vertex_data.dart';
import '../helpers.dart';

void main () {
  group('VertexArray', () {
    group('default constructor', () {
      test('throws an ArgumentError if vertices have differing numbers of attributes', () {
        expect(() => new VertexArray([
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
        expect(() => new VertexArray([
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
        expect(() => new VertexArray([
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
        final vertices = new VertexArray([
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

        test('returns a vertex array with the correct length', () {
          expect(vertices.length, equals(3));
        });

        test('returns a vertex array with the correct attributes', () {
          expect(vertices.attributes.keys, unorderedEquals(['position', 'color']));
        });

        test('returns a vertex array backed by a single attribute data table not marked as dynamic with the correct row length', () {
          final tables = vertices.attributes.values.map((a) => a.attributeDataTable).toSet();

          expect(tables.length, equals(1));
          expect(tables.first.isDynamic, isFalse);
          expect(tables.first.rowLength, equals(5));
        });
      });
    });

    group('dynamic constructor', () {
      test('throws an ArgumentError if vertices have differing numbers of attributes', () {
        expect(() => new VertexArray.dynamic([
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
        expect(() => new VertexArray.dynamic([
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
        expect(() => new VertexArray.dynamic([
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
        final vertices = new VertexArray.dynamic([
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

        test('returns a vertex array with the correct length', () {
          expect(vertices.length, equals(3));
        });

        test('returns a vertex array with the correct attributes', () {
          expect(vertices.attributes.keys, unorderedEquals(['position', 'color']));
        });

        test('returns a vertex array backed by a single attribute data table marked as dynamic with the correct row length', () {
          final tables = vertices.attributes.values.map((a) => a.attributeDataTable).toSet();

          expect(tables.length, equals(1));
          expect(tables.first.isDynamic, isTrue);
          expect(tables.first.rowLength, equals(5));
        });
      });
    });

    group('fromAttributes constructor', () {
      final positionData = new AttributeDataTable.fromList(2, [
        0.0,  0.5,
        -0.5, -0.5,
        0.5, -0.5
      ]);
      final colorData = new AttributeDataTable.fromList(3, [
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
      ]);
      final interleavedAttributeData = positionData.interleavedWith(colorData);

      test('throws an ArgumentError if the attributes are defined on tables of differening lengths', () {
        final shortColorData = new AttributeDataTable.fromList(3, [
          1.0, 0.0, 0.0,
          0.0, 1.0, 0.0
        ]);

        expect(() => new VertexArray.fromAttributes({
          'position': new Vector2Attribute(positionData),
          'color': new Vector3Attribute(shortColorData)
        }), throwsArgumentError);
      });

      group('from 2 tables of equal length', () {
        final vertices = new VertexArray.fromAttributes({
          'position': new Vector2Attribute(positionData),
          'color': new Vector3Attribute(colorData)
        });

        test('instantiates a new vertex array with 2 tables', () {
          expect(vertices.attributeDataTables.length, equals(2));
        });

        test('instantiates a new vertex array with the correct length', () {
          expect(vertices.length, equals(3));
        });
      });

      group('from 1 interleaved table', () {
        final vertices = new VertexArray.fromAttributes({
          'position': new Vector2Attribute(interleavedAttributeData),
          'color': new Vector3Attribute(interleavedAttributeData, offset: 2)
        });

        test('instantiates a new vertex array with 1 tables', () {
          expect(vertices.attributeDataTables.length, equals(1));
        });

        test('instantiates a new vertex array with the correct length', () {
          expect(vertices.length, equals(3));
        });
      });
    });

    group('instance with 1 interleaved attribute data table', () {
      final attributeData = new AttributeDataTable.fromList(5, [
         // Position    // Color
         0.0,  0.5,     1.0, 0.0, 0.0,
        -0.5, -0.5,     0.0, 1.0, 0.0,
         0.5, -0.5,     0.0, 0.0, 1.0
      ]);

      var vertices = new VertexArray.fromAttributes({
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

          expect(third.vertexArray, equals(vertices));
          expect(third.index, equals(2));
        });
      });

      group('indexOf', () {
        test('returns -1 if the vertex is not in the vertex array', () {
          final other = new VertexArray.fromAttributes({
            'position': new Vector2Attribute(attributeData),
            'color': new Vector3Attribute(attributeData, offset: 2)
          });
          final otherVertex = other.elementAt(1);

          expect(vertices.indexOf(otherVertex), equals(-1));
        });

        test('returns the correct index if the vertex is in the vertex array', () {
          final second = vertices.elementAt(1);

          expect(vertices.indexOf(second), equals(1));
        });
      });

      group('subArray', () {
        test('throws a RangeError if start < 0', () {
          expect(() => vertices.subArray(-1), throwsRangeError);
        });

        test('throws a RangeError if start >= length', () {
          expect(() => vertices.subArray(3), throwsRangeError);
        });

        test('throws a RangeError if end < start', () {
          expect(() => vertices.subArray(1, 0), throwsRangeError);
        });

        test('throws a RangeError if end > length', () {
          expect(() => vertices.subArray(1, 4), throwsRangeError);
        });

        group('without an end specified', () {
          final subArray = vertices.subArray(1);

          test('returns a new vertex array with the correct length', () {
            expect(subArray.length, equals(2));
          });

          test('returns a new vertex array with the correct attributes', () {
            expect(subArray.attributeNames, unorderedEquals(['position', 'color']));
            expect(subArray.attributes['position'].attributeDataTable, equals(subArray.attributes['color'].attributeDataTable));
            expect(subArray.attributes['position'].attributeDataTable.rowLength, equals(5));
          });
        });

        group('with an end specified', () {
          final subArray = vertices.subArray(1, 2);

          test('returns a new vertex array with the correct length', () {
            expect(subArray.length, equals(1));
          });

          test('returns a new vertex array with the correct attributes', () {
            expect(subArray.attributeNames, unorderedEquals(['position', 'color']));
            expect(subArray.attributes['position'].attributeDataTable, equals(subArray.attributes['color'].attributeDataTable));
            expect(subArray.attributes['position'].attributeDataTable.rowLength, equals(5));
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

          expect(third.vertexArray, equals(vertices));
          expect(third.index, equals(2));
        });
      });
    });

    group('instance with 2 seperate attribute data tables', () {
      final positionData = new AttributeDataTable.fromList(2, [
        0.0,  0.5,
        -0.5, -0.5,
        0.5, -0.5
      ]);
      final colorData = new AttributeDataTable.fromList(3, [
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
      ]);
      final vertices = new VertexArray.fromAttributes({
        'position': new Vector2Attribute(positionData),
        'color': new Vector3Attribute(colorData)
      });

      group('subArray', () {
        group('without an end specified', () {
          final subArray = vertices.subArray(1);

          test('returns a new vertex array with the correct length', () {
            expect(subArray.length, equals(2));
          });

          test('returns a new vertex array with the correct attributes', () {
            expect(subArray.attributeNames, unorderedEquals(['position', 'color']));
            expect(subArray.attributes['position'].attributeDataTable.rowLength, equals(2));
            expect(subArray.attributes['color'].attributeDataTable.rowLength, equals(3));
          });
        });

        group('with an end specified', () {
          final subArray = vertices.subArray(1, 2);

          test('returns a new vertex array with the correct length', () {
            expect(subArray.length, equals(1));
          });

          test('returns a new vertex array with the correct attributes', () {
            expect(subArray.attributeNames, unorderedEquals(['position', 'color']));
            expect(subArray.attributes['position'].attributeDataTable.rowLength, equals(2));
            expect(subArray.attributes['color'].attributeDataTable.rowLength, equals(3));
          });
        });
      });
    });
  });

  group('VertexArrayIterator', () {
    final vertices = new VertexArray([
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

    group('instance', () {
      final iterator = new VertexArrayIterator(vertices);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterator over in a while loop', () {
        var loopCount = 0;
        var vertices = [];

        while (iterator.moveNext()) {
          loopCount++;
          vertices.add(iterator.current);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(3));
        });

        test('returns the correct current value on each iteration', () {
          expect(vertices[0].index, equals(0));
          expect(vertices[1].index, equals(1));
          expect(vertices[2].index, equals(2));
        });

        test('returns null as the current value after iterating', () {
          expect(iterator.current, isNull);
        });

        test('returns false on moveNext after iterating', () {
          expect(iterator.moveNext(), isFalse);
        });
      });
    });
  });

  group('VertexArrayVertexView', () {
    final vertices = new VertexArray([
      new Vertex({
        'position': new Vector2(-1.0, -1.0),
        'color': new Vector3(0.0, 1.0, 0.0)
      }),
      new Vertex({
        'position': new Vector2(0.0, 1.0),
        'color': new Vector3(1.0, 0.0, 0.0)
      }),
      new Vertex({
        'position': new Vector2(1.0, -1.0),
        'color': new Vector3(0.0, 0.0, 1.0)
      })
    ]);

    group('instance', () {
      final vertex = new VertexArrayVertexView(vertices, 1);

      group('attributeNames', () {
        test('returns the correct attribute names', () {
          expect(vertex.attributeNames, unorderedEquals(['position', 'color']));
        });
      });

      group('attributeValues', () {
        test('returns the correct attribute values', () {
          expect(vertex.attributeValues, unorderedEquals([
            new Vector2(0.0, 1.0),
            new Vector3(1.0, 0.0, 0.0)
          ]));
        });
      });

      group('hasAttribute', () {
        test('returns true if the attribute is present', () {
          expect(vertex.hasAttribute('position'), isTrue);
        });

        test('returns false if the attribute is not present', () {
          expect(vertex.hasAttribute('normal'), isFalse);
        });
      });

      group('toMap', () {
        var map = vertex.toMap();

        test('returns a map with the correct length', () {
          expect(map.length, equals(2));
        });

        test('returns a map with the correct name-value pairs', () {
          expect(map, containsPair('position', new Vector2(0.0, 1.0)));
          expect(map, containsPair('color', new Vector3(1.0, 0.0, 0.0)));
        });
      });

      group('[] operator', () {
        test('returns null when the attribute is not present', () {
          expect(vertex['normal'], isNull);
        });

        test('returns the correct value when the attribute is present', () {
          expect(vertex['position'], equals(new Vector2(0.0, 1.0)));
        });
      });

      group('[]= operator', () {
        test('throws an ArgumentError when the attribute is not present', () {
          expect(() => vertex['normal'] = new Vector3(0.5, 0.5, 0.5), throwsArgumentError);
        });

        group('with a valid attribute name', () {
          final vertices = new VertexArray([
            new Vertex({
              'position': new Vector2(-1.0, -1.0),
              'color': new Vector3(0.0, 1.0, 0.0)
            }),
            new Vertex({
              'position': new Vector2(0.0, 1.0),
              'color': new Vector3(1.0, 0.0, 0.0)
            }),
            new Vertex({
              'position': new Vector2(1.0, -1.0),
              'color': new Vector3(0.0, 0.0, 1.0)
            })
          ]);

          final vertex = new VertexArrayVertexView(vertices, 1);

          vertex['position'] = new Vector2(0.5, 0.5);

          test('correctly updates the attribute value', () {
            expect(vertex['position'], equals(new Vector2(0.5, 0.5)));
          });

          test('correctly updates the attribute data', () {
            expect(vertices.attributeDataTables.first[1], orderedCloseTo([0.5, 0.5, 1.0, 0.0, 0.0], 0.00001));
          });
        });
      });
    });
  });
}
