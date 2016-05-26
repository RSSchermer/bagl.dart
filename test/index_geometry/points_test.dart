import 'package:test/test.dart';
import 'package:bagl/index_geometry.dart';
import 'package:bagl/vertex.dart';
import 'package:bagl/vertex_data.dart';

void main() {
  final vertices = new VertexArray([
    new Vertex({'position': 0.0 }),
    new Vertex({'position': 1.0 }),
    new Vertex({'position': 2.0 }),
    new Vertex({'position': 3.0 })
  ]);

  group('Points', () {
    group('default constructor', () {
      final indices = new IndexList.incrementing(4);

      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, indices, -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of indices', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, indices, 4), throwsRangeError);
        });
      });

      group('with a valid offset and a negative count', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, indices, 1, -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the indices', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, indices, 1, 4), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new Points(vertices, indices, 1, 3).length, equals(3));
        });
      });
    });

    group('[] operator', () {
      final indices = new IndexList.incrementing(4);
      final points = new Points(vertices, indices);

      test('returns a point view with the correct index', () {
        expect(points[1].index, equals(1));
      });
    });
  });

  group('PointsIterator', () {
    final indices = new IndexList.incrementing(4);
    final points = new Points(vertices, indices);

    group('instance', () {
      final iterator = new PointsIterator(points);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterated over in a while loop', () {
        var loopCount = 0;
        final pointViewIndices = [];

        while (iterator.moveNext()) {
          loopCount++;
          pointViewIndices.add(iterator.current.index);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(4));
        });

        test('returns the correct point view on each iteration', () {
          expect(pointViewIndices, equals([0, 1, 2, 3]));
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

  group('PointsPointView', () {
    group('get vertexIndex', () {
      final indices = new IndexList.incrementing(4);
      final points = new Points(vertices, indices);
      final pointView = new PointsPointView(points, 1);

      test('returns the correct value', () {
        expect(pointView.vertexIndex, equals(1));
      });
    });

    group('set vertexIndex', () {
      final indices = new IndexList.incrementing(4);
      final points = new Points(vertices, indices);
      final pointView = new PointsPointView(points, 1);

      group('with an index that is out of bounds', () {
        test('throws a RangeError', () {
          expect(() => pointView.vertexIndex = 4, throwsRangeError);
        });
      });

      group('with a valid index', () {
        pointView.vertexIndex = 0;

        test('correctly updates the index list', () {
          expect(indices[1], equals(0));
        });
      });
    });

    group('get vertex', () {
      final indices = new IndexList.incrementing(4);
      final points = new Points(vertices, indices);
      final pointView = new PointsPointView(points, 1);

      test('returns the correct vertex', () {
        expect(pointView.vertex['position'], equals(1.0));
      });
    });
  });
}
