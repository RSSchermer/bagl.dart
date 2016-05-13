part of index_geometry;

/// An ordered collection of triangles described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// Each group of 3 indices defines 1 triangle.
///
/// See also [TriangleStrip] and [TriangleFan].
class Triangles extends IterableBase<TrianglesTriangleView>
    implements IndexGeometry {
  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for these triangles begin.
  final int offset;

  /// Creates a new instance of [Triangles] from the [vertices] and the
  /// [indices].
  ///
  /// Optionally, these [Triangles] can be defined on only a sub-range of the
  /// [indices] list. A [start] position may be specified to define the start of
  /// the range. The [start] is inclusive. If omitted [start] defaults to `0`.
  /// An [end] position may be specified to define the [end] of the range. The
  /// [end] is exclusive. If omitted the range will extend to the end of the
  /// [indices].
  ///
  /// Throws an [ArgumentError] if the difference between the [start] and [end]
  /// is not a multiple of 3.
  ///
  /// Throws an [ArgumentError] if the [start] is greater than or equal to the
  /// [end].
  Triangles(this.vertices, IndexList indices, [int start = 0, int end])
      : indices = indices,
        offset = start,
        length = ((end ?? indices.length) - start) ~/ 3 {
    if (((end ?? indices.length) - start).remainder(3) != 0) {
      throw new ArgumentError('The difference between the start ($start) '
          'position of the range and end position of the range ($end) must be '
          'a multiple of 3.');
    } else if (end != null && start >= end) {
      throw new ArgumentError('The start position of the range may not be '
          'greater than or equal to the end position.');
    }
  }

  TrianglesIterator get iterator => new TrianglesIterator(this);

  TrianglesTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
  TrianglesTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TrianglesTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [Triangles] collection.
class TrianglesIterator extends Iterator<TrianglesTriangleView> {
  final Triangles triangles;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangles].
  TrianglesIterator(Triangles triangles)
      : triangles = triangles,
        _trianglesLength = triangles.length;

  TrianglesTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TrianglesTriangleView(triangles, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

/// A triangle as a view on the data in a [Triangles] instance.
class TrianglesTriangleView implements Triangle {
  /// The [Triangles] instance on which this [TrianglesTriangleView] is defined.
  final Triangles triangles;

  /// The index of this [TrianglesTriangleView] in the [triangles] on which this
  /// [TrianglesTriangleView] is defined.
  final int index;

  final int _offset;

  /// Instantiates a new [TrianglesTriangleView] on the triangle at the given
  /// [index] in the given set of [triangles].
  TrianglesTriangleView(Triangles triangles, int index)
      : triangles = triangles,
        index = index,
        _offset = triangles.offset + index * 3;

  /// The index of the first vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get aIndex => triangles.indices[_offset];

  /// The index of the second vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get bIndex => triangles.indices[_offset + 1];

  /// The index of the third vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get cIndex => triangles.indices[_offset + 2];

  /// Sets the index of the triangles first vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set aIndex(int index) {
    RangeError.checkValidIndex(index, triangles.vertices);

    triangles.indices[_offset] = index;
  }

  /// Sets the index of the triangles second vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set bIndex(int index) {
    RangeError.checkValidIndex(index, triangles.vertices);

    triangles.indices[_offset + 1] = index;
  }

  /// Sets the index of the triangles third vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set cIndex(int index) {
    RangeError.checkValidIndex(index, triangles.vertices);

    triangles.indices[_offset + 2] = index;
  }

  Vertex get a => triangles.vertices[aIndex];
  Vertex get b => triangles.vertices[bIndex];
  Vertex get c => triangles.vertices[cIndex];

  /// Sets the triangle's first vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this triangle is defined.
  void set a(Vertex vertex) {
    final vertexIndex = triangles.vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex array on which this '
          'triangle is defined.');
    } else {
      aIndex = vertexIndex;
    }
  }

  /// Sets the triangle's second vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this triangle is defined.
  void set b(Vertex vertex) {
    final vertexIndex = triangles.vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex array on which this '
          'triangle is defined.');
    } else {
      bIndex = vertexIndex;
    }
  }

  /// Sets the triangle's third vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this triangle is defined.
  void set c(Vertex vertex) {
    final vertexIndex = triangles.vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex array on which this '
          'triangle is defined.');
    } else {
      cIndex = vertexIndex;
    }
  }
}
