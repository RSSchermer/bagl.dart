import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:math';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('Matrix4', () {
    group('default constructor', () {
      test('instantiates a matrix with the right values', () {
        final m = new Matrix4(
             1.0,  2.0,  3.0,  4.0,
             5.0,  6.0,  7.0,  8.0,
             9.0, 10.0, 11.0, 12.0,
            13.0, 14.0, 15.0, 16.0
        );

        expect(m.values, orderedCloseTo([
           1.0,  2.0,  3.0,  4.0,
           5.0,  6.0,  7.0,  8.0,
           9.0, 10.0, 11.0, 12.0,
          13.0, 14.0, 15.0, 16.0
        ], 0.00001));
      });
    });

    group('fromList constructor', () {
      test('throws an error when the list has more than 16 items', () {
        final list = new List.filled(17, 1.0);

        expect(() => new Matrix4.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 16 items', () {
        final list = new List.filled(15, 1.0);

        expect(() => new Matrix4.fromList(list), throwsArgumentError);
      });
    });

    group('fromFloat32List constructor', () {
      test('throws an error when the list has more than 16 items', () {
        final list = new Float32List(17);

        expect(() => new Matrix4.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 16 items', () {
        final list = new Float32List(15);

        expect(() => new Matrix4.fromList(list), throwsArgumentError);
      });
    });

    test('constant constructor', () {
      final m = new Matrix4.constant(1.0);

      expect(m.values, orderedCloseTo([
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0
      ], 0.00001));
    });

    test('zero constructor', () {
      final m = new Matrix4.zero();

      expect(m.values, orderedCloseTo([
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0
      ], 0.00001));
    });

    test('identity constructor', () {
      final m = new Matrix4.identity();

      expect(m.values, orderedCloseTo([
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
      ], 0.00001));
    });

    test('translation constructor', () {
      final m = new Matrix4.translation(new Vector3(2.0, 3.0, 4.0));

      expect(m.values, orderedCloseTo([
        1.0, 0.0, 0.0, 2.0,
        0.0, 1.0, 0.0, 3.0,
        0.0, 0.0, 1.0, 4.0,
        0.0, 0.0, 0.0, 1.0
      ], 0.00001));
    });

    test('scale constructor', () {
      final m = new Matrix4.scale(2.0, 3.0, 4.0);

      expect(m.values, orderedCloseTo([
        2.0, 0.0, 0.0, 0.0,
        0.0, 3.0, 0.0, 0.0,
        0.0, 0.0, 4.0, 0.0,
        0.0, 0.0, 0.0, 1.0
      ], 0.00001));
    });

    group('rotation constructor', () {
      test('with an axis in the X direction', () {
        final m = new Matrix4.rotation(new Vector3(1.0, 0.0, 0.0), 0.5 * PI);

        expect(m.values, orderedCloseTo([
          1.0, 0.0,  0.0, 0.0,
          0.0, 0.0, -1.0, 0.0,
          0.0, 1.0,  0.0, 0.0,
          0.0, 0.0,  0.0, 1.0
        ], 0.00001));
      });

      test('with an axis in the Y direction', () {
        final m = new Matrix4.rotation(new Vector3(0.0, 1.0, 0.0), 0.5 * PI);

        expect(m.values, orderedCloseTo([
           0.0, 0.0, 1.0, 0.0,
           0.0, 1.0, 0.0, 0.0,
          -1.0, 0.0, 0.0, 0.0,
           0.0, 0.0, 0.0, 1.0
        ], 0.00001));
      });

      test('with an axis in the Z direction', () {
        final m = new Matrix4.rotation(new Vector3(0.0, 0.0, 1.0), 0.5 * PI);

        expect(m.values, orderedCloseTo([
          0.0, -1.0, 0.0, 0.0,
          1.0,  0.0, 0.0, 0.0,
          0.0,  0.0, 1.0, 0.0,
          0.0,  0.0, 0.0, 1.0
        ], 0.00001));
      });
    });

    test('rotationX constructor', () {
      final m = new Matrix4.rotationX(0.5 * PI);

      expect(m.values, orderedCloseTo([
        1.0, 0.0,  0.0, 0.0,
        0.0, 0.0, -1.0, 0.0,
        0.0, 1.0,  0.0, 0.0,
        0.0, 0.0,  0.0, 1.0
      ], 0.00001));
    });

    test('rotationY constructor', () {
      final m = new Matrix4.rotationY(0.5 * PI);

      expect(m.values, orderedCloseTo([
         0.0, 0.0, 1.0, 0.0,
         0.0, 1.0, 0.0, 0.0,
        -1.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 1.0
      ], 0.00001));
    });

    test('rotationZ constructor', () {
      final m = new Matrix4.rotationZ(0.5 * PI);

      expect(m.values, orderedCloseTo([
        0.0, -1.0, 0.0, 0.0,
        1.0,  0.0, 0.0, 0.0,
        0.0,  0.0, 1.0, 0.0,
        0.0,  0.0, 0.0, 1.0
      ], 0.00001));
    });

    group('instance', () {
      final matrix = new Matrix4(
           1.0,  2.0,  3.0,  4.0,
           5.0,  6.0,  7.0,  8.0,
           9.0, 10.0, 11.0, 12.0,
          13.0, 14.0, 15.0, 16.0
      );

      group('matrixProduct ', () {
        group('with a Matrix4', () {
          final m2 = new Matrix4(
               1.0,  2.0,  3.0,  4.0,
               5.0,  6.0,  7.0,  8.0,
               9.0, 10.0, 11.0, 12.0,
              13.0, 14.0, 15.0, 16.0
          );
          final product = matrix * m2;

          test('results in a new Matrix4', () {
            expect(product is Matrix4, isTrue);
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([
               90.0, 100.0, 110.0, 120.0,
              202.0, 228.0, 254.0, 280.0,
              314.0, 356.0, 398.0, 440.0,
              426.0, 484.0, 542.0, 600.0
            ], 0.00001));
          });
        });

        group('with a Vector4', () {
          final v = new Vector4(1.0, 2.0, 3.0, 4.0);
          final product = matrix * v;

          test('results in a new Vector4', () {
            expect(product is Vector4, isTrue);
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([30.0, 70.0, 110.0, 150.0], 0.00001));
          });
        });
      });

      group('value accessor', () {
        test('r0c0 returns the correct value', () {
          expect(matrix.r0c0, closeTo(1.0, 0.00001));
        });

        test('r0c1 returns the correct value', () {
          expect(matrix.r0c1, closeTo(2.0, 0.00001));
        });

        test('r0c2 returns the correct value', () {
          expect(matrix.r0c2, closeTo(3.0, 0.00001));
        });

        test('r0c3 returns the correct value', () {
          expect(matrix.r0c3, closeTo(4.0, 0.00001));
        });

        test('r1c0 returns the correct value', () {
          expect(matrix.r1c0, closeTo(5.0, 0.00001));
        });

        test('r1c1 returns the correct value', () {
          expect(matrix.r1c1, closeTo(6.0, 0.00001));
        });

        test('r1c2 returns the correct value', () {
          expect(matrix.r1c2, closeTo(7.0, 0.00001));
        });

        test('r1c3 returns the correct value', () {
          expect(matrix.r1c3, closeTo(8.0, 0.00001));
        });

        test('r2c0 returns the correct value', () {
          expect(matrix.r2c0, closeTo(9.0, 0.00001));
        });

        test('r2c1 returns the correct value', () {
          expect(matrix.r2c1, closeTo(10.0, 0.00001));
        });

        test('r2c2 returns the correct value', () {
          expect(matrix.r2c2, closeTo(11.0, 0.00001));
        });

        test('r2c3 returns the correct value', () {
          expect(matrix.r2c3, closeTo(12.0, 0.00001));
        });

        test('r3c0 returns the correct value', () {
          expect(matrix.r3c0, closeTo(13.0, 0.00001));
        });

        test('r3c1 returns the correct value', () {
          expect(matrix.r3c1, closeTo(14.0, 0.00001));
        });

        test('r3c2 returns the correct value', () {
          expect(matrix.r3c2, closeTo(15.0, 0.00001));
        });

        test('r3c3 returns the correct value', () {
          expect(matrix.r3c3, closeTo(16.0, 0.00001));
        });
      });

      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => matrix[-1], throwsRangeError);
          expect(() => matrix[4], throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix[0], orderedCloseTo([1.0, 2.0, 3.0, 4.0], 0.00001));
          expect(matrix[1], orderedCloseTo([5.0, 6.0, 7.0, 8.0], 0.00001));
          expect(matrix[2], orderedCloseTo([9.0, 10.0, 11.0, 12.0], 0.00001));
          expect(matrix[3], orderedCloseTo([13.0, 14.0, 15.0, 16.0], 0.00001));
        });
      });
    });
  });
}
