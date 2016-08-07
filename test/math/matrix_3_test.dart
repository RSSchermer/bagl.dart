import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:math';
import '../helpers.dart';

void main() {
  group('Matrix3', () {
    group('default constructor', () {
      test('instantiates a matrix with the right values', () {
        final m = new Matrix3(
            1.0, 2.0, 3.0,  
            4.0, 5.0, 6.0, 
            7.0, 8.0, 9.0
        );

        expect(m.values, orderedCloseTo([
          1.0, 2.0, 3.0,
          4.0, 5.0, 6.0,
          7.0, 8.0, 9.0
        ], 0.00001));
      });
    });

    group('fromList constructor', () {
      test('throws an error when the list has more than 9 items', () {
        final list = new List.filled(10, 1.0);

        expect(() => new Matrix3.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 9 items', () {
        final list = new List.filled(8, 1.0);

        expect(() => new Matrix3.fromList(list), throwsArgumentError);
      });
    });

    test('constant constructor', () {
      final m = new Matrix3.constant(1.0);

      expect(m.values, orderedCloseTo([
        1.0, 1.0, 1.0,
        1.0, 1.0, 1.0,
        1.0, 1.0, 1.0
      ], 0.00001));
    });

    test('zero constructor', () {
      final m = new Matrix3.zero();

      expect(m.values, orderedCloseTo([
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0
      ], 0.00001));
    });

    test('identity constructor', () {
      final m = new Matrix3.identity();

      expect(m.values, orderedCloseTo([
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
      ], 0.00001));
    });

    test('translation constructor', () {
      final m = new Matrix3.translation(new Vector2(2.0, 3.0));

      expect(m.values, orderedCloseTo([
        1.0, 0.0, 2.0,
        0.0, 1.0, 3.0,
        0.0, 0.0, 1.0,
      ], 0.00001));
    });

    test('scale constructor', () {
      final m = new Matrix3.scale(2.0, 3.0, 4.0);

      expect(m.values, orderedCloseTo([
        2.0, 0.0, 0.0,
        0.0, 3.0, 0.0,
        0.0, 0.0, 4.0,
      ], 0.00001));
    });

    group('rotation constructor', () {
      test('with an axis in the X direction', () {
        final m = new Matrix3.rotation(new Vector3(1.0, 0.0, 0.0), 0.5 * PI);

        expect(m.values, orderedCloseTo([
          1.0, 0.0,  0.0,
          0.0, 0.0, -1.0,
          0.0, 1.0,  0.0,
        ], 0.00001));
      });

      test('with an axis in the Y direction', () {
        final m = new Matrix3.rotation(new Vector3(0.0, 1.0, 0.0), 0.5 * PI);

        expect(m.values, orderedCloseTo([
           0.0, 0.0, 1.0,
           0.0, 1.0, 0.0,
          -1.0, 0.0, 0.0,
        ], 0.00001));
      });

      test('with an axis in the Z direction', () {
        final m = new Matrix3.rotation(new Vector3(0.0, 0.0, 1.0), 0.5 * PI);

        expect(m.values, orderedCloseTo([
          0.0, -1.0, 0.0,
          1.0,  0.0, 0.0,
          0.0,  0.0, 1.0,
        ], 0.00001));
      });
    });

    test('rotationX constructor', () {
      final m = new Matrix3.rotationX(0.5 * PI);

      expect(m.values, orderedCloseTo([
        1.0, 0.0,  0.0,
        0.0, 0.0, -1.0,
        0.0, 1.0,  0.0,
      ], 0.00001));
    });

    test('rotationY constructor', () {
      final m = new Matrix3.rotationY(0.5 * PI);

      expect(m.values, orderedCloseTo([
         0.0, 0.0, 1.0,
         0.0, 1.0, 0.0,
        -1.0, 0.0, 0.0,
      ], 0.00001));
    });

    test('rotationZ constructor', () {
      final m = new Matrix3.rotationZ(0.5 * PI);

      expect(m.values, orderedCloseTo([
        0.0, -1.0, 0.0,
        1.0,  0.0, 0.0,
        0.0,  0.0, 1.0,
      ], 0.00001));
    });
    
    group('instance', () {
      final matrix = new Matrix3(
          4.0, 2.0, 7.0,
          3.0, 9.0, 5.0,
          1.0, 6.0, 8.0
      );

      group('valueAt', () {
        test('(1, 0)', () {
          expect(matrix.valueAt(1, 0), closeTo(3.0, 0.00001));
        });
      });

      group('rowAt', () {
        test('throws an error when trying to access an out of bounds row', () {
          expect(() => matrix.rowAt(3), throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix.rowAt(1), orderedCloseTo([3.0, 9.0, 5.0], 0.00001));
        });
      });

      group('valuesColumnPacked', () {
        test('returns the correct value', () {
          expect(matrix.valuesColumnPacked, orderedCloseTo([
            4.0, 3.0, 1.0,
            2.0, 9.0, 6.0,
            7.0, 5.0, 8.0
          ], 0.00001));
        });
      });

      group('transpose', () {
        final transpose = matrix.transpose;

        test('returns a Matrix3', () {
          expect(transpose, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(transpose.values, orderedCloseTo([
            4.0, 3.0, 1.0,
            2.0, 9.0, 6.0,
            7.0, 5.0, 8.0
          ], 0.00001));
        });
      });

      group('determinant', () {
        test('returns the correct value', () {
          expect(matrix.determinant, equals(193.0));
        });
      });

      group('inverse', () {
        final inverse = matrix.inverse;

        test('returns a Matrix3', () {
          expect(inverse, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(inverse.values, orderedCloseTo([
             0.21762,  0.13472, -0.27461,
            -0.09845,  0.12953,  0.00518,
             0.04663, -0.11399,  0.15544
          ], 0.00001));
        });
      });

      group('scalarProduct', () {
        final product = matrix.scalarProduct(2);

        test('returns a Matrix3', () {
          expect(product, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
            8.0,  4.0, 14.0,
            6.0, 18.0, 10.0,
            2.0, 12.0, 16.0
          ], 0.00001));
        });
      });

      group('scalarDivision', () {
        final product = matrix.scalarDivision(2);

        test('returns a Matrix3', () {
          expect(product, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
            2.0, 1.0, 3.5,
            1.5, 4.5, 2.5,
            0.5, 3.0, 4.0
          ], 0.00001));
        });
      });

      group('entrywiseSum', () {
        final other = new Matrix3(
            1.0, 2.0, 3.0,
            4.0, 5.0, 6.0,
            7.0, 8.0, 9.0
        );
        final sum = matrix.entrywiseSum(other);

        test('returns a Matrix3', () {
          expect(sum, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(sum.values, orderedCloseTo([
            5.0,  4.0, 10.0,
            7.0, 14.0, 11.0,
            8.0, 14.0, 17.0
          ], 0.00001));
        });
      });

      group('entrywiseDifference', () {
        final other = new Matrix3(
            1.0, 2.0, 3.0,
            4.0, 5.0, 6.0,
            7.0, 8.0, 9.0
        );
        final difference = matrix.entrywiseDifference(other);

        test('returns a Matrix3', () {
          expect(difference, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(difference.values, orderedCloseTo([
             3.0,  0.0,  4.0,
            -1.0,  4.0, -1.0,
            -6.0, -2.0, -1.0
          ], 0.00001));
        });
      });

      group('entrywiseProduct', () {
        final other = new Matrix3(
            1.0, 2.0, 3.0,
            4.0, 5.0, 6.0,
            7.0, 8.0, 9.0
        );
        final product = matrix.entrywiseProduct(other);

        test('returns a Matrix3', () {
          expect(product, new isInstanceOf<Matrix3>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
             4.0,  4.0, 21.0,
            12.0, 45.0, 30.0,
             7.0, 48.0, 72.0
          ], 0.00001));
        });
      });

      group('matrixProduct', () {
        group('with a Matrix3', () {
          final m2 = new Matrix3(
              1.0, 2.0, 3.0,
              4.0, 5.0, 6.0,
              7.0, 8.0, 9.0
          );
          final product = matrix * m2;

          test('results in a new Matrix3', () {
            expect(product, new isInstanceOf<Matrix3>());
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([
              61.0, 74.0,  87.0,
              74.0, 91.0, 108.0,
              81.0, 96.0, 111.0
            ], 0.00001));
          });
        });

        group('with a Vector3', () {
          final v = new Vector3(1.0, 2.0, 3.0);
          final product = matrix * v;

          test('results in a new Vector3', () {
            expect(product, new isInstanceOf<Vector3>());
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([29.0, 36.0, 37.0], 0.00001));
          });
        });
      });

      group('value accessor', () {
        test('r0c0 returns the correct value', () {
          expect(matrix.r0c0, closeTo(4.0, 0.00001));
        });

        test('r0c1 returns the correct value', () {
          expect(matrix.r0c1, closeTo(2.0, 0.00001));
        });

        test('r0c2 returns the correct value', () {
          expect(matrix.r0c2, closeTo(7.0, 0.00001));
        });

        test('r1c0 returns the correct value', () {
          expect(matrix.r1c0, closeTo(3.0, 0.00001));
        });

        test('r1c1 returns the correct value', () {
          expect(matrix.r1c1, closeTo(9.0, 0.00001));
        });

        test('r1c2 returns the correct value', () {
          expect(matrix.r1c2, closeTo(5.0, 0.00001));
        });

        test('r2c0 returns the correct value', () {
          expect(matrix.r2c0, closeTo(1.0, 0.00001));
        });

        test('r2c1 returns the correct value', () {
          expect(matrix.r2c1, closeTo(6.0, 0.00001));
        });

        test('r2c2 returns the correct value', () {
          expect(matrix.r2c2, closeTo(8.0, 0.00001));
        });
      });

      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => matrix[-1], throwsRangeError);
          expect(() => matrix[3], throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix[0], orderedCloseTo([4.0, 2.0, 7.0], 0.00001));
          expect(matrix[1], orderedCloseTo([3.0, 9.0, 5.0], 0.00001));
          expect(matrix[2], orderedCloseTo([1.0, 6.0, 8.0], 0.00001));
        });
      });
    });
  });
}
