import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:math';
import '../helpers.dart';

void main() {
  group('Matrix2', () {
    group('default constructor', () {
      test('instantiates a matrix with the right values', () {
        final m = new Matrix2(
            1.0, 2.0,
            3.0, 4.0
        );

        expect(m.values, orderedCloseTo([
          1.0, 2.0,
          3.0, 4.0
        ], 0.00001));
      });
    });

    group('fromList constructor', () {
      test('throws an error when the list has more than 4 items', () {
        final list = new List<double>.filled(5, 1.0);

        expect(() => new Matrix2.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 4 items', () {
        final list = new List<double>.filled(3, 1.0);

        expect(() => new Matrix2.fromList(list), throwsArgumentError);
      });
    });

    test('constant constructor', () {
      final m = new Matrix2.constant(1.0);

      expect(m.values, orderedCloseTo([
        1.0, 1.0,
        1.0, 1.0
      ], 0.00001));
    });

    test('zero constructor', () {
      final m = new Matrix2.zero();

      expect(m.values, orderedCloseTo([
        0.0, 0.0,
        0.0, 0.0
      ], 0.00001));
    });

    test('identity constructor', () {
      final m = new Matrix2.identity();

      expect(m.values, orderedCloseTo([
        1.0, 0.0,
        0.0, 1.0
      ], 0.00001));
    });

    test('translation constructor', () {
      final m = new Matrix2.translation(5.0);

      expect(m.values, orderedCloseTo([
        1.0, 5.0,
        0.0, 1.0
      ], 0.00001));
    });

    test('scale constructor', () {
      final m = new Matrix2.scale(2.0, 3.0);

      expect(m.values, orderedCloseTo([
        2.0, 0.0,
        0.0, 3.0
      ], 0.00001));
    });

    test('rotation constructor', () {
      final m = new Matrix2.rotation(0.5 * PI);

      expect(m.values, orderedCloseTo([
        0.0, -1.0,
        1.0,  0.0
      ], 0.00001));
    });
    
    group('instance', () {
      final matrix = new Matrix2(
          1.0, 2.0,
          3.0, 4.0
      );

      group('valueAt', () {
        test('(1, 0)', () {
          expect(matrix.valueAt(1, 0), closeTo(3.0, 0.00001));
        });
      });

      group('rowAt', () {
        test('throws an error when trying to access an out of bounds row', () {
          expect(() => matrix.rowAt(2), throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix.rowAt(1), orderedCloseTo([3.0, 4.0], 0.00001));
        });
      });

      group('valuesColumnPacked', () {
        test('returns the correct value', () {
          expect(matrix.valuesColumnPacked, orderedCloseTo([
            1.0, 3.0,
            2.0, 4.0
          ], 0.00001));
        });
      });

      group('transpose', () {
        final transpose = matrix.transpose;

        test('returns a Matrix2', () {
          expect(transpose, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(transpose.values, orderedCloseTo([
            1.0, 3.0,
            2.0, 4.0
          ], 0.00001));
        });
      });

      group('determinant', () {
        test('returns the correct value', () {
          expect(matrix.determinant, equals(-2.0));
        });
      });

      group('inverse', () {
        final inverse = matrix.inverse;

        test('returns a Matrix2', () {
          expect(inverse, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(inverse.values, orderedCloseTo([
            -2.0,  1.0,
             1.5, -0.5
          ], 0.00001));
        });
      });

      group('scalarProduct', () {
        final product = matrix.scalarProduct(2);

        test('returns a Matrix2', () {
          expect(product, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
            2.0, 4.0,
            6.0, 8.0
          ], 0.00001));
        });
      });

      group('scalarDivision', () {
        final product = matrix.scalarDivision(2);

        test('returns a Matrix2', () {
          expect(product, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
            0.5, 1.0,
            1.5, 2.0
          ], 0.00001));
        });
      });

      group('entrywiseSum', () {
        final other = new Matrix2(
            4.0, 3.0,
            2.0, 1.0
        );
        final sum = matrix.entrywiseSum(other);

        test('returns a Matrix2', () {
          expect(sum, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(sum.values, orderedCloseTo([
            5.0, 5.0,
            5.0, 5.0
          ], 0.00001));
        });
      });

      group('entrywiseDifference', () {
        final other = new Matrix2(
            4.0, 3.0,
            2.0, 1.0
        );
        final difference = matrix.entrywiseDifference(other);

        test('returns a Matrix2', () {
          expect(difference, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(difference.values, orderedCloseTo([
            -3.0, -1.0,
             1.0,  3.0
          ], 0.00001));
        });
      });

      group('entrywiseProduct', () {
        final other = new Matrix2(
            4.0, 3.0,
            2.0, 1.0
        );
        final product = matrix.entrywiseProduct(other);

        test('returns a Matrix2', () {
          expect(product, new isInstanceOf<Matrix2>());
        });

        test('returns a matrix with the correct values', () {
          expect(product.values, orderedCloseTo([
            4.0, 6.0,
            6.0, 4.0
          ], 0.00001));
        });
      });
      
      group('matrixProduct', () {
        group('with a Matrix2', () {
          final m2 = new Matrix2(
              1.0, 2.0,
              3.0, 4.0
          );
          final product = matrix * m2;

          test('results in a new Matrix2', () {
            expect(product, new isInstanceOf<Matrix2>());
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([
               7.0, 10.0,
              15.0, 22.0
            ], 0.00001));
          });
        });

        group('with a Vector2', () {
          final v = new Vector2(1.0, 2.0);
          final product = matrix * v;

          test('results in a new Vector2', () {
            expect(product, new isInstanceOf<Vector2>());
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([5.0, 11.0], 0.00001));
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

        test('r1c0 returns the correct value', () {
          expect(matrix.r1c0, closeTo(3.0, 0.00001));
        });

        test('r1c1 returns the correct value', () {
          expect(matrix.r1c1, closeTo(4.0, 0.00001));
        });
      });

      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => matrix[-1], throwsRangeError);
          expect(() => matrix[2], throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix[0], orderedCloseTo([1.0, 2.0], 0.00001));
          expect(matrix[1], orderedCloseTo([3.0, 4.0], 0.00001));
        });
      });
    });
  });
}