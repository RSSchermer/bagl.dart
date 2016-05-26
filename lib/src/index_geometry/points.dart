part of index_geometry;

/// An ordered collection of points described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// Each index defines 1 point.
class Points extends IterableBase<PointsPointView> implements IndexGeometry {
  final topology = Topology.points;

  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  final int offset;

  final int indexCount;

  /// Creates a new instance of [Points] from the [vertices] and the [indices].
  ///
  /// An [offset] and [count] may be specified to limit these [Points] to a
  /// subset of the [indices]. If omitted, the [offset] defaults to `0`. If
  /// omitted, the [count] defaults to `null` which indicates all indices
  /// between the [offset] and the end of the list of [indices] will be used.
  ///
  /// Throws a [RangeError] if the [offset] is negative or equal to or greater
  /// than the length of the list of [indices].
  ///
  /// Throws a [RangeError] if the [count] is negative or `offset + count` is
  /// greater than the length of the list of [indices].
  factory Points(VertexArray vertices, IndexList indices,
      [int offset = 0, int count]) =>
      new Points._internal(
          vertices, indices, offset, count ?? (indices.length - offset));

  Points._internal(this.vertices, this.indices, this.offset, int count)
      : indexCount = count,
        length = count {
    RangeError.checkValueInInterval(offset, 0, indices.length - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, indices.length - offset, 'count');
  }

  PointsIterator get iterator => new PointsIterator(this);

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
class PointsIterator extends Iterator<PointsPointView> {
  final Points points;

  int _pointsLength;

  int _currentPointIndex = -1;

  /// Instantiates a new iterator over the given [points].
  PointsIterator(Points points)
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

  /// Instantiates a new [PointsPointView] on the point at the given
  /// [index] in the given set of [points].
  PointsPointView(Points points, int index)
      : points = points,
        index = index,
        _offset = points.offset + index;

  /// The index of the [vertex] in the [VertexArray] on which this point view is
  /// defined.
  int get vertexIndex => points.indices[_offset];

  /// Sets the index of the [vertex] to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the point is defined.
  void set vertexIndex(int index) {
    RangeError.checkValidIndex(index, points.vertices);

    points.indices[_offset] = index;
  }

  Vertex get vertex => points.vertices[vertexIndex];
}
