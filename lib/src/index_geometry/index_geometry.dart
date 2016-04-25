part of index_geometry;

/// Abstract base class for geometry described by a [VertexArray] and a sequence
/// of indices.
///
/// The indices define how the vertices in the [VertexArray] are to be combined
/// into a sequence of geometry primitives (points, lines or triangles).
///
/// See [Lines], [LineStrip] and [LineLoop] for concrete implementations of
/// [IndexGeometry] for describing [Line] geometry.
///
/// See [Triangles], [TriangleStrip] and [TriangleFan] for concrete
/// implementations of [IndexGeometry] for describing [Triangle]
/// geometry.
///
/// See [Points] for a concrete implementation of [IndexGeometry] for
/// describing [Point] geometry.
abstract class IndexGeometry {
  /// The [VertexArray] on which this index geometry is defined.
  VertexArray get vertices;

  /// The indices describing how the [vertices] are combined into geometry
  /// primitives.
  Uint16List get indices;

  /// Whether or not this index geometry is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that the index geometry
  /// is intended to be modified regularly, allowing the rendering back-end to
  /// optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the index data for geometry that is
  /// not marked as dynamic can still be modified.
  bool get isDynamic;
}
