import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';
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

    group('fromFloat32List constructor', () {
      test('throws an error when the list has more than 9 items', () {
        final list = new Float32List(10);

        expect(() => new Matrix3.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 9 items', () {
        final list = new Float32List(8);

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
    
    group('instance', () {
      final matrix = new Matrix3(
          1.0, 2.0, 3.0,
          4.0, 5.0, 6.0,
          7.0, 8.0, 9.0
      );

      group('matrixProduct', () {
        group('with a Matrix3', () {
          final m2 = new Matrix3(
              1.0, 2.0, 3.0,
              4.0, 5.0, 6.0,
              7.0, 8.0, 9.0
          );
          final product = matrix * m2;

          test('results in a new Matrix3', () {
            expect(product is Matrix3, isTrue);
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([
              30.0,  36.0,  42.0,
              66.0,  81.0,  96.0,
              102.0, 126.0, 150.0
            ], 0.00001));
          });
        });

        group('with a Vector3', () {
          final v = new Vector3(1.0, 2.0, 3.0);
          final product = matrix * v;

          test('results in a new Vector3', () {
            expect(product is Vector3, isTrue);
          });

          test('results in a new matrix with the correct values', () {
            expect(product.values, orderedCloseTo([14.0, 32.0, 50.0], 0.00001));
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

        test('r1c0 returns the correct value', () {
          expect(matrix.r1c0, closeTo(4.0, 0.00001));
        });

        test('r1c1 returns the correct value', () {
          expect(matrix.r1c1, closeTo(5.0, 0.00001));
        });

        test('r1c2 returns the correct value', () {
          expect(matrix.r1c2, closeTo(6.0, 0.00001));
        });

        test('r2c0 returns the correct value', () {
          expect(matrix.r2c0, closeTo(7.0, 0.00001));
        });

        test('r2c1 returns the correct value', () {
          expect(matrix.r2c1, closeTo(8.0, 0.00001));
        });

        test('r2c2 returns the correct value', () {
          expect(matrix.r2c2, closeTo(9.0, 0.00001));
        });
      });

      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => matrix[-1], throwsRangeError);
          expect(() => matrix[3], throwsRangeError);
        });

        test('returns the correct row', () {
          expect(matrix[0], orderedCloseTo([1.0, 2.0, 3.0], 0.00001));
          expect(matrix[1], orderedCloseTo([4.0, 5.0, 6.0], 0.00001));
          expect(matrix[2], orderedCloseTo([7.0, 8.0, 9.0], 0.00001));
        });
      });
    });
  });
}
