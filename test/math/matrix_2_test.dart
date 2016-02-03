import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('Matrix2', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a matrix with the right values', () {
          var m = new Matrix2(1.0, 2.0, 
                              3.0, 4.0);

          expect(m.values, orderedCloseTo([1.0, 2.0,
                                           3.0, 4.0], 0.00001));
        });
      });

      group('fromList', () {
        test('throws an error when the list has more than 4 items', () {
          var list = new List.filled(5, 1.0);

          expect(() => new Matrix2.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 4 items', () {
          var list = new List.filled(3, 1.0);

          expect(() => new Matrix2.fromList(list), throwsArgumentError);
        });
      });

      group('fromFloat32List', () {
        test('throws an error when the list has more than 4 items', () {
          var list = new Float32List(5);

          expect(() => new Matrix2.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 4 items', () {
          var list = new Float32List(3);

          expect(() => new Matrix2.fromList(list), throwsArgumentError);
        });
      });

      test('constant', () {
        var m = new Matrix2.constant(1.0);

        expect(m.values, orderedCloseTo([1.0, 1.0,
                                         1.0, 1.0], 0.00001));
      });

      test('zero', () {
        var m = new Matrix2.zero();

        expect(m.values, orderedCloseTo([0.0, 0.0,
                                         0.0, 0.0], 0.00001));
      });

      test('identity', () {
        var m = new Matrix2.identity();

        expect(m.values, orderedCloseTo([1.0, 0.0,
                                         0.0, 1.0], 0.00001));
      });
    });

    group('matrixProduct', () {
      group('with a Matrix2', () {
        var m1 = new Matrix2(1.0, 2.0, 
                             3.0, 4.0);
        var m2 = new Matrix2(1.0, 2.0,
                             3.0, 4.0);
        var product = m1 * m2;

        test('results in a new Matrix2', () {
          expect(product is Matrix2, isTrue);
        });

        test('results in a new matrix with the correct values', () {
          expect(product.values, orderedCloseTo([ 7.0, 10.0,
                                                 15.0, 22.0], 0.00001));
        });
      });

      group('with a Vector2', () {
        var m = new Matrix2(1.0, 2.0,
                            3.0, 4.0);
        var v = new Vector2(1.0, 2.0);
        var product = m * v;

        test('results in a new Vector2', () {
          expect(product is Vector2, isTrue);
        });

        test('results in a new matrix with the correct values', () {
          expect(product.values, orderedCloseTo([5.0, 11.0], 0.00001));
        });
      });
    });

    group('[] operator', () {
      var m = new Matrix2(1.0, 2.0,
                          3.0, 4.0);

      test('throws RangError if the index is out of bounds', () {
        expect(() => m[-1], throwsRangeError);
        expect(() => m[2], throwsRangeError);
      });

      test('returns the correct row', () {
        expect(m[0], orderedCloseTo([1.0, 2.0], 0.00001));
        expect(m[1], orderedCloseTo([3.0, 4.0], 0.00001));
      });
    });
  });
}