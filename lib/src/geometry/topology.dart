part of geometry;

/// Enumerates the ways in which a sequence of vertices connected into a
/// sequence of geometry primitives.
///
/// See the corresponding [PrimitiveSequence] implementations for details on
/// how each of these topologies connect vertices:
///
/// - [points]: [Points].
/// - [lines]: [Lines].
/// - [lineStrip]: [LineStrip].
/// - [lineLoop]: [LineLoop].
/// - [triangles]: [Triangles].
/// - [triangleStrip]: [TriangleStrip].
/// - [triangleFan]: [TriangleFan].
///
enum Topology {
  points,
  lines,
  lineStrip,
  lineLoop,
  triangles,
  triangleStrip,
  triangleFan
}
