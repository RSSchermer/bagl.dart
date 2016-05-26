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

  group('LineStrip', () {
    group('default constructor', () {
      final indices = new IndexList.incrementing(6);

      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new LineStrip(vertices, indices, -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of indices', () {
        test('throws a RangeError', () {
          expect(() => new LineStrip(vertices, indices, 6), throwsRangeError);
        });
      });

      group('with a valid offset and a negative count', () {
        test('throws a RangeError', () {
          expect(() => new LineStrip(vertices, indices, 1, -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the indices', () {
        test('throws a RangeError', () {
          expect(() => new LineStrip(vertices, indices, 1, 6), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        group('with a count smaller than 2', () {
          test('returns an instance with a length of 0', () {
            expect(new LineStrip(vertices, indices, 1, 1).length, equals(0));
          });
        });

        group('with a count of 2', () {
          test('returns an instance with a length of 2', () {
            expect(new LineStrip(vertices, indices, 1, 2).length, equals(1));
          });
        });
      });
    });

    group('[] operator', () {
      final indices = new IndexList.incrementing(6);
      final lineStrip = new LineStrip(vertices, indices);

      test('returns a line view with the correct index', () {
        expect(lineStrip[1].index, equals(1));
      });
    });
  });

  group('LineStripIterator', () {
    final indices = new IndexList.incrementing(4);
    final lineStrip = new LineStrip(vertices, indices);

    group('instance', () {
      final iterator = new LineStripIterator(lineStrip);

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

  group('LineStripLineView', () {
    group('get startIndex', () {
      final indices = new IndexList.incrementing(6);
      final lineStrip = new LineStrip(vertices, indices);
      final lineView = new LineStripLineView(lineStrip, 1);

      test('returns the correct value', () {
        expect(lineView.startIndex, equals(1));
      });
    });

    group('get endIndex', () {
      final indices = new IndexList.incrementing(6);
      final lineStrip = new LineStrip(vertices, indices);
      final lineView = new LineStripLineView(lineStrip, 1);

      test('returns the correct value', () {
        expect(lineView.endIndex, equals(2));
      });
    });

    group('get start', () {
      final indices = new IndexList.incrementing(6);
      final lineStrip = new LineStrip(vertices, indices);
      final lineView = new LineStripLineView(lineStrip, 1);

      test('returns the correct vertex', () {
        expect(lineView.start['position'], equals(1.0));
      });
    });

    group('get end', () {
      final indices = new IndexList.incrementing(6);
      final lineStrip = new LineStrip(vertices, indices);
      final lineView = new LineStripLineView(lineStrip, 1);

      test('returns the correct vertex', () {
        expect(lineView.end['position'], equals(2.0));
      });
    });
  });
}
