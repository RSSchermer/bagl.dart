part of bagl.geometry;

/// An ordered collection of points described by a sequence of vertices.
///
/// Each vertex in the sequence defines 1 [Point]: the first vertex in the
/// sequence defines the first [Point], the second vertex in the sequence
/// defines the second [Point], etc.
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
class Points extends IterableBase<PointsPointView>
    implements PrimitiveSequence<PointsPointView> {
  final topology = Topology.points;

  final VertexArray vertices;

  final IndexList indices;

  final int offset;

  int _count;

  /// Creates a new instance of [Points].
  ///
  /// See the class documentation of [Points] for details.
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
  factory Points(VertexArray vertices,
      {IndexList indices, int offset: 0, int count}) {
    final maxCount = indices == null ? vertices.length : indices.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new Points._internal(vertices, indices, offset, count ?? maxCount);
  }

  Points._internal(this.vertices, this.indices, this.offset, this._count);

  Iterator<PointsPointView> get iterator => new _PointsIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indices == null ? vertices.length : indices.length;

    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    _count = count;
  }

  int get length => count;

  PointsPointView elementAt(int index) => this[index];

  /// Returns the point at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  PointsPointView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new PointsPointView(this, index);
  }
}

/// Iterator over the points in a [Points] collection.
class _PointsIterator extends Iterator<PointsPointView> {
  final Points points;

  int _pointsLength;

  int _currentPointIndex = -1;

  /// Instantiates a new iterator over the given [points].
  _PointsIterator(Points points)
      : points = points,
        _pointsLength = points.length;

  PointsPointView get current {
    if (_currentPointIndex >= 0 && _currentPointIndex < _pointsLength) {
      return new PointsPointView(points, _currentPointIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentPointIndex++;

    return _currentPointIndex < _pointsLength;
  }
}

/// A point as a view on the data in a [Points] instance.
class PointsPointView implements Point {
  /// The [Points] instance on which this [PointsPointView] is defined.
  final Points points;

  /// The index of this [PointsPointView] in the [points] on which this
  /// [PointsPointView] is defined.
  final int index;

  final int _offset;

  final IndexList _indices;

  /// Instantiates a new [PointsPointView] on the point at the given
  /// [index] in the given set of [points].
  PointsPointView(Points points, int index)
      : points = points,
        index = index,
        _offset = points.offset + index,
        _indices = points.indices;

  /// The offset of the index for the [vertex] in the [IndexList] used by the
  /// [points].
  ///
  /// If no [IndexList] is used by the [points] then this offset is always equal
  /// to the [vertexIndex].
  int get vertexOffset => _offset;

  /// The index of the [vertex] in the [VertexArray] on which this point view is
  /// defined.
  int get vertexIndex {
    if (_indices != null) {
      return _indices[vertexOffset];
    } else {
      return vertexOffset;
    }
  }

  Vertex get vertex => points.vertices[vertexIndex];
}
