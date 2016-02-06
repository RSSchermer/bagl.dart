import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';
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
        final list = new List.filled(5, 1.0);

        expect(() => new Matrix2.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 4 items', () {
        final list = new List.filled(3, 1.0);

        expect(() => new Matrix2.fromList(list), throwsArgumentError);
      });
    });

    group('fromFloat32List constructor', () {
      test('throws an error when the list has more than 4 items', () {
        final list = new Float32List(5);

        expect(() => new Matrix2.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 4 items', () {
        final list = new Float32List(3);

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
    
    group('instance', () {
      final matrix = new Matrix2(
          1.0, 2.0,
          3.0, 4.0
      );
      
      group('matrixProduct', () {
        group('with a Matrix2', () {
          final m2 = new Matrix2(
              1.0, 2.0,
              3.0, 4.0
          );
          final product = matrix * m2;

          test('results in a new Matrix2', () {
            expect(product is Matrix2, isTrue);
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
            expect(product is Vector2, isTrue);
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