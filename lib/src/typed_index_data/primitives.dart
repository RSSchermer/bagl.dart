part of typed_index_data;

abstract class Point {
  Vertex get vertex;
}

abstract class LineSegment {
  Vertex get vertexOne;

  Vertex get vertexTwo;
}

abstract class Triangle {
  Vertex get vertexOne;

  Vertex get vertexTwo;

  Vertex get vertexThree;
}
