part of bagl.geometry;

/// An ordered collection of triangles described by a sequence of vertices.
///
/// A sequence of vertices is combined into [Triangle]s by partitioning the
/// vertex sequence into groups of 3: the first [Triangle] is described by
/// vertices `0`, `1` and `2`; the second [Triangle] is described by vertices
/// `3`, `4` and `5`; etc.
///
/// The vertex sequence is described by the [vertices], the [indices], the
/// [offset] and the [count].
///
/// The [indices] may be `null`. If the [indices] is `null`, then the vertex
/// sequence is the identical to the vertex sequence of the [vertices]: the
/// first vertex in the sequence is the first vertex in the [vertices], the
/// second vertex in the sequence is the second vertex in the [vertices], etc.
///
/// If the [indices] is not `null`, then the vertex sequence is the sequence
/// of indices, mapped to the vertices they identify in the [vertices]: the
/// first vertex in the sequence is the vertex in the [vertices] identified
/// by the first index in the [indices], the second vertex in the sequence is
/// the vertex in the [vertices] identified by the second index in the
/// [indices], etc. The indices in the [indices] must all be valid indices
/// for vertices in the [vertices].
///
/// The [offset] and [count] can be used to constrain the vertex sequence to
/// a subrange of the sequence described by the [vertices] and the [indices].
/// The [offset] declares the number of vertices that are to be skipped at the
/// beginning of the sequence. The [count] declares the number of vertices that
/// are to be drawn from the sequence (starting at the [offset]).
///
/// See also [TriangleStrip] and [TriangleFan].
class Triangles extends IterableBase<TrianglesTriangleView>
    implements PrimitiveSequence<TrianglesTriangleView> {
  final topology = Topology.triangles;

  final VertexArray vertices;

  final IndexList indices;

  final int offset;

  int _count;

  /// Creates a new instance of [Triangles].
  ///
  /// See the class documentation for [Triangles] for details.
  ///
  /// Throws a [RangeError] if the [offset] is negative.
  ///
  /// Throws a [RangeError] if the [offset] is equal to or greater than the
  /// length of the [vertices] if no [indices] is specified.
  ///
  /// Throws a [RangeError] if the [offset] is equal to or greater than the
  /// length of the [indices] if an [indices] is specified.
  ///
  /// Throws a [RangeError] if the [count] is negative.
  ///
  /// Throws a [RangeError] if `offset + count` is greater than the length of
  /// the [vertices] if no [indices] is specified.
  ///
  /// Throws a [RangeError] if `offset + count` is greater than the length of
  /// the [indices] if an [indices] is specified.
  factory Triangles(VertexArray vertices,
      {IndexList indices, int offset: 0, int count}) {
    final maxCount = indices == null ? vertices.length : indices.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new Triangles._internal(
        vertices, indices, offset, count ?? maxCount);
  }

  Triangles._internal(this.vertices, this.indices, this.offset, this._count);

  Iterator<TrianglesTriangleView> get iterator => new _TrianglesIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indices == null ? vertices.length : indices.length;

    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    _count = count;
  }

  int get length => count ~/ 3;

  TrianglesTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  TrianglesTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TrianglesTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [Triangles] collection.
class _TrianglesIterator extends Iterator<TrianglesTriangleView> {
  final Triangles triangles;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangles].
  _TrianglesIterator(Triangles triangles)
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

  final IndexList _indices;

  /// Instantiates a new [TrianglesTriangleView] on the triangle at the given
  /// [index] in the given set of [triangles].
  TrianglesTriangleView(Triangles triangles, int index)
      : triangles = triangles,
        index = index,
        _offset = triangles.offset + index * 3,
        _indices = triangles.indices;

  /// The offset of the index for vertex [a] in the [IndexList] used by the
  /// [triangles].
  ///
  /// If no [IndexList] is used by the [triangles] then this offset is always
  /// equal to the [aIndex].
  int get aOffset => _offset;

  /// The offset of the index for vertex [b] in the [IndexList] used by the
  /// [triangles].
  ///
  /// If no [IndexList] is used by the [triangles] then this offset is always
  /// equal to the [bIndex].
  int get bOffset => _offset + 1;

  /// The offset of the index for vertex [c] in the [IndexList] used by the
  /// [triangles].
  ///
  /// If no [IndexList] is used by the [triangles] then this offset is always
  /// equal to the [cIndex].
  int get cOffset => _offset + 2;

  /// The index of vertex [a] in the [VertexArray] on which this triangle view
  /// is defined.
  int get aIndex {
    if (_indices != null) {
      return _indices[aOffset];
    } else {
      return aOffset;
    }
  }

  /// The index of vertex [b] in the [VertexArray] on which this triangle view
  /// is defined.
  int get bIndex {
    if (_indices != null) {
      return _indices[bOffset];
    } else {
      return bOffset;
    }
  }

  /// The index of vertex [c] in the [VertexArray] on which this triangle view
  /// is defined.
  int get cIndex {
    if (_indices != null) {
      return _indices[cOffset];
    } else {
      return cOffset;
    }
  }

  Vertex get a => triangles.vertices[aIndex];
  Vertex get b => triangles.vertices[bIndex];
  Vertex get c => triangles.vertices[cIndex];
}
