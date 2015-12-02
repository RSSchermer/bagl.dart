import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'dart:typed_data';

void main() {
  group('Vector4', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a vector with the right values', () {
          var m = new Vector4(1.0, 2.0, 3.0, 4.0);

          expect(m.valueAt(0, 0), equals(1.0));
          expect(m.valueAt(0, 1), equals(2.0));
          expect(m.valueAt(0, 2), equals(3.0));
          expect(m.valueAt(0, 3), equals(4.0));
        });
      });

      group('fromList', () {
        test('throws an error when the list has more than 4 items', () {
          var list = new List.filled(5, 1.0);

          expect(() => new Vector4.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 4 items', () {
          var list = new List.filled(3, 1.0);

          expect(() => new Vector4.fromList(list), throwsArgumentError);
        });
      });

      group('fromFloat32List', () {
        test('throws an error when the list has more than 4 items', () {
          var list = new Float32List(5);

          expect(() => new Vector4.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 4 items', () {
          var list = new Float32List(3);

          expect(() => new Vector4.fromList(list), throwsArgumentError);
        });
      });
    });

    group('[] operator', () {
      test('returns the correct value', () {
        var v = new Vector4(1.0, 2.0, 3.0, 4.0);

        expect(v[2], equals(3.0));
      });
    });
  });
}
