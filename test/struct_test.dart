import 'package:test/test.dart';
import 'package:bagl/struct.dart';

void main() {
  group('Struct', () {
    group('instance', () {
      final struct = new Struct({
        'member1': 1.0,
        'member2': 2.0,
        'member3': 3.0
      });

      group('members', () {
        test('returns the correct values', () {
          expect(struct.members, unorderedEquals(['member1', 'member2', 'member3']));
        });
      });

      group('hasMember', () {
        test('returns false with a member name that does not occur', () {
          expect(struct.hasMember('nonExistant'), isFalse);
        });

        test('returns true with a member name that does occur', () {
          expect(struct.hasMember('member1'), isTrue);
        });
      });

      group('forEach', () {
        final calls = [];

        testFunction(String memberName, dynamic memberValue) {
          calls.add([memberName, memberValue]);
        }

        struct.forEach(testFunction);

        test('calls the supplied function the correct number of times', () {
          expect(calls.length, equals(3));
        });

        test('calls the supplied function with the correct values', () {
          expect(calls[0], orderedEquals(['member1', 1.0]));
          expect(calls[1], orderedEquals(['member2', 2.0]));
          expect(calls[2], orderedEquals(['member3', 3.0]));
        });
      });

      group('[] operator', () {
        test('returns null for a member that does not occur', () {
          expect(struct['nonExistant'], isNull);
        });

        test('returns the correct value for a member that does occurr', () {
          expect(struct['member1'], equals(1.0));
        });
      });
    });
  });
}