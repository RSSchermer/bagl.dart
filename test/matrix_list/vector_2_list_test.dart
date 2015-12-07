import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/matrix_list.dart';
import 'dart:typed_data';

void main() {
  group('Vector2List', () {
    group('constructor', () {
      group('default', () {
        var l = new Vector2List(3);

        test('instantiates a Vector2List of the right length', () {
          expect(l.length, equals(3));
        });

        test('instantiates a Vector2List with all values set to zero', () {
          expect(l.toList(), equals([
            new Vector2(0.0, 0.0),
            new Vector2(0.0, 0.0),
            new Vector2(0.0, 0.0)
          ]));
        });
      });

      group('fromList', () {
        var l = new Vector2List.fromList([
          new Vector2(0.0, 0.0),
          new Vector2(1.0, 1.0),
          new Vector2(2.0, 2.0)
        ]);

        test('instantiates a Vector2List of the right length', () {
          expect(l.length, equals(3));
        });

        test('instantiates a Vector2List with the correct values', () {
          expect(l.toList(), equals([
            new Vector2(0.0, 0.0),
            new Vector2(1.0, 1.0),
            new Vector2(2.0, 2.0)
          ]));
        });
      });

      group('view', () {
        var values = new Float32List.fromList([
          0.0, 0.0,
          1.0, 1.0,
          2.0, 2.0,
          3.0, 3.0,
          4.0, 4.0
        ]);
        var l = new Vector2List.view(values.buffer, 8, 3);

        test('instantiates a Vector2List of the right length', () {
          expect(l.length, equals(3));
        });

        test('instantiates a Vector2List with the correct values', () {
          expect(l.toList(), equals([
            new Vector2(1.0, 1.0),
            new Vector2(2.0, 2.0),
            new Vector2(3.0, 3.0)
          ]));
        });
      });
    });

    group('[] operator', () {
      var l = new Vector2List.fromList([
        new Vector2(0.0, 0.0),
        new Vector2(1.0, 1.0),
        new Vector2(2.0, 2.0)
      ]);

      test('throws a RangeError if the index is out of bounds', () {
        expect(() => l[-1], throwsRangeError);
        expect(() => l[3], throwsRangeError);
      });

      test('returns the correct value', () {
        expect(l[0], equals(new Vector2(0.0, 0.0)));
        expect(l[1], equals(new Vector2(1.0, 1.0)));
        expect(l[2], equals(new Vector2(2.0, 2.0)));
      });
    });

    group('[]= operator', () {
      var l = new Vector2List.fromList([
        new Vector2(0.0, 0.0),
        new Vector2(1.0, 1.0),
        new Vector2(2.0, 2.0)
      ]);

      test('throws a RangeError if the index is out of bounds', () {
        expect(() => l[-1] = new Vector2(4.0, 4.0), throwsRangeError);
        expect(() => l[3] = new Vector2(4.0, 4.0), throwsRangeError);
      });

      test('updates the correct value in the list', () {
        l[1] = new Vector2(4.0, 4.0);

        expect(l.toList(), equals([
          new Vector2(0.0, 0.0),
          new Vector2(4.0, 4.0),
          new Vector2(2.0, 2.0)
        ]));
      });
    });
  });
}
