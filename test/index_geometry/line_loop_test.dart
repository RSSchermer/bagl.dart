import 'package:test/test.dart';
import 'package:bagl/geometry.dart';
import 'package:bagl/index_list.dart';
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
      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, offset: -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of vertexArray', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, offset: 6), throwsRangeError);
        });
      });

      group('with a negative count', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, count: -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the vertex array', () {
        test('throws a RangeError', () {
          expect(() => new LineLoop(vertices, offset: 1, count: 6), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new LineLoop(vertices, offset: 1, count: 4).length, equals(4));
        });
      });

      group('with an index list', () {
        final indexList = new Index16List.fromList([0, 1, 2, 3, 1, 2, 3, 4]);

        group('with an offset equal to the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new LineLoop(vertices, indices: indexList, offset: 8), throwsRangeError);
          });
        });

        group('with an offset and count whose sum is greater than the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new LineLoop(vertices, offset: 1, count: 8), throwsRangeError);
          });
        });

        group('with a valid offset and count', () {
          test('returns an instance with the correct length', () {
            expect(new LineLoop(vertices, indices: indexList, offset: 2, count: 6).length, equals(6));
          });
        });
      });
    });

    group('instance without an index list', () {
      final lineLoop = new LineLoop(vertices);

      group('iterator', () {
        final iterator = lineLoop.iterator;

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
            expect(loopCount, equals(6));
          });

          test('returns the correct point view on each iteration', () {
            expect(pointViewIndices, equals([0, 1, 2, 3, 4, 5]));
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
          expect(lineLoop.count, equals(6));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => lineLoop.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => lineLoop.count = 7, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() => lineLoop.count = 4);
            tearDown(() => lineLoop.count = 6);

            test('correctly updates the count', () {
              expect(lineLoop.count, equals(4));
            });

            test('correctly updates the length', () {
              expect(lineLoop.length, equals(4));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(lineLoop[1].index, equals(1));
        });
      });
    });

    group('instance with an index list', () {
      final indexList = new Index16List.fromList([0, 5, 4, 3, 2, 1]);
      final lineLoop = new LineLoop(vertices, indices: indexList);

      group('iterator', () {
        final iterator = lineLoop.iterator;

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
            expect(loopCount, equals(6));
          });

          test('returns the correct point view on each iteration', () {
            expect(pointViewIndices, equals([0, 1, 2, 3, 4, 5]));
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
          expect(lineLoop.count, equals(6));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => lineLoop.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => lineLoop.count = 7, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() =>lineLoop.count = 4);
            tearDown(() => lineLoop.count = 6);

            test('correctly updates the count', () {
              expect(lineLoop.count, equals(4));
            });

            test('correctly updates the length', () {
              expect(lineLoop.length, equals(4));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(lineLoop[1].index, equals(1));
        });
      });
    });
  });

  group('LineLoopLineView', () {
    group('instance defined on LineLoop without an index list', () {
      final lineLoop = new LineLoop(vertices);
      final lineView = new LineLoopLineView(lineLoop, 1);

      test('startIndex returns the correct value', () {
        expect(lineView.startIndex, equals(1));
      });

      test('startOffset returns the correct value', () {
        expect(lineView.startOffset, equals(1));
      });

      test('start returns the correct vertex', () {
        expect(lineView.start['position'], equals(1.0));
      });

      test('endIndex returns the correct value', () {
        expect(lineView.endIndex, equals(2));
      });

      test('endOffset returns the correct value', () {
        expect(lineView.endOffset, equals(2));
      });

      test('end returns the correct vertex', () {
        expect(lineView.end['position'], equals(2.0));
      });
    });

    group('instance defined on LineLoop with an index list', () {
      final indexList = new Index16List.fromList([3, 2, 1, 0]);
      final lineLoop = new LineLoop(vertices, indices: indexList);
      final lineView = new LineLoopLineView(lineLoop, 1);

      test('startIndex returns the correct value', () {
        expect(lineView.startIndex, equals(2));
      });

      test('startOffset returns the correct value', () {
        expect(lineView.startOffset, equals(1));
      });

      test('start returns the correct vertex', () {
        expect(lineView.start['position'], equals(2.0));
      });

      test('endIndex returns the correct value', () {
        expect(lineView.endIndex, equals(1));
      });

      test('endOffset returns the correct value', () {
        expect(lineView.endOffset, equals(2));
      });

      test('end returns the correct vertex', () {
        expect(lineView.end['position'], equals(1.0));
      });
    });

    group('instance of the final line defined on LineLoop without an index list', () {
      final lineLoop = new LineLoop(vertices);
      final lineView = new LineLoopLineView(lineLoop, 5);

      test('startIndex returns the correct value', () {
        expect(lineView.startIndex, equals(5));
      });

      test('startOffset returns the correct value', () {
        expect(lineView.startOffset, equals(5));
      });

      test('start returns the correct vertex', () {
        expect(lineView.start['position'], equals(5.0));
      });

      test('endIndex returns the correct value', () {
        expect(lineView.endIndex, equals(0));
      });

      test('endOffset returns the correct value', () {
        expect(lineView.endOffset, equals(0));
      });

      test('end returns the correct vertex', () {
        expect(lineView.end['position'], equals(0.0));
      });
    });
  });
}
