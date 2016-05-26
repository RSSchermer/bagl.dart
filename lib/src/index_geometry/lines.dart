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
  final topology = Topology.lines;

  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  final int offset;

  final int indexCount;

  /// Creates a new instance of [Lines] from the [vertices] and the [indices].
  ///
  /// An [offset] and [count] may be specified to limit these [Lines] to a
  /// subset of the [indices]. If omitted, the [offset] defaults to `0`. If
  /// omitted, the [count] defaults to `null` which indicates all indices
  /// between the [offset] and the end of the list of [indices] will be used.
  ///
  /// Throws a [RangeError] if the [offset] is negative or equal to or greater
  /// than the length of the list of [indices].
  ///
  /// Throws a [RangeError] if the [count] is negative or `offset + count` is
  /// greater than the length of the list of [indices].
  factory Lines(VertexArray vertices, IndexList indices,
      [int offset = 0, int count]) =>
      new Lines._internal(
          vertices, indices, offset, count ?? (indices.length - offset));

  Lines._internal(this.vertices, this.indices, this.offset, int count)
      : indexCount = count,
        length = count ~/ 2 {
    RangeError.checkValueInInterval(offset, 0, indices.length - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, indices.length - offset, 'count');
  }

  LinesIterator get iterator => new LinesIterator(this);

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

  /// The index of the [start] vertex in the [VertexArray] on which this line
  /// view is defined.
  int get startIndex => lines.indices[_offset];

  /// Sets the index of the [start] vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the line is defined.
  void set startIndex(int index) {
    RangeError.checkValidIndex(index, lines.vertices);

    lines.indices[_offset] = index;
  }

  /// The index of the [end] vertex in the [VertexArray] on which this line view
  /// is defined.
  int get endIndex => lines.indices[_offset + 1];

  /// Sets the index of the [end] vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the line is defined.
  void set endIndex(int index) {
    RangeError.checkValidIndex(index, lines.vertices);

    lines.indices[_offset + 1] = index;
  }

  Vertex get start => lines.vertices[startIndex];
  Vertex get end => lines.vertices[endIndex];
}
