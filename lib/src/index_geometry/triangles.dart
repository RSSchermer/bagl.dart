part of index_geometry;

/// An ordered collection of triangles described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
/// Each group of 3 indices defines 1 triangle.
///
/// See also [TriangleStrip] and [TriangleFan].
class Triangles extends IterableBase<TrianglesTriangleView>
    implements IndexGeometry<TrianglesTriangleView> {
  final topology = Topology.triangles;

  final VertexArray vertices;

  final IndexList indices;

  final int length;

  final int offset;

  final int indexCount;

  /// Creates a new instance of [Triangles] from the [vertices] and the
  /// [indices].
  ///
  /// An [offset] and [count] may be specified to limit these [Triangles] to
  /// a subset of the [indices]. If omitted, the [offset] defaults to `0`. If
  /// omitted, the [count] defaults to `null` which indicates all indices
  /// between the [offset] and the end of the list of [indices] will be used.
  ///
  /// Throws a [RangeError] if the [offset] is negative or equal to or greater
  /// than the length of the list of [indices].
  ///
  /// Throws a [RangeError] if the [count] is negative or `offset + count` is
  /// greater than the length of the list of [indices].
  factory Triangles(VertexArray vertices, IndexList indices,
          [int offset = 0, int count]) =>
      new Triangles._internal(
          vertices, indices, offset, count ?? (indices.length - offset));

  Triangles._internal(this.vertices, this.indices, this.offset, int count)
      : indexCount = count,
        length = count ~/ 3 {
    RangeError.checkValueInInterval(offset, 0, indices.length - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, indices.length - offset, 'count');
  }

  TrianglesIterator get iterator => new TrianglesIterator(this);

  TrianglesTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  TrianglesTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TrianglesTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [Triangles] collection.
class TrianglesIterator extends Iterator<TrianglesTriangleView> {
  final Triangles triangles;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangles].
  TrianglesIterator(Triangles triangles)
      : triangles = triangles,
        _trianglesLength = triangles.length;

  TrianglesTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TrianglesTriangleView(triangles, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

/// A triangle as a view on the data in a [Triangles] instance.
class TrianglesTriangleView implements Triangle {
  /// The [Triangles] instance on which this [TrianglesTriangleView] is defined.
  final Triangles triangles;

  /// The index of this [TrianglesTriangleView] in the [triangles] on which this
  /// [TrianglesTriangleView] is defined.
  final int index;

  final int _offset;

  /// Instantiates a new [TrianglesTriangleView] on the triangle at the given
  /// [index] in the given set of [triangles].
  TrianglesTriangleView(Triangles triangles, int index)
      : triangles = triangles,
        index = index,
        _offset = triangles.offset + index * 3;

  /// The index of the vertex [a] in the [VertexArray] on which this triangle
  /// view is defined.
  int get aIndex => triangles.indices[_offset];

  /// Sets the index of vertex [a] of this to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set aIndex(int index) {
    RangeError.checkValidIndex(index, triangles.vertices);

    triangles.indices[_offset] = index;
  }

  /// The index of the vertex [b] in the [VertexArray] on which this triangle
  /// view is defined.
  int get bIndex => triangles.indices[_offset + 1];

  /// Sets the index of vertex [b] of this to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set bIndex(int index) {
    RangeError.checkValidIndex(index, triangles.vertices);

    triangles.indices[_offset + 1] = index;
  }

  /// The index of the vertex [c] in the [VertexArray] on which this triangle
  /// view is defined.
  int get cIndex => triangles.indices[_offset + 2];

  /// Sets the index of vertex [c] of this to the given [index].
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the
  /// [VertexArray] on which the triangle is defined.
  void set cIndex(int index) {
    RangeError.checkValidIndex(index, triangles.vertices);

    triangles.indices[_offset + 2] = index;
  }

  Vertex get a => triangles.vertices[aIndex];
  Vertex get b => triangles.vertices[bIndex];
  Vertex get c => triangles.vertices[cIndex];
}
