import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';

void main() {
  group('Vector2', () {
    group('constructor', () {
      group('default', () {
        test('instantiates a vector with the right values', () {
          var v = new Vector2(1.0, 2.0);

          expect(v.values.toList(), equals([1.0, 2.0]));
        });
      });

      group('fromList', () {
        test('throws an error when the list has more than 2 items', () {
          var list = new List.filled(3, 1.0);

          expect(() => new Vector2.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 2 items', () {
          var list = new List.filled(1, 1.0);

          expect(() => new Vector2.fromList(list), throwsArgumentError);
        });
      });

      group('fromFloat32List', () {
        test('throws an error when the list has more than 2 items', () {
          var list = new Float32List(3);

          expect(() => new Vector2.fromList(list), throwsArgumentError);
        });

        test('throws an error when the list has less than 2 items', () {
          var list = new Float32List(1);

          expect(() => new Vector2.fromList(list), throwsArgumentError);
        });
      });

      test('constant', () {
        var v = new Vector2.constant(1.0);

        expect(v.values.toList(), equals([1.0, 1.0]));
      });

      test('zero', () {
        var v = new Vector2.zero();

        expect(v.values.toList(), equals([0.0, 0.0]));
      });
    });

    group('[] operator', () {
      var v = new Vector2(1.0, 2.0);

      test('throws RangError if the index is out of bounds', () {
        expect(() => v[-1], throwsRangeError);
        expect(() => v[2], throwsRangeError);
      });

      test('returns the correct value', () {
        expect(v[0], equals(1.0));
        expect(v[1], equals(2.0));
      });
    });
  });
}
