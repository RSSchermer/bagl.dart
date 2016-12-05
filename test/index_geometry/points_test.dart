import 'package:test/test.dart';
import 'package:bagl/geometry.dart';
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
      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, offset: -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of vertexArray', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, offset: 4), throwsRangeError);
        });
      });

      group('with a negative count', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, count: -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the vertex array', () {
        test('throws a RangeError', () {
          expect(() => new Points(vertices, offset: 1, count: 4), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new Points(vertices, offset: 1, count: 3).length, equals(3));
        });
      });

      group('with an index list', () {
        final indexList = new IndexList.fromList([0, 0, 1, 1, 2, 2, 3, 3]);

        group('with an offset equal to the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new Points(vertices, indexList: indexList, offset: 8), throwsRangeError);
          });
        });

        group('with an offset and count whose sum is greater than the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new Points(vertices, offset: 1, count: 7), throwsRangeError);
          });
        });

        group('with a valid offset and count', () {
          test('returns an instance with the correct length', () {
            expect(new Points(vertices, indexList: indexList, offset: 1, count: 7).length, equals(7));
          });
        });
      });
    });

    group('instance without an index list', () {
      final points = new Points(vertices);

      group('iterator', () {
        final iterator = points.iterator;

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
          expect(points.count, equals(4));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => points.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => points.count = 5, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() =>points.count = 3);
            tearDown(() => points.count = 4);

            test('correctly updates the count', () {
              expect(points.count, equals(3));
            });

            test('correctly updates the length', () {
              expect(points.length, equals(3));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(points[1].index, equals(1));
        });
      });
    });

    group('instance with an index list', () {
      final indexList = new IndexList.fromList([0, 3, 2, 1, 0]);
      final points = new Points(vertices, indexList: indexList);

      group('iterator', () {
        final iterator = points.iterator;

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
            expect(loopCount, equals(5));
          });

          test('returns the correct point view on each iteration', () {
            expect(pointViewIndices, equals([0, 1, 2, 3, 4]));
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
          expect(points.count, equals(5));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => points.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => points.count = 6, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() =>points.count = 3);
            tearDown(() => points.count = 5);

            test('correctly updates the count', () {
              expect(points.count, equals(3));
            });

            test('correctly updates the length', () {
              expect(points.length, equals(3));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(points[1].index, equals(1));
        });
      });
    });
  });

  group('PointsPointView', () {
    group('instance defined on Points without an index list', () {
      final points = new Points(vertices);
      final pointView = new PointsPointView(points, 1);

      test('vertexIndex returns the correct value', () {
        expect(pointView.vertexIndex, equals(1));
      });

      test('vertexOffset returns the correct value', () {
        expect(pointView.vertexOffset, equals(1));
      });

      test('vertex returns the correct vertex', () {
        expect(pointView.vertex['position'], equals(1.0));
      });
    });

    group('instance defined on Points with an index list', () {
      final indexList = new IndexList.fromList([3, 2, 1, 0]);
      final points = new Points(vertices, indexList: indexList);
      final pointView = new PointsPointView(points, 1);

      test('vertexIndex returns the correct value', () {
        expect(pointView.vertexIndex, equals(2));
      });

      test('vertexOffset returns the correct value', () {
        expect(pointView.vertexOffset, equals(1));
      });

      test('vertex returns the correct vertex', () {
        expect(pointView.vertex['position'], equals(2.0));
      });
    });
  });
}
