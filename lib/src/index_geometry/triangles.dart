part of index_geometry;

/// An ordered collection of triangles described by an [VertexArray] and a
/// list of indices.
///
/// The indices in the index buffer must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// Each group of 3 indices defines 1 triangle.
///
/// See also [TriangleStrip] and [TriangleFan].
class Triangles extends IterableBase<TrianglesTriangleView>
    implements IndexGeometry {
  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  final bool isDynamic;

  /// Creates a new instance of [Triangles] from the [vertices] and an
  /// optional list of [indices].
  ///
  /// The [indices] are optional and may be omitted. If omitted, the first
  /// triangle is formed by vertices 0, 1 and 2, the second triangle is formed
  /// by vertices 3, 4 and 5, the third triangle is formed by vertices 6, 7 and
  /// 8, etc.
  ///
  /// Throws an [ArgumentError] if a the list of [indices] is specified and the
  /// length of the list is not a multiple of 3.
  /// Throws an [ArgumentError] if no list of [indices] is specified and the
  /// length of the array of [vertices] is not a multiple of 3.
  factory Triangles(VertexArray vertices, [List<int> indices]) =>
      new Triangles._internal(vertices, indices, false);

  // TODO: when Dart allows optional positional and named parameters in the
  // same method, merge the dynamic constructor into the default constructor.

  /// Creates a new instance of [Triangles] from the [vertices] and an
  /// optional list of [indices] that is marked as dynamic.
  ///
  /// The [indices] are optional and may be omitted. If omitted, the first
  /// triangle is formed by vertices 0, 1 and 2, the second triangle is formed
  /// by vertices 3, 4 and 5, the third triangle is formed by vertices 6, 7 and
  /// 8, etc.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  ///
  /// Throws an [ArgumentError] if a the list of [indices] is specified and the
  /// length of the list is not a multiple of 3.
  /// Throws an [ArgumentError] if no list of [indices] is specified and the
  /// length of the array of [vertices] is not a multiple of 3.
  factory Triangles.dynamic(VertexArray vertices, [List<int> indices]) =>
      new Triangles._internal(vertices, indices, true);

  /// Creates a new instance of [Triangles] from the [vertices] and a typed
  /// [Uint16List] of [indices].
  ///
  /// Optionally, the [dynamic] parameter may be specified. When `true` it
  /// signals to the rendering back-end that the indices are intended to be
  /// modified regularly, allowing the rendering back-end to optimize for this.
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the index data for geometry that is
  /// not marked as dynamic can still be modified.
  ///
  /// Throws an [ArgumentError] if the length of the list of [indices] is not a
  /// multiple of 3.
  Triangles.fromUint16Indices(this.vertices, Uint16List indices,
      {bool dynamic: false})
      : indices = indices,
        isDynamic = dynamic,
        length = indices.length ~/ 3 {
    if (indices.length % 3 != 0) {
      throw new ArgumentError(
          'The length of the list of indices must be a multiple of 3.');
    }
  }

  factory Triangles._internal(
      VertexArray vertices, List<int> indices, bool dynamic) {
    if (indices != null) {
      return new Triangles.fromUint16Indices(
          vertices, new Uint16List.fromList(indices),
          dynamic: dynamic);
    } else {
      final length = vertices.length;
      final indexData = new Uint16List(length);

      for (var i = 0; i < length; i++) {
        indexData[i] = i;
      }

      return new Triangles.fromUint16Indices(vertices, indexData,
          dynamic: dynamic);
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

/// A triangle as a view on the data in a [Triangles] collection.
class TrianglesTriangleView implements Triangle {
  final Triangles _triangles;

  final int _index;

  final int _offset;

  final VertexArray _vertices;

  final Uint16List _indices;

  /// Instantiates a new [TrianglesTriangleView] on the triangle at the given
  /// [index] in the given set of [triangles].
  TrianglesTriangleView(Triangles triangles, int index)
      : _triangles = triangles,
        _index = index,
        _offset = index * 3,
        _vertices = triangles.vertices,
        _indices = triangles.indices;

  /// The index of the first vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get aIndex => _indices[_offset];

  /// The index of the second vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get bIndex => _indices[_offset + 1];

  /// The index of the third vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get cIndex => _indices[_offset + 1];

  /// Sets the index of the triangles first vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set aIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indices[_offset] = index;
  }

  /// Sets the index of the triangles second vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set bIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indices[_offset + 1] = index;
  }

  /// Sets the index of the triangles third vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set cIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indices[_offset + 2] = index;
  }

  Vertex get a => _vertices[aIndex];
  Vertex get b => _vertices[bIndex];
  Vertex get c => _vertices[cIndex];

  /// Sets the triangle's first vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this triangle is defined.
  void set a(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

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
    final vertexIndex = _vertices.indexOf(vertex);

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
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex array on which this '
          'triangle is defined.');
    } else {
      cIndex = vertexIndex;
    }
  }
}
