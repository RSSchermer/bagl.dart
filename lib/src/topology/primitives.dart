part of geometry;

abstract class Point {
  Vertex get vertex;
}

abstract class LineSegment {
  Vertex get start;

  Vertex get end;
}

abstract class Triangle {
  Vertex get a;

  Vertex get b;

  Vertex get c;
}
