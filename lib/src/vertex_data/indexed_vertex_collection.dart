part of vertex_data;

abstract class IndexedVertexCollection extends Iterable<Vertex> {
  Iterable<String> get attributeNames;

  bool hasAttribute(String name);

  Map<String, VertexAttributePointer> get attributePointerMap;

  Vertex operator [](int index);
}
