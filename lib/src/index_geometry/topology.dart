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
