import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('Matrix4', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a matrix with the right values', () {
          var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                               5.0,  6.0,  7.0,  8.0,
                               9.0, 10.0, 11.0, 12.0,
                              13.0, 14.0, 15.0, 16.0);

          expect(m.values, orderedCloseTo([ 1.0,  2.0,  3.0,  4.0,
                                            5.0,  6.0,  7.0,  8.0,
                                            9.0, 10.0, 11.0, 12.0,
                                           13.0, 14.0, 15.0, 16.0], 0.00001));
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

        expect(m.values, orderedCloseTo([1.0, 1.0, 1.0, 1.0,
                                         1.0, 1.0, 1.0, 1.0,
                                         1.0, 1.0, 1.0, 1.0,
                                         1.0, 1.0, 1.0, 1.0], 0.00001));
      });

      test('zero', () {
        var m = new Matrix4.zero();

        expect(m.values, orderedCloseTo([0.0, 0.0, 0.0, 0.0,
                                         0.0, 0.0, 0.0, 0.0,
                                         0.0, 0.0, 0.0, 0.0,
                                         0.0, 0.0, 0.0, 0.0], 0.00001));
      });

      test('identity', () {
        var m = new Matrix4.identity();

        expect(m.values, orderedCloseTo([1.0, 0.0, 0.0, 0.0,
                                         0.0, 1.0, 0.0, 0.0,
                                         0.0, 0.0, 1.0, 0.0,
                                         0.0, 0.0, 0.0, 1.0], 0.00001));
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
          expect(product.values, orderedCloseTo([ 90.0, 100.0, 110.0, 120.0,
                                                 202.0, 228.0, 254.0, 280.0,
                                                 314.0, 356.0, 398.0, 440.0,
                                                 426.0, 484.0, 542.0, 600.0], 0.00001));
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
          expect(product.values, orderedCloseTo([30.0, 70.0, 110.0, 150.0], 0.00001));
        });
      });
    });

    group('value accessors', () {
      var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                           5.0,  6.0,  7.0,  8.0,
                           9.0, 10.0, 11.0, 12.0,
                          13.0, 14.0, 15.0, 16.0);

      test('r0c0 returns the correct value', () {
        expect(m.r0c0, closeTo(1.0, 0.00001));
      });

      test('r0c1 returns the correct value', () {
        expect(m.r0c1, closeTo(2.0, 0.00001));
      });

      test('r0c2 returns the correct value', () {
        expect(m.r0c2, closeTo(3.0, 0.00001));
      });

      test('r0c3 returns the correct value', () {
        expect(m.r0c3, closeTo(4.0, 0.00001));
      });

      test('r1c0 returns the correct value', () {
        expect(m.r1c0, closeTo(5.0, 0.00001));
      });

      test('r1c1 returns the correct value', () {
        expect(m.r1c1, closeTo(6.0, 0.00001));
      });

      test('r1c2 returns the correct value', () {
        expect(m.r1c2, closeTo(7.0, 0.00001));
      });

      test('r1c3 returns the correct value', () {
        expect(m.r1c3, closeTo(8.0, 0.00001));
      });

      test('r2c0 returns the correct value', () {
        expect(m.r2c0, closeTo(9.0, 0.00001));
      });

      test('r2c1 returns the correct value', () {
        expect(m.r2c1, closeTo(10.0, 0.00001));
      });

      test('r2c2 returns the correct value', () {
        expect(m.r2c2, closeTo(11.0, 0.00001));
      });

      test('r2c3 returns the correct value', () {
        expect(m.r2c3, closeTo(12.0, 0.00001));
      });

      test('r3c0 returns the correct value', () {
        expect(m.r3c0, closeTo(13.0, 0.00001));
      });

      test('r3c1 returns the correct value', () {
        expect(m.r3c1, closeTo(14.0, 0.00001));
      });

      test('r3c2 returns the correct value', () {
        expect(m.r3c2, closeTo(15.0, 0.00001));
      });

      test('r3c3 returns the correct value', () {
        expect(m.r3c3, closeTo(16.0, 0.00001));
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
        expect(m[0], orderedCloseTo([1.0, 2.0, 3.0, 4.0], 0.00001));
        expect(m[1], orderedCloseTo([5.0, 6.0, 7.0, 8.0], 0.00001));
        expect(m[2], orderedCloseTo([9.0, 10.0, 11.0, 12.0], 0.00001));
        expect(m[3], orderedCloseTo([13.0, 14.0, 15.0, 16.0], 0.00001));
      });
    });
  });
}
