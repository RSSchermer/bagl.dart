part of bagl.geometry;

/// An ordered collection of points described by a sequence of vertices.
///
/// Each vertex in the sequence defines 1 [Point]: the first vertex in the
/// sequence defines the first [Point], the second vertex in the sequence
/// defines the second [Point], etc.
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
class Points extends IterableBase<PointsPointView>
    implements PrimitiveSequence<PointsPointView> {
  final topology = Topology.points;

  final VertexArray vertexArray;

  final IndexList indexList;

  final int offset;

  int _count;

  /// Creates a new instance of [Points].
  ///
  /// See the class documentation of [Points] for details.
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
  factory Points(VertexArray vertexArray,
      {IndexList indexList, int offset: 0, int count}) {
    final maxCount = indexList == null ? vertexArray.length : indexList.length;

    count ??= maxCount;

    RangeError.checkValueInInterval(offset, 0, maxCount - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, maxCount - offset, 'count');

    return new Points._internal(
        vertexArray, indexList, offset, count ?? maxCount);
  }

  Points._internal(this.vertexArray, this.indexList, this.offset, this._count);

  Iterator<PointsPointView> get iterator => new _PointsIterator(this);

  int get count => _count;

  void set count(int count) {
    final maxCount = indexList == null ? vertexArray.length : indexList.length;

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

  final IndexList _indexList;

  /// Instantiates a new [PointsPointView] on the point at the given
  /// [index] in the given set of [points].
  PointsPointView(Points points, int index)
      : points = points,
        index = index,
        _offset = points.offset + index,
        _indexList = points.indexList;

  /// The offset of the index for the [vertex] in the [IndexList] used by the
  /// [points].
  ///
  /// If no [IndexList] is used by the [points] then this offset is always equal
  /// to the [vertexIndex].
  int get vertexOffset => _offset;

  /// The index of the [vertex] in the [VertexArray] on which this point view is
  /// defined.
  int get vertexIndex {
    if (_indexList != null) {
      return _indexList[vertexOffset];
    } else {
      return vertexOffset;
    }
  }

  Vertex get vertex => points.vertexArray[vertexIndex];
}
