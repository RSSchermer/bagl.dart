import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
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

          expect(m.valueAt(0, 0), equals(1.0));
          expect(m.valueAt(1, 1), equals(6.0));
          expect(m.valueAt(2, 2), equals(11.0));
          expect(m.valueAt(3, 3), equals(16.0));
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
          var list = new Float32List(15);

          expect(() => new Matrix4.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 16 items', () {
          var list = new Float32List(17);

          expect(() => new Matrix4.fromList(list), throwsArgumentError);
        });
      });
    });

    group('matrixProduct', () {
      test('with a Matrix4 results in a new Matrix4', () {
        var m1 = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                              5.0,  6.0,  7.0,  8.0,
                              9.0, 10.0, 11.0, 12.0,
                             13.0, 14.0, 15.0, 16.0);

        var m2 = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                              5.0,  6.0,  7.0,  8.0,
                              9.0, 10.0, 11.0, 12.0,
                             13.0, 14.0, 15.0, 16.0);
        var product = m1 * m2;

        expect(product is Matrix4, isTrue);
      });

      test('with a Vector4 results in a new Vector4', () {
        var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                             5.0,  6.0,  7.0,  8.0,
                             9.0, 10.0, 11.0, 12.0,
                            13.0, 14.0, 15.0, 16.0);
        var v = new Vector4(1.0, 2.0, 3.0, 4.0);
        var product = m * v;

        expect(product is Vector4, isTrue);
      });
    });

    group('[] operator', () {
      test('returns the correct row', () {
        var m = new Matrix4( 1.0,  2.0,  3.0,  4.0,
                             5.0,  6.0,  7.0,  8.0,
                             9.0, 10.0, 11.0, 12.0,
                            13.0, 14.0, 15.0, 16.0);

        expect(m[2], equals([9.0, 10.0, 11.0, 12.0]));
      });
    });
  });
}
