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
    new Vertex({'position': 5.0 })
  ]);

  group('Lines', () {
    group('default constructor', () {
      final indices = new IndexList.incrementing(5);

      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, indices, -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of indices', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, indices, 5), throwsRangeError);
        });
      });

      group('with a valid offset and a negative count', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, indices, 1, -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the indices', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, indices, 1, 6), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new Lines(vertices, indices, 1, 4).length, equals(2));
        });
      });
    });

    group('[] operator', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);

      test('returns a line view with the correct index', () {
        expect(lines[1].index, equals(1));
      });
    });
  });

  group('LinesIterator', () {
    final indices = new IndexList.incrementing(6);
    final lines = new Lines(vertices, indices);

    group('instance', () {
      final iterator = new LinesIterator(lines);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterated over in a while loop', () {
        var loopCount = 0;
        final lineViewIndices = [];

        while (iterator.moveNext()) {
          loopCount++;
          lineViewIndices.add(iterator.current.index);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(3));
        });

        test('returns the correct line view on each iteration', () {
          expect(lineViewIndices, equals([0, 1, 2]));
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

  group('LinesLineView', () {
    group('get startIndex', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      test('returns the correct value', () {
        expect(lineView.startIndex, equals(2));
      });
    });

    group('set startIndex', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      group('with an index that is out of bounds', () {
        test('throws a RangeError', () {
          expect(() => lineView.startIndex = 6, throwsRangeError);
        });
      });

      group('with a valid index', () {
        lineView.startIndex = 0;

        test('correctly updates the index list', () {
          expect(indices[2], equals(0));
        });
      });
    });

    group('get endIndex', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      test('returns the correct value', () {
        expect(lineView.endIndex, equals(3));
      });
    });

    group('set endIndex', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      group('with an index that is out of bounds', () {
        test('throws a RangeError', () {
          expect(() => lineView.endIndex = 6, throwsRangeError);
        });
      });

      group('with a valid index', () {
        lineView.endIndex = 0;

        test('correctly updates the index list', () {
          expect(indices[3], equals(0));
        });
      });
    });

    group('get start', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      test('returns the correct vertex', () {
        expect(lineView.start['position'], equals(2.0));
      });
    });

    group('get end', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      test('returns the correct vertex', () {
        expect(lineView.end['position'], equals(3.0));
      });
    });
  });
}
