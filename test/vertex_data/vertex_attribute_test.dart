import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/buffered_vertex_data.dart';
import '../helpers.dart';

void main() {
  group('FloatAttribute', () {
    final frame = new AttributeDataFrame(2, [
      0.0, 0.1,
      1.0, 1.1,
      2.0, 2.1
    ]);
    final attribute = new FloatAttribute(frame, offset: 1);

    group('default constructor', () {
      test('throws an ArgumentError if the offset is greater than the length of rows in the frame', () {
        expect(() => new FloatAttribute(frame, offset: 2), throwsArgumentError);
      });
    });

    group('instance', () {
      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), closeTo(1.1, 0.00001));
        });
      });

      group('setValueAtRow', () {
        final value = 8.1;

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.0, 8.1], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(3, [
            0.0, 0.1,
            1.0, 1.1,
            2.0, 2.1
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), closeTo(2.1, 0.00001));
        });
      });

      group('setOn', () {
        final value = 9.1;

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(3, [
            0.0, 0.1,
            1.0, 1.1,
            2.0, 2.1
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.0, 9.1], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(2, [
          0.2, 0.1,
          1.2, 1.1,
          2.2, 2.1
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), closeTo(1.1, 0.00001));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), closeTo(1.2, 0.00001));
        });
      });
    });
  });

  group('Vector2Attribute', () {
    final frame = new AttributeDataFrame(3, [
      0.0, 0.1, 0.2,
      1.0, 1.1, 1.2,
      2.0, 2.1, 2.2
    ]);

    group('default constructor', () {
      test('throws an ArgumentError if the attribute does not fit within a row of the frame', () {
        expect(() => new Vector2Attribute(frame, offset: 2), throwsArgumentError);
      });
    });

    group('instance', () {
      final attribute = new Vector2Attribute(frame, offset: 1);

      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), equals(new Vector2(1.1, 1.2)));
        });
      });

      group('setValueAtRow', () {
        final value = new Vector2(8.1, 8.2);

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.0, 8.1, 8.2], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(3, [
            0.0, 0.1, 0.2,
            1.0, 1.1, 1.2,
            2.0, 2.1, 2.2
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), equals(new Vector2(2.1, 2.2)));
        });
      });

      group('setOn', () {
        final value = new Vector2(9.1, 9.2);

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(3, [
            0.0, 0.1, 0.2,
            1.0, 1.1, 1.2,
            2.0, 2.1, 2.2
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.0, 9.1, 9.2], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(3, [
          0.2, 0.1, 0.0,
          1.2, 1.1, 1.0,
          2.2, 2.1, 2.0
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), equals(new Vector2(1.1, 1.0)));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), equals(new Vector2(1.2, 1.1)));
        });
      });
    });
  });

  group('Vector3Attribute', () {
    final frame = new AttributeDataFrame(4, [
      0.0, 0.1, 0.2, 0.3,
      1.0, 1.1, 1.2, 1.3,
      2.0, 2.1, 2.2, 2.3
    ]);

    group('default constructor', () {
      test('throws an ArgumentError if the attribute does not fit within a row of the frame', () {
        expect(() => new Vector3Attribute(frame, offset: 2), throwsArgumentError);
      });
    });

    group('instance', () {
      final attribute = new Vector3Attribute(frame, offset: 1);

      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), equals(new Vector3(1.1, 1.2, 1.3)));
        });
      });

      group('setValueAtRow', () {
        final value = new Vector3(8.1, 8.2, 8.3);

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.0, 8.1, 8.2, 8.3], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(4, [
            0.0, 0.1, 0.2, 0.3,
            1.0, 1.1, 1.2, 1.3,
            2.0, 2.1, 2.2, 2.3
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), equals(new Vector3(2.1, 2.2, 2.3)));
        });
      });

      group('setOn', () {
        final value = new Vector3(9.1, 9.2, 9.3);

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(4, [
            0.0, 0.1, 0.2, 0.3,
            1.0, 1.1, 1.2, 1.3,
            2.0, 2.1, 2.2, 2.3
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.0, 9.1, 9.2, 9.3], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(4, [
          0.3, 0.2, 0.1, 0.0,
          1.3, 1.2, 1.1, 1.0,
          2.3, 2.2, 2.1, 2.0
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), equals(new Vector3(1.2, 1.1, 1.0)));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), equals(new Vector3(1.3, 1.2, 1.1)));
        });
      });
    });
  });

  group('Vector4Attribute', () {
    final frame = new AttributeDataFrame(5, [
      0.0, 0.1, 0.2, 0.3, 0.4,
      1.0, 1.1, 1.2, 1.3, 1.4,
      2.0, 2.1, 2.2, 2.3, 2.4
    ]);

    group('default constructor', () {
      test('throws an ArgumentError if the attribute does not fit within a row of the frame', () {
        expect(() => new Vector4Attribute(frame, offset: 2), throwsArgumentError);
      });
    });

    group('instance', () {
      final attribute = new Vector4Attribute(frame, offset: 1);

      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), equals(new Vector4(1.1, 1.2, 1.3, 1.4)));
        });
      });

      group('setValueAtRow', () {
        final value = new Vector4(8.1, 8.2, 8.3, 8.4);

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.0, 8.1, 8.2, 8.3, 8.4], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(5, [
            0.0, 0.1, 0.2, 0.3, 0.4,
            1.0, 1.1, 1.2, 1.3, 1.4,
            2.0, 2.1, 2.2, 2.3, 2.4
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), equals(new Vector4(2.1, 2.2, 2.3, 2.4)));
        });
      });

      group('setOn', () {
        final value = new Vector4(9.1, 9.2, 9.3, 9.4);

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(5, [
            0.0, 0.1, 0.2, 0.3, 0.4,
            1.0, 1.1, 1.2, 1.3, 1.4,
            2.0, 2.1, 2.2, 2.3, 2.4
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.0, 9.1, 9.2, 9.3, 9.4], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(5, [
          0.4, 0.3, 0.2, 0.1, 0.0,
          1.4, 1.3, 1.2, 1.1, 1.0,
          2.4, 2.3, 2.2, 2.1, 2.0
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), equals(new Vector4(1.3, 1.2, 1.1, 1.0)));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), equals(new Vector4(1.4, 1.3, 1.2, 1.1)));
        });
      });
    });
  });

  group('Matrix2Attribute', () {
    final frame = new AttributeDataFrame(5, [
      0.0, 0.1, 0.2, 0.3, 0.4,
      1.0, 1.1, 1.2, 1.3, 1.4,
      2.0, 2.1, 2.2, 2.3, 2.4
    ]);

    group('default constructor', () {
      test('throws an ArgumentError if the attribute does not fit within a row of the frame', () {
        expect(() => new Matrix2Attribute(frame, offset: 2), throwsArgumentError);
      });
    });

    group('instance', () {
      final attribute = new Matrix2Attribute(frame, offset: 1);
      
      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), equals(new Matrix2(
              1.1, 1.2,
              1.3, 1.4
          )));
        });
      });

      group('setValueAtRow', () {
        final value = new Matrix2(
            8.1, 8.2,
            8.3, 8.4
        );

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.0, 8.1, 8.2, 8.3, 8.4], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(5, [
            0.0, 0.1, 0.2, 0.3, 0.4,
            1.0, 1.1, 1.2, 1.3, 1.4,
            2.0, 2.1, 2.2, 2.3, 2.4
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), equals(new Matrix2(
              2.1, 2.2,
              2.3, 2.4
          )));
        });
      });

      group('setOn', () {
        final value = new Matrix2(
            9.1, 9.2,
            9.3, 9.4
        );

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(5, [
            0.0, 0.1, 0.2, 0.3, 0.4,
            1.0, 1.1, 1.2, 1.3, 1.4,
            2.0, 2.1, 2.2, 2.3, 2.4
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.0, 9.1, 9.2, 9.3, 9.4], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(5, [
          0.4, 0.3, 0.2, 0.1, 0.0,
          1.4, 1.3, 1.2, 1.1, 1.0,
          2.4, 2.3, 2.2, 2.1, 2.0
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), equals(new Matrix2(
              1.3, 1.2,
              1.1, 1.0
          )));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), equals(new Matrix2(
              1.4, 1.3,
              1.2, 1.1
          )));
        });
      });
    });
  });

  group('Matrix3Attribute', () {
    final frame = new AttributeDataFrame(10, [
      0.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09,
      1.00, 1.01, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08, 1.09,
      2.00, 2.01, 2.02, 2.03, 2.04, 2.05, 2.06, 2.07, 2.08, 2.09
    ]);
    

    group('default constructor', () {
      test('throws an ArgumentError if the attribute does not fit within a row of the frame', () {
        expect(() => new Matrix3Attribute(frame, offset: 2), throwsArgumentError);
      });
    });

    group('instance', () {
      final attribute = new Matrix3Attribute(frame, offset: 1);
      
      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), equals(new Matrix3(
              1.01, 1.02, 1.03,
              1.04, 1.05, 1.06,
              1.07, 1.08, 1.09
          )));
        });
      });

      group('setValueAtRow', () {
        final value = new Matrix3(
            8.01, 8.02, 8.03,
            8.04, 8.05, 8.06,
            8.07, 8.08, 8.09
        );

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.00,
            8.01, 8.02, 8.03,
            8.04, 8.05, 8.06,
            8.07, 8.08, 8.09
          ], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(10, [
            0.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09,
            1.00, 1.01, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08, 1.09,
            2.00, 2.01, 2.02, 2.03, 2.04, 2.05, 2.06, 2.07, 2.08, 2.09
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), equals(new Matrix3(
              2.01, 2.02, 2.03,
              2.04, 2.05, 2.06,
              2.07, 2.08, 2.09
          )));
        });
      });

      group('setOn', () {
        final value = new Matrix3(
            9.01, 9.02, 9.03,
            9.04, 9.05, 9.06,
            9.07, 9.08, 9.09
        );

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(10, [
            0.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09,
            1.00, 1.01, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08, 1.09,
            2.00, 2.01, 2.02, 2.03, 2.04, 2.05, 2.06, 2.07, 2.08, 2.09
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.00,
            9.01, 9.02, 9.03,
            9.04, 9.05, 9.06,
            9.07, 9.08, 9.09
          ], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(10, [
          0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01, 0.00,
          1.09, 1.08, 1.07, 1.06, 1.05, 1.04, 1.03, 1.02, 1.01, 1.00,
          2.09, 2.08, 2.07, 2.06, 2.05, 2.04, 2.03, 2.02, 2.01, 2.00
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), equals(new Matrix3(
              1.08, 1.07, 1.06,
              1.05, 1.04, 1.03,
              1.02, 1.01, 1.00
          )));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), equals(new Matrix3(
              1.09, 1.08, 1.07,
              1.06, 1.05, 1.04,
              1.03, 1.02, 1.01
          )));
        });
      });
    });
  });

  group('Matrix4Attribute', () {
    final frame = new AttributeDataFrame(17, [
      0.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16,
      1.00, 1.01, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08, 1.09, 1.10, 1.11, 1.12, 1.13, 1.14, 1.15, 1.16,
      2.00, 2.01, 2.02, 2.03, 2.04, 2.05, 2.06, 2.07, 2.08, 2.09, 2.10, 2.11, 2.12, 2.13, 2.14, 2.15, 2.16
    ]);
    

    group('default constructor', () {
      test('throws an ArgumentError if the attribute does not fit within a row of the frame', () {
        expect(() => new Matrix4Attribute(frame, offset: 2), throwsArgumentError);
      });
    });
    
    group('instance', () {
      final attribute = new Matrix4Attribute(frame, offset: 1);

      group('extractValueAtRow', () {
        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.extractValueAtRow(-1), throwsRangeError);
          expect(() => attribute.extractValueAtRow(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(attribute.extractValueAtRow(1), equals(new Matrix4(
              1.01, 1.02, 1.03, 1.04,
              1.05, 1.06, 1.07, 1.08,
              1.09, 1.10, 1.11, 1.12,
              1.13, 1.14, 1.15, 1.16
          )));
        });
      });

      group('setValueAtRow', () {
        final value = new Matrix4(
            8.01, 8.02, 8.03, 8.04,
            8.05, 8.06, 8.07, 8.08,
            8.09, 8.10, 8.11, 8.12,
            8.13, 8.14, 8.15, 8.16
        );

        test('throws a RangeError when the given index is out of bounds', () {
          expect(() => attribute.setValueAtRow(-1, value), throwsRangeError);
          expect(() => attribute.setValueAtRow(3, value), throwsRangeError);
        });

        test('with a valid index correctly updates the attribute data frame', () {
          attribute.setValueAtRow(1, value);

          expect(frame[1], orderedCloseTo([1.00,
            8.01, 8.02, 8.03, 8.04,
            8.05, 8.06, 8.07, 8.08,
            8.09, 8.10, 8.11, 8.12,
            8.13, 8.14, 8.15, 8.16
          ], 0.00001));
        });
      });

      group('extractFrom', () {
        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(17, [
            0.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16,
            1.00, 1.01, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08, 1.09, 1.10, 1.11, 1.12, 1.13, 1.14, 1.15, 1.16,
            2.00, 2.01, 2.02, 2.03, 2.04, 2.05, 2.06, 2.07, 2.08, 2.09, 2.10, 2.11, 2.12, 2.13, 2.14, 2.15, 2.16
          ]);

          expect(() => attribute.extractFrom(frame2[1]), throwsArgumentError);
        });

        test('with a valid row returns the correct value', () {
          expect(attribute.extractFrom(frame[2]), equals(new Matrix4(
              2.01, 2.02, 2.03, 2.04,
              2.05, 2.06, 2.07, 2.08,
              2.09, 2.10, 2.11, 2.12,
              2.13, 2.14, 2.15, 2.16
          )));
        });
      });

      group('setOn', () {
        final value = new Matrix4(
            9.01, 9.02, 9.03, 9.04,
            9.05, 9.06, 9.07, 9.08,
            9.09, 9.10, 9.11, 9.12,
            9.13, 9.14, 9.15, 9.16
        );

        test('throws an ArgumentError when the given row is part of a different frame', () {
          final frame2 = new AttributeDataFrame(17, [
            0.00, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16,
            1.00, 1.01, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08, 1.09, 1.10, 1.11, 1.12, 1.13, 1.14, 1.15, 1.16,
            2.00, 2.01, 2.02, 2.03, 2.04, 2.05, 2.06, 2.07, 2.08, 2.09, 2.10, 2.11, 2.12, 2.13, 2.14, 2.15, 2.16
          ]);

          expect(() => attribute.setOn(frame2[1], value), throwsArgumentError);
        });

        test('with a valid row correctly updates the attribute data frame', () {
          attribute.setOn(frame[2], value);

          expect(frame[2], orderedCloseTo([2.00,
            9.01, 9.02, 9.03, 9.04,
            9.05, 9.06, 9.07, 9.08,
            9.09, 9.10, 9.11, 9.12,
            9.13, 9.14, 9.15, 9.16
          ], 0.00001));
        });
      });

      group('onFrame', () {
        final newFrame = new AttributeDataFrame(17, [
          0.16, 0.15, 0.14, 0.13, 0.12, 0.11, 0.10, 0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01, 0.00,
          1.16, 1.15, 1.14, 1.13, 1.12, 1.11, 1.10, 1.09, 1.08, 1.07, 1.06, 1.05, 1.04, 1.03, 1.02, 1.01, 1.00,
          2.16, 2.15, 2.14, 2.13, 2.12, 2.11, 2.10, 2.09, 2.08, 2.07, 2.06, 2.05, 2.04, 2.03, 2.02, 2.01, 2.00
        ]);

        test('returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame);

          expect(newAttribute.extractValueAtRow(1), equals(new Matrix4(
              1.15, 1.14, 1.13, 1.12,
              1.11, 1.10, 1.09, 1.08,
              1.07, 1.06, 1.05, 1.04,
              1.03, 1.02, 1.01, 1.00
          )));
        });

        test('with an offset returns a new attribute on the target frame that extracts the correct values', () {
          final newAttribute = attribute.onFrame(newFrame, offset: 0);

          expect(newAttribute.extractValueAtRow(1), equals(new Matrix4(
              1.16, 1.15, 1.14, 1.13,
              1.12, 1.11, 1.10, 1.09,
              1.08, 1.07, 1.06, 1.05,
              1.04, 1.03, 1.02, 1.01
          )));
        });
      });
    });
  });
}