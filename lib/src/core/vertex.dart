part of bagl;

/// Dynamic vertex data structure.
///
/// This vertex data structure is agnostic as to the attributes a vertex should
/// have. Instead it behaves similar to a map, where an attribute name is linked
/// to a value.
abstract class Vertex {
  /// Whether or not an attribute with the given name exists.
  bool hasAttribute(String attributeName);

  /// Gets the value of the attribute with the given name.
  dynamic operator [](String attributeName);

  /// Sets the specified attribute name to the given value.
  ///
  /// Throws [ArgumentError] if the specified attribute name can not be
  /// represented on this vertex.
  void operator []=(String attributeName, dynamic value);

//  dynamic noSuchMethod(Invocation invocation) {
//    var memberName = invocation.memberName.toString();
//
//    if (invocation.isAccessor || hasAttribute(memberName)) {
//      if (invocation.isSetter) {
//        return this[memberName] = invocation.positionalArguments.first;
//      } else {
//        return this[memberName];
//      }
//    } else {
//      return super.noSuchMethod(invocation);
//    }
//  }
}

/// Set of vertices as a view on byte buffer.
abstract class VertexSet extends Iterable<Vertex> {
  Map<String, VertexAttribute> attributes;
}

class StaticVertexSet extends Iterable<Vertex> {}
