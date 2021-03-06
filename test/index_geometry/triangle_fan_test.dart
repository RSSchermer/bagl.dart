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
    new Vertex({'position': 5.0 }),
    new Vertex({'position': 6.0 }),
    new Vertex({'position': 7.0 }),
    new Vertex({'position': 8.0 })
  ]);

  group('TriangleFan', () {
    group('default constructor', () {
      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, offset: -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of vertexArray', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, offset: 8), throwsRangeError);
        });
      });

      group('with a negative count', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, count: -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the vertex array', () {
        test('throws a RangeError', () {
          expect(() => new TriangleFan(vertices, offset: 1, count: 9), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new TriangleFan(vertices, offset: 1, count: 6).length, equals(4));
        });
      });

      group('with an index list', () {
        final indexList = new Index16List.fromList([0, 1, 2, 3, 4, 1, 2, 3, 4, 5]);

        group('with an offset equal to the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new TriangleFan(vertices, indices: indexList, offset: 10), throwsRangeError);
          });
        });

        group('with an offset and count whose sum is greater than the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new TriangleFan(vertices, offset: 1, count: 10), throwsRangeError);
          });
        });

        group('with a valid offset and count', () {
          test('returns an instance with the correct length', () {
            expect(new TriangleFan(vertices, indices: indexList, offset: 2, count: 6).length, equals(4));
          });
        });
      });
    });

    group('instance without an index list', () {
      final triangleFan = new TriangleFan(vertices);

      group('iterator', () {
        final iterator = triangleFan.iterator;

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
            expect(loopCount, equals(7));
          });

          test('returns the correct point view on each iteration', () {
            expect(pointViewIndices, equals([0, 1, 2, 3, 4, 5, 6]));
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
          expect(triangleFan.count, equals(9));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => triangleFan.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => triangleFan.count = 10, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() => triangleFan.count = 6);
            tearDown(() => triangleFan.count = 9);

            test('correctly updates the count', () {
              expect(triangleFan.count, equals(6));
            });

            test('correctly updates the length', () {
              expect(triangleFan.length, equals(4));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(triangleFan[1].index, equals(1));
        });
      });
    });

    group('instance with an index list', () {
      final indexList = new Index16List.fromList([0, 5, 4, 3, 2, 1]);
      final triangleFan = new TriangleFan(vertices, indices: indexList);

      group('iterator', () {
        final iterator = triangleFan.iterator;

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

      group('count', () {
        test('returns the correct value', () {
          expect(triangleFan.count, equals(6));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => triangleFan.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => triangleFan.count = 7, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() =>triangleFan.count = 3);
            tearDown(() => triangleFan.count = 6);

            test('correctly updates the count', () {
              expect(triangleFan.count, equals(3));
            });

            test('correctly updates the length', () {
              expect(triangleFan.length, equals(1));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(triangleFan[1].index, equals(1));
        });
      });
    });
  });

  group('TriangleFanTriangleView', () {
    group('instance defined on TriangleFan without an index list', () {
      final triangleFan = new TriangleFan(vertices);
      final triangleView = new TriangleFanTriangleView(triangleFan, 2);

      test('aIndex returns the correct value', () {
        expect(triangleView.aIndex, equals(0));
      });

      test('aOffset returns the correct value', () {
        expect(triangleView.aOffset, equals(0));
      });

      test('a returns the correct vertex', () {
        expect(triangleView.a['position'], equals(0.0));
      });

      test('startIndex returns the correct value', () {
        expect(triangleView.bIndex, equals(3));
      });

      test('startOffset returns the correct value', () {
        expect(triangleView.bOffset, equals(3));
      });

      test('start returns the correct vertex', () {
        expect(triangleView.b['position'], equals(3.0));
      });

      test('cIndex returns the correct value', () {
        expect(triangleView.cIndex, equals(4));
      });

      test('cOffset returns the correct value', () {
        expect(triangleView.cOffset, equals(4));
      });

      test('c returns the correct vertex', () {
        expect(triangleView.c['position'], equals(4.0));
      });
    });

    group('instance defined on TriangleFan with an index list', () {
      final indexList = new Index16List.fromList([5, 4, 3, 2, 1, 0]);
      final triangleFan = new TriangleFan(vertices, indices: indexList);
      final triangleView = new TriangleFanTriangleView(triangleFan, 2);

      test('aIndex returns the correct value', () {
        expect(triangleView.aIndex, equals(5));
      });

      test('aOffset returns the correct value', () {
        expect(triangleView.aOffset, equals(0));
      });

      test('a returns the correct vertex', () {
        expect(triangleView.a['position'], equals(5.0));
      });

      test('startIndex returns the correct value', () {
        expect(triangleView.bIndex, equals(2));
      });

      test('startOffset returns the correct value', () {
        expect(triangleView.bOffset, equals(3));
      });

      test('start returns the correct vertex', () {
        expect(triangleView.b['position'], equals(2.0));
      });

      test('cIndex returns the correct value', () {
        expect(triangleView.cIndex, equals(1));
      });

      test('cOffset returns the correct value', () {
        expect(triangleView.cOffset, equals(4));
      });

      test('c returns the correct vertex', () {
        expect(triangleView.c['position'], equals(1.0));
      });
    });
  });
}
