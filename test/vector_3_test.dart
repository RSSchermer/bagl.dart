import 'package:test/test.dart';
import 'package:bagl/bagl.dart';
import 'dart:typed_data';

void main() {
  group('Vector3', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a vector with the right values', () {
          var v = new Vector3(1.0, 2.0, 3.0);

          expect(v.values.toList(), equals([1.0, 2.0, 3.0]));
        });
      });

      group('fromList', () {
        test('throws an error when the list has more than 3 items', () {
          var list = new List.filled(4, 1.0);

          expect(() => new Vector3.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 3 items', () {
          var list = new List.filled(2, 1.0);

          expect(() => new Vector3.fromList(list), throwsArgumentError);
        });
      });

      group('fromFloat32List', () {
        test('throws an error when the list has more than 3 items', () {
          var list = new Float32List(4);

          expect(() => new Vector3.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 3 items', () {
          var list = new Float32List(2);

          expect(() => new Vector3.fromList(list), throwsArgumentError);
        });
      });

      test('constant', () {
        var v = new Vector3.constant(1.0);

        expect(v.values.toList(), equals([1.0, 1.0, 1.0]));
      });

      test('zero', () {
        var v = new Vector3.zero();

        expect(v.values.toList(), equals([0.0, 0.0, 0.0]));
      });
    });

    group('[] operator', () {
      test('returns the correct value', () {
        var v = new Vector3(1.0, 2.0, 3.0);

        expect(v[0], equals(1.0));
        expect(v[1], equals(2.0));
        expect(v[2], equals(3.0));
      });
    });
  });
}
