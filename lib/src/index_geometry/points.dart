part of index_geometry;

/// An ordered collection of points described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// Each index defines 1 point.
class Points extends IterableBase<PointsPointView> implements IndexGeometry {
  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for these points begin.
  final int offset;

  /// Creates a new instance of [Points] from the [vertices] and the
  /// [indices].
  ///
  /// Optionally, these [Points] can be defined as a range on the [indices] list
  /// from [start] inclusive to [end] exclusive. If omitted [start] defaults to
  /// `0`. If omitted [end] defaults to `null` which means the range will extend
  /// to the end of the [indices] list.
  ///
  /// Throws a [RangeError] if range defined by [start] and [end] is not a valid
  /// range for the [indices] list.
  Points(this.vertices, IndexList indices, [int start = 0, int end])
      : indices = indices,
        offset = start,
        length = (end ?? indices.length) - start {
    end ??= indices.length;

    RangeError.checkValidRange(start, end, indices.length);
  }

  PointsIterator get iterator => new PointsIterator(this);

  PointsPointView elementAt(int index) => this[index];

  /// Returns the point at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
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

  /// The index of vertex of for point in the [VertexArray] on which this point
  /// view is defined.
  int get vertexIndex => points.indices[_offset];

  /// Sets the index of the points first vertex to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the point is defined.
  void set vertexIndex(int index) {
    RangeError.checkValidIndex(index, points.vertices);

    points.indices[_offset] = index;
  }

  Vertex get vertex => points.vertices[vertexIndex];

  /// Sets the point's vertex to be the given [vertex].
  ///
  /// Throws an [ArgumentError] if the [vertex] is not found in the
  /// [VertexArray] on which this point is defined.
  void set vertex(Vertex vertex) {
    final index = points.vertices.indexOf(vertex);

    if (index == -1) {
      throw new ArgumentError('The vertex was not found in the vertex array on '
          'which this point is defined.');
    } else {
      vertexIndex = index;
    }
  }
}
