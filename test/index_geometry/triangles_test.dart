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
      final indices = new IndexList.incrementing(7);

      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new Triangles(vertices, indices, -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of indices', () {
        test('throws a RangeError', () {
          expect(() => new Triangles(vertices, indices, 7), throwsRangeError);
        });
      });

      group('with a valid offset and a negative count', () {
        test('throws a RangeError', () {
          expect(() => new Triangles(vertices, indices, 1, -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the indices', () {
        test('throws a RangeError', () {
          expect(() => new Triangles(vertices, indices, 1, 7), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new Triangles(vertices, indices, 1, 6).length, equals(2));
        });
      });
    });

    group('iterator', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);

      group('instance', () {
        final iterator = triangles.iterator;

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

    group('[] operator', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);

      test('returns a triangle view with the correct index', () {
        expect(triangles[1].index, equals(1));
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

    group('get b', () {
      final indices = new IndexList.incrementing(9);
      final triangles = new Triangles(vertices, indices);
      final triangleView = new TrianglesTriangleView(triangles, 1);

      test('returns the correct vertex', () {
        expect(triangleView.b['position'], equals(4.0));
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
  });
}
