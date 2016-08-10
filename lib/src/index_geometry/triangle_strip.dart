part of index_geometry;

/// A strip of connected triangles described by an [VertexArray] and an
/// [IndexList].
///
/// The indices in the [IndexList] must be valid indices for vertices in the
/// [VertexArray]. Each index uniquely identifies a vertex in the [VertexArray].
///
/// Suppose `v0` is the vertex identified by the first index, `v1` is the vertex
/// identified by the second index, `v2` is the vertex identified by the third
/// index, etc. A [TriangleStrip] will then combine these vertices into the
/// following sequence of triangles:
///
/// - Triangle `0`: (`a`:`v0`, `b`:`v1`, `c`:`v2`)
/// - Triangle `1`: (`a`:`v2`, `b`:`v1`, `c`:`v3`)
/// - Triangle `2`: (`a`:`v2`, `b`:`v3`, `c`:`v4`)
/// - Triangle `3`: (`a`:`v4`, `b`:`v3`, `c`:`v5`)
/// - Triangle `4`: (`a`:`v4`, `b`:`v5`, `c`:`v6`)
/// - Triangle `5`: (`a`:`v6`, `b`:`v5`, `c`:`v7`)
/// - Triangle `6`: ...
///
///
///     // The connectedness of the vertices in a triangle strip:
///     //
///     // v1---v3---v5---v7
///     // |\   |\   |\   |
///     // | \  | \  | \  |
///     // |  \ |  \ |  \ |
///     // |   \|   \|   \|
///     // v0---v2---v4---v6
///
/// See also [Triangles] and [TriangleFan].
class TriangleStrip extends IterableBase<TriangleStripTriangleView>
    implements IndexGeometry<TriangleStripTriangleView> {
  final topology = Topology.triangleStrip;

  final VertexArray vertices;

  final Uint16List indices;

  final int length;

  final int offset;

  final int indexCount;

  /// Creates a new [TriangleStrip] instance from the [vertices] and the
  /// [indices].
  ///
  /// An [offset] and [count] may be specified to limit this [TriangleStrip] to
  /// a subset of the [indices]. If omitted, the [offset] defaults to `0`. If
  /// omitted, the [count] defaults to `null` which indicates all indices
  /// between the [offset] and the end of the list of [indices] will be used.
  ///
  /// Throws a [RangeError] if the [offset] is negative or equal to or greater
  /// than the length of the list of [indices].
  ///
  /// Throws a [RangeError] if the [count] is negative or `offset + count` is
  /// greater than the length of the list of [indices].
  factory TriangleStrip(VertexArray vertices, IndexList indices,
          [int offset = 0, int count]) =>
      new TriangleStrip._internal(
          vertices, indices, offset, count ?? (indices.length - offset));

  TriangleStrip._internal(this.vertices, this.indices, this.offset, int count)
      : indexCount = count,
        length = count < 3 ? 0 : count - 2 {
    RangeError.checkValueInInterval(offset, 0, indices.length - 1, 'offset');
    RangeError.checkValueInInterval(count, 0, indices.length - offset, 'count');
  }

  TriangleStripIterator get iterator => new TriangleStripIterator(this);

  TriangleStripTriangleView elementAt(int index) => this[index];

  /// Returns the triangle at the given [index].
  ///
  /// Throws a [RangeError] if the [index] is out of bounds.
  TriangleStripTriangleView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new TriangleStripTriangleView(this, index);
  }
}

/// Iterator over the triangles in a [TriangleStrip].
class TriangleStripIterator extends Iterator<TriangleStripTriangleView> {
  final TriangleStrip triangleStrip;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator over the given [triangleStrip].
  TriangleStripIterator(TriangleStrip triangleStrip)
      : triangleStrip = triangleStrip,
        _trianglesLength = triangleStrip.length;

  TriangleStripTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TriangleStripTriangleView(
          triangleStrip, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

/// A triangle as a view on the data in a [TriangleStrip] instance.
class TriangleStripTriangleView implements Triangle {
  /// The [TriangleStrip] instance on which this [TriangleStripTriangleView] is
  /// defined.
  final TriangleStrip triangleStrip;

  /// The index of this [TriangleStripTriangleView] in the [triangleStrip] on
  /// which this [TriangleStripTriangleView] is defined.
  final int index;

  final int _offset;

  /// Instantiates a new [TriangleStripTriangleView] on the triangle at the
  /// given [index] in the [triangleStrip].
  TriangleStripTriangleView(TriangleStrip triangleStrip, int index)
      : triangleStrip = triangleStrip,
        index = index,
        _offset = triangleStrip.offset + index;

  /// The index of the vertex [a] in the [VertexArray] on which this triangle
  /// view is defined.
  int get aIndex => index.isEven
      ? triangleStrip.indices[_offset]
      : triangleStrip.indices[_offset + 1];

  /// The index of the vertex [b] in the [VertexArray] on which this triangle
  /// view is defined.
  int get bIndex => index.isEven
      ? triangleStrip.indices[_offset + 1]
      : triangleStrip.indices[_offset];

  /// The index of the vertex [c] in the [VertexArray] on which this triangle
  /// view is defined.
  int get cIndex => triangleStrip.indices[_offset + 2];

  Vertex get a => triangleStrip.vertices[aIndex];
  Vertex get b => triangleStrip.vertices[bIndex];
  Vertex get c => triangleStrip.vertices[cIndex];
}
