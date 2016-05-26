part of index_geometry;

/// An loop of connected line segments described by a [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
///
/// A [LineLoop] is very similar to a [LineStrip], the only difference being
/// that the first index in the [IndexList] does not only identify the first
/// line segment's `start` vertex, it also identifies the last line segment's
/// `end` vertex. This means that the initial line segment's `start` vertex is
/// the same vertex as the final line segment's `end` vertex.
///
/// See also [Lines] and [LineStrip].
class LineLoop extends IterableBase<LineLoopLineView> implements IndexGeometry {
  final topology = Topology.lineLoop;

  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  final int offset;

  final int indexCount;

  /// Creates a new [LineLoop] instance from the [vertices] and the [indices].
  ///
  /// An [offset] and [count] may be specified to limit this [LineLoop] to a
  /// subset of the [indices]. If omitted, the [offset] defaults to `0`. If
  /// omitted, the [count] defaults to `null` which indicates all indices
  /// between the [offset] and the end of the list of [indices] will be used.
  ///
  /// Throws a [RangeError] if the [offset] is negative or equal to or greater
  /// than the length of the list of [indices].
  ///
  /// Throws a [RangeError] if the [count] is negative or `offset + count` is
  /// greater than the length of the list of [indices].
  factory LineLoop(VertexArray vertices, IndexList indices,
      [int offset = 0, int count]) =>
      new LineLoop._internal(
          vertices, indices, offset, count ?? (indices.length - offset));

  LineLoop._internal(this.vertices, this.indices, this.offset, int count)
      : indexCount = count,
        length = count < 2 ? 0 : count {
    RangeError.checkValueInInterval(offset, 0, indices.length - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, indices.length - offset, 'count');
  }

  LineLoopIterator get iterator => new LineLoopIterator(this);

  LineLoopLineView elementAt(int index) => this[index];

  /// Returns the line at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  LineLoopLineView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new LineLoopLineView(this, index);
  }
}

/// Iterator over the lines in a [LineLoop].
class LineLoopIterator extends Iterator<LineLoopLineView> {
  final LineLoop lineLoop;

  int _lineLoopLength;

  int _currentLineIndex = -1;

  /// Instantiates a new iterator over the given [lineLoop].
  LineLoopIterator(LineLoop lineLoop)
      : lineLoop = lineLoop,
        _lineLoopLength = lineLoop.length;

  LineLoopLineView get current {
    if (_currentLineIndex >= 0 && _currentLineIndex < _lineLoopLength) {
      return new LineLoopLineView(lineLoop, _currentLineIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentLineIndex++;

    return _currentLineIndex < _lineLoopLength;
  }
}

/// A line as a view on the data in a [LineLoop] instance.
class LineLoopLineView implements Line {
  /// The [LineLoop] instance on which this [LineLoopLineView] is defined.
  final LineLoop lineLoop;

  /// The index of this [LineLoopLineView] in the [lineLoop] on which this
  /// [LineLoopLineView] is defined.
  final int index;

  final int _offset;

  /// Instantiates a new [LineLoopLineView] on the line at the given [index] in
  /// the given [lineLoop].
  LineLoopLineView(LineLoop lineLoop, int index)
      : lineLoop = lineLoop,
        index = index,
        _offset = lineLoop.offset + index;

  /// The index of the [start] vertex in the [VertexArray] on which this line
  /// view is defined.
  int get startIndex => lineLoop.indices[_offset];

  /// The index of the [end] vertex in the [VertexArray] on which this line view
  /// is defined.
  int get endIndex => index == lineLoop.length - 1
      ? lineLoop.indices[lineLoop.offset]
      : lineLoop.indices[_offset + 1];

  Vertex get start => lineLoop.vertices[startIndex];
  Vertex get end => lineLoop.vertices[endIndex];
}
