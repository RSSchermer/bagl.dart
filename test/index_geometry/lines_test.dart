import 'package:test/test.dart';
import 'package:bagl/geometry.dart';
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
      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, offset: -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of vertexArray', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, offset: 6), throwsRangeError);
        });
      });

      group('with a negative count', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, count: -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the vertex array', () {
        test('throws a RangeError', () {
          expect(() => new Lines(vertices, offset: 1, count: 6), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new Lines(vertices, offset: 1, count: 4).length, equals(2));
        });
      });

      group('with an index list', () {
        final indexList = new IndexList.fromList([0, 1, 2, 3, 1, 2, 3, 4]);

        group('with an offset equal to the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new Lines(vertices, indexList: indexList, offset: 8), throwsRangeError);
          });
        });

        group('with an offset and count whose sum is greater than the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new Lines(vertices, offset: 1, count: 8), throwsRangeError);
          });
        });

        group('with a valid offset and count', () {
          test('returns an instance with the correct length', () {
            expect(new Lines(vertices, indexList: indexList, offset: 2, count: 6).length, equals(3));
          });
        });
      });
    });

    group('instance without an index list', () {
      final lines = new Lines(vertices);

      group('iterator', () {
        final iterator = lines.iterator;

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
            expect(loopCount, equals(3));
          });

          test('returns the correct point view on each iteration', () {
            expect(pointViewIndices, equals([0, 1, 2]));
          });

          test('returns null as the current value after iterating', () {
            expect(iterator.current, isNull);
          });

          test('returns false on moveNext after iterating', () {
            expect(iterator.moveNext(), isFalse);
          });
        });
      });

      group('count', () {
        test('returns the correct value', () {
          expect(lines.count, equals(6));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => lines.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => lines.count = 7, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() => lines.count = 4);
            tearDown(() => lines.count = 6);

            test('correctly updates the count', () {
              expect(lines.count, equals(4));
            });

            test('correctly updates the length', () {
              expect(lines.length, equals(2));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(lines[1].index, equals(1));
        });
      });
    });

    group('instance with an index list', () {
      final indexList = new IndexList.fromList([0, 5, 4, 3, 2, 1]);
      final lines = new Lines(vertices, indexList: indexList);

      group('iterator', () {
        final iterator = lines.iterator;

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
            expect(loopCount, equals(3));
          });

          test('returns the correct point view on each iteration', () {
            expect(pointViewIndices, equals([0, 1, 2]));
          });

          test('returns null as the current value after iterating', () {
            expect(iterator.current, isNull);
          });

          test('returns false on moveNext after iterating', () {
            expect(iterator.moveNext(), isFalse);
          });
        });
      });

      group('count', () {
        test('returns the correct value', () {
          expect(lines.count, equals(6));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => lines.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => lines.count = 7, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() =>lines.count = 4);
            tearDown(() => lines.count = 6);

            test('correctly updates the count', () {
              expect(lines.count, equals(4));
            });

            test('correctly updates the length', () {
              expect(lines.length, equals(2));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(lines[1].index, equals(1));
        });
      });
    });
  });

  group('LinesLineView', () {
    group('instance defined on Lines without an index list', () {
      final lines = new Lines(vertices);
      final lineView = new LinesLineView(lines, 1);

      test('startIndex returns the correct value', () {
        expect(lineView.startIndex, equals(2));
      });

      test('startOffset returns the correct value', () {
        expect(lineView.startOffset, equals(2));
      });

      test('start returns the correct vertex', () {
        expect(lineView.start['position'], equals(2.0));
      });

      test('endIndex returns the correct value', () {
        expect(lineView.endIndex, equals(3));
      });

      test('endOffset returns the correct value', () {
        expect(lineView.endOffset, equals(3));
      });

      test('end returns the correct vertex', () {
        expect(lineView.end['position'], equals(3.0));
      });
    });

    group('instance defined on Lines with an index list', () {
      final indexList = new IndexList.fromList([3, 2, 1, 0]);
      final lines = new Lines(vertices, indexList: indexList);
      final lineView = new LinesLineView(lines, 1);

      test('startIndex returns the correct value', () {
        expect(lineView.startIndex, equals(1));
      });

      test('startOffset returns the correct value', () {
        expect(lineView.startOffset, equals(2));
      });

      test('start returns the correct vertex', () {
        expect(lineView.start['position'], equals(1.0));
      });

      test('endIndex returns the correct value', () {
        expect(lineView.endIndex, equals(0));
      });

      test('endOffset returns the correct value', () {
        expect(lineView.endOffset, equals(3));
      });

      test('end returns the correct vertex', () {
        expect(lineView.end['position'], equals(0.0));
      });
    });
  });
}
