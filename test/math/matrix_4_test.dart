import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:math';
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
      final m = new Matrix4.translation(2.0, 3.0, 4.0);

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
           4.0, 11.0,  8.0, 15.0,
           1.0,  7.0,  9.0, 10.0,
           6.0,  2.0, 13.0, 16.0,
          14.0,  3.0, 12.0,  5.0
      );

      group('valueAt', () {
        test('(1, 0)', () {
          expect(matrix.valueAt(1, 0), closeTo(1.0, 0.00001));
        });
      });

      group('rowAt', () {
        test('throws an error when trying to access an out of bounds row', () {
          expect(() => matrix.rowAt(4), throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix.rowAt(1), orderedCloseTo([1.0, 7.0, 9.0, 10.0], 0.00001));
        });
      });

      group('valuesColumnPacked', () {
        test('returns the correct value', () {
          expect(matrix.valuesColumnPacked, orderedCloseTo([
             4.0,  1.0,  6.0, 14.0,
            11.0,  7.0,  2.0,  3.0,
             8.0,  9.0, 13.0, 12.0,
            15.0, 10.0, 16.0,  5.0
          ], 0.00001));
        });
      });

      group('transpose', () {
        final transpose = matrix.transpose;

        test('returns a Matrix4', () {
          expect(transpose, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(transpose.values, orderedCloseTo([
            4.0,  1.0,  6.0, 14.0,
            11.0,  7.0,  2.0,  3.0,
            8.0,  9.0, 13.0, 12.0,
            15.0, 10.0, 16.0,  5.0
          ], 0.00001));
        });
      });

      group('determinant', () {
        test('returns the correct value', () {
          expect(matrix.determinant, equals(-8712.0));
        });
      });

      group('inverse', () {
        final inverse = matrix.inverse;

        test('returns a Matrix4', () {
          expect(inverse, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(inverse.values, orderedCloseTo([
             0.08000, -0.15129,  0.00115,  0.05888,
             0.05957,  0.06956, -0.10675,  0.02376,
            -0.14004,  0.21028, -0.00918,  0.02893,
             0.07633, -0.12282,  0.08287, -0.04855
          ], 0.00001));
        });
      });

      group('scalarProduct', () {
        final product = matrix.scalarProduct(2);

        test('returns a Matrix4', () {
          expect(product, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
             8.0, 22.0, 16.0, 30.0,
             2.0, 14.0, 18.0, 20.0,
            12.0,  4.0, 26.0, 32.0,
            28.0,  6.0, 24.0, 10.0
          ], 0.00001));
        });
      });

      group('scalarDivision', () {
        final product = matrix.scalarDivision(2);

        test('returns a Matrix4', () {
          expect(product, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
            2.0, 5.5, 4.0, 7.5,
            0.5, 3.5, 4.5, 5.0,
            3.0, 1.0, 6.5, 8.0,
            7.0, 1.5, 6.0, 2.5
          ], 0.00001));
        });
      });

      group('entrywiseSum', () {
        final other = new Matrix4(
             1.0,  2.0,  3.0,  4.0,
             5.0,  6.0,  7.0,  8.0,
             9.0, 10.0, 11.0, 12.0,
            13.0, 14.0, 15.0, 16.0
        );
        final sum = matrix.entrywiseSum(other);

        test('returns a Matrix4', () {
          expect(sum, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(sum.values, orderedCloseTo([
             5.0, 13.0, 11.0, 19.0,
             6.0, 13.0, 16.0, 18.0,
            15.0, 12.0, 24.0, 28.0,
            27.0, 17.0, 27.0, 21.0
          ], 0.00001));
        });
      });

      group('entrywiseDifference', () {
        final other = new Matrix4(
             1.0,  2.0,  3.0,  4.0,
             5.0,  6.0,  7.0,  8.0,
             9.0, 10.0, 11.0, 12.0,
            13.0, 14.0, 15.0, 16.0
        );
        final difference = matrix.entrywiseDifference(other);

        test('returns a Matrix4', () {
          expect(difference, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(difference.values, orderedCloseTo([
             3.0,   9.0,  5.0,  11.0,
            -4.0,   1.0,  2.0,   2.0,
            -3.0,  -8.0,  2.0,   4.0,
             1.0, -11.0, -3.0, -11.0
          ], 0.00001));
        });
      });

      group('entrywiseProduct', () {
        final other = new Matrix4(
             1.0,  2.0,  3.0,  4.0,
             5.0,  6.0,  7.0,  8.0,
             9.0, 10.0, 11.0, 12.0,
            13.0, 14.0, 15.0, 16.0
        );
        final product = matrix.entrywiseProduct(other);

        test('returns a Matrix4', () {
          expect(product, new isInstanceOf<Matrix4>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
              4.0, 22.0,  24.0,  60.0,
              5.0, 42.0,  63.0,  80.0,
             54.0, 20.0, 143.0, 192.0,
            182.0, 42.0, 180.0,  80.0
          ], 0.00001));
        });
      });

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
              326.0, 364.0, 402.0, 440.0,
              247.0, 274.0, 301.0, 328.0,
              341.0, 378.0, 415.0, 452.0,
              202.0, 236.0, 270.0, 304.0
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
            expect(product.values, orderedCloseTo([110.0, 82.0, 113.0, 76.0], 0.00001));
          });
        });
      });

      group('value accessor', () {
        test('r0c0 returns the correct value', () {
          expect(matrix.r0c0, closeTo(4.0, 0.00001));
        });

        test('r0c1 returns the correct value', () {
          expect(matrix.r0c1, closeTo(11.0, 0.00001));
        });

        test('r0c2 returns the correct value', () {
          expect(matrix.r0c2, closeTo(8.0, 0.00001));
        });

        test('r0c3 returns the correct value', () {
          expect(matrix.r0c3, closeTo(15.0, 0.00001));
        });

        test('r1c0 returns the correct value', () {
          expect(matrix.r1c0, closeTo(1.0, 0.00001));
        });

        test('r1c1 returns the correct value', () {
          expect(matrix.r1c1, closeTo(7.0, 0.00001));
        });

        test('r1c2 returns the correct value', () {
          expect(matrix.r1c2, closeTo(9.0, 0.00001));
        });

        test('r1c3 returns the correct value', () {
          expect(matrix.r1c3, closeTo(10.0, 0.00001));
        });

        test('r2c0 returns the correct value', () {
          expect(matrix.r2c0, closeTo(6.0, 0.00001));
        });

        test('r2c1 returns the correct value', () {
          expect(matrix.r2c1, closeTo(2.0, 0.00001));
        });

        test('r2c2 returns the correct value', () {
          expect(matrix.r2c2, closeTo(13.0, 0.00001));
        });

        test('r2c3 returns the correct value', () {
          expect(matrix.r2c3, closeTo(16.0, 0.00001));
        });

        test('r3c0 returns the correct value', () {
          expect(matrix.r3c0, closeTo(14.0, 0.00001));
        });

        test('r3c1 returns the correct value', () {
          expect(matrix.r3c1, closeTo(3.0, 0.00001));
        });

        test('r3c2 returns the correct value', () {
          expect(matrix.r3c2, closeTo(12.0, 0.00001));
        });

        test('r3c3 returns the correct value', () {
          expect(matrix.r3c3, closeTo(5.0, 0.00001));
        });
      });

      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => matrix[-1], throwsRangeError);
          expect(() => matrix[4], throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix[0], orderedCloseTo([4.0, 11.0, 8.0, 15.0], 0.00001));
          expect(matrix[1], orderedCloseTo([1.0, 7.0, 9.0, 10.0], 0.00001));
          expect(matrix[2], orderedCloseTo([6.0, 2.0, 13.0, 16.0], 0.00001));
          expect(matrix[3], orderedCloseTo([14.0, 3.0, 12.0, 5.0], 0.00001));
        });
      });
    });
  });
}
