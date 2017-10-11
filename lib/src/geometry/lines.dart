part of bagl.geometry;

/// An ordered collection of line segments described by a vertex sequence.
///
/// A sequence of vertices is combined into [Line]s by partitioning the vertex
/// sequence into pairs: the first [Line] is described by vertices `0` and `1`;
/// the second [Line] is described by vertices `2` and `3`; etc.
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
/// See also [LineStrip] and [LineLoop].
class Lines extends IterableBase<LinesLineView>
    implements PrimitiveSequence<LinesLineView> {
  final topology = Topology.lines;

  final VertexArray vertices;

  final IndexList indices;

  final int offset;

  int _count;

  /// Creates a new instance of [Lines].
  ///
  /// See the class documentation for [Lines] for details.
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
  factory Lines(VertexArray vertices,
      {IndexList indices, int offset: 0, int count}) {
    final maxCount = indices == null ? vertices.length : indices.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new Lines._internal(vertices, indices, offset, count ?? maxCount);
  }

  Lines._internal(this.vertices, this.indices, this.offset, this._count);

  Iterator<LinesLineView> get iterator => new _LinesIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indices == null ? vertices.length : indices.length;

    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    _count = count;
  }

  int get length => count ~/ 2;

  LinesLineView elementAt(int index) => this[index];

  /// Returns the line at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  LinesLineView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new LinesLineView(this, index);
  }
}

/// Iterator over the lines in a [Lines] collection.
class _LinesIterator extends Iterator<LinesLineView> {
  final Lines lines;

  int _linesLength;

  int _currentLineIndex = -1;

  /// Instantiates a new iterator over the given [lines].
  _LinesIterator(Lines lines)
      : lines = lines,
        _linesLength = lines.length;

  LinesLineView get current {
    if (_currentLineIndex >= 0 && _currentLineIndex < _linesLength) {
      return new LinesLineView(lines, _currentLineIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentLineIndex++;

    return _currentLineIndex < _linesLength;
  }
}

/// A line as a view on the data in a [Lines] instance.
class LinesLineView implements Line {
  /// The [Lines] instance on which this [LinesLineView] is defined.
  final Lines lines;

  /// The index of this [LinesLineView] in the [lines] on which this
  /// [LinesLineView] is defined.
  final int index;

  final int _offset;

  final IndexList _indices;

  /// Instantiates a new [LinesLineView] on the line at the given
  /// [index] in the given set of [lines].
  LinesLineView(Lines lines, int index)
      : lines = lines,
        index = index,
        _offset = lines.offset + index * 2,
        _indices = lines.indices;

  /// The offset of the index for the [start] vertex in the [IndexList] used by
  /// the [lines].
  ///
  /// If no [IndexList] is used by the [lines] then this offset is always equal
  /// to the [startIndex].
  int get startOffset => _offset;

  /// The offset of the index for the [start] vertex in the [IndexList] used by
  /// the [lines].
  ///
  /// If no [IndexList] is used by the [lines] then this offset is always equal
  /// to the [endIndex].
  int get endOffset => _offset + 1;

  /// The index of the [start] vertex in the [VertexArray] on which this line
  /// view is defined.
  int get startIndex {
    if (_indices != null) {
      return _indices[startOffset];
    } else {
      return startOffset;
    }
  }

  /// The index of the [end] vertex in the [VertexArray] on which this line view
  /// is defined.
  int get endIndex {
    if (_indices != null) {
      return _indices[endOffset];
    } else {
      return endOffset;
    }
  }

  Vertex get start => lines.vertices[startIndex];
  Vertex get end => lines.vertices[endIndex];
}
