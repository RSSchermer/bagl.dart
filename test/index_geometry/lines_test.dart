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
      group('with an index list with a length that is not a multiple of 3', () {
        test('throws an ArgumentError', () {
          final indices = new IndexList.incrementing(5);

          expect(() => new Lines(vertices, indices), throwsArgumentError);
        });
      });

      group('with an index list with a length that is a multiple of 3', () {
        final indices = new IndexList.incrementing(4);

        test('results in an instance with the correct length', () {
          final lines = new Lines(vertices, indices);

          expect(lines.length, equals(2));
        });
      });

      group('with a range start', () {
        final indices = new IndexList.incrementing(5);

        test('results in an instance with the correct length', () {
          final lines = new Lines(vertices, indices, 1);

          expect(lines.length, equals(2));
        });
      });

      group('with a range start and end', () {
        final indices = new IndexList.incrementing(6);

        test('results in an instance with the correct length', () {
          final lines = new Lines(vertices, indices, 1, 5);

          expect(lines.length, equals(2));
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

    group('set start', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      group('with a vertex that does not belong to the vertex array on which the lines are defined', () {
        test('throws an ArgumentError', () {
          expect(() => lineView.start = new Vertex({'position': 0.0}), throwsArgumentError);
        });
      });

      group('with a vertex that does belong to the vertex array on which the lines are defined', () {
        lineView.start = vertices[0];

        test('correctly updates the index list', () {
          expect(indices[2], equals(0));
        });
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

    group('set end', () {
      final indices = new IndexList.incrementing(6);
      final lines = new Lines(vertices, indices);
      final lineView = new LinesLineView(lines, 1);

      group('with a vertex that does not belong to the vertex array on which the lines are defined', () {
        test('throws an ArgumentError', () {
          expect(() => lineView.end = new Vertex({'position': 0.0}), throwsArgumentError);
        });
      });

      group('with a vertex that does belong to the vertex array on which the lines are defined', () {
        lineView.end = vertices[0];

        test('correctly updates the index list', () {
          expect(indices[3], equals(0));
        });
      });
    });
  });
}
