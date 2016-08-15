import 'package:test/test.dart';
import 'package:bagl/math.dart';
import '../helpers.dart';

void main() {
  group('Vector2', () {
    group('default constructor', () {
      test('instantiates a vector with the right values', () {
        final v = new Vector2(1.0, 2.0);

        expect(v.values, orderedCloseTo([1.0, 2.0], 0.00001));
      });
    });

    group('fromList constructor', () {
      test('throws an error when the list has more than 2 items', () {
        final list = new List<double>.filled(3, 1.0);

        expect(() => new Vector2.fromList(list), throwsArgumentError);
      });

      test('throws an error when the list has less than 2 items', () {
        final list = new List<double>.filled(1, 1.0);

        expect(() => new Vector2.fromList(list), throwsArgumentError);
      });
    });

    test('constant constructor', () {
      final v = new Vector2.constant(1.0);

      expect(v.values, orderedCloseTo([1.0, 1.0], 0.00001));
    });

    test('zero constructor', () {
      final v = new Vector2.zero();

      expect(v.values, orderedCloseTo([0.0, 0.0], 0.00001));
    });
    
    group('instance', () {
      final vector = new Vector2(1.0, 2.0);

      group('valueAt', () {
        test('(1, 0)', () {
          expect(vector.valueAt(1, 0), closeTo(2.0, 0.00001));
        });
      });

      group('rowAt', () {
        test('throws an error when trying to access an out of bounds row', () {
          expect(() => vector.rowAt(3), throwsRangeError);
        });

        test('returns the correct row', () {
          expect(vector.rowAt(1), orderedCloseTo([2.0], 0.00001));
        });
      });

      group('valuesColumnPacked', () {
        test('returns the correct value', () {
          expect(vector.valuesColumnPacked, orderedCloseTo([1.0, 2.0], 0.00001));
        });
      });

      group('transpose', () {
        final transpose = vector.transpose;

        test('returns a vector with the correct column dimension', () {
          expect(transpose.columnDimension, equals(2));
        });

        test('returns a matrix with the correct values', () {
          expect(transpose.values, orderedCloseTo([1.0, 2.0], 0.00001));
        });
      });

      group('scalarProduct', () {
        final product = vector.scalarProduct(2);

        test('returns a Vector2', () {
          expect(product, new isInstanceOf<Vector2>());
        });

        test('returns a vector with the correct values', () {
          expect(product.values, orderedCloseTo([2.0, 4.0], 0.00001));
        });
      });

      group('scalarDivision', () {
        final product = vector.scalarDivision(2);

        test('returns a Vector2', () {
          expect(product, new isInstanceOf<Vector2>());
        });

        test('returns a vector with the correct values', () {
          expect(product.values, orderedCloseTo([0.5, 1.0], 0.00001));
        });
      });

      group('entrywiseSum', () {
        final other = new Vector2(2.0, 1.0);
        final sum = vector.entrywiseSum(other);

        test('returns a Vector2', () {
          expect(sum, new isInstanceOf<Vector2>());
        });

        test('returns a vector with the correct values', () {
          expect(sum.values, orderedCloseTo([3.0, 3.0], 0.00001));
        });
      });

      group('entrywiseDifference', () {
        final other = new Vector2(2.0, 1.0);
        final difference = vector.entrywiseDifference(other);

        test('returns a Vector2', () {
          expect(difference, new isInstanceOf<Vector2>());
        });

        test('returns a vector with the correct values', () {
          expect(difference.values, orderedCloseTo([-1.0, 1.0], 0.00001));
        });
      });

      group('entrywiseProduct', () {
        final other = new Vector2(2.0, 1.0);
        final product = vector.entrywiseProduct(other);

        test('returns a Vector2', () {
          expect(product, new isInstanceOf<Vector2>());
        });

        test('returns a vector with the correct values', () {
          expect(product.values, orderedCloseTo([2.0, 2.0], 0.00001));
        });
      });
      
      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => vector[-1], throwsRangeError);
          expect(() => vector[2], throwsRangeError);
        });

        test('returns the correct value', () {
          expect(vector[0], closeTo(1.0, 0.00001));
          expect(vector[1], closeTo(2.0, 0.00001));
        });
      });
    });
  });
}
