part of vertex_data;

/// Abstract base class for indexed collections of vertices.
///
/// Vertices are ordered and uniquely identified by consecutive integer indices
/// starting at 0. The same index should identify the same vertex at all times.
/// This means implementations of this abstract class should only allow adding
/// or removing vertices at the tail of the collection (or not at all). Other
/// operations should return a new [IndexedVertexCollection], rather than
/// modify the current [IndexedVertexCollection].
///
/// All vertices in an [IndexedVertexCollection] must define the same the same
/// attributes. Implementations of this abstract class should enforce this.
///
/// See [BufferedVertexCollection] for an implementation that allows for
/// efficient rendering with WebGL.
abstract class IndexedVertexCollection extends Iterable<Vertex> {
  /// The names of the attributes defined for the vertices in this collection.
  Iterable<String> get attributeNames;

  /// Whether or not the vertices in this collection have an attribute with
  /// the given name.
  bool hasAttribute(String name);

  /// Returns the index of [vertex] in this vertex collection.
  ///
  /// Returns -1 if [vertex] is not found in this vertex collection.
  int indexOf(Vertex vertex);

  /// Returns the vertex at the specified [index].
  ///
  /// Throws a [RangeError] when the [index] is out of bounds.
  Vertex operator [](int index);
}
