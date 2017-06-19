part of bagl.geometry;

/// Point vertex geometry primitive.
///
/// A point is defined by a single [vertex].
///
/// See also [Line] and [Triangle].
class Point {
  /// The vertex for the point.
  final Vertex vertex;

  /// Instantiates a new [Point].
  Point(this.vertex);
}

/// Line vertex geometry primitive.
///
/// A line is defined by two vertices: the [start] vertex and the [end] vertex.
/// Typically describes a line segment between these vertices. More complex
/// paths are typically described by multiple lines that share vertices (e.g.
/// the first line's ending vertex is the second line's starting vertex).
///
/// See also [Point] and [Triangle].
class Line {
  /// The line's starting vertex.
  final Vertex start;

  /// The line's ending vertex.
  final Vertex end;

  /// Instantiates a new [Line].
  Line(this.start, this.end);
}

/// Triangle vertex geometry primitive.
///
/// A triangle is defined by three vertices: vertex [a], vertex [b] and vertex
/// [c]. Typically describes a surface between these vertices. More complex
/// surfaces are typically described by multiple triangles that share vertices
/// (e.g. vertices [b] and [c] on the first triangle are the same vertices as
/// vertices [a] and [b] on the second triangle).
///
/// See also [Point] and [Line].
class Triangle {
  /// The triangle's first vertex.
  final Vertex a;

  /// The triangle's second vertex.
  final Vertex b;

  /// The triangle's third vertex.
  final Vertex c;

  /// Instantiates a new [Triangle].
  Triangle(this.a, this.b, this.c);
}
