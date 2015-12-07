import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';

void main() {
  group('Matrix4', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a matrix with the right values', () {
          var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                               5.0,  6.0,  7.0,  8.0,
                               9.0, 10.0, 11.0, 12.0,
                              13.0, 14.0, 15.0, 16.0);

          expect(m.values.toList(), equals([ 1.0,  2.0,  3.0,  4.0,
                                             5.0,  6.0,  7.0,  8.0,
                                             9.0, 10.0, 11.0, 12.0,
                                            13.0, 14.0, 15.0, 16.0]));
        });
      });

      group('fromList', () {
        test('throws an error when the list has more than 16 items', () {
          var list = new List.filled(17, 1.0);

          expect(() => new Matrix4.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 16 items', () {
          var list = new List.filled(15, 1.0);

          expect(() => new Matrix4.fromList(list), throwsArgumentError);
        });
      });

      group('fromFloat32List', () {
        test('throws an error when the list has more than 16 items', () {
          var list = new Float32List(17);

          expect(() => new Matrix4.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 16 items', () {
          var list = new Float32List(15);

          expect(() => new Matrix4.fromList(list), throwsArgumentError);
        });
      });

      test('constant', () {
        var m = new Matrix4.constant(1.0);

        expect(m.values.toList(), equals([1.0, 1.0, 1.0, 1.0,
                                          1.0, 1.0, 1.0, 1.0,
                                          1.0, 1.0, 1.0, 1.0,
                                          1.0, 1.0, 1.0, 1.0]));
      });

      test('zero', () {
        var m = new Matrix4.zero();

        expect(m.values.toList(), equals([0.0, 0.0, 0.0, 0.0,
                                          0.0, 0.0, 0.0, 0.0,
                                          0.0, 0.0, 0.0, 0.0,
                                          0.0, 0.0, 0.0, 0.0]));
      });

      test('identity', () {
        var m = new Matrix4.identity();

        expect(m.values.toList(), equals([1.0, 0.0, 0.0, 0.0,
                                          0.0, 1.0, 0.0, 0.0,
                                          0.0, 0.0, 1.0, 0.0,
                                          0.0, 0.0, 0.0, 1.0]));
      });
    });

    group('matrixProduct', () {
      group('with a Matrix4', () {
        var m1 = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                              5.0,  6.0,  7.0,  8.0,
                              9.0, 10.0, 11.0, 12.0,
                             13.0, 14.0, 15.0, 16.0);

        var m2 = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                              5.0,  6.0,  7.0,  8.0,
                              9.0, 10.0, 11.0, 12.0,
                             13.0, 14.0, 15.0, 16.0);
        var product = m1 * m2;

        test('results in a new Matrix4', () {
          expect(product is Matrix4, isTrue);
        });

        test('results in a new matrix with the correct values', () {
          expect(product.values.toList(), equals([ 90.0, 100.0, 110.0, 120.0,
                                                  202.0, 228.0, 254.0, 280.0,
                                                  314.0, 356.0, 398.0, 440.0,
                                                  426.0, 484.0, 542.0, 600.0]));
        });
      });

      group('with a Vector4', () {
        var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                             5.0,  6.0,  7.0,  8.0,
                             9.0, 10.0, 11.0, 12.0,
                            13.0, 14.0, 15.0, 16.0);
        var v = new Vector4(1.0, 2.0, 3.0, 4.0);
        var product = m * v;

        test('results in a new Vector4', () {
          expect(product is Vector4, isTrue);
        });

        test('results in a new matrix with the correct values', () {
          expect(product.values.toList(), equals([30.0, 70.0, 110.0, 150.0]));
        });
      });
    });

    group('[] operator', () {
      var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                           5.0,  6.0,  7.0,  8.0,
                           9.0, 10.0, 11.0, 12.0,
                          13.0, 14.0, 15.0, 16.0);

      test('throws RangError if the index is out of bounds', () {
        expect(() => m[-1], throwsRangeError);
        expect(() => m[4], throwsRangeError);
      });

      test('returns the correct row', () {
        expect(m[0], equals([1.0, 2.0, 3.0, 4.0]));
        expect(m[1], equals([5.0, 6.0, 7.0, 8.0]));
        expect(m[2], equals([9.0, 10.0, 11.0, 12.0]));
        expect(m[3], equals([13.0, 14.0, 15.0, 16.0]));
      });
    });
  });
}
