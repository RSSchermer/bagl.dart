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
  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for these lines begin.
  final int offset;

  /// Creates a new instance of [LineLoop] from the [vertices] and the
  /// [indices].
  ///
  /// Optionally, these [LineLoop] can be defined as a range on the [indices]
  /// list from [start] inclusive to [end] exclusive. If omitted [start]
  /// defaults to `0`. If omitted [end] defaults to `null` which means the range
  /// will extend to the end of the [indices] list.
  ///
  /// Throws a [RangeError] if range defined by [start] and [end] is not a
  /// valid range for the [indices] list.
  ///
  /// Throws an [ArgumentError] if the difference between [start] and [end] is
  /// 1.
  LineLoop(this.vertices, IndexList indices, [int start = 0, int end])
      : indices = indices,
        offset = start,
        length = (end ?? indices.length) - start {
    end ??= indices.length;

    RangeError.checkValidRange(start, end, indices.length);

    if (end - start == 1) {
      throw new ArgumentError('The difference between the start of the range '
          '($start) and the end of the range ($end) cannot be 1.');
    }
  }

  LineLoopIterator get iterator => new LineLoopIterator(this);

  LineLoopLineView elementAt(int index) => this[index];

  /// Returns the line at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
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

  /// The index of the [start] vertex of this line in the [VertexArray] on which
  /// this line view is defined.
  int get startIndex => lineLoop.indices[_offset];

  /// The index of the [end] vertex of this line in the [VertexArray] on which
  /// this line view is defined.
  int get endIndex => index == lineLoop.length - 1
      ? lineLoop.indices[lineLoop.offset]
      : lineLoop.indices[_offset + 1];

  Vertex get start => lineLoop.vertices[startIndex];
  Vertex get end => lineLoop.vertices[endIndex];
}
