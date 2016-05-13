import 'package:test/test.dart';
import 'package:bagl/index_geometry.dart';
import 'package:bagl/vertex.dart';
import 'package:bagl/vertex_data.dart';

void main() {
  final vertices = new VertexArray([
    new Vertex({'position': 0.0 }),
    new Vertex({'position': 1.0 }),
    new Vertex({'position': 2.0 }),
    new Vertex({'position': 3.0 }),
    new Vertex({'position': 4.0 }),
    new Vertex({'position': 5.0 }),
    new Vertex({'position': 6.0 }),
    new Vertex({'position': 7.0 }),
    new Vertex({'position': 8.0 })
  ]);

  group('Triangles', () {
    group('default constructor', () {
      group('with an index list with a length that is not a multiple of 3', () {
        test('throws an ArgumentError', () {
          final indices = new IndexList.incrementing(7);

          expect(() => new Triangles(vertices, indices), throwsArgumentError);
        });
      });

      group('with an index list with a length that is a multiple of 3', () {
        final indices = new IndexList.incrementing(6);

        test('results in an instance with the correct length', () {
          final triangles = new Triangles(vertices, indices);

          expect(triangles.length, equals(2));
        });
      });

      group('with a range start', () {
        final indices = new IndexList.incrementing(7);

        test('results in an instance with the correct length', () {
          final triangles = new Triangles(vertices, indices, 1);

          expect(triangles.length, equals(2));
        });
      });

      group('with a range start and end', () {
        final indices = new IndexList.incrementing(8);

        test('results in an instance with the correct length', () {
          final triangles = new Triangles(vertices, indices, 1, 7);

          expect(triangles.length, equals(2));
        });
      });
    });
  });

  group('TrianglesIterator', () {
    final indices = new IndexList.incrementing(9);
    final triangles = new Triangles(vertices, indices);

    group('instance', () {
      final iterator = new TrianglesIterator(triangles);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterated over in a while loop', () {
        var loopCount = 0;
        final triangleViewIndices = [];

        while (iterator.moveNext()) {
          loopCount++;
          triangleViewIndices.add(iterator.current.index);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(3));
        });

        test('returns the correct triangle view on each iteration', () {
          expect(triangleViewIndices, equals([0, 1, 2]));
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

  group('TrianglesTriangleView', () {
    group('get aIndex', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct value', () {
        expect(triangleView.aIndex, equals(3));
      });
    });

    group('set aIndex', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      group('with an index that is out of bounds', () {
        test('throws a RangeError', () {
          expect(() => triangleView.aIndex = 9, throwsRangeError);
        });
      });

      group('with a valid index', () {
        triangleView.aIndex = 0;

        test('correctly updates the index list', () {
          expect(indices[3], equals(0));
        });
      });
    });

    group('get bIndex', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct value', () {
        expect(triangleView.bIndex, equals(4));
      });
    });

    group('set bIndex', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      group('with an index that is out of bounds', () {
        test('throws a RangeError', () {
          expect(() => triangleView.bIndex = 9, throwsRangeError);
        });
      });

      group('with a valid index', () {
        triangleView.bIndex = 0;

        test('correctly updates the index list', () {
          expect(indices[4], equals(0));
        });
      });
    });

    group('get cIndex', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct value', () {
        expect(triangleView.cIndex, equals(5));
      });
    });

    group('set cIndex', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      group('with an index that is out of bounds', () {
        test('throws a RangeError', () {
          expect(() => triangleView.cIndex = 9, throwsRangeError);
        });
      });

      group('with a valid index', () {
        triangleView.cIndex = 0;

        test('correctly updates the index list', () {
          expect(indices[5], equals(0));
        });
      });
    });

    group('get a', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct vertex', () {
        expect(triangleView.a['position'], equals(3.0));
      });
    });

    group('set a', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      group('with a vertex that does not belong to the vertex array on which the triangles are defined', () {
        test('throws an ArgumentError', () {
          expect(() => triangleView.a = new Vertex({'position': 0.0}), throwsArgumentError);
        });
      });

      group('with a vertex that does belong to the vertex array on which the triangles are defined', () {
        triangleView.a = vertices[0];

        test('correctly updates the index list', () {
          expect(indices[3], equals(0));
        });
      });
    });

    group('get b', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct vertex', () {
        expect(triangleView.b['position'], equals(4.0));
      });
    });

    group('set b', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      group('with a vertex that does not belong to the vertex array on which the triangles are defined', () {
        test('throws an ArgumentError', () {
          expect(() => triangleView.b = new Vertex({'position': 0.0}), throwsArgumentError);
        });
      });

      group('with a vertex that does belong to the vertex array on which the triangles are defined', () {
        triangleView.b = vertices[0];

        test('correctly updates the index list', () {
          expect(indices[4], equals(0));
        });
      });
    });

    group('get c', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct vertex', () {
        expect(triangleView.c['position'], equals(5.0));
      });
    });

    group('set c', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      group('with a vertex that does not belong to the vertex array on which the triangles are defined', () {
        test('throws an ArgumentError', () {
          expect(() => triangleView.c = new Vertex({'position': 0.0}), throwsArgumentError);
        });
      });

      group('with a vertex that does belong to the vertex array on which the triangles are defined', () {
        triangleView.c = vertices[0];

        test('correctly updates the index list', () {
          expect(indices[5], equals(0));
        });
      });
    });
  });
}
