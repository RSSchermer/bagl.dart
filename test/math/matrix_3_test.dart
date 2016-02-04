import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('Matrix3', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a matrix with the right values', () {
          var m = new Matrix3(1.0, 2.0, 3.0,  
                              4.0, 5.0, 6.0, 
                              7.0, 8.0, 9.0);

          expect(m.values, orderedCloseTo([1.0, 2.0, 3.0,
                                           4.0, 5.0, 6.0,
                                           7.0, 8.0, 9.0], 0.00001));
        });
      });

      group('fromList', () {
        test('throws an error when the list has more than 9 items', () {
          var list = new List.filled(10, 1.0);

          expect(() => new Matrix3.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 9 items', () {
          var list = new List.filled(8, 1.0);

          expect(() => new Matrix3.fromList(list), throwsArgumentError);
        });
      });

      group('fromFloat32List', () {
        test('throws an error when the list has more than 9 items', () {
          var list = new Float32List(10);

          expect(() => new Matrix3.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 9 items', () {
          var list = new Float32List(8);

          expect(() => new Matrix3.fromList(list), throwsArgumentError);
        });
      });

      test('constant', () {
        var m = new Matrix3.constant(1.0);

        expect(m.values, orderedCloseTo([1.0, 1.0, 1.0,
                                         1.0, 1.0, 1.0,
                                         1.0, 1.0, 1.0], 0.00001));
      });

      test('zero', () {
        var m = new Matrix3.zero();

        expect(m.values, orderedCloseTo([0.0, 0.0, 0.0,
                                         0.0, 0.0, 0.0,
                                         0.0, 0.0, 0.0], 0.00001));
      });

      test('identity', () {
        var m = new Matrix3.identity();

        expect(m.values, orderedCloseTo([1.0, 0.0, 0.0,
                                         0.0, 1.0, 0.0,
                                         0.0, 0.0, 1.0,], 0.00001));
      });
    });

    group('matrixProduct', () {
      group('with a Matrix3', () {
        var m1 = new Matrix3(1.0, 2.0, 3.0,
                             4.0, 5.0, 6.0,
                             7.0, 8.0, 9.0);

        var m2 = new Matrix3(1.0, 2.0, 3.0,
                             4.0, 5.0, 6.0,
                             7.0, 8.0, 9.0);
        var product = m1 * m2;

        test('results in a new Matrix3', () {
          expect(product is Matrix3, isTrue);
        });

        test('results in a new matrix with the correct values', () {
          expect(product.values, orderedCloseTo([ 30.0,  36.0,  42.0,
                                                  66.0,  81.0,  96.0,
                                                 102.0, 126.0, 150.0], 0.00001));
        });
      });

      group('with a Vector3', () {
        var m = new Matrix3(1.0, 2.0, 3.0,
                            4.0, 5.0, 6.0,
                            7.0, 8.0, 9.0);
        var v = new Vector3(1.0, 2.0, 3.0);
        var product = m * v;

        test('results in a new Vector3', () {
          expect(product is Vector3, isTrue);
        });

        test('results in a new matrix with the correct values', () {
          expect(product.values, orderedCloseTo([14.0, 32.0, 50.0], 0.00001));
        });
      });
    });

    group('value accessors', () {
      var m = new Matrix3(1.0, 2.0, 3.0,
                          4.0, 5.0, 6.0,
                          7.0, 8.0, 9.0);

      test('r0c0 returns the correct value', () {
        expect(m.r0c0, closeTo(1.0, 0.00001));
      });

      test('r0c1 returns the correct value', () {
        expect(m.r0c1, closeTo(2.0, 0.00001));
      });

      test('r0c2 returns the correct value', () {
        expect(m.r0c2, closeTo(3.0, 0.00001));
      });

      test('r1c0 returns the correct value', () {
        expect(m.r1c0, closeTo(4.0, 0.00001));
      });

      test('r1c1 returns the correct value', () {
        expect(m.r1c1, closeTo(5.0, 0.00001));
      });

      test('r1c2 returns the correct value', () {
        expect(m.r1c2, closeTo(6.0, 0.00001));
      });

      test('r2c0 returns the correct value', () {
        expect(m.r2c0, closeTo(7.0, 0.00001));
      });

      test('r2c1 returns the correct value', () {
        expect(m.r2c1, closeTo(8.0, 0.00001));
      });

      test('r2c2 returns the correct value', () {
        expect(m.r2c2, closeTo(9.0, 0.00001));
      });
    });

    group('[] operator', () {
      var m = new Matrix3(1.0, 2.0, 3.0,
                          4.0, 5.0, 6.0,
                          7.0, 8.0, 9.0);

      test('throws RangError if the index is out of bounds', () {
        expect(() => m[-1], throwsRangeError);
        expect(() => m[3], throwsRangeError);
      });

      test('returns the correct row', () {
        expect(m[0], orderedCloseTo([1.0, 2.0, 3.0], 0.00001));
        expect(m[1], orderedCloseTo([4.0, 5.0, 6.0], 0.00001));
        expect(m[2], orderedCloseTo([7.0, 8.0, 9.0], 0.00001));
      });
    });
  });
}
