part of vertex_data;

class BufferedVertexCollection extends IterableBase<BufferedVertexView>
    implements IndexedVertexCollection {
  final Map<String, VertexAttribute> attributes;

  Map<String, VertexAttributePointer> _attributePointerMap;

  factory BufferedVertexCollection(Iterable<Vertex> vertices) =>
      new BufferedVertexCollection.fromAttributeValueMaps(vertices.map((v) => v.toMap()));

  BufferedVertexCollection.fromAttributeData(this.attributes);

  /// Instantiates a new [BufferedVertexCollection] from a collection of
  /// attribute-value maps.
  ///
  /// Allows creating a new [BufferedVertexCollection] without needing a
  /// concrete implementation of [Vertex]:
  ///
  ///     var vertices = new BufferedVertexCollection.fromAttributeValueMaps([
  ///       {
  ///         position: new Vertex2(0.0, 1.0),
  ///         color: new Vertex3(1.0, 0.0, 0.0)
  ///       },
  ///       {
  ///         position: new Vertex2(-1.0, -1.0),
  ///         color: new Vertex3(0.0, 1.0, 0.0)
  ///       },
  ///       {
  ///         position: new Vertex2(1.0, -1.0),
  ///         color: new Vertex3(0.0, 0.0, 1.0)
  ///       }
  ///     ]);
  ///
  /// Every attribute-value map must define the same attributes and the value
  /// types for a particular attribute must be the same. Valid value types are:
  /// [double], [Vertex2], [Vertex3], [Vertex4], [Matrix2], [Matrix3] and
  /// [Matrix4].
  ///
  /// Throws an [ArgumentError] when the [attributeValueMaps] collection is
  /// empty.
  /// Throws an [ArgumentError] when an attribute value is not of a valid type.
  /// Throws an [ArgumentError] when an attribute-value map defines attributes
  /// that are not consistent with the attributes defined other attribute-value
  /// maps.
  factory BufferedVertexCollection.fromAttributeValueMaps(
      Iterable<Map<String, dynamic>> attributeValueMaps) {
    if (attributeValueMaps.isEmpty) {
      throw new ArgumentError(
          'Cannot instantiate a BufferedVertexCollection from an empty '
          'collection of vertices.');
    }

    // Create empty attribute data frame with the correct dimensions
    final rowLength = attributeValueMaps.first.values.fold(0, (a, value) {
      if (value is double) {
        return a + 1;
      } else if (value is Vector2) {
        return a + 2;
      } else if (value is Vector3) {
        return a + 3;
      } else if (value is Vector4) {
        return a + 4;
      } else if (value is Matrix2) {
        return a + 4;
      } else if (value is Matrix3) {
        return a + 9;
      } else if (value is Matrix4) {
        return a + 16;
      } else {
        throw new ArgumentError(
            '"${value.runtimeType}" is not a valid type for a vertex '
            'attribute. Valid types are: double, Vector2, Vector3, Vector4, '
            'Matrix2, Matrix3, Matrix4.');
      }
    });
    final data = new Float32List(rowLength * attributeValueMaps.length);
    final frame = new AttributeDataFrame(rowLength, data);

    // Define attributes on the attribute data frame
    final attributes = new Map<String, VertexAttribute>();
    var offset = 0;

    attributeValueMaps.first.forEach((name, value) {
      if (value is double) {
        attributes[name] = new FloatAttribute(frame, offset: offset);
        offset += 1;
      } else if (value is Vector2) {
        attributes[name] = new Vector2Attribute(frame, offset: offset);
        offset += 2;
      } else if (value is Vector3) {
        attributes[name] = new Vector3Attribute(frame, offset: offset);
        offset += 3;
      } else if (value is Vector4) {
        attributes[name] = new Vector4Attribute(frame, offset: offset);
        offset += 4;
      } else if (value is Matrix2) {
        attributes[name] = new Matrix2Attribute(frame, offset: offset);
        offset += 4;
      } else if (value is Matrix3) {
        attributes[name] = new Matrix3Attribute(frame, offset: offset);
        offset += 9;
      } else if (value is Matrix4) {
        attributes[name] = new Matrix4Attribute(frame, offset: offset);
        offset += 16;
      } else {
        throw new ArgumentError(
            'The vertex at position 0 sets attribute "$name" to value '
            '"$value", but this is not a valid value type for a vertex '
            'attribute. Valid types are: double, Vector2, Vector3, Vector4, '
            'Matrix2, Matrix3, Matrix4.');
      }
    });

    // Fill the frame with the attribute data
    final attributesLength = attributes.length;
    var counter = 0;

    for (var attributeValueMap in attributeValueMaps) {
      if (attributeValueMap.length != attributesLength) {
        throw new ArgumentError(
            'The vertex at position $counter defines '
            '${attributeValueMap.length}, whereas the vertex at position 0 '
            'defines $attributesLength attributes. Each vertex after the first '
            'must define the same attributes.');
      }

      attributes.forEach((name, attribute) {
        final value = attributeValueMap[name];

        if (value == null) {
          throw new ArgumentError(
              'The vertex at position 0 defines an attribute named $name, but '
              'the vertex at position does not define an attribute with this '
              'name. Each vertexafter the first must define the same '
              'attributes.');
        } else {
          attribute.setValueAtRow(0, value);
        }
      });

      counter++;
    }

    return new BufferedVertexCollection.fromAttributeData(attributes);
  }

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

  int indexOf(Vertex vertex) {
    if (vertex is BufferedVertexView && vertex._vertexCollection == this) {
      return vertex._index;
    } else {
      return -1;
    }
  }

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

  Map<String, dynamic> toMap() {
    final map = new Map();

    attributeNames.forEach((attribute) {
      map[attribute] = this[attribute];
    });

    return map;
  }

  operator [](String attributeName) =>
      _vertexCollection.attributes[attributeName].extractValueAtRow(_index);

  void operator []=(String attributeName, value) {
    _vertexCollection.attributes[attributeName].setValueAtRow(_index, value);
  }
}
