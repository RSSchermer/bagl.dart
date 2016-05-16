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
    new Vertex({'position': 5.0 }),
    new Vertex({'position': 6.0 }),
    new Vertex({'position': 7.0 }),
    new Vertex({'position': 8.0 })
  ]);

  group('TriangleStrip', () {
    group('default constructor', () {
      group('with an index list with a length that less than 3', () {
        test('throws an ArgumentError', () {
          final indices = new IndexList.incrementing(2);

          expect(() => new TriangleStrip(vertices, indices), throwsArgumentError);
        });
      });

      group('with an index list with a length that greater than 3', () {
        final indices = new IndexList.incrementing(6);

        test('results in an instance with the correct length', () {
          final triangleStrip = new TriangleStrip(vertices, indices);

          expect(triangleStrip.length, equals(4));
        });
      });

      group('with a range start', () {
        final indices = new IndexList.incrementing(7);

        test('results in an instance with the correct length', () {
          final triangleStrip = new TriangleStrip(vertices, indices, 1);

          expect(triangleStrip.length, equals(4));
        });
      });

      group('with a range start and end', () {
        final indices = new IndexList.incrementing(8);

        test('results in an instance with the correct length', () {
          final triangleStrip = new TriangleStrip(vertices, indices, 1, 7);

          expect(triangleStrip.length, equals(4));
        });
      });
    });

    group('[] operator', () {
      final indices = new IndexList.incrementing(9);
      final triangleStrip = new TriangleStrip(vertices, indices);

      test('returns a triangle view with the correct index', () {
        expect(triangleStrip[1].index, equals(1));
      });
    });
  });

  group('TriangleStripIterator', () {
    final indices = new IndexList.incrementing(5);
    final triangleStrip = new TriangleStrip(vertices, indices);

    group('instance', () {
      final iterator = new TriangleStripIterator(triangleStrip);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterated over in a while loop', () {
        var loopCount = 0;
        final triangleViewIndices = [];

        while (iterator.moveNext()) {
          loopCount++;
          triangleViewIndices.add(iterator.current.index);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(3));
        });

        test('returns the correct triangle view on each iteration', () {
          expect(triangleViewIndices, equals([0, 1, 2]));
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

  group('TriangleStripTriangleView', () {
    group('with an even index', () {
      final indices = new IndexList.incrementing(9);
      final triangleStrip = new TriangleStrip(vertices, indices);
      final triangleView = new TriangleStripTriangleView(triangleStrip, 2);

      group('get aIndex', () {
        test('returns the correct value', () {
          expect(triangleView.aIndex, equals(2));
        });
      });

      group('get bIndex', () {
        test('returns the correct value', () {
          expect(triangleView.bIndex, equals(3));
        });
      });

      group('get cIndex', () {
        test('returns the correct value', () {
          expect(triangleView.cIndex, equals(4));
        });
      });

      group('get a', () {
        test('returns the correct vertex', () {
          expect(triangleView.a['position'], equals(2.0));
        });
      });

      group('get b', () {
        test('returns the correct vertex', () {
          expect(triangleView.b['position'], equals(3.0));
        });
      });

      group('get c', () {
        test('returns the correct vertex', () {
          expect(triangleView.c['position'], equals(4.0));
        });
      });
    });

    group('with an odd index', () {
      final indices = new IndexList.incrementing(9);
      final triangleStrip = new TriangleStrip(vertices, indices);
      final triangleView = new TriangleStripTriangleView(triangleStrip, 1);

      group('get aIndex', () {
        test('returns the correct value', () {
          expect(triangleView.aIndex, equals(2));
        });
      });

      group('get bIndex', () {
        test('returns the correct value', () {
          expect(triangleView.bIndex, equals(1));
        });
      });

      group('get cIndex', () {
        test('returns the correct value', () {
          expect(triangleView.cIndex, equals(3));
        });
      });

      group('get a', () {
        test('returns the correct vertex', () {
          expect(triangleView.a['position'], equals(2.0));
        });
      });

      group('get b', () {
        test('returns the correct vertex', () {
          expect(triangleView.b['position'], equals(1.0));
        });
      });

      group('get c', () {
        test('returns the correct vertex', () {
          expect(triangleView.c['position'], equals(3.0));
        });
      });
    });
  });
}
