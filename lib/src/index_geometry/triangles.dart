part of index_geometry;

/// An ordered collection of triangles described by an [IndexedVertexCollection]
/// and an index buffer.
///
/// The indices in the index buffer must be valid indices for vertices in the
/// [IndexedVertexCollection]. The indices in the index buffer are conceptually
/// partitioned into groups of 3. Each group of 3 indices defines 1 triangle.
///
/// See also [TriangleStrip] and [TriangleFan].
class Triangles extends IterableBase<TrianglesTriangleView> implements IndexGeometry {
  final VertexArray vertices;

  /// The index data as a typed [Uint16List] view on the index buffer.
  final Uint16List indexBuffer;

  final int length;

  final bool isDynamic;

  /// Creates a new instance of [Triangles] from the [vertices] and the
  /// [indexBuffer].
  ///
  /// The [indexBuffer] is optional and may be omitted. If omitted, the first
  /// triangle is formed by vertices 0, 1 and 2, the second triangle is formed
  /// by vertices 3, 4 and 5, the third triangle is formed by vertices 6, 7 and
  /// 8, etc.
  ///
  /// Throws an [ArgumentError] if an [indexBuffer] is specified and the length
  /// of the [indexBuffer] is not a multiple of 3.
  /// Throws an [ArgumentError] if no [indexBuffer] is specified and the length
  /// of the [vertices] collection is not a multiple of 3.
  factory Triangles(VertexArray vertices,
      [Uint16List indexBuffer]) {
    if (indexBuffer == null) {
      final length = vertices.length;
      indexBuffer = new Uint16List(length);

      for (var i = 0; i < length; i++) {
        indexBuffer[i] = i;
      }
    }

    return new Triangles._internal(vertices, indexBuffer, false);
  }

  factory Triangles.dynamic(VertexArray vertices,
      [Uint16List indexBuffer]) {
    if (indexBuffer == null) {
      final length = vertices.length;
      indexBuffer = new Uint16List(length);

      for (var i = 0; i < length; i++) {
        indexBuffer[i] = i;
      }
    }

    return new Triangles._internal(vertices, indexBuffer, true);
  }

  /// Creates a new instances of [Triangles] from the [vertices] and the
  /// [indexDataList].
  ///
  /// Throws an [ArgumentError] if the length of the [indexDataList] is not a
  /// multiple of 3.
  Triangles.fromIndexDataList(
      VertexArray vertices, List<int> indexDataList, [bool isDynamic = false])
      : this._internal(vertices, new Uint16List.fromList(indexDataList), isDynamic);

  Triangles._internal(this.vertices, Uint16List indexBuffer, this.isDynamic)
      : indexBuffer = indexBuffer,
        length = indexBuffer.length ~/ 3 {
    if (indexBuffer.length % 3 != 0) {
      throw new ArgumentError(
          'The length of the indexBuffer must be a multiple of 3.');
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

  /// Instantiates a new iterator over the given triangles.
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
class TrianglesTriangleView extends Triangle {
  final Triangles _triangles;

  final int _index;

  final int _offset;

  final IndexedVertexCollection _vertices;

  final Uint16List _indexData;

  /// Instantiates a new [TrianglesTriangleView] on the triangle at the given
  /// [index] in the given [triangles] collection.
  TrianglesTriangleView(Triangles triangles, int index)
      : _triangles = triangles,
        _index = index,
        _offset = index * 3,
        _vertices = triangles.vertices,
        _indexData = triangles.indexBuffer;

  /// The index of the first vertex of this triangle in the collection of
  /// vertices on which this triangle view is defined.
  int get aIndex => _indexData[_offset];

  /// The index of the second vertex of this triangle in the collection of
  /// vertices on which this triangle view is defined.
  int get bIndex => _indexData[_offset + 1];

  /// The index of the third vertex of this triangle in the collection of
  /// vertices on which this triangle view is defined.
  int get cIndex => _indexData[_offset + 1];

  /// Sets the index of the triangles first vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the vertex
  /// collection on which the triangle is defined.
  void set aIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indexData[_offset] = index;
  }

  /// Sets the index of the triangles second vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the vertex
  /// collection on which the triangle is defined.
  void set bIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indexData[_offset + 1] = index;
  }

  /// Sets the index of the triangles third vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the vertex
  /// collection on which the triangle is defined.
  void set cIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indexData[_offset + 2] = index;
  }

  Vertex get a => _vertices[aIndex];
  Vertex get b => _vertices[bIndex];
  Vertex get c => _vertices[cIndex];

  /// Sets the triangle's first vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the vertex
  /// collection on which this triangle is defined.
  void set a(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex collection on which this '
          'triangle is defined.');
    } else {
      aIndex = vertexIndex;
    }
  }

  /// Sets the triangle's second vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the vertex
  /// collection on which this triangle is defined.
  void set b(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex collection on which this '
          'triangle is defined.');
    } else {
      bIndex = vertexIndex;
    }
  }

  /// Sets the triangle's third vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the vertex
  /// collection on which this triangle is defined.
  void set c(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex collection on which this '
          'triangle is defined.');
    } else {
      cIndex = vertexIndex;
    }
  }
}
