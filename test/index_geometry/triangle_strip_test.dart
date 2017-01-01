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
    new Vertex({'position': 5.0 }),
    new Vertex({'position': 6.0 }),
    new Vertex({'position': 7.0 }),
    new Vertex({'position': 8.0 })
  ]);

  group('TriangleStrip', () {
    group('default constructor', () {
      group('with a negative offset', () {
        test('throws a RangeError', () {
          expect(() => new TriangleStrip(vertices, offset: -1), throwsRangeError);
        });
      });

      group('with a offset equal to the length of the list of vertexArray', () {
        test('throws a RangeError', () {
          expect(() => new TriangleStrip(vertices, offset: 8), throwsRangeError);
        });
      });

      group('with a negative count', () {
        test('throws a RangeError', () {
          expect(() => new TriangleStrip(vertices, count: -1), throwsRangeError);
        });
      });

      group('with an offset and count whose sum is greater than the length of the vertex array', () {
        test('throws a RangeError', () {
          expect(() => new TriangleStrip(vertices, offset: 1, count: 9), throwsRangeError);
        });
      });

      group('with a valid offset and count', () {
        test('returns an instance with the correct length', () {
          expect(new TriangleStrip(vertices, offset: 1, count: 6).length, equals(4));
        });
      });

      group('with an index list', () {
        final indexList = new Index16List.fromList([0, 1, 2, 3, 4, 1, 2, 3, 4, 5]);

        group('with an offset equal to the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new TriangleStrip(vertices, indexList: indexList, offset: 10), throwsRangeError);
          });
        });

        group('with an offset and count whose sum is greater than the length of the index list', () {
          test('throws a RangeError', () {
            expect(() => new TriangleStrip(vertices, offset: 1, count: 10), throwsRangeError);
          });
        });

        group('with a valid offset and count', () {
          test('returns an instance with the correct length', () {
            expect(new TriangleStrip(vertices, indexList: indexList, offset: 2, count: 6).length, equals(4));
          });
        });
      });
    });

    group('instance without an index list', () {
      final triangleStrip = new TriangleStrip(vertices);

      group('iterator', () {
        final iterator = triangleStrip.iterator;

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
          expect(triangleStrip.count, equals(9));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => triangleStrip.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => triangleStrip.count = 10, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() => triangleStrip.count = 6);
            tearDown(() => triangleStrip.count = 9);

            test('correctly updates the count', () {
              expect(triangleStrip.count, equals(6));
            });

            test('correctly updates the length', () {
              expect(triangleStrip.length, equals(4));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(triangleStrip[1].index, equals(1));
        });
      });
    });

    group('instance with an index list', () {
      final indexList = new Index16List.fromList([0, 5, 4, 3, 2, 1]);
      final triangleStrip = new TriangleStrip(vertices, indexList: indexList);

      group('iterator', () {
        final iterator = triangleStrip.iterator;

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
          expect(triangleStrip.count, equals(6));
        });

        group('set', () {
          test('with a negative value throws a RangeError', () {
            expect(() => triangleStrip.count = -1, throwsRangeError);
          });

          test('with a value greater than the length of the index list throws a RangeError', () {
            expect(() => triangleStrip.count = 7, throwsRangeError);
          });

          group('with a valid value', () {
            setUp(() =>triangleStrip.count = 3);
            tearDown(() => triangleStrip.count = 6);

            test('correctly updates the count', () {
              expect(triangleStrip.count, equals(3));
            });

            test('correctly updates the length', () {
              expect(triangleStrip.length, equals(1));
            });
          });
        });
      });

      group('[] operator', () {
        test('returns a point view with the correct index', () {
          expect(triangleStrip[1].index, equals(1));
        });
      });
    });
  });

  group('TriangleStripTriangleView', () {
    group('instance with an even index defined on TriangleStrip without an index list', () {
      final triangleStrip = new TriangleStrip(vertices);
      final triangleView = new TriangleStripTriangleView(triangleStrip, 2);

      test('aIndex returns the correct value', () {
        expect(triangleView.aIndex, equals(2));
      });

      test('aOffset returns the correct value', () {
        expect(triangleView.aOffset, equals(2));
      });

      test('a returns the correct vertex', () {
        expect(triangleView.a['position'], equals(2.0));
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

    group('instance with an even index defined on TriangleStrip with an index list', () {
      final indexList = new Index16List.fromList([5, 4, 3, 2, 1, 0]);
      final triangleStrip = new TriangleStrip(vertices, indexList: indexList);
      final triangleView = new TriangleStripTriangleView(triangleStrip, 2);

      test('aIndex returns the correct value', () {
        expect(triangleView.aIndex, equals(3));
      });

      test('aOffset returns the correct value', () {
        expect(triangleView.aOffset, equals(2));
      });

      test('a returns the correct vertex', () {
        expect(triangleView.a['position'], equals(3.0));
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

    group('instance with an odd index defined on TriangleStrip without an index list', () {
      final triangleStrip = new TriangleStrip(vertices);
      final triangleView = new TriangleStripTriangleView(triangleStrip, 1);

      test('aIndex returns the correct value', () {
        expect(triangleView.aIndex, equals(2));
      });

      test('aOffset returns the correct value', () {
        expect(triangleView.aOffset, equals(2));
      });

      test('a returns the correct vertex', () {
        expect(triangleView.a['position'], equals(2.0));
      });

      test('startIndex returns the correct value', () {
        expect(triangleView.bIndex, equals(1));
      });

      test('startOffset returns the correct value', () {
        expect(triangleView.bOffset, equals(1));
      });

      test('start returns the correct vertex', () {
        expect(triangleView.b['position'], equals(1.0));
      });

      test('cIndex returns the correct value', () {
        expect(triangleView.cIndex, equals(3));
      });

      test('cOffset returns the correct value', () {
        expect(triangleView.cOffset, equals(3));
      });

      test('c returns the correct vertex', () {
        expect(triangleView.c['position'], equals(3.0));
      });
    });
  });
}
