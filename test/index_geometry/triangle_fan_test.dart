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

  group('TriangleFan', () {
    group('default constructor', () {
      final indices = new IndexList.incrementing(8);

      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, indices, -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of indices', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, indices, 8), throwsRangeError);
        });
      });

      group('with a valid offset and a negative count', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, indices, 1, -1), throwsRangeError);
        });
      });

      group(
          'with an offset and count whose sum is greater than the length of the indices', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, indices, 1, 8), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        group('with a count smaller than 3', () {
          test('returns an instance with a length of 0', () {
            expect(new TriangleFan(vertices, indices, 1, 2).length, equals(0));
          });
        });

        group('with a count of 2', () {
          test('returns an instance with a length of 3', () {
            expect(new TriangleFan(vertices, indices, 1, 3).length, equals(1));
          });
        });
      });
    });

    group('iterator', () {
      final indices = new IndexList.incrementing(5);
      final triangleFan = new TriangleFan(vertices, indices);

      group('instance', () {
        final iterator = triangleFan.iterator;

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
      final triangleFan = new TriangleFan(vertices, indices);

      test('returns a triangle view with the correct index', () {
        expect(triangleFan[1].index, equals(1));
      });
    });
  });

  group('TriangleFanTriangleView', () {
    final indices = new IndexList.incrementing(9);
    final triangleFan = new TriangleFan(vertices, indices);
    final triangleView = new TriangleFanTriangleView(triangleFan, 2);

    group('get aIndex', () {
      test('returns the correct value', () {
        expect(triangleView.aIndex, equals(0));
      });
    });

    group('get bIndex', () {
      test('returns the correct value', () {
        expect(triangleView.bIndex, equals(3));
      });
    });

    group('get cIndex', () {
      test('returns the correct value', () {
        expect(triangleView.cIndex, equals(4));
      });
    });

    group('get a', () {
      test('returns the correct vertex', () {
        expect(triangleView.a['position'], equals(0.0));
      });
    });

    group('get b', () {
      test('returns the correct vertex', () {
        expect(triangleView.b['position'], equals(3.0));
      });
    });

    group('get c', () {
      test('returns the correct vertex', () {
        expect(triangleView.c['position'], equals(4.0));
      });
    });
  });
}
