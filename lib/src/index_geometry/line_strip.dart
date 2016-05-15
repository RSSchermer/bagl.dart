part of index_geometry;

/// An strip of connected line segments described by a [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// The first index in the [IndexList] identifies the `start` vertex for first
/// line segment. The second index in the [IndexList] identifies both the `end`
/// vertex for the first line segment, as well as the `start` vertex for the
/// second line segment (the first line segment's `end` vertex is the same
/// vertex as the second line segment's `start` vertex). The third index in the
/// [IndexList] identifies both the `end` vertex for the second line segment,
/// as well as the `start` vertex for the third line segment, etc.
///
/// In general:
///
/// - Each line segment's `start` vertex is equal to the preceding line
///   segment's `end` vertex. The initial line segment is an exception as it has
///   no preceding line segment.
///
/// Or alternatively:
///
/// - Each line segment's `end` vertex is equal to the succeeding line segment's
///   `start` vertex. The final line segment is an exception as it has no
///   succeeding line segment.
///
/// See also [Lines] and [LineLoop].
class LineStrip extends IterableBase<LineStripLineView>
    implements IndexGeometry {
  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for these lines begin.
  final int offset;

  /// Creates a new instance of [LineStrip] from the [vertices] and the
  /// [indices].
  ///
  /// Optionally, these [LineStrip] can be defined as a range on the [indices]
  /// list from [start] inclusive to [end] exclusive. If omitted [start]
  /// defaults to `0`. If omitted [end] defaults to `null` which means the range
  /// will extend to the end of the [indices] list.
  ///
  /// Throws a [RangeError] if range defined by [start] and [end] is not a valid
  /// range for the [indices] list.
  LineStrip(this.vertices, IndexList indices, [int start = 0, int end])
      : indices = indices,
        offset = start,
        length = (end ?? indices.length) - start - 1 {
    RangeError.checkValidRange(start, end, indices.length);
  }

  LineStripIterator get iterator => new LineStripIterator(this);

  LineStripLineView elementAt(int index) => this[index];

  /// Returns the line at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
  LineStripLineView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new LineStripLineView(this, index);
  }
}

/// Iterator over the lines in a [LineStrip].
class LineStripIterator extends Iterator<LineStripLineView> {
  final LineStrip lineStrip;

  int _lineStripLength;

  int _currentLineIndex = -1;

  /// Instantiates a new iterator over the given [lineStrip].
  LineStripIterator(LineStrip lineStrip)
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

  /// Instantiates a new [LineStripLineView] on the line at the given [index] in
  /// the given [lineStrip].
  LineStripLineView(LineStrip lineStrip, int index)
      : lineStrip = lineStrip,
        index = index,
        _offset = lineStrip.offset + index;

  /// The index of the [start] vertex of this line in the [VertexArray] on which
  /// this line view is defined.
  int get startIndex => lineStrip.indices[_offset];

  /// The index of the [end] vertex of this line in the [VertexArray] on which
  /// this line view is defined.
  int get endIndex => lineStrip.indices[_offset + 1];

  Vertex get start => lineStrip.vertices[startIndex];
  Vertex get end => lineStrip.vertices[endIndex];
}
