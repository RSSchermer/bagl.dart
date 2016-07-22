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
    implements IndexGeometry<TriangleFanTriangleView> {
  final topology = Topology.triangleFan;

  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  final int offset;

  final int indexCount;

  /// Creates a new [TriangleFan] instance from the [vertices] and the
  /// [indices].
  ///
  /// An [offset] and [count] may be specified to limit this [TriangleFan] to a
  /// subset of the [indices]. If omitted, the [offset] defaults to `0`. If
  /// omitted, the [count] defaults to `null` which indicates all indices
  /// between the [offset] and the end of the list of [indices] will be used.
  ///
  /// Throws a [RangeError] if the [offset] is negative or equal to or greater
  /// than the length of the list of [indices].
  ///
  /// Throws a [RangeError] if the [count] is negative or `offset + count` is
  /// greater than the length of the list of [indices].
  factory TriangleFan(VertexArray vertices, IndexList indices,
          [int offset = 0, int count]) =>
      new TriangleFan._internal(
          vertices, indices, offset, count ?? (indices.length - offset));

  TriangleFan._internal(this.vertices, this.indices, this.offset, int count)
      : indexCount = count,
        length = count < 3 ? 0 : count - 2 {
    RangeError.checkValueInInterval(offset, 0, indices.length - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, indices.length - offset, 'count');
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

  /// The index of the vertex [a] in the [VertexArray] on which this triangle
  /// view is defined.
  int get aIndex => triangleFan.indices[triangleFan.offset];

  /// The index of the vertex [b] in the [VertexArray] on which this triangle
  /// view is defined.
  int get bIndex => triangleFan.indices[_offset + 1];

  /// The index of the vertex [c] in the [VertexArray] on which this triangle
  /// view is defined.
  int get cIndex => triangleFan.indices[_offset + 2];

  Vertex get a => triangleFan.vertices[aIndex];
  Vertex get b => triangleFan.vertices[bIndex];
  Vertex get c => triangleFan.vertices[cIndex];
}
