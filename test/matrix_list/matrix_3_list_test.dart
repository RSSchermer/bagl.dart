import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/matrix_list.dart';
import 'dart:typed_data';

void main() {
  group('Matrix3List', () {
    group('default constructor', () {
      final l = new Matrix3List(3);

      test('instantiates a Matrix3List of the right length', () {
        expect(l.length, equals(3));
      });

      test('instantiates a Matrix3List with all values set to zero', () {
        expect(l.toList(), equals([
          new Matrix3(
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0
          ),
          new Matrix3(
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0
          ),
          new Matrix3(
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0
          )
        ]));
      });
    });

    group('fromList constructor', () {
      final l = new Matrix3List.fromList([
        new Matrix3(
            0.0, 0.3, 0.6,
            0.1, 0.4, 0.7,
            0.2, 0.5, 0.8
        ),
        new Matrix3(
            1.0, 1.3, 1.6,
            1.1, 1.4, 1.7,
            1.2, 1.5, 1.8
        ),
        new Matrix3(
            2.0, 2.3, 2.6,
            2.1, 2.4, 2.7,
            2.2, 2.5, 2.8
        )
      ]);

      test('instantiates a Matrix3List of the right length', () {
        expect(l.length, equals(3));
      });

      test('instantiates a Matrix3List with the correct values', () {
        expect(l.toList(), equals([
          new Matrix3(
              0.0, 0.3, 0.6,
              0.1, 0.4, 0.7,
              0.2, 0.5, 0.8
          ),
          new Matrix3(
              1.0, 1.3, 1.6,
              1.1, 1.4, 1.7,
              1.2, 1.5, 1.8
          ),
          new Matrix3(
              2.0, 2.3, 2.6,
              2.1, 2.4, 2.7,
              2.2, 2.5, 2.8
          )
        ]));
      });
    });

    group('view constructor', () {
      final values = new Float32List.fromList([
        0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8,
        1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8,
        2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8,
        3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8,
        4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8
      ]);
      final l = new Matrix3List.view(values.buffer, 36, 3);

      test('instantiates a Matrix3List of the right length', () {
        expect(l.length, equals(3));
      });

      test('instantiates a Matrix3List with the correct values', () {
        expect(l.toList(), equals([
          new Matrix3(
              1.0, 1.3, 1.6,
              1.1, 1.4, 1.7,
              1.2, 1.5, 1.8
          ),
          new Matrix3(
              2.0, 2.3, 2.6,
              2.1, 2.4, 2.7,
              2.2, 2.5, 2.8
          ),
          new Matrix3(
              3.0, 3.3, 3.6,
              3.1, 3.4, 3.7,
              3.2, 3.5, 3.8
          )
        ]));
      });
    });
    
    group('instance', () {
      final l = new Matrix3List.fromList([
        new Matrix3(
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0
        ),
        new Matrix3(
            1.0, 1.0, 1.0,
            1.0, 1.0, 1.0,
            1.0, 1.0, 1.0
        ),
        new Matrix3(
            2.0, 2.0, 2.0,
            2.0, 2.0, 2.0,
            2.0, 2.0, 2.0
        )
      ]);
      
      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => l[-1], throwsRangeError);
          expect(() => l[3], throwsRangeError);
        });

        test('returns the correct value', () {
          expect(l[0], equals(
              new Matrix3(
                  0.0, 0.0, 0.0,
                  0.0, 0.0, 0.0,
                  0.0, 0.0, 0.0
              )
          ));
          expect(l[1], equals(
              new Matrix3(
                  1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0
              )
          ));
          expect(l[2], equals(
              new Matrix3(
                  2.0, 2.0, 2.0,
                  2.0, 2.0, 2.0,
                  2.0, 2.0, 2.0
              )
          ));
        });
      });

      group('[]= operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => l[-1] = new Matrix3(
              4.0, 4.0, 4.0,
              4.0, 4.0, 4.0,
              4.0, 4.0, 4.0
          ), throwsRangeError);
          expect(() => l[3] = new Matrix3(
              4.0, 4.0, 4.0,
              4.0, 4.0, 4.0,
              4.0, 4.0, 4.0
          ), throwsRangeError);
        });

        test('updates the correct value in the list', () {
          l[1] = new Matrix3(
              4.0, 4.0, 4.0,
              4.0, 4.0, 4.0,
              4.0, 4.0, 4.0
          );

          expect(l.toList(), equals([
            new Matrix3(
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0
            ),
            new Matrix3(
                4.0, 4.0, 4.0,
                4.0, 4.0, 4.0,
                4.0, 4.0, 4.0
            ),
            new Matrix3(
                2.0, 2.0, 2.0,
                2.0, 2.0, 2.0,
                2.0, 2.0, 2.0
            )
          ]));
        });
      });
    });
  });
}
