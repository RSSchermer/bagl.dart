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

  /// Returns a new vertex collection from [start] inclusive to [end] exclusive.
  ///
  /// If [end] is omitted, the [length] of this collection is used.
  ///
  /// Throws an [ArgumentError] if [start] is outside of the range `0..length`
  /// or if [end] is outside of the range `start..length`.
  IndexedVertexCollection subCollection(int start, [int end]);

  /// Returns a builder which can be used to create a modified version of this
  /// vertex collection.
  ///
  ///     var modified = vertices.toBuilder()
  ///         ..omit(someVertex)
  ///         ..appendAll(newVertices)
  ///         .build();
  ///
  /// See [IndexedVertexCollectionBuilder].
  IndexedVertexCollectionBuilder toBuilder();

  /// Returns the vertex at the specified [index].
  ///
  /// Throws a [RangeError] when the [index] is out of bounds.
  Vertex operator [](int index);
}

/// Builds an [IndexedVertexCollection].
abstract class IndexedVertexCollectionBuilder {
  /// Appends the [vertex] at the tail of the vertex collection that is being
  /// build.
  void append(Vertex vertex);

  /// Appends the [vertices] at the tail of the vertex collection that is being
  /// build.
  void appendAll(Iterable<Vertex> vertices);

  /// Instructs this builder to omit the [vertex] from new vertex collections
  /// created with the builder.
  ///
  /// If an existing vertex collection is used as a base for this builder and
  /// the [vertex] is present in this base collection, then the builder will
  /// omit the [vertex] from any new vertex collection instances it builds.
  ///
  /// Returns true if the vertex was in the base collection, false otherwise.
  bool omit(Vertex vertex);

  /// Instructs this builder to omit the vertex at the given [index] from new
  /// vertex collections created with the builder.
  ///
  /// If an existing vertex collection is used as a base for this builder, then
  /// the builder will omit the vertex at the given [index] from any new vertex
  /// collection instances it builds.
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the base
  /// collection.
  /// Throws an [UnsupportedError] if no base collection base specified for the
  /// builder.
  void omitAt(int index);

  /// Instructs this builder to omit the [vertices] from new vertex collections
  /// created with the builder.
  ///
  /// If an existing vertex collection is used as a base for this builder and
  /// any of the [vertices] are present in this base collection, then the
  /// builder will omit these [vertices] from any new vertex collection
  /// instances it builds.
  void omitAll(Iterable<Vertex> vertices);

  /// Instantiates a new vertex collection using on the build instructions
  /// provided to the builder.
  ///
  /// For example:
  ///
  ///     var newCollection = oldCollection.toBuilder()
  ///         ..omit(someVertex)
  ///         ..appendAll(newVertices)
  ///         .build();
  ///
  IndexedVertexCollection build();
}
