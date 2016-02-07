/// Defines the basic vertex data structure.
library vertex;

import 'math.dart';

/// Vertex data structure.
///
/// This vertex data structure is agnostic as to the attributes a vertex should
/// have.
///
/// It behaves similar to a map, where an attribute name is linked to a value:
///
///     var vertex = new Vertex({
///       'position': new Vector2(0.0, 1.0),
///       'color': new Vector3(1.0, 0.0, 0.0)
///     });
///
///     var position = vertex['position']; // Vector2(0.0, 1.0)
///     var color = vertex['color']; // new Vector3(1.0, 0.0, 0.0)
///
class Vertex {
  final Map<String, dynamic> _attributes;
  // TODO: If/when Dart gets union/sum types, replace dynamic with:
  // double|Vector2|Vector3|Vector4|Matrix2|Matrix3|Matrix4
  // (Would make check in constructor obsolete.)

  /// Instantiates a new vertex from the given attribute-value map.
  ///
  /// Valid types for attribute values are: [double], [Vector2], [Vector3],
  /// [Vector4], [Matrix2], [Matrix3] and [Matrix4].
  ///
  /// Throws an [ArgumentError] if an attribute is of an invalid type.
  Vertex(this._attributes) {
    _attributes.forEach((name, value) {
      if (value is! double &&
          value is! Vector2 &&
          value is! Vector3 &&
          value is! Vector4 &&
          value is! Matrix2 &&
          value is! Matrix3 &&
          value is! Matrix4) {
        throw new ArgumentError(
            'The attribute named "$name" has value "$value" of type '
            '"${value.runtimeType}", but this is not a valid type for a vertex '
            'attribute. Valid types are: double, Vector2, Vector3, Vector4, '
            'Matrix2, Matrix3 and Matrix4.');
      }
    });
  }

  /// The names of the vertex's attributes.
  Iterable<String> get attributeNames => _attributes.keys;

  /// The values of the vertex's attributes.
  Iterable<dynamic> get attributeValues => _attributes.values;
  // TODO: If/when Dart gets union/sum types, replace dynamic with:
  // double|Vector2|Vector3|Vector4|Matrix2|Matrix3|Matrix4

  /// Whether or not an attribute with the given name exists.
  bool hasAttribute(String attributeName) =>
      _attributes.containsKey(attributeName);

  /// Returns a map of the vertex attributes where the keys are the attribute
  /// names.
  ///
  /// Modifications to the resulting map will not cause modifications to the
  /// vertex.
  Map<String, dynamic> toMap() => new Map.from(_attributes);
  // TODO: If/when Dart gets union/sum types, replace dynamic with:
  // double|Vector2|Vector3|Vector4|Matrix2|Matrix3|Matrix4

  /// Returns the value of the attribute with the given name or null if no
  /// attribute with that name is present.
  operator [](String attributeName) => _attributes[attributeName];
}
