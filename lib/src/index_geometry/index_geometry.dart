part of index_geometry;

/// Enumerates the ways in which a sequence of vertices can be turned into a
/// sequence of geometry primitives.
enum Topology {
  points,
  lines,
  lineStrip,
  lineLoop,
  triangles,
  triangleStrip,
  triangleFan
}

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
  /// The [Topology] for this [IndexGeometry].
  Topology get topology;

  /// The [VertexArray] on which this [IndexGeometry] is defined.
  VertexArray get vertices;

  /// The indices describing how the [vertices] are combined into geometry
  /// primitives.
  Uint16List get indices;

  /// The number of indices to skip at the start of the [indices] list before
  /// the values for this [IndexGeometry] begin.
  int get offset;
}
