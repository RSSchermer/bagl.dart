import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('Vector4', () {
    group('default constructor', () {
      test('instantiates a vector with the right values', () {
        final v = new Vector4(1.0, 2.0, 3.0, 4.0);

        expect(v.values, orderedCloseTo([1.0, 2.0, 3.0, 4.0], 0.00001));
      });
    });

    group('fromList constructor', () {
      test('throws an error when the list has more than 4 items', () {
        final list = new List.filled(5, 1.0);

        expect(() => new Vector4.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 4 items', () {
        final list = new List.filled(3, 1.0);

        expect(() => new Vector4.fromList(list), throwsArgumentError);
      });
    });

    group('fromFloat32List constructor', () {
      test('throws an error when the list has more than 4 items', () {
        final list = new Float32List(5);

        expect(() => new Vector4.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 4 items', () {
        final list = new Float32List(3);

        expect(() => new Vector4.fromList(list), throwsArgumentError);
      });
    });

    test('constant constructor', () {
      final v = new Vector4.constant(1.0);

      expect(v.values, orderedCloseTo([1.0, 1.0, 1.0, 1.0], 0.00001));
    });

    test('zero constructor', () {
      final v = new Vector4.zero();

      expect(v.values, orderedCloseTo([0.0, 0.0, 0.0, 0.0], 0.00001));
    });
    
    group('instance', () {
      final v = new Vector4(1.0, 2.0, 3.0, 4.0);

      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => v[-1], throwsRangeError);
          expect(() => v[4], throwsRangeError);
        });

        test('returns the correct value', () {
          expect(v[0], closeTo(1.0, 0.00001));
          expect(v[1], closeTo(2.0, 0.00001));
          expect(v[2], closeTo(3.0, 0.00001));
          expect(v[3], closeTo(4.0, 0.00001));
        });
      });
    });
  });
}
