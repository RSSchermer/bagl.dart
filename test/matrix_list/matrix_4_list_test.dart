import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/matrix_list.dart';
import 'dart:typed_data';

void main() {
  group('Matrix4List', () {
    group('default constructor', () {
      final l = new Matrix4List(3);

      test('instantiates a Matrix4List of the right length', () {
        expect(l.length, equals(3));
      });

      test('instantiates a Matrix4List with all values set to zero', () {
        expect(l.toList(), equals([
          new Matrix4(
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0
          ),
          new Matrix4(
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0
          ),
          new Matrix4(
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0,
              0.0, 0.0, 0.0, 0.0
          )
        ]));
      });
    });

    group('fromList constructor', () {
      final l = new Matrix4List.fromList([
        new Matrix4(
            0.0, 0.4, 0.8,  0.12,
            0.1, 0.5, 0.9,  0.13,
            0.2, 0.6, 0.10, 0.14,
            0.3, 0.7, 0.11, 0.15
        ),
        new Matrix4(
            1.0, 1.4, 1.8,  1.12,
            1.1, 1.5, 1.9,  1.13,
            1.2, 1.6, 1.10, 1.14,
            1.3, 1.7, 1.11, 1.15
        ),
        new Matrix4(
            2.0, 2.4, 2.8,  2.12,
            2.1, 2.5, 2.9,  2.13,
            2.2, 2.6, 2.10, 2.14,
            2.3, 2.7, 2.11, 2.15
        )
      ]);

      test('instantiates a Matrix4List of the right length', () {
        expect(l.length, equals(3));
      });

      test('instantiates a Matrix4List with the correct values', () {
        expect(l.toList(), equals([
          new Matrix4(
              0.0, 0.4, 0.8,  0.12,
              0.1, 0.5, 0.9,  0.13,
              0.2, 0.6, 0.10, 0.14,
              0.3, 0.7, 0.11, 0.15
          ),
          new Matrix4(
              1.0, 1.4, 1.8,  1.12,
              1.1, 1.5, 1.9,  1.13,
              1.2, 1.6, 1.10, 1.14,
              1.3, 1.7, 1.11, 1.15
          ),
          new Matrix4(
              2.0, 2.4, 2.8,  2.12,
              2.1, 2.5, 2.9,  2.13,
              2.2, 2.6, 2.10, 2.14,
              2.3, 2.7, 2.11, 2.15
          )
        ]));
      });
    });

    group('view constructor', () {
      final values = new Float32List.fromList([
        0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15,
        1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 1.10, 1.11, 1.12, 1.13, 1.14, 1.15,
        2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10, 2.11, 2.12, 2.13, 2.14, 2.15,
        3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14, 3.15,
        4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 4.10, 4.11, 4.12, 4.13, 4.14, 4.15
      ]);
      final l = new Matrix4List.view(values.buffer, 64, 3);

      test('instantiates a Matrix4List of the right length', () {
        expect(l.length, equals(3));
      });

      test('instantiates a Matrix4List with the correct values', () {
        expect(l.toList(), equals([
          new Matrix4(
              1.0, 1.4, 1.8,  1.12,
              1.1, 1.5, 1.9,  1.13,
              1.2, 1.6, 1.10, 1.14,
              1.3, 1.7, 1.11, 1.15
          ),
          new Matrix4(
              2.0, 2.4, 2.8,  2.12,
              2.1, 2.5, 2.9,  2.13,
              2.2, 2.6, 2.10, 2.14,
              2.3, 2.7, 2.11, 2.15
          ),
          new Matrix4(
              3.0, 3.4, 3.8,  3.12,
              3.1, 3.5, 3.9,  3.13,
              3.2, 3.6, 3.10, 3.14,
              3.3, 3.7, 3.11, 3.15
          )
        ]));
      });
    });
    
    group('instance', () {
      final l = new Matrix4List.fromList([
        new Matrix4(
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0
        ),
        new Matrix4(
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0
        ),
        new Matrix4(
            2.0, 2.0, 2.0, 2.0,
            2.0, 2.0, 2.0, 2.0,
            2.0, 2.0, 2.0, 2.0,
            2.0, 2.0, 2.0, 2.0
        )
      ]);
      
      group('[] operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => l[-1], throwsRangeError);
          expect(() => l[3], throwsRangeError);
        });

        test('returns the correct value', () {
          expect(l[0], equals(
              new Matrix4(
                  0.0, 0.0, 0.0, 0.0,
                  0.0, 0.0, 0.0, 0.0,
                  0.0, 0.0, 0.0, 0.0,
                  0.0, 0.0, 0.0, 0.0
              )
          ));
          expect(l[1], equals(
              new Matrix4(
                  1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0,
                  1.0, 1.0, 1.0, 1.0
              )
          ));
          expect(l[2], equals(
              new Matrix4(
                  2.0, 2.0, 2.0, 2.0,
                  2.0, 2.0, 2.0, 2.0,
                  2.0, 2.0, 2.0, 2.0,
                  2.0, 2.0, 2.0, 2.0
              )
          ));
        });
      });

      group('[]= operator', () {
        test('throws a RangeError if the index is out of bounds', () {
          expect(() => l[-1] = new Matrix4(
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0
          ), throwsRangeError);
          expect(() => l[3] = new Matrix4(
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0
          ), throwsRangeError);
        });

        test('updates the correct value in the list', () {
          l[1] = new Matrix4(
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0,
              4.0, 4.0, 4.0, 4.0
          );

          expect(l.toList(), equals([
            new Matrix4(
                0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0,
                0.0, 0.0, 0.0, 0.0
            ),
            new Matrix4(
                4.0, 4.0, 4.0, 4.0,
                4.0, 4.0, 4.0, 4.0,
                4.0, 4.0, 4.0, 4.0,
                4.0, 4.0, 4.0, 4.0
            ),
            new Matrix4(
                2.0, 2.0, 2.0, 2.0,
                2.0, 2.0, 2.0, 2.0,
                2.0, 2.0, 2.0, 2.0,
                2.0, 2.0, 2.0, 2.0
            )
          ]));
        });
      });
    });
  });
}
