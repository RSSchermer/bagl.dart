import 'package:test/test.dart';
import 'package:bagl/vertex_data.dart';
import 'dart:typed_data';
import '../helpers.dart';

void main() {
  group('AttributeDataTable', () {
    group('default constructor', () {
      final table = new AttributeDataTable(3, 3);

      test('instantiates a new table with the correct length', () {
        expect(table.length, equals(3));
      });

      test('instantiates a new table with the correct values', () {
        expect(table[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(table[1], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(table[2], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
      });

      test('instantiates a new table that is not marked as dynamic', () {
        expect(table.isDynamic, isFalse);
      });
    });

    group('dynamic constructor', () {
      final table = new AttributeDataTable.dynamic(3, 3);

      test('instantiates a new table with the correct length', () {
        expect(table.length, equals(3));
      });

      test('instantiates a new table with the correct values', () {
        expect(table[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(table[1], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(table[2], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
      });

      test('instantiates a new table that is marked as dynamic', () {
        expect(table.isDynamic, isTrue);
      });
    });

    group('fromList constructor', () {
      final table = new AttributeDataTable.fromList(3, [
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ]);

      test('instantiates a new table with the correct length', () {
        expect(table.length, equals(3));
      });

      test('instantiates a new table with the correct values', () {
        expect(table[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(table[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(table[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
      });

      test('instantiates a new table that is not marked as dynamic', () {
        expect(table.isDynamic, isFalse);
      });
    });

    group('dynamicFromList constructor', () {
      final table = new AttributeDataTable.dynamicFromList(3, [
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0
      ]);

      test('instantiates a new table with the correct length', () {
        expect(table.length, equals(3));
      });

      test('instantiates a new table with the correct values', () {
        expect(table[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
        expect(table[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(table[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
      });

      test('instantiates a new table that is marked as dynamic', () {
        expect(table.isDynamic, isTrue);
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

      final table = new AttributeDataTable.view(3, values.buffer, 12, 3);

      test('instantiates a new table with the correct length', () {
        expect(table.length, equals(3));
      });

      test('instantiates a new table with the correct values', () {
        expect(table[0], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(table[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
        expect(table[2], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
      });

      test('instantiates a new table that is not marked as dynamic', () {
        expect(table.isDynamic, isFalse);
      });
    });

    group('dynamicView constructor', () {
      final values = new Float32List.fromList([
        0.0, 0.0, 0.0,
        1.0, 1.0, 1.0,
        2.0, 2.0, 2.0,
        3.0, 3.0, 3.0,
        4.0, 4.0, 4.0
      ]);

      final table = new AttributeDataTable.dynamicView(3, values.buffer, 12, 3);

      test('instantiates a new table with the correct length', () {
        expect(table.length, equals(3));
      });

      test('instantiates a new table with the correct values', () {
        expect(table[0], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
        expect(table[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
        expect(table[2], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
      });

      test('instantiates a new table that is marked as dynamic', () {
        expect(table.isDynamic, isTrue);
      });
    });

    group('instance', () {
      group('iterator', () {
        final table = new AttributeDataTable.fromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]);

        group('instance', () {
          final iterator = table.iterator;

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

      group('elementAt', () {
        final table = new AttributeDataTable.fromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]);

        test('throws a RangeError when the index is out of bounds', () {
          expect(() => table.elementAt(-1), throwsRangeError);
          expect(() => table.elementAt(3), throwsRangeError);
        });
      });

      group('withoutRow', () {
        final table = new AttributeDataTable.fromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0
        ]);

        test('throws a RangeError when the index is out of bounds', () {
          expect(() => table.withoutRow(-1), throwsRangeError);
          expect(() => table.withoutRow(4), throwsRangeError);
        });

        group('with a valid index', () {
          final withoutRow2 = table.withoutRow(2);

          test('returns a new table with one less row', () {
            expect(withoutRow2.length, equals(3));
          });

          test('returns a new table with the correct row removed', () {
            expect(withoutRow2[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
            expect(withoutRow2[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
            expect(withoutRow2[2], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
          });

          test('returns a table not marked as dynamic', () {
            expect(withoutRow2.isDynamic, isFalse);
          });
        });

        group('on a table not marked as dynamic', () {
          final table = new AttributeDataTable.fromList(3, [
            0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0
          ]).withoutRow(2);

          test('returns a table not marked as dynamic', () {
            expect(table.isDynamic, isFalse);
          });
        });

        group('on a table marked as dynamic', () {
          final table = new AttributeDataTable.dynamicFromList(3, [
            0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0
          ]).withoutRow(2);

          test('returns a table marked as dynamic', () {
            expect(table.isDynamic, isTrue);
          });
        });
      });

      group('withoutRows', () {
        final table = new AttributeDataTable.fromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0,
          4.0, 4.0, 4.0,
          5.0, 5.0, 5.0,
          6.0, 6.0, 6.0,
          7.0, 7.0, 7.0
        ]);

        test(
            'throws a RangeError when the index list contains an out of bounds index', () {
          expect(() => table.withoutRows([1, 2, 8]), throwsRangeError);
          expect(() => table.withoutRows([1, 2, -1]), throwsRangeError);
        });

        group('with a list of valid indices', () {
          final withoutRows = table.withoutRows([1, 3, 4, 6]);

          test('returns a new table with the correct length', () {
            expect(withoutRows.length, equals(4));
          });

          test('returns a new table with the correct values', () {
            expect(withoutRows[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
            expect(withoutRows[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
            expect(withoutRows[2], orderedCloseTo([5.0, 5.0, 5.0], 0.00001));
            expect(withoutRows[3], orderedCloseTo([7.0, 7.0, 7.0], 0.00001));
          });

          test('returns a new table not marked as dynamic', () {
            expect(withoutRows.isDynamic, isFalse);
          });
        });

        group('with a list of valid indices including a duplicate index', () {
          final withoutRows = table.withoutRows([0, 3, 4, 4, 7]);

          test('returns a new table with the correct length', () {
            expect(withoutRows.length, equals(4));
          });

          test('returns a new table with the correct values', () {
            expect(withoutRows[0], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
            expect(withoutRows[1], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
            expect(withoutRows[2], orderedCloseTo([5.0, 5.0, 5.0], 0.00001));
            expect(withoutRows[3], orderedCloseTo([6.0, 6.0, 6.0], 0.00001));
          });
        });

        group('on a table not marked as dynamic', () {
          final table = new AttributeDataTable.fromList(3, [
            0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0,
            4.0, 4.0, 4.0,
            5.0, 5.0, 5.0,
            6.0, 6.0, 6.0,
            7.0, 7.0, 7.0
          ]).withoutRows([1, 3, 4, 6]);

          test('returns a table not marked as dynamic', () {
            expect(table.isDynamic, isFalse);
          });
        });

        group('on a table marked as dynamic', () {
          final table = new AttributeDataTable.dynamicFromList(3, [
            0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0,
            4.0, 4.0, 4.0,
            5.0, 5.0, 5.0,
            6.0, 6.0, 6.0,
            7.0, 7.0, 7.0
          ]).withoutRows([1, 3, 4, 6]);

          test('returns a table marked as dynamic', () {
            expect(table.isDynamic, isTrue);
          });
        });
      });

      group('withAppendedData', () {
        final table = new AttributeDataTable.fromList(3,[
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0
        ]).withAppendedData([
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0
        ]);

        test('returns a new table with the correct length', () {
          expect(table.length, equals(4));
        });

        test('retruns a new table with the correct values', () {
          expect(table[0], orderedCloseTo([0.0, 0.0, 0.0], 0.00001));
          expect(table[1], orderedCloseTo([1.0, 1.0, 1.0], 0.00001));
          expect(table[2], orderedCloseTo([2.0, 2.0, 2.0], 0.00001));
          expect(table[3], orderedCloseTo([3.0, 3.0, 3.0], 0.00001));
        });

        group('on a table not marked as dynamic', () {
          final table = new AttributeDataTable.fromList(3,[
            0.0, 0.0, 0.0,
            1.0, 1.0, 1.0
          ]).withAppendedData([
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0
          ]);

          test('returns a table not marked as dynamic', () {
            expect(table.isDynamic, isFalse);
          });
        });

        group('on a table marked as dynamic', () {
          final table = new AttributeDataTable.dynamicFromList(3,[
            0.0, 0.0, 0.0,
            1.0, 1.0, 1.0
          ]).withAppendedData([
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0
          ]);

          test('returns a table marked as dynamic', () {
            expect(table.isDynamic, isTrue);
          });
        });
      });

      group('interleavedWith', () {
        final table = new AttributeDataTable.fromList(3, [
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0,
          3.0, 3.0, 3.0
        ]);

        test('with a table of a different length throws an ArgumentError', () {
          final otherTable = new AttributeDataTable.fromList(3, [
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0,
            4.0, 4.0, 4.0
          ]);

          expect(() => table.interleavedWith(otherTable), throwsArgumentError);
        });

        group('with a valid table', () {
          final otherTable = new AttributeDataTable.fromList(3, [
            -1.0, -1.0, -1.0,
            -2.0, -2.0, -2.0,
            -3.0, -3.0, -3.0
          ]);
          final interleaved = table.interleavedWith(otherTable);

          test('results in a new table with the correct length', () {
            expect(interleaved.length, equals(3));
          });

          test('results in a new table with the correct values', () {
            expect(interleaved[0], orderedCloseTo([1.0, 1.0, 1.0, -1.0, -1.0, -1.0], 0.00001));
            expect(interleaved[1], orderedCloseTo([2.0, 2.0, 2.0, -2.0, -2.0, -2.0], 0.00001));
            expect(interleaved[2], orderedCloseTo([3.0, 3.0, 3.0, -3.0, -3.0, -3.0], 0.00001));
          });
        });

        group('on a table not marked as dynamic', () {
          final table = new AttributeDataTable.fromList(3, [
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0
          ]).interleavedWith(new AttributeDataTable.fromList(3, [
            -1.0, -1.0, -1.0,
            -2.0, -2.0, -2.0,
            -3.0, -3.0, -3.0
          ]));

          test('returns a table not marked as dynamic', () {
            expect(table.isDynamic, isFalse);
          });
        });

        group('on a table marked as dynamic', () {
          final table = new AttributeDataTable.dynamicFromList(3, [
            1.0, 1.0, 1.0,
            2.0, 2.0, 2.0,
            3.0, 3.0, 3.0
          ]).interleavedWith(new AttributeDataTable.fromList(3, [
            -1.0, -1.0, -1.0,
            -2.0, -2.0, -2.0,
            -3.0, -3.0, -3.0
          ]));

          test('returns a table marked as dynamic', () {
            expect(table.isDynamic, isTrue);
          });
        });
      });

      group('subTable', () {
        final table = new AttributeDataTable.fromList(4, [
          0.0, 0.1, 0.2, 0.3,
          1.0, 1.1, 1.2, 1.3,
          2.0, 2.1, 2.2, 2.3,
          3.0, 3.1, 3.2, 3.3
        ]);

        test('throws a RangeError if rowStart is out of bounds', () {
          expect(() => table.subTable(-1), throwsRangeError);
          expect(() => table.subTable(5), throwsRangeError);
        });

        test('throws a RangeError if rowEnd is out of bounds', () {
          expect(() => table.subTable(0, -1), throwsRangeError);
          expect(() => table.subTable(0, 5), throwsRangeError);
        });

        test('throws a RangeError if colStart is out of bounds', () {
          expect(() => table.subTable(0, 3, -1), throwsRangeError);
          expect(() => table.subTable(0, 3, 5), throwsRangeError);
        });

        test('throws a RangeError if colEnd is out of bounds', () {
          expect(() => table.subTable(0, 3, 0, -1), throwsRangeError);
          expect(() => table.subTable(0, 3, 0, 5), throwsRangeError);
        });

        test('throws an argumentError if rowEnd =< rowStart', () {
          expect(() => table.subTable(1, 1), throwsArgumentError);
          expect(() => table.subTable(1, 0), throwsArgumentError);
        });

        test('throws an argumentError if colEnd =< colStart', () {
          expect(() => table.subTable(0, 3, 1, 1), throwsArgumentError);
          expect(() => table.subTable(0, 3, 1, 0), throwsArgumentError);
        });

        group('with a valid rowStart', () {
          final subTable = table.subTable(1);

          test('returns a new table with the correct length (up till the end of the old table)', () {
            expect(subTable.length, equals(3));
          });

          test('returns a new table with the correct values (up till the end of the old table)', () {
            expect(subTable[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subTable[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
            expect(subTable[2], orderedCloseTo([3.0, 3.1, 3.2, 3.3], 0.00001));
          });
        });

        group('with a valid row range', () {
          final subTable = table.subTable(1, 3);

          test('returns a new table with the correct length', () {
            expect(subTable.length, equals(2));
          });

          test('returns a new table with the correct values', () {
            expect(subTable[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subTable[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
          });
        });

        group('with a valid row range and a valid colStart', () {
          final subTable = table.subTable(1, 3, 1);

          test('returns a new table with the correct rowLength (up till the last column of the old table)', () {
            expect(subTable.rowLength, equals(3));
          });

          test('returns a new table with the correct values (up till the last column of the old table)', () {
            expect(subTable[0], orderedCloseTo([1.1, 1.2, 1.3], 0.00001));
            expect(subTable[1], orderedCloseTo([2.1, 2.2, 2.3], 0.00001));
          });
        });

        group('with a valid row range and a valid col range', () {
          final subTable = table.subTable(1, 3, 1, 3);

          test('returns a new table with the correct rowLength', () {
            expect(subTable.rowLength, equals(2));
          });

          test('returns a new table with the correct values', () {
            expect(subTable[0], orderedCloseTo([1.1, 1.2], 0.00001));
            expect(subTable[1], orderedCloseTo([2.1, 2.2], 0.00001));
          });
        });

        group('on a table not marked as dynamic', () {
          final table = new AttributeDataTable.fromList(4, [
            0.0, 0.1, 0.2, 0.3,
            1.0, 1.1, 1.2, 1.3,
            2.0, 2.1, 2.2, 2.3,
            3.0, 3.1, 3.2, 3.3
          ]).subTable(1);

          test('returns a table not marked as dynamic', () {
            expect(table.isDynamic, isFalse);
          });
        });

        group('on a table marked as dynamic', () {
          final table = new AttributeDataTable.dynamicFromList(4, [
            0.0, 0.1, 0.2, 0.3,
            1.0, 1.1, 1.2, 1.3,
            2.0, 2.1, 2.2, 2.3,
            3.0, 3.1, 3.2, 3.3
          ]).subTable(1);

          test('returns a table marked as dynamic', () {
            expect(table.isDynamic, isTrue);
          });
        });
      });

      group('subTableView', () {
        final table = new AttributeDataTable.fromList(4, [
          0.0, 0.1, 0.2, 0.3,
          1.0, 1.1, 1.2, 1.3,
          2.0, 2.1, 2.2, 2.3,
          3.0, 3.1, 3.2, 3.3
        ]);

        test('throws a RangeError if rowStart is out of bounds', () {
          expect(() => table.subTableView(-1), throwsRangeError);
          expect(() => table.subTableView(5), throwsRangeError);
        });

        test('throws a RangeError if rowEnd is out of bounds', () {
          expect(() => table.subTableView(0, -1), throwsRangeError);
          expect(() => table.subTableView(0, 5), throwsRangeError);
        });

        group('with a valid rowStart', () {
          final subTableView = table.subTableView(1);

          test('returns a new table with the correct length (up till the end of the viewed table)', () {
            expect(subTableView.length, equals(3));
          });

          test('returns a new table with the correct values (up till the end of the viewed table)', () {
            expect(subTableView[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subTableView[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
            expect(subTableView[2], orderedCloseTo([3.0, 3.1, 3.2, 3.3], 0.00001));
          });
        });

        group('with a valid row range', () {
          final subTableView = table.subTableView(1, 3);

          test('returns a new table with the correct length', () {
            expect(subTableView.length, equals(2));
          });

          test('returns a new table with the correct values', () {
            expect(subTableView[0], orderedCloseTo([1.0, 1.1, 1.2, 1.3], 0.00001));
            expect(subTableView[1], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
          });
        });

        group('on another attribute data table view (with an offset on the underlying byte buffer)', () {
          final subTableView = table.subTableView(1);
          final viewOnView = subTableView.subTableView(1);

          test('returns a new table with the correct length', () {
            expect(viewOnView.length, equals(2));
          });

          test('returns a new table with the correct values', () {
            expect(viewOnView[0], orderedCloseTo([2.0, 2.1, 2.2, 2.3], 0.00001));
            expect(viewOnView[1], orderedCloseTo([3.0, 3.1, 3.2, 3.3], 0.00001));
          });
        });

        group('on a table not marked as dynamic', () {
          final table = new AttributeDataTable.fromList(4, [
            0.0, 0.1, 0.2, 0.3,
            1.0, 1.1, 1.2, 1.3,
            2.0, 2.1, 2.2, 2.3,
            3.0, 3.1, 3.2, 3.3
          ]).subTableView(1);

          test('returns a table not marked as dynamic', () {
            expect(table.isDynamic, isFalse);
          });
        });

        group('on a table marked as dynamic', () {
          final table = new AttributeDataTable.dynamicFromList(4, [
            0.0, 0.1, 0.2, 0.3,
            1.0, 1.1, 1.2, 1.3,
            2.0, 2.1, 2.2, 2.3,
            3.0, 3.1, 3.2, 3.3
          ]).subTableView(1);

          test('returns a table marked as dynamic', () {
            expect(table.isDynamic, isTrue);
          });
        });
      });
    });

    group('asDynamic', () {
      group('on a table not marked as dynamic', () {
        final table = new AttributeDataTable.fromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]).asDynamicView();

        test('returns a table marked as dynamic', () {
          expect(table.isDynamic, isTrue);
        });
      });

      group('on a table marked as dynamic', () {
        final table = new AttributeDataTable.dynamicFromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]).asDynamicView();

        test('returns a table marked as dynamic', () {
          expect(table.isDynamic, isTrue);
        });
      });
    });

    group('asStatic', () {
      group('on a table not marked as dynamic', () {
        final table = new AttributeDataTable.fromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]).asStaticView();

        test('returns a table marked as dynamic', () {
          expect(table.isDynamic, isFalse);
        });
      });

      group('on a table marked as dynamic', () {
        final table = new AttributeDataTable.dynamicFromList(3, [
          0.0, 0.0, 0.0,
          1.0, 1.0, 1.0,
          2.0, 2.0, 2.0
        ]).asStaticView();

        test('returns a table marked as dynamic', () {
          expect(table.isDynamic, isFalse);
        });
      });
    });
  });

  group('AttributeDataRowView', () {
    final table = new AttributeDataTable.fromList(3, [
      0.0, 0.1, 0.2,
      1.0, 1.1, 1.2,
      2.0, 2.1, 2.2
    ]);

    group('default constructor', () {
      test('throws a RangeError when the row index is out of bounds', () {
        expect(() => new AttributeDataRowView(table, -1), throwsRangeError);
        expect(() => new AttributeDataRowView(table, 3), throwsRangeError);
      });
    });

    group('instance', () {
      final rowView = new AttributeDataRowView(table, 1);

      group('iterator', () {
        group('instance', () {
          final iterator = rowView.iterator;

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

        test('updates the correct value on the table', () {
          rowView[1] = 8.0;

          expect(table[1][1], closeTo(8.0, 0.00001));
        });
      });
    });
  });
}
