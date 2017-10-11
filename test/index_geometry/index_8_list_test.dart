import 'package:test/test.dart';
import 'package:bagl/index_list.dart';
import 'dart:typed_data';

void main() {
  group('Index8List', () {
    group('default constructor', () {
      final indexList = new Index8List(5);

      test('creates a new instance with the correct length', () {
        expect(indexList.length, equals(5));
      });

      test('creates a new instance with the correct values', () {
        expect(indexList[0], equals(0));
        expect(indexList[1], equals(0));
        expect(indexList[2], equals(0));
        expect(indexList[3], equals(0));
        expect(indexList[4], equals(0));
      });

      test('creates a new instance that is not marked as dynamic', () {
        expect(indexList.isDynamic, isFalse);
      });
    });

    group('dynamic constructor', () {
      final indexList = new Index8List.dynamic(5);

      test('creates a new instance with the correct length', () {
        expect(indexList.length, equals(5));
      });

      test('creates a new instance with the correct values', () {
        expect(indexList[0], equals(0));
        expect(indexList[1], equals(0));
        expect(indexList[2], equals(0));
        expect(indexList[3], equals(0));
        expect(indexList[4], equals(0));
      });

      test('creates a new instance that is marked as dynamic', () {
        expect(indexList.isDynamic, isTrue);
      });
    });

    group('incrementing constructor', () {
      group('without the start parameter', () {
        final indexList = new Index8List.incrementing(5);

        test('creates a new instance with the correct length', () {
          expect(indexList.length, equals(5));
        });

        test('creates a new instance with the correct values', () {
          expect(indexList[0], equals(0));
          expect(indexList[1], equals(1));
          expect(indexList[2], equals(2));
          expect(indexList[3], equals(3));
          expect(indexList[4], equals(4));
        });

        test('creates a new instance that is not marked as dynamic', () {
          expect(indexList.isDynamic, isFalse);
        });
      });


      group('with the start parameter', () {
        final indexList = new Index8List.incrementing(5, 3);

        test('creates a new instance with the correct length', () {
          expect(indexList.length, equals(5));
        });

        test('creates a new instance with the correct values', () {
          expect(indexList[0], equals(3));
          expect(indexList[1], equals(4));
          expect(indexList[2], equals(5));
          expect(indexList[3], equals(6));
          expect(indexList[4], equals(7));
        });

        test('creates a new instance that is not marked as dynamic', () {
          expect(indexList.isDynamic, isFalse);
        });
      });
    });

    group('dynamicIncrementing constructor', () {
      group('without the start parameter', () {
        final indexList = new Index8List.dynamicIncrementing(5);

        test('creates a new instance with the correct length', () {
          expect(indexList.length, equals(5));
        });

        test('creates a new instance with the correct values', () {
          expect(indexList[0], equals(0));
          expect(indexList[1], equals(1));
          expect(indexList[2], equals(2));
          expect(indexList[3], equals(3));
          expect(indexList[4], equals(4));
        });

        test('creates a new instance that is marked as dynamic', () {
          expect(indexList.isDynamic, isTrue);
        });
      });


      group('with the start parameter', () {
        final indexList = new Index8List.dynamicIncrementing(5, 3);

        test('creates a new instance with the correct length', () {
          expect(indexList.length, equals(5));
        });

        test('creates a new instance with the correct values', () {
          expect(indexList[0], equals(3));
          expect(indexList[1], equals(4));
          expect(indexList[2], equals(5));
          expect(indexList[3], equals(6));
          expect(indexList[4], equals(7));
        });

        test('creates a new instance that is marked as dynamic', () {
          expect(indexList.isDynamic, isTrue);
        });
      });
    });

    group('fromList constructor', () {
      final indexList = new Index8List.fromList([4, 3, 2, 1, 0]);

      test('creates a new instance with the correct length', () {
        expect(indexList.length, equals(5));
      });

      test('creates a new instance with the correct values', () {
        expect(indexList[0], equals(4));
        expect(indexList[1], equals(3));
        expect(indexList[2], equals(2));
        expect(indexList[3], equals(1));
        expect(indexList[4], equals(0));
      });

      test('creates a new instance that is not marked as dynamic', () {
        expect(indexList.isDynamic, isFalse);
      });
    });

    group('dynamicFromList constructor', () {
      final indexList = new Index8List.dynamicFromList([4, 3, 2, 1, 0]);

      test('creates a new instance with the correct length', () {
        expect(indexList.length, equals(5));
      });

      test('creates a new instance with the correct values', () {
        expect(indexList[0], equals(4));
        expect(indexList[1], equals(3));
        expect(indexList[2], equals(2));
        expect(indexList[3], equals(1));
        expect(indexList[4], equals(0));
      });

      test('creates a new instance that is marked as dynamic', () {
        expect(indexList.isDynamic, isTrue);
      });
    });

    group('view constructor', () {
      final data = new Uint8List.fromList([5, 4, 3, 2, 1, 0]);
      final indexList = new Index8List.view(data.buffer, 1, 3);

      test('creates a new instance with the correct length', () {
        expect(indexList.length, equals(3));
      });

      test('creates a new instance with the correct values', () {
        expect(indexList[0], equals(4));
        expect(indexList[1], equals(3));
        expect(indexList[2], equals(2));
      });

      test('creates a new instance that is not marked as dynamic', () {
        expect(indexList.isDynamic, isFalse);
      });
    });

    group('dynamicView constructor', () {
      final data = new Uint8List.fromList([5, 4, 3, 2, 1, 0]);
      final indexList = new Index8List.dynamicView(data.buffer, 1, 3);

      test('creates a new instance with the correct length', () {
        expect(indexList.length, equals(3));
      });

      test('creates a new instance with the correct values', () {
        expect(indexList[0], equals(4));
        expect(indexList[1], equals(3));
        expect(indexList[2], equals(2));
      });

      test('creates a new instance that is marked as dynamic', () {
        expect(indexList.isDynamic, isTrue);
      });
    });
  });
}
