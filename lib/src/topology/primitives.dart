part of topology;

/// Point vertex topology primitive.
///
/// A point is defined by a single [vertex].
///
/// See also [Points].
abstract class Point {
  /// The vertex that defines the point.
  Vertex get vertex;
}

/// Line vertex topology primitive.
///
/// A line is defined by two vertices: the [start] vertex and the
/// [end] vertex. Typically describes a line segment between these vertices.
/// More complex lines are typically described by multiple lines sharing the
/// same vertex (e.g. the first line's ending vertex is the second line's
/// starting vertex).
///
/// See also [Lines], [LineStrip] and [LineLoop].
abstract class Line {
  /// The line's starting vertex.
  Vertex get start;

  /// The line's ending vertex.
  Vertex get end;
}

/// Triangle vertex topology primitive.
///
/// A triangle is defined by three vertices: vertex [a], vertex [b] and vertex
/// [c]. Typically describes a surface between these vertices. More complex
/// surfaces are typically described by multiple triangles that each share 2
/// vertices with at least one other triangle (e.g. vertices b and c on the
/// first triangle are the same vertices as vertices a and b on the second
/// triangle).
///
/// See also [Triangles], [TriangleStrip] and [TriangleFan].
abstract class Triangle {
  /// The triangle's first vertex.
  Vertex get a;

  /// The triangle's second vertex.
  Vertex get b;

  /// The triangle's third vertex.
  Vertex get c;
}
