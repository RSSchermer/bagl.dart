import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';

void main() {
  group('Matrix3', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a matrix with the right values', () {
          var m = new Matrix3(1.0, 2.0, 3.0,  
                              4.0, 5.0, 6.0, 
                              7.0, 8.0, 9.0);

          expect(m.values.toList(), equals([1.0, 2.0, 3.0,
                                            4.0, 5.0, 6.0,
                                            7.0, 8.0, 9.0]));
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

        expect(m.values.toList(), equals([1.0, 1.0, 1.0,
                                          1.0, 1.0, 1.0,
                                          1.0, 1.0, 1.0]));
      });

      test('zero', () {
        var m = new Matrix3.zero();

        expect(m.values.toList(), equals([0.0, 0.0, 0.0,
                                          0.0, 0.0, 0.0,
                                          0.0, 0.0, 0.0]));
      });

      test('identity', () {
        var m = new Matrix3.identity();

        expect(m.values.toList(), equals([1.0, 0.0, 0.0,
                                          0.0, 1.0, 0.0,
                                          0.0, 0.0, 1.0,]));
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
          expect(product.values.toList(), equals([ 30.0,  36.0,  42.0,
                                                   66.0,  81.0,  96.0,
                                                  102.0, 126.0, 150.0]));
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
          expect(product.values.toList(), equals([14.0, 32.0, 50.0]));
        });
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
        expect(m[0], equals([1.0, 2.0, 3.0]));
        expect(m[1], equals([4.0, 5.0, 6.0]));
        expect(m[2], equals([7.0, 8.0, 9.0]));
      });
    });
  });
}
