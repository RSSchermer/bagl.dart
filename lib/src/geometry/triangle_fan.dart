part of bagl.geometry;

/// A fan of connected triangles described by a sequence of vertices.
///
/// A sequence of vertices is combined into [Triangle]s. Suppose `v0` is the
/// first vertex in the sequence, `v1` is the second vertex in the sequence,
/// `v2` is the third vertex in the sequence, etc. A [TriangleFan] will then
/// combine these vertices into the following sequence of triangles:
///
/// - Triangle `0`: (`a`:`v0`, `b`:`v1`, `c`:`v2`)
/// - Triangle `1`: (`a`:`v0`, `b`:`v2`, `c`:`v3`)
/// - Triangle `2`: (`a`:`v0`, `b`:`v3`, `c`:`v4`)
/// - Triangle `3`: (`a`:`v0`, `b`:`v4`, `c`:`v5`)
/// - Triangle `4`: (`a`:`v0`, `b`:`v5`, `c`:`v6`)
/// - Triangle `5`: ...
///
/// This diagram shows the connectedness of the vertices a triangle fan:
///
///     //      v4--------v3
///     //     / \       / \
///     //    /   \     /   \
///     //   /     \   /     \
///     //  /       \ /       \
///     // v5--------v0-------v2
///     //  \       / \       /
///     //   \     /   \     /
///     //    \   /     \   /
///     //     \ /       \ /
///     //      v6        v1
///
/// The vertex sequence is described by the [vertices], the [indices], the
/// [offset] and the [count].
///
/// The [indices] may be `null`. If the [indices] is `null`, then the vertex
/// sequence is the identical to the vertex sequence of the [vertices]: the
/// first vertex in the sequence is the first vertex in the [vertices], the
/// second vertex in the sequence is the second vertex in the [vertices], etc.
///
/// If the [indices] is not `null`, then the vertex sequence is the sequence of
/// indices, mapped to the vertices they identify in the [vertices]: the first
/// vertex in the sequence is the vertex in the [vertices] identified by the
/// first index in the [indices], the second vertex in the sequence is the
/// vertex in the [vertices] identified by the second index in the [indices],
/// etc. The indices in the [indices] must all be valid indices for vertices in
/// the [vertices].
///
/// The [offset] and [count] can be used to constrain the vertex sequence to a
/// subrange of the sequence described by the [vertices] and the [indices]. The
/// [offset] declares the number of vertices that are to be skipped at the
/// beginning of the sequence. The [count] declares the number of vertices that
/// are to be drawn from the sequence (starting at the [offset]).
///
/// See also [Triangles] and [TriangleStrip].
class TriangleFan extends IterableBase<TriangleFanTriangleView>
    implements PrimitiveSequence<TriangleFanTriangleView> {
  final topology = Topology.triangleFan;

  final VertexArray vertices;

  final IndexList indices;

  final int offset;

  int _count;

  /// Creates a new [TriangleFan] instance.
  ///
  /// See the class documentation for [TriangleFan] for details.
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
  factory TriangleFan(VertexArray vertices,
      {IndexList indices, int offset: 0, int count}) {
    final maxCount = indices == null ? vertices.length : indices.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new TriangleFan._internal(
        vertices, indices, offset, count ?? maxCount);
  }

  TriangleFan._internal(this.vertices, this.indices, this.offset, this._count);

  Iterator<TriangleFanTriangleView> get iterator =>
      new _TriangleFanIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indices == null ? vertices.length : indices.length;

    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    _count = count;
  }

  int get length => _count < 3 ? 0 : _count - 2;

  TriangleFanTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  TriangleFanTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TriangleFanTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [TriangleFan].
class _TriangleFanIterator extends Iterator<TriangleFanTriangleView> {
  final TriangleFan triangleFan;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangleFan].
  _TriangleFanIterator(TriangleFan triangleFan)
      : triangleFan = triangleFan,
        _trianglesLength = triangleFan.length;

  TriangleFanTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TriangleFanTriangleView(triangleFan, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

/// A triangle as a view on the data in a [TriangleFan] instance.
class TriangleFanTriangleView implements Triangle {
  /// The [TriangleFan] instance on which this [TriangleFanTriangleView] is
  /// defined.
  final TriangleFan triangleFan;

  /// The index of this [TriangleFanTriangleView] in the [triangleFan] on
  /// which this [TriangleFanTriangleView] is defined.
  final int index;

  final int _offset;

  final IndexList _indices;

  /// Instantiates a new [TriangleFanTriangleView] on the triangle at the
  /// given [index] in the [triangleFan].
  TriangleFanTriangleView(TriangleFan triangleFan, int index)
      : triangleFan = triangleFan,
        index = index,
        _offset = triangleFan.offset + index,
        _indices = triangleFan.indices;

  /// The offset of the index for vertex [a] in the [IndexList] used by the
  /// [triangleFan].
  ///
  /// If no [IndexList] is used by the [triangleFan] then this offset is always
  /// equal to the [aIndex].
  int get aOffset => triangleFan.offset;

  /// The offset of the index for vertex [b] in the [IndexList] used by the
  /// [triangleFan].
  ///
  /// If no [IndexList] is used by the [triangleFan] then this offset is always
  /// equal to the [bIndex].
  int get bOffset => _offset + 1;

  /// The offset of the index for vertex [c] in the [IndexList] used by the
  /// [triangleFan].
  ///
  /// If no [IndexList] is used by the [triangleFan] then this offset is always
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

  Vertex get a => triangleFan.vertices[aIndex];
  Vertex get b => triangleFan.vertices[bIndex];
  Vertex get c => triangleFan.vertices[cIndex];
}
