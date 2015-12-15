import 'package:test/test.dart';
import 'package:bagl/vertex_data.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('AttributeDataFrame', () {
    group('default constructor', () {
      var frame = new AttributeDataFrame([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ], 3);

      test('instantiates a new frame with the correct length', () {
        expect(frame.length, equals(3));
      });

      test('instantiates a new frame with the correct values', () {
        expect(frame[0], equals([0.0, 0.0, 0.0]));
        expect(frame[1], equals([1.0, 1.0, 1.0]));
        expect(frame[2], equals([2.0, 2.0, 2.0]));
      });
    });

    group('fromFloat32List constructor', () {
      var values = new Float32List.fromList([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ]);
      var frame = new AttributeDataFrame.fromFloat32List(values, 3);

      test('instantiates a new frame with the correct length', () {
        expect(frame.length, equals(3));
      });

      test('instantiates a new frame with the correct values', () {
        expect(frame[0], equals([0.0, 0.0, 0.0]));
        expect(frame[1], equals([1.0, 1.0, 1.0]));
        expect(frame[2], equals([2.0, 2.0, 2.0]));
      });
    });

    group('view constructor', () {
      var values = new Float32List.fromList([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0,
        4.0, 4.0, 4.0
      ]);

      var frame = new AttributeDataFrame.view(values.buffer, 3, 12, 3);

      test('instantiates a new frame with the correct length', () {
        expect(frame.length, equals(3));
      });

      test('instantiates a new frame with the correct values', () {
        expect(frame[0], equals([1.0, 1.0, 1.0]));
        expect(frame[1], equals([2.0, 2.0, 2.0]));
        expect(frame[2], equals([3.0, 3.0, 3.0]));
      });
    });

    group('elementAt', () {
      var frame = new AttributeDataFrame([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ], 3);

      test('throws a RangeError when the index is out of bounds', () {
        expect(() => frame.elementAt(-1), throwsRangeError);
        expect(() => frame.elementAt(3), throwsRangeError);
      });
    });

    group('withoutRow', () {
      var frame = new AttributeDataFrame([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0
      ], 3);

      test('throws a RangeError when the index is out of bounds', () {
        expect(() => frame.withoutRow(-1), throwsRangeError);
        expect(() => frame.withoutRow(4), throwsRangeError);
      });

      group('with a valid index', () {
        var withoutRow2 = frame.withoutRow(2);

        test('returns a new frame with one less row', () {
          expect(withoutRow2.length, equals(3));
        });

        test('returns a new frame with the correct row removed', () {
          expect(withoutRow2[0], equals([0.0, 0.0, 0.0]));
          expect(withoutRow2[1], equals([1.0, 1.0, 1.0]));
          expect(withoutRow2[2], equals([3.0, 3.0, 3.0]));
        });
      });
    });

    group('withoutRows', () {
      var frame = new AttributeDataFrame([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0,
        4.0, 4.0, 4.0,
        5.0, 5.0, 5.0,
        6.0, 6.0, 6.0,
        7.0, 7.0, 7.0
      ], 3);

      test('throws a RangeError when the index list contains an out of bounds index', () {
        expect(() => frame.withoutRows([1, 2, 8]), throwsRangeError);
      });

      group('with a list of valid indices', () {
        var withoutRows = frame.withoutRows([1, 3, 4, 6]);

        test('returns a new frame with the correct length', () {
          expect(withoutRows.length, equals(4));
        });

        test('returns a new frame with the correct values', () {
          expect(withoutRows[0], equals([0.0, 0.0, 0.0]));
          expect(withoutRows[1], equals([2.0, 2.0, 2.0]));
          expect(withoutRows[2], equals([5.0, 5.0, 5.0]));
          expect(withoutRows[3], equals([7.0, 7.0, 7.0]));
        });
      });
    });

    group('withAppendedData', () {
      var frame = new AttributeDataFrame([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0
      ], 3).withAppendedData([
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0
      ]);

      test('returns a new frame with the correct length', () {
        expect(frame.length, equals(4));
      });

      test('retruns a new frame with the correct values', () {
        expect(frame[0], equals([0.0, 0.0, 0.0]));
        expect(frame[1], equals([1.0, 1.0, 1.0]));
        expect(frame[2], equals([2.0, 2.0, 2.0]));
        expect(frame[3], equals([3.0, 3.0, 3.0]));
      });
    });

    group('interleavedWith', () {
      var frame = new AttributeDataFrame([
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0
      ], 3);

      test('with a frame of a different length throws an ArgumentError', () {
        var otherFrame = new AttributeDataFrame([
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0,
          4.0, 4.0, 4.0
        ], 3);

        expect(() => frame.interleavedWith(otherFrame), throwsArgumentError);
      });

      group('with a valid frame', () {
        var otherFrame = new AttributeDataFrame([
          -1.0, -1.0, -1.0,
          -2.0, -2.0, -2.0,
          -3.0, -3.0, -3.0
        ], 3);
        var interleaved = frame.interleavedWith(otherFrame);

        test('results in a new frame with the correct length', () {
          expect(interleaved.length, equals(3));
        });

        test('results in a new frame with the correct values', () {
          expect(interleaved[0], equals([1.0, 1.0, 1.0, -1.0, -1.0, -1.0]));
          expect(interleaved[1], equals([2.0, 2.0, 2.0, -2.0, -2.0, -2.0]));
          expect(interleaved[2], equals([3.0, 3.0, 3.0, -3.0, -3.0, -3.0]));
        });
      });
    });

    group('subFrame', () {
      var frame = new AttributeDataFrame([
        0.0, 0.1, 0.2, 0.3,
        1.0, 1.1, 1.2, 1.3,
        2.0, 2.1, 2.2, 2.3,
        3.0, 3.1, 3.2, 3.3
      ], 4);

      test('throws a RangeError if rowStart is out of bounds', () {
        expect(() => frame.subFrame(-1), throwsRangeError);
        expect(() => frame.subFrame(5), throwsRangeError);
      });

      test('throws a RangeError if rowEnd is out of bounds', () {
        expect(() => frame.subFrame(0, -1), throwsRangeError);
        expect(() => frame.subFrame(0, 5), throwsRangeError);
      });

      test('throws a RangeError if colStart is out of bounds', () {
        expect(() => frame.subFrame(0, 3, -1), throwsRangeError);
        expect(() => frame.subFrame(0, 3, 5), throwsRangeError);
      });

      test('throws a RangeError if colEnd is out of bounds', () {
        expect(() => frame.subFrame(0, 3, 0, -1), throwsRangeError);
        expect(() => frame.subFrame(0, 3, 0, 5), throwsRangeError);
      });

      test('throws an argumentError if rowEnd =< rowStart', () {
        expect(() => frame.subFrame(1, 1), throwsArgumentError);
        expect(() => frame.subFrame(1, 0), throwsArgumentError);
      });

      test('throws an argumentError if colEnd =< colStart', () {
        expect(() => frame.subFrame(0, 3, 1, 1), throwsArgumentError);
        expect(() => frame.subFrame(0, 3, 1, 0), throwsArgumentError);
      });

      group('with a valid rowStart', () {
        var subFrame = frame.subFrame(1);

        test('returns a new frame with the correct length (up till the end of the old frame)', () {
          expect(subFrame.length, equals(3));
        });

        test('returns a new frame with the correct values (up till the end of the old frame)', () {
          expect(subFrame[0], pairWiseDifferenceLessThan([1.0, 1.1, 1.2, 1.3], 0.00001));
          expect(subFrame[1], pairWiseDifferenceLessThan([2.0, 2.1, 2.2, 2.3], 0.00001));
          expect(subFrame[2], pairWiseDifferenceLessThan([3.0, 3.1, 3.2, 3.3], 0.00001));
        });
      });

      group('with a valid row range', () {
        var subFrame = frame.subFrame(1, 3);

        test('returns a new frame with the correct length', () {
          expect(subFrame.length, equals(2));
        });

        test('returns a new frame with the correct values', () {
          expect(subFrame[0], pairWiseDifferenceLessThan([1.0, 1.1, 1.2, 1.3], 0.00001));
          expect(subFrame[1], pairWiseDifferenceLessThan([2.0, 2.1, 2.2, 2.3], 0.00001));
        });
      });

      group('with a valid row range and a valid colStart', () {
        var subFrame = frame.subFrame(1, 3, 1);

        test('returns a new frame with the correct rowLength (up till the last column of the old frame)', () {
          expect(subFrame.rowLength, equals(3));
        });

        test('returns a new frame with the correct values (up till the last column of the old frame)', () {
          expect(subFrame[0], pairWiseDifferenceLessThan([1.1, 1.2, 1.3], 0.00001));
          expect(subFrame[1], pairWiseDifferenceLessThan([2.1, 2.2, 2.3], 0.00001));
        });
      });

      group('with a valid row range and a valid col range', () {
        var subFrame = frame.subFrame(1, 3, 1, 3);

        test('returns a new frame with the correct rowLength', () {
          expect(subFrame.rowLength, equals(2));
        });

        test('returns a new frame with the correct values', () {
          expect(subFrame[0], pairWiseDifferenceLessThan([1.1, 1.2], 0.00001));
          expect(subFrame[1], pairWiseDifferenceLessThan([2.1, 2.2], 0.00001));
        });
      });
    });
  });
}
