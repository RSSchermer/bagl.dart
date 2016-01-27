part of geometry;

class Triangles extends IterableBase<TrianglesTriangleView> {
  final IndexedVertexCollection vertices;

  /// The index data as a typed [UInt16List] view on the data buffer.
  final Uint16List indexData;

  final int length;

  factory Triangles(IndexedVertexCollection vertices) {
    final length = vertices.length;
    final indexData = new Uint16List(length);

    for (var i = 0; i < length; i++) {
      indexData[i] = i;
    }

    return new Triangles.fromUint16IndexData(vertices, indexData);
  }

  Triangles.fromIndexData(IndexedVertexCollection vertices, List<int> indexData)
      : this.fromUint16IndexData(vertices, new Uint16List.fromList(indexData));

  Triangles.fromUint16IndexData(this.vertices, Uint16List indexData)
      : indexData = indexData,
        length = indexData.length ~/ 3 {
    if (indexData.length % 3 != 0) {
      throw new ArgumentError(
          'The length of the indexData list must be a multiple of 3.');
    }
  }

  TrianglesIterator get iterator => new TrianglesIterator(this);

  TrianglesTriangleView elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return new TrianglesTriangleView(this, index);
  }

  TrianglesTriangleView operator [](int index) => elementAt(index);
}

class TrianglesIterator extends Iterator<TrianglesTriangleView> {
  final Triangles triangles;

  int _trianglesLength;

  int _currentTriangleIndex = -1;

  /// Instantiates a new iterator of the rows in the given attribute data frame.
  TrianglesIterator(Triangles triangles)
      : triangles = triangles,
        _trianglesLength = triangles.length;

  TrianglesTriangleView get current {
    if (_currentTriangleIndex >= 0 &&
        _currentTriangleIndex < _trianglesLength) {
      return new TrianglesTriangleView(triangles, _currentTriangleIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentTriangleIndex++;

    return _currentTriangleIndex < _trianglesLength;
  }
}

class TrianglesTriangleView extends Triangle {
  final Triangles _triangles;

  final int _index;

  final int _offset;

  final IndexedVertexCollection _vertices;

  final Uint16List _indexData;

  TrianglesTriangleView(Triangles triangles, int index)
      : _triangles = triangles,
        _index = index,
        _offset = index * 3,
        _vertices = triangles.vertices,
        _indexData = triangles.indexData;

  int get aIndex => _indexData[_offset];
  int get bIndex => _indexData[_offset + 1];
  int get cIndex => _indexData[_offset + 1];

  void set aIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indexData[_offset] = index;
  }

  void set bIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indexData[_offset + 1] = index;
  }

  void set cIndex(int index) {
    RangeError.checkValidIndex(index, _vertices);

    _indexData[_offset + 2] = index;
  }

  Vertex get a => _vertices[aIndex];
  Vertex get b => _vertices[bIndex];
  Vertex get c => _vertices[cIndex];

  void set a(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex collection on which this '
          'triangle is defined.');
    } else {
      aIndex = vertexIndex;
    }
  }

  void set b(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex collection on which this '
          'triangle is defined.');
    } else {
      bIndex = vertexIndex;
    }
  }

  void set c(Vertex vertex) {
    final vertexIndex = _vertices.indexOf(vertex);

    if (vertexIndex == -1) {
      throw new ArgumentError(
          'The vertex was not found in the vertex collection on which this '
          'triangle is defined.');
    } else {
      cIndex = vertexIndex;
    }
  }
}
