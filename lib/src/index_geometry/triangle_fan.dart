part of index_geometry;

/// A fan of connected triangles described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
///
/// Suppose `v0` is the vertex identified by the first index, `v1` is the vertex
/// identified by the second index, `v2` is the vertex identified by the third
/// index, etc. A [TriangleFan] will then combine these vertices into the
/// following sequence of triangles:
///
/// - Triangle `0`: (`a`:`v0`, `b`:`v1`, `c`:`v2`)
/// - Triangle `1`: (`a`:`v0`, `b`:`v2`, `c`:`v3`)
/// - Triangle `2`: (`a`:`v0`, `b`:`v3`, `c`:`v4`)
/// - Triangle `3`: (`a`:`v0`, `b`:`v4`, `c`:`v5`)
/// - Triangle `4`: (`a`:`v0`, `b`:`v5`, `c`:`v6`)
/// - Triangle `5`: ...
///
///     // The connectedness of the vertices a triangle fan:
///     //
///     //      v4--------v3
///     //     / \       / \
///     //    /   \     /   \
///     //   /     \   /     \
///     //  /       \ /       \
///     // v5--------v0-------v2
///     //  \       / \       /
///     //   \     /   \     /
///     //    \   /     \   /
///     //     \ /       \ /
///     //      v6        v1
///
/// See also [Triangles] and [TriangleFan].
class TriangleFan extends IterableBase<TriangleFanTriangleView>
    implements IndexGeometry {
  final topology = Topology.triangleFan;

  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for this [TriangleFan] begin.
  final int offset;

  /// Creates a new instance of [TriangleFan] from the [vertices] and the
  /// [indices].
  ///
  /// Optionally, these [TriangleFan] can be defined as a range on the
  /// [indices] list from [start] inclusive to [end] exclusive. If omitted
  /// [start] defaults to `0`. If omitted [end] defaults to `null` which means
  /// the range will extend to the end of the [indices] list.
  ///
  /// Throws an [ArgumentError] if the difference between the [start] and [end]
  /// is less than 3.
  ///
  /// Throws a [RangeError] if range defined by [start] and [end] is not a valid
  /// range for the [indices] list.
  TriangleFan(this.vertices, IndexList indices, [int start = 0, int end])
      : indices = indices,
        offset = start,
        length = (end ?? indices.length) - start - 2 {
    end ??= indices.length;

    RangeError.checkValidRange(start, end, indices.length);

    if (end - start < 3) {
      throw new ArgumentError('The difference between the start ($start) '
          'position of the range and end position of the range ($end) must be '
          'at least 3.');
    }
  }

  TriangleFanIterator get iterator => new TriangleFanIterator(this);

  TriangleFanTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  TriangleFanTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TriangleFanTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [TriangleFan].
class TriangleFanIterator extends Iterator<TriangleFanTriangleView> {
  final TriangleFan triangleFan;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangleFan].
  TriangleFanIterator(TriangleFan triangleFan)
      : triangleFan = triangleFan,
        _trianglesLength = triangleFan.length;

  TriangleFanTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TriangleFanTriangleView(triangleFan, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

/// A triangle as a view on the data in a [TriangleFan] instance.
class TriangleFanTriangleView implements Triangle {
  /// The [TriangleFan] instance on which this [TriangleFanTriangleView] is
  /// defined.
  final TriangleFan triangleFan;

  /// The index of this [TriangleFanTriangleView] in the [triangleFan] on
  /// which this [TriangleFanTriangleView] is defined.
  final int index;

  final int _offset;

  /// Instantiates a new [TriangleFanTriangleView] on the triangle at the
  /// given [index] in the [triangleFan].
  TriangleFanTriangleView(TriangleFan triangleFan, int index)
      : triangleFan = triangleFan,
        index = index,
        _offset = triangleFan.offset + index;

  /// The index of the first vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get aIndex => triangleFan.indices[triangleFan.offset];

  /// The index of the second vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get bIndex => triangleFan.indices[_offset + 1];

  /// The index of the third vertex of this triangle in the [VertexArray] on
  /// which this triangle view is defined.
  int get cIndex => triangleFan.indices[_offset + 2];

  Vertex get a => triangleFan.vertices[aIndex];
  Vertex get b => triangleFan.vertices[bIndex];
  Vertex get c => triangleFan.vertices[cIndex];
}
