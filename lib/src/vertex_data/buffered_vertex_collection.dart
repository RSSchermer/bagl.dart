part of vertex_data;

class BufferedVertexCollection extends IterableBase<BufferedVertexView>
    implements IndexedVertexCollection {
  final Map<String, VertexAttribute> attributes;

  Map<String, VertexAttributePointer> _attributePointerMap;

  BufferedVertexCollection.fromAttributeData(this.attributes);

  Iterator<BufferedVertexView> get iterator =>
      new BufferedVertexCollectionIterator(this);

  Iterable<String> get attributeNames => attributes.keys;

  bool hasAttribute(String name) => attributes.containsKey(name);

  Map<String, VertexAttributePointer> get attributePointerMap {
    if (_attributePointerMap != null) {
      return _attributePointerMap;
    }

    _attributePointerMap = new Map<String, VertexAttributePointer>();

    attributes.forEach((name, attribute) {
      final size = attribute.sizeInBytes;
      final stride = attribute.frame.elementSizeInBytes - size;
      final offset = attribute.frame.offsetInBytes + attribute.offsetInBytes;

      _attributePointerMap[name] = new VertexAttributePointer(
          attribute.frame.buffer, size, stride, offset);
    });

    return _attributePointerMap;
  }

  BufferedVertexView elementAt(int index) => this[index];

  BufferedVertexView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new BufferedVertexView(this, index);
  }
}

class BufferedVertexCollectionIterator extends Iterator<BufferedVertexView> {
  final BufferedVertexCollection _vertexCollection;

  final int _vertexCollectionLength;

  int _currentIndex = -1;

  BufferedVertexCollectionIterator(BufferedVertexCollection vertexCollection)
      : _vertexCollection = vertexCollection,
        _vertexCollectionLength = vertexCollection.length;

  BufferedVertexView get current {
    if (_currentIndex >= 0 && _currentIndex < _vertexCollectionLength) {
      return new BufferedVertexView(_vertexCollection, _currentIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentIndex++;

    return _currentIndex < _vertexCollectionLength;
  }
}

class BufferedVertexView extends Vertex {
  final BufferedVertexCollection _vertexCollection;

  final int _index;

  BufferedVertexView(this._vertexCollection, this._index);

  Iterable<String> get attributeNames => _vertexCollection.attributeNames;

  bool hasAttribute(String name) => _vertexCollection.hasAttribute(name);

  Iterable<dynamic> get attributeValues => attributeNames.map(
      (name) => _vertexCollection.attributes[name].extractValueAtRow(_index));

  operator [](String attributeName) =>
      _vertexCollection.attributes[attributeName].extractValueAtRow(_index);

  void operator []=(String attributeName, value) {
    _vertexCollection.attributes[attributeName].setValueAtRow(_index, value);
  }
}
