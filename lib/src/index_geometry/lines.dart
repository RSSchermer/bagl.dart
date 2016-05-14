part of index_geometry;

/// An ordered collection of lines described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// Each pair of indices defines 1 line.
///
/// See also [LineStrip] and [LineLoop].
class Lines extends IterableBase<LinesLineView> implements IndexGeometry {
  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for these lines begin.
  final int offset;

  /// Creates a new instance of [Lines] from the [vertices] and the
  /// [indices].
  ///
  /// Optionally, these [Lines] can be defined as a range on the [indices]
  /// list from [start] inclusive to [end] exclusive. If omitted [start]
  /// defaults to `0`. If omitted [end] defaults to `null` which means the range
  /// will extend to the end of the [indices] list.
  ///
  /// Throws an [ArgumentError] if the difference between the [start] and [end]
  /// is not a multiple of 2.
  ///
  /// Throws an [RangeError] if range defined by [start] and [end] is not a
  /// valid range for the [indices] list.
  Lines(this.vertices, IndexList indices, [int start = 0, int end])
      : indices = indices,
        offset = start,
        length = ((end ?? indices.length) - start) ~/ 2 {
    end ??= indices.length;

    RangeError.checkValidRange(start, end, indices.length);

    if ((end - start).remainder(2) != 0) {
      throw new ArgumentError('The difference between the start ($start) '
          'position of the range and end position of the range ($end) must be '
          'a multiple of 2.');
    }
  }

  LinesIterator get iterator => new LinesIterator(this);

  LinesLineView elementAt(int index) => this[index];

  /// Returns the line at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
  LinesLineView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new LinesLineView(this, index);
  }
}

/// Iterator over the lines in a [Lines] collection.
class LinesIterator extends Iterator<LinesLineView> {
  final Lines lines;

  int _linesLength;

  int _currentLineIndex = -1;

  /// Instantiates a new iterator over the given [lines].
  LinesIterator(Lines lines)
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

  /// Instantiates a new [LinesLineView] on the line at the given
  /// [index] in the given set of [lines].
  LinesLineView(Lines lines, int index)
      : lines = lines,
        index = index,
        _offset = lines.offset + index * 2;

  /// The index of the [start] vertex of this line in the [VertexArray] on
  /// which this line view is defined.
  int get startIndex => lines.indices[_offset];

  /// The index of the [end] vertex of this line in the [VertexArray] on
  /// which this line view is defined.
  int get endIndex => lines.indices[_offset + 1];

  /// Sets the index of the lines [start] vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the line is defined.
  void set startIndex(int index) {
    RangeError.checkValidIndex(index, lines.vertices);

    lines.indices[_offset] = index;
  }

  /// Sets the index of the lines [end] vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the line is defined.
  void set endIndex(int index) {
    RangeError.checkValidIndex(index, lines.vertices);

    lines.indices[_offset + 1] = index;
  }

  Vertex get start => lines.vertices[startIndex];
  Vertex get end => lines.vertices[endIndex];

  /// Sets the line's start vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this line is defined.
  void set start(Vertex vertex) {
    final vertexIndex = lines.vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError('The vertex was not found in the vertex array on '
          'which this line is defined.');
    } else {
      startIndex = vertexIndex;
    }
  }

  /// Sets the line's end vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this line is defined.
  void set end(Vertex vertex) {
    final vertexIndex = lines.vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex array on which this '
          'line is defined.');
    } else {
      endIndex = vertexIndex;
    }
  }
}
