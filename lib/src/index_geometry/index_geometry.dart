part of index_geometry;

/// Abstract base class for geometry described by a [VertexArray] and an
/// [IndexList].
///
/// The [IndexList] define how the vertices in the [VertexArray] are to be
/// combined into a sequence of geometry primitives (points, lines or
/// triangles).
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
  /// The [VertexArray] on which this [IndexGeometry] is defined.
  VertexArray get vertices;

  /// The indices describing how the [vertices] are combined into geometry
  /// primitives.
  Uint16List get indices;
}
