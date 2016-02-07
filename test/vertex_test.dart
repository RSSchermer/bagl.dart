import 'package:test/test.dart';
import 'package:bagl/math.dart';
import 'package:bagl/vertex.dart';

void main() {
  group('Vertex', () {
    group('default constructor', () {
      test('throws an error when an attribute is of an invalid type', () {
        expect(() => new Vertex({
          'color': 'blue'
        }), throwsArgumentError);
      });
    });

    group('instance', () {
      final vertex = new Vertex({
        'position': new Vector2(0.0, 1.0),
        'color': new Vector3(1.0, 0.0, 0.0)
      });

      group('attributeNames', () {
        test('returns the correct attribute names', () {
          expect(vertex.attributeNames, unorderedEquals(['position', 'color']));
        });
      });

      group('attributeValues', () {
        test('returns the correct attribute values', () {
          expect(vertex.attributeValues, unorderedEquals([
            new Vector2(0.0, 1.0),
            new Vector3(1.0, 0.0, 0.0)
          ]));
        });
      });

      group('hasAttribute', () {
        test('returns true if the attribute is present', () {
          expect(vertex.hasAttribute('position'), isTrue);
        });

        test('returns false if the attribute is not present', () {
          expect(vertex.hasAttribute('normal'), isFalse);
        });
      });

      group('toMap', () {
        var map = vertex.toMap();

        test('returns a map with the correct length', () {
          expect(map.length, equals(2));
        });

        test('returns a map with the correct name-value pairs', () {
          expect(map, containsPair('position', new Vector2(0.0, 1.0)));
          expect(map, containsPair('color', new Vector3(1.0, 0.0, 0.0)));
        });
      });

      group('[] operator', () {
        test('returns null when the attribute is not present', () {
          expect(vertex['normal'], isNull);
        });

        test('returns the correct value when the attribute is present', () {
          expect(vertex['position'], equals(new Vector2(0.0, 1.0)));
        });
      });
    });
  });
}
