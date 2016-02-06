import 'package:test/test.dart';
import 'package:bagl/vertex_data.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('AttributeDataFrame', () {
    group('default constructor', () {
      final frame = new AttributeDataFrame(3, [
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ]);

      test('instantiates a new frame with the correct length', () {
        expect(frame.length, equals(3));
      });

      test('instantiates a new frame with the correct values', () {
        expect(frame[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(frame[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(frame[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
      });
    });

    group('fromFloat32List constructor', () {
      final values = new Float32List.fromList([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ]);
      final frame = new AttributeDataFrame.fromFloat32List(3, values);

      test('instantiates a new frame with the correct length', () {
        expect(frame.length, equals(3));
      });

      test('instantiates a new frame with the correct values', () {
        expect(frame[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(frame[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(frame[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
      });
    });

    group('view constructor', () {
      final values = new Float32List.fromList([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0,
        4.0, 4.0, 4.0
      ]);

      final frame = new AttributeDataFrame.view(3, values.buffer, 12, 3);

      test('instantiates a new frame with the correct length', () {
        expect(frame.length, equals(3));
      });

      test('instantiates a new frame with the correct values', () {
        expect(frame[0], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(frame[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
        expect(frame[2], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
      });
    });

    group('instance', () {
      group('elementAt', () {
        final frame = new AttributeDataFrame(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]);

        test('throws a RangeError when the index is out of bounds', () {
          expect(() => frame.elementAt(-1), throwsRangeError);
          expect(() => frame.elementAt(3), throwsRangeError);
        });
      });

      group('withoutRow', () {
        final frame = new AttributeDataFrame(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0
        ]);

        test('throws a RangeError when the index is out of bounds', () {
          expect(() => frame.withoutRow(-1), throwsRangeError);
          expect(() => frame.withoutRow(4), throwsRangeError);
        });

        group('with a valid index', () {
          final withoutRow2 = frame.withoutRow(2);

          test('returns a new frame with one less row', () {
            expect(withoutRow2.length, equals(3));
          });

          test('returns a new frame with the correct row removed', () {
            expect(withoutRow2[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
            expect(withoutRow2[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
            expect(withoutRow2[2], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
          });
        });
      });

      group('withoutRows', () {
        final frame = new AttributeDataFrame(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0,
          4.0, 4.0, 4.0,
          5.0, 5.0, 5.0,
          6.0, 6.0, 6.0,
          7.0, 7.0, 7.0
        ]);

        test('throws a RangeError when the index list contains an out of bounds index', () {
          expect(() => frame.withoutRows([1, 2, 8]), throwsRangeError);
          expect(() => frame.withoutRows([1, 2, -1]), throwsRangeError);
        });

        group('with a list of valid indices', () {
          final withoutRows = frame.withoutRows([1, 3, 4, 6]);

          test('returns a new frame with the correct length', () {
            expect(withoutRows.length, equals(4));
          });

          test('returns a new frame with the correct values', () {
            expect(withoutRows[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
            expect(withoutRows[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
            expect(withoutRows[2], orderedCloseTo([5.0, 5.0, 5.0], 0.00001));
            expect(withoutRows[3], orderedCloseTo([7.0, 7.0, 7.0], 0.00001));
          });
        });

        group('with a list of valid indices including a duplicate index', () {
          final withoutRows = frame.withoutRows([0, 3, 4, 4, 7]);

          test('returns a new frame with the correct length', () {
            expect(withoutRows.length, equals(4));
          });

          test('returns a new frame with the correct values', () {
            expect(withoutRows[0], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
            expect(withoutRows[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
            expect(withoutRows[2], orderedCloseTo([5.0, 5.0, 5.0], 0.00001));
            expect(withoutRows[3], orderedCloseTo([6.0, 6.0, 6.0], 0.00001));
          });
        });
      });

      group('withAppendedData', () {
        final frame = new AttributeDataFrame(3,[
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0
        ]).withAppendedData([
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0
        ]);

        test('returns a new frame with the correct length', () {
          expect(frame.length, equals(4));
        });

        test('retruns a new frame with the correct values', () {
          expect(frame[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
          expect(frame[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
          expect(frame[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
          expect(frame[3], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
        });
      });

      group('interleavedWith', () {
        final frame = new AttributeDataFrame(3, [
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0
        ]);

        test('with a frame of a different length throws an ArgumentError', () {
          final otherFrame = new AttributeDataFrame(3, [
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0,
            4.0, 4.0, 4.0
          ]);

          expect(() => frame.interleavedWith(otherFrame), throwsArgumentError);
        });

        group('with a valid frame', () {
          final otherFrame = new AttributeDataFrame(3, [
            -1.0, -1.0, -1.0,
            -2.0, -2.0, -2.0,
            -3.0, -3.0, -3.0
          ]);
          final interleaved = frame.interleavedWith(otherFrame);

          test('results in a new frame with the correct length', () {
            expect(interleaved.length, equals(3));
          });

          test('results in a new frame with the correct values', () {
            expect(interleaved[0], orderedCloseTo([1.0, 1.0, 1.0, -1.0, -1.0, -1.0], 0.00001));
            expect(interleaved[1], orderedCloseTo([2.0, 2.0, 2.0, -2.0, -2.0, -2.0], 0.00001));
            expect(interleaved[2], orderedCloseTo([3.0, 3.0, 3.0, -3.0, -3.0, -3.0], 0.00001));
          });
        });
      });

      group('subFrame', () {
        final frame = new AttributeDataFrame(4, [
          0.0, 0.1, 0.2, 0.3,
          1.0, 1.1, 1.2, 1.3,
          2.0, 2.1, 2.2, 2.3,
          3.0, 3.1, 3.2, 3.3
        ]);

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
          final subFrame = frame.subFrame(1);

          test('returns a new frame with the correct length (up till the end of the old frame)', () {
            expect(subFrame.length, equals(3));
          });

          test('returns a new frame with the correct values (up till the end of the old frame)', () {
            expect(subFrame[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subFrame[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
            expect(subFrame[2], orderedCloseTo([3.0, 3.1, 3.2, 3.3], 0.00001));
          });
        });

        group('with a valid row range', () {
          final subFrame = frame.subFrame(1, 3);

          test('returns a new frame with the correct length', () {
            expect(subFrame.length, equals(2));
          });

          test('returns a new frame with the correct values', () {
            expect(subFrame[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subFrame[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
          });
        });

        group('with a valid row range and a valid colStart', () {
          final subFrame = frame.subFrame(1, 3, 1);

          test('returns a new frame with the correct rowLength (up till the last column of the old frame)', () {
            expect(subFrame.rowLength, equals(3));
          });

          test('returns a new frame with the correct values (up till the last column of the old frame)', () {
            expect(subFrame[0], orderedCloseTo([1.1, 1.2, 1.3], 0.00001));
            expect(subFrame[1], orderedCloseTo([2.1, 2.2, 2.3], 0.00001));
          });
        });

        group('with a valid row range and a valid col range', () {
          final subFrame = frame.subFrame(1, 3, 1, 3);

          test('returns a new frame with the correct rowLength', () {
            expect(subFrame.rowLength, equals(2));
          });

          test('returns a new frame with the correct values', () {
            expect(subFrame[0], orderedCloseTo([1.1, 1.2], 0.00001));
            expect(subFrame[1], orderedCloseTo([2.1, 2.2], 0.00001));
          });
        });
      });

      group('subFrameView', () {
        final frame = new AttributeDataFrame(4, [
          0.0, 0.1, 0.2, 0.3,
          1.0, 1.1, 1.2, 1.3,
          2.0, 2.1, 2.2, 2.3,
          3.0, 3.1, 3.2, 3.3
        ]);

        test('throws a RangeError if rowStart is out of bounds', () {
          expect(() => frame.subFrameView(-1), throwsRangeError);
          expect(() => frame.subFrameView(5), throwsRangeError);
        });

        test('throws a RangeError if rowEnd is out of bounds', () {
          expect(() => frame.subFrameView(0, -1), throwsRangeError);
          expect(() => frame.subFrameView(0, 5), throwsRangeError);
        });

        group('with a valid rowStart', () {
          final subFrameView = frame.subFrameView(1);

          test('returns a new frame with the correct length (up till the end of the viewed frame)', () {
            expect(subFrameView.length, equals(3));
          });

          test('returns a new frame with the correct values (up till the end of the viewed frame)', () {
            expect(subFrameView[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subFrameView[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
            expect(subFrameView[2], orderedCloseTo([3.0, 3.1, 3.2, 3.3], 0.00001));
          });
        });

        group('with a valid row range', () {
          final subFrameView = frame.subFrameView(1, 3);

          test('returns a new frame with the correct length', () {
            expect(subFrameView.length, equals(2));
          });

          test('returns a new frame with the correct values', () {
            expect(subFrameView[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subFrameView[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
          });
        });

        group('on another attribute data frame view (with an offset on the underlying byte buffer)', () {
          final subFrameView = frame.subFrameView(1);
          final viewOnView = subFrameView.subFrameView(1);

          test('returns a new frame with the correct length', () {
            expect(viewOnView.length, equals(2));
          });

          test('returns a new frame with the correct values', () {
            expect(viewOnView[0], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
            expect(viewOnView[1], orderedCloseTo([3.0, 3.1, 3.2, 3.3], 0.00001));
          });
        });
      });
    });
  });

  group('AttributeDataFrameIterator', () {
    final frame = new AttributeDataFrame(3, [
      0.0, 0.0, 0.0,
      1.0, 1.0, 1.0,
      2.0, 2.0, 2.0
    ]);

    group('instance', () {
      final iterator = new AttributeDataFrameIterator(frame);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterator over in a while loop', () {
        var loopCount = 0;
        var rows = [];

        while (iterator.moveNext()) {
          loopCount++;
          rows.add(iterator.current);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(3));
        });

        test('returns the correct current value on each iteration', () {
          expect(rows[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
          expect(rows[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
          expect(rows[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
        });

        test('returns null as the current value after iterating', () {
          expect(iterator.current, isNull);
        });

        test('returns false on moveNext after iterating', () {
          expect(iterator.moveNext(), isFalse);
        });
      });
    });
  });

  group('AttributeDataFrameRowView', () {
    final frame = new AttributeDataFrame(3, [
      0.0, 0.1, 0.2,
      1.0, 1.1, 1.2,
      2.0, 2.1, 2.2
    ]);

    group('default constructor', () {
      test('throws a RangeError when the row index is out of bounds', () {
        expect(() => new AttributeDataRowView(frame, -1), throwsRangeError);
        expect(() => new AttributeDataRowView(frame, 3), throwsRangeError);
      });
    });

    group('instance', () {
      final rowView = new AttributeDataRowView(frame, 1);

      group('elementAt', () {
        test('throws a RangeError when the index is out of bounds', () {
          expect(() => rowView.elementAt(-1), throwsRangeError);
          expect(() => rowView.elementAt(3), throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(rowView.elementAt(1), closeTo(1.1, 0.0001));
        });
      });

      group('[] operator', () {
        test('throws a RangeError when the index is out of bounds', () {
          expect(() => rowView[-1], throwsRangeError);
          expect(() => rowView[3], throwsRangeError);
        });

        test('returns the correct value with a valid index', () {
          expect(rowView[1], closeTo(1.1, 0.0001));
        });
      });

      group('[]= operator', () {
        test('throws a RangeError when the index is out of bounds', () {
          expect(() => rowView[-1] = 0.0, throwsRangeError);
          expect(() => rowView[3] = 0.0, throwsRangeError);
        });

        test('updates the correct value on the frame', () {
          rowView[1] = 8.0;

          expect(frame[1][1], closeTo(8.0, 0.00001));
        });
      });
    });
  });

  group('AttributeDataRowViewIterator', () {
    final frame = new AttributeDataFrame(3, [
      0.0, 0.1, 0.2,
      1.0, 1.1, 1.2,
      2.0, 2.1, 2.2
    ]);
    final rowView = new AttributeDataRowView(frame, 1);

    group('instance', () {
      final iterator = new AttributeDataRowViewIterator(rowView);

      test('current is null initially', () {
        expect(iterator.current, isNull);
      });

      group('when iterated over in a while loop', () {
        var loopCount = 0;
        var rows = [];

        while (iterator.moveNext()) {
          loopCount++;
          rows.add(iterator.current);
        }

        test('loops the correct number of times', () {
          expect(loopCount, equals(3));
        });

        test('returns the correct current value on each iteration', () {
          expect(rows[0], closeTo(1.0, 0.00001));
          expect(rows[1], closeTo(1.1, 0.00001));
          expect(rows[2], closeTo(1.2, 0.00001));
        });

        test('returns null as the current value after iterating', () {
          expect(iterator.current, isNull);
        });

        test('returns false on moveNext after iterating', () {
          expect(iterator.moveNext(), isFalse);
        });
      });
    });
  });
}
