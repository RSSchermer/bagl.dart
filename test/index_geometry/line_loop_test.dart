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

  group('LineLoop', () {
    group('default constructor', () {
      final indices = new IndexList.incrementing(5);

      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, indices, -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of indices', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, indices, 5), throwsRangeError);
        });
      });

      group('with a valid offset and a negative count', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, indices, 1, -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the indices', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, indices, 1, 5), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        group('with a count smaller than 2', () {
          test('returns an instance with a length of 0', () {
            expect(new LineLoop(vertices, indices, 1, 1).length, equals(0));
          });
        });

        group('with a count of 2', () {
          test('returns an instance with a length of 2', () {
            expect(new LineLoop(vertices, indices, 1, 2).length, equals(2));
          });
        });
      });
    });

    group('[] operator', () {
      final indices = new IndexList.incrementing(6);
      final lineLoop = new LineLoop(vertices, indices);

      test('returns a line view with the correct index', () {
        expect(lineLoop[1].index, equals(1));
      });
    });
  });

  group('LineLoopIterator', () {
    final indices = new IndexList.incrementing(3);
    final lineLoop = new LineLoop(vertices, indices);

    group('instance', () {
      final iterator = new LineLoopIterator(lineLoop);

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

  group('LineLoopLineView', () {
    group('not the final line', () {
      final indices = new IndexList.incrementing(6);
      final lineLoop = new LineLoop(vertices, indices);
      final lineView = new LineLoopLineView(lineLoop, 1);

      group('get startIndex', () {
        test('returns the correct value', () {
          expect(lineView.startIndex, equals(1));
        });
      });

      group('get endIndex', () {
        test('returns the correct value', () {
          expect(lineView.endIndex, equals(2));
        });
      });

      group('get start', () {
        test('returns the correct vertex', () {
          expect(lineView.start['position'], equals(1.0));
        });
      });

      group('get end', () {
        test('returns the correct vertex', () {
          expect(lineView.end['position'], equals(2.0));
        });
      });
    });

    group('the final line', () {
      final indices = new IndexList.incrementing(6);
      final lineLoop = new LineLoop(vertices, indices);
      final lineView = new LineLoopLineView(lineLoop, 5);

      group('get startIndex', () {
        test('returns the correct value', () {
          expect(lineView.startIndex, equals(5));
        });
      });

      group('get endIndex', () {
        test('returns the correct value', () {
          expect(lineView.endIndex, equals(0));
        });
      });

      group('get start', () {
        test('returns the correct vertex', () {
          expect(lineView.start['position'], equals(5.0));
        });
      });

      group('get end', () {
        test('returns the correct vertex', () {
          expect(lineView.end['position'], equals(0.0));
        });
      });
    });
  });
}