part of vertex_data;

/// Vertex data structure.
///
/// This vertex data structure is agnostic as to the attributes a vertex should
/// have. Instead it behaves similar to a map, where an attribute name is linked
/// to a value.
abstract class Vertex {
  Iterable<String> get attributeNames;

  Iterable<dynamic> get attributeValues;
  // TODO: If/when Dart gets union/sum types, replace dynamic with:
  // double|Vector2|Vector3|Vector4|Matrix2|Matrix3|Matrix4

  /// Whether or not an attribute with the given name exists.
  bool hasAttribute(String attributeName);

  /// Returns the value of the attribute with the given name.
  operator [](String attributeName);

  /// Sets attribute with the specified name to the given value.
  ///
  /// Throws [ArgumentError] if the specified attribute name can not be
  /// represented on this vertex.
  void operator []=(String attributeName, dynamic value);
}
