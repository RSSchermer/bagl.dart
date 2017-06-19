part of bagl.geometry;

/// An strip of connected line segments described by a vertex sequence.
///
/// A sequence of vertices is combined into [Line]s. Suppose `v0` is the first
/// vertex in the sequence, `v1` is the second vertex in the sequence, `v2` is
/// the third vertex in the sequence, etc. The first [Line] is then described by
/// `v0` and `v1`, the second line is described by `v1` and `v2`, the third line
/// is described by `v2` and `v3`, etc. Note that `v1` is both the `end` vertex
/// for the first [Line], as well the `start` vertex for the second line; `v2`
/// is both the `end` vertex for the second [Line], as well the `start` vertex
/// for the third line. In general: for each [Line] in a [LineStrip] the `start`
/// vertex is equal to the preceding [Line]'s `end` vertex. The first [Line] is
/// an exception as it has no preceding line segment.
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
/// See also [Lines] and [LineLoop].
class LineStrip extends IterableBase<LineStripLineView>
    implements PrimitiveSequence<LineStripLineView> {
  final topology = Topology.lineStrip;

  final VertexArray vertexArray;

  final IndexList indexList;

  final int offset;

  int _count;

  /// Creates a new [LineStrip] instance.
  ///
  /// See the class documentation for [LineStrip] for details.
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
  factory LineStrip(VertexArray vertexArray,
      {IndexList indexList, int offset: 0, int count}) {
    final maxCount = indexList == null ? vertexArray.length : indexList.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new LineStrip._internal(
        vertexArray, indexList, offset, count ?? maxCount);
  }

  LineStrip._internal(
      this.vertexArray, this.indexList, this.offset, this._count);

  Iterator<LineStripLineView> get iterator => new _LineStripIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indexList == null ? vertexArray.length : indexList.length;

    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    _count = count;
  }

  int get length => count < 2 ? 0 : count - 1;

  LineStripLineView elementAt(int index) => this[index];

  /// Returns the line at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  LineStripLineView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new LineStripLineView(this, index);
  }
}

/// Iterator over the lines in a [LineStrip].
class _LineStripIterator extends Iterator<LineStripLineView> {
  final LineStrip lineStrip;

  int _lineStripLength;

  int _currentLineIndex = -1;

  /// Instantiates a new iterator over the given [lineStrip].
  _LineStripIterator(LineStrip lineStrip)
      : lineStrip = lineStrip,
        _lineStripLength = lineStrip.length;

  LineStripLineView get current {
    if (_currentLineIndex >= 0 && _currentLineIndex < _lineStripLength) {
      return new LineStripLineView(lineStrip, _currentLineIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentLineIndex++;

    return _currentLineIndex < _lineStripLength;
  }
}

/// A line as a view on the data in a [LineStrip] instance.
class LineStripLineView implements Line {
  /// The [LineStrip] instance on which this [LineStripLineView] is defined.
  final LineStrip lineStrip;

  /// The index of this [LineStripLineView] in the [lineStrip] on which this
  /// [LineStripLineView] is defined.
  final int index;

  final int _offset;

  final IndexList _indexList;

  /// Instantiates a new [LineStripLineView] on the line at the given [index] in
  /// the given [lineStrip].
  LineStripLineView(LineStrip lineStrip, int index)
      : lineStrip = lineStrip,
        index = index,
        _offset = lineStrip.offset + index,
        _indexList = lineStrip.indexList;

  /// The offset of the index for the [start] vertex in the [IndexList] used by
  /// the [lineStrip].
  ///
  /// If no [IndexList] is used by the [lineStrip] then this offset is always
  /// equal to the [startIndex].
  int get startOffset => _offset;

  /// The offset of the index for the [start] vertex in the [IndexList] used by
  /// the [lineStrip].
  ///
  /// If no [IndexList] is used by the [lineStrip] then this offset is always
  /// equal to the [endIndex].
  int get endOffset => _offset + 1;

  /// The index of the [start] vertex in the [VertexArray] on which this line
  /// view is defined.
  int get startIndex {
    if (_indexList != null) {
      return _indexList[startOffset];
    } else {
      return startOffset;
    }
  }

  /// The index of the [end] vertex in the [VertexArray] on which this line view
  /// is defined.
  int get endIndex {
    if (_indexList != null) {
      return _indexList[endOffset];
    } else {
      return endOffset;
    }
  }

  Vertex get start => lineStrip.vertexArray[startIndex];
  Vertex get end => lineStrip.vertexArray[endIndex];
}
