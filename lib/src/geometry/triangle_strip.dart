part of geometry;

/// A strip of connected triangles described by a sequence of vertices.
///
/// A sequence of vertices is combined into [Triangle]s. Suppose `v0` is the
/// first vertex in the sequence, `v1` is the second vertex in the sequence,
/// `v2` is the third vertex in the sequence, etc. A [TriangleStrip] will then
/// combine this vertex sequence into the following [Triangle] sequence:
///
/// - Triangle `0`: (`a`:`v0`, `b`:`v1`, `c`:`v2`)
/// - Triangle `1`: (`a`:`v2`, `b`:`v1`, `c`:`v3`)
/// - Triangle `2`: (`a`:`v2`, `b`:`v3`, `c`:`v4`)
/// - Triangle `3`: (`a`:`v4`, `b`:`v3`, `c`:`v5`)
/// - Triangle `4`: (`a`:`v4`, `b`:`v5`, `c`:`v6`)
/// - Triangle `5`: (`a`:`v6`, `b`:`v5`, `c`:`v7`)
/// - Triangle `6`: ...
///
/// This diagram shows the connectedness of the vertices in a triangle strip:
///
///     // v1---v3---v5---v7
///     // |\   |\   |\   |
///     // | \  | \  | \  |
///     // |  \ |  \ |  \ |
///     // |   \|   \|   \|
///     // v0---v2---v4---v6
///
/// The vertex sequence is described by the [vertexArray], the [indexList],
/// the [offset] and the [count].
///
/// The [indexList] may be `null`. If the [indexList] is `null`, then the
/// vertex sequence is the identical to the vertex sequence of the
/// [vertexArray]: the first vertex in the sequence is the first vertex in the
/// [vertexArray], the second vertex in the sequence is the second vertex in the
/// [vertexArray], etc.
///
/// If the [indexList] is not `null`, then the vertex sequence is the sequence
/// of indices, mapped to the vertices they identify in the [vertexArray]: the
/// first vertex in the sequence is the vertex in the [vertexArray] identified
/// by the first index in the [indexList], the second vertex in the sequence is
/// the vertex in the [vertexArray] identified by the second index in the
/// [indexList], etc. The indices in the [indexList] must all be valid indices
/// for vertices in the [vertexArray].
///
/// The [offset] and [count] can be used to constrain the vertex sequence to
/// a subrange of the sequence described by the [vertexArray] and the
/// [indexList]. The [offset] declares the number of vertices that are to be
/// skipped at the beginning of the sequence. The [count] declares the number of
/// vertices that are to be drawn from the sequence (starting at the [offset]).
///
/// See also [Triangles] and [TriangleFan].
class TriangleStrip extends IterableBase<TriangleStripTriangleView>
    implements PrimitiveSequence<TriangleStripTriangleView> {
  final topology = Topology.triangleStrip;

  final VertexArray vertexArray;

  final IndexList indexList;

  final int offset;

  int _count;

  /// Creates a new [TriangleStrip] instance.
  ///
  /// See the class documentation for [TriangleStrip] for details.
  ///
  /// Throws a [RangeError] if the [offset] is negative.
  ///
  /// Throws a [RangeError] if the [offset] is equal to or greater than the
  /// length of the [vertexArray] if no [indexList] is specified.
  ///
  /// Throws a [RangeError] if the [offset] is equal to or greater than the
  /// length of the [indexList] if an [indexList] is specified.
  ///
  /// Throws a [RangeError] if the [count] is negative.
  ///
  /// Throws a [RangeError] if `offset + count` is greater than the length of
  /// the [vertexArray] if no [indexList] is specified.
  ///
  /// Throws a [RangeError] if `offset + count` is greater than the length of
  /// the [indexList] if an [indexList] is specified.
  factory TriangleStrip(VertexArray vertexArray,
      {IndexList indexList, int offset: 0, int count}) {
    final maxCount = indexList == null ? vertexArray.length : indexList.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new TriangleStrip._internal(
        vertexArray, indexList, offset, count ?? maxCount);
  }

  TriangleStrip._internal(
      this.vertexArray, this.indexList, this.offset, this._count);

  Iterator<TriangleStripTriangleView> get iterator =>
      new _TriangleStripIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indexList == null ? vertexArray.length : indexList.length;

    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    _count = count;
  }

  int get length => count < 3 ? 0 : count - 2;

  TriangleStripTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  TriangleStripTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TriangleStripTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [TriangleStrip].
class _TriangleStripIterator extends Iterator<TriangleStripTriangleView> {
  final TriangleStrip triangleStrip;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangleStrip].
  _TriangleStripIterator(TriangleStrip triangleStrip)
      : triangleStrip = triangleStrip,
        _trianglesLength = triangleStrip.length;

  TriangleStripTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TriangleStripTriangleView(
          triangleStrip, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

/// A triangle as a view on the data in a [TriangleStrip] instance.
class TriangleStripTriangleView implements Triangle {
  /// The [TriangleStrip] instance on which this [TriangleStripTriangleView] is
  /// defined.
  final TriangleStrip triangleStrip;

  /// The index of this [TriangleStripTriangleView] in the [triangleStrip] on
  /// which this [TriangleStripTriangleView] is defined.
  final int index;

  final int _offset;

  final IndexList _indexList;

  /// Instantiates a new [TriangleStripTriangleView] on the triangle at the
  /// given [index] in the [triangleStrip].
  TriangleStripTriangleView(TriangleStrip triangleStrip, int index)
      : triangleStrip = triangleStrip,
        index = index,
        _offset = triangleStrip.offset + index,
        _indexList = triangleStrip.indexList;

  /// The offset of the index for vertex [a] in the [IndexList] used by the
  /// [triangleStrip].
  ///
  /// If no [IndexList] is used by the [triangleStrip] then this offset is
  /// always equal to the [aIndex].
  int get aOffset => index.isEven ? _offset : _offset + 1;

  /// The offset of the index for vertex [b] in the [IndexList] used by the
  /// [triangleStrip].
  ///
  /// If no [IndexList] is used by the [triangleStrip] then this offset is
  /// always equal to the [bIndex].
  int get bOffset => index.isEven ? _offset + 1 : _offset;

  /// The offset of the index for vertex [c] in the [IndexList] used by the
  /// [triangleStrip].
  ///
  /// If no [IndexList] is used by the [triangleStrip] then this offset is
  /// always equal to the [cIndex].
  int get cOffset => _offset + 2;

  /// The index of vertex [a] in the [VertexArray] on which this triangle view
  /// is defined.
  int get aIndex {
    if (_indexList != null) {
      return _indexList[aOffset];
    } else {
      return aOffset;
    }
  }

  /// The index of vertex [b] in the [VertexArray] on which this triangle view
  /// is defined.
  int get bIndex {
    if (_indexList != null) {
      return _indexList[bOffset];
    } else {
      return bOffset;
    }
  }

  /// The index of vertex [c] in the [VertexArray] on which this triangle view
  /// is defined.
  int get cIndex {
    if (_indexList != null) {
      return _indexList[cOffset];
    } else {
      return cOffset;
    }
  }

  Vertex get a => triangleStrip.vertexArray[aIndex];
  Vertex get b => triangleStrip.vertexArray[bIndex];
  Vertex get c => triangleStrip.vertexArray[cIndex];
}
