part of vertex_data;

/// Defines an [IndexedVertexCollection] as a view on buffered attribute data.
///
/// Changes to the buffered attribute data will change the vertices in this
/// collection and vice versa.
///
/// A [BufferedVertexCollection] can be instantiated a collection of vertices:
///
///     var vertices = new BufferedVertexCollection([
///       new Vertex({
///         'position': new Vector2(0.0, 1.0),
///         'color': new Vector3(1.0, 0.0, 0.0)
///       }),
///       new Vertex({
///         'position': new Vector2(-1.0, -1.0),
///         'color': new Vector3(0.0, 1.0, 0.0)
///       }),
///       new Vertex({
///         'position': new Vector2(1.0, -1.0),
///         'color': new Vector3(0.0, 0.0, 1.0)
///       })
///     ]);
///
/// A [BufferedVertexCollection] can also be instantiated from
/// [VertexAttribute]s defined on [AttributeDataFrame]s:
///
///     var attributeData = new AttributeDataFrame(5, [
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ]);
///
///     var vertices = new BufferedVertexCollection.fromAttributeData({
///       'position': new Vector2Attribute(attributeData),
///       'color': new Vector3Attribute(attributeData, offset: 2)
///     });
///
/// Note that for large collections of vertices, instantiating a
/// [BufferedVertexCollection] directly from attribute data may be more
/// efficient than instantiating a [BufferedVertexCollection] from a collection
/// of vertices.
///
/// It is not possible to replace a vertex in a [BufferedVertexCollection].
/// However, it is possible to modify individual attributes of individual
/// vertices. One might for example change the 'position' of the vertex at index
/// 2:
///
///     vertices[2]['position'] = new Vector2(0.5, 0.5);
///
/// This will update the buffered attribute data.
///
/// Vertices may not be added or removed from a [BufferedVertexCollection].
/// However, `toBuilder()` may be called to create a new instance as a modified
/// version of the [BufferedVertexCollection]:
///
///     var modified = vertices.toBuilder()
///         ..omit(someVertex)
///         ..appendAll(newVertices)
///         .build();
///
/// See [BufferedVertexCollectionBuilder] for further details on using the
/// builder to create a new modified version of a [BufferedVertexCollection].
class BufferedVertexCollection extends IterableBase<BufferedVertexView>
    implements IndexedVertexCollection {
  /// Map of the [VertexAttribute]s defined on the buffered vertex data, keyed
  /// by the attribute names.
  final Map<String, VertexAttribute> attributes;

  final int length;

  /// Instantiates a new [BufferedVertexCollection] from a collection of
  /// vertices.
  ///
  /// Every vertex map must define the same attributes and the value types for
  /// a particular attribute must be the same across all vertices.
  ///
  /// This will create a single new byte buffer which stores the attribute
  /// values of the vertices as interleaved data (as opposed to creating
  /// multiple byte buffers each storing a single attribute).
  ///
  ///     var vertices = new BufferedVertexCollection([
  ///       new Vertex({
  ///         'position': new Vector2(0.0, 1.0),
  ///         'color': new Vector3(1.0, 0.0, 0.0)
  ///       }),
  ///       new Vertex({
  ///         'position': new Vector2(-1.0, -1.0),
  ///         'color': new Vector3(0.0, 1.0, 0.0)
  ///       }),
  ///       new Vertex({
  ///         'position': new Vector2(1.0, -1.0),
  ///         'color': new Vector3(0.0, 0.0, 1.0)
  ///       })
  ///     ]);
  ///
  /// Throws an [ArgumentError] when the [vertices] collection is empty.
  /// Throws an [ArgumentError] when a vertex defines attributes that are not
  /// consistent with the attributes defined on preceding vertices.
  factory BufferedVertexCollection(Iterable<Vertex> vertices) {
    if (vertices.isEmpty) {
      throw new ArgumentError(
          'Cannot instantiate a BufferedVertexCollection from an empty '
          'collection of vertices.');
    }

    // If the vertex collection is a buffered vertex collection, return a copy.
    if (vertices is BufferedVertexCollection) {
      return vertices.subCollection(0);
    }

    final firstVertexAttributes = vertices.first.toMap();

    // Create empty attribute data frame with the correct dimensions
    var rowLength = 0;

    firstVertexAttributes.forEach((name, value) {
      if (value is double) {
        rowLength += 1;
      } else if (value is Vector2) {
        rowLength += 2;
      } else if (value is Vector3) {
        rowLength += 3;
      } else if (value is Vector4) {
        rowLength += 4;
      } else if (value is Matrix2) {
        rowLength += 4;
      } else if (value is Matrix3) {
        rowLength += 9;
      } else if (value is Matrix4) {
        rowLength += 16;
      } else {
        throw new ArgumentError(
            'The vertex at position 0 sets attribute "$name" to value "$value" '
            'of type "${value.runtimeType}", but this is not a valid value '
            'type for a vertex attribute. Valid value types are: double, '
            'Vector2, Vector3, Vector4, Matrix2, Matrix3, Matrix4.');
      }
    });

    final data = new Float32List(rowLength * vertices.length);
    final frame = new AttributeDataFrame(rowLength, data);

    // Define attributes on the attribute data frame
    final attributes = new Map<String, VertexAttribute>();
    var offset = 0;

    firstVertexAttributes.forEach((name, value) {
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
            '"$value" of type "${value.runtimeType}", but this is not a valid '
            'value type for a vertex attribute. Valid value types are: double, '
            'Vector2, Vector3, Vector4, Matrix2, Matrix3, Matrix4.');
      }
    });

    // Fill the frame with the attribute data
    final attributesLength = attributes.length;
    var counter = 0;

    for (var vertex in vertices) {
      if (vertex.attributeNames.length != attributesLength) {
        throw new ArgumentError('The vertex at position $counter defines '
            '${vertex.attributeNames.length} attributes, whereas the preceding'
            'vertices at define $attributesLength attributes. All vertices '
            'must define the same attributes.');
      }

      attributes.forEach((name, attribute) {
        final value = vertex[name];

        if (value == null) {
          throw new ArgumentError(
              'The vertex at position $counter does not define an attribute '
              'named "$name", whereas the preceding vertices do. All vertices '
              'must define the same attributes.');
        } else {
          try {
            attribute.setValueAtRow(counter, value);
          } on TypeError {
            throw new ArgumentError(
                'The vertex at position $counter declares the attribute named '
                '"$name" to have value "$value" of type '
                '"${value.runtimeType}", but this value type is not consistent '
                'with the value type used by preceding vertices for this '
                'attribute. All vertices must use a consistent value type for '
                'an attribute.');
          }
        }
      });

      counter++;
    }

    return new BufferedVertexCollection.fromAttributeData(attributes);
  }

  /// Instantiates a new [BufferedVertexCollection] from one or more
  /// [VertexAttributes] defined on one or more [AttributeDataFrame]s.
  ///
  /// The attribute data for multiple attributes may be interleaved in a single
  /// [AttributeDataFrame]:
  ///
  ///     var attributeData = new AttributeDataFrame(5, [
  ///        // Position    // Color
  ///        0.0,  0.5,     1.0, 0.0, 0.0,
  ///       -0.5, -0.5,     0.0, 1.0, 0.0,
  ///        0.5, -0.5,     0.0, 0.0, 1.0
  ///     ]);
  ///
  ///     var vertices = new BufferedVertexCollection.fromAttributeData({
  ///       'position': new Vector2Attribute(attributeData),
  ///       'color': new Vector3Attribute(attributeData, offset: 2)
  ///     });
  ///
  /// Note that attributes might have to specify an `offset` if the offset of
  /// the attribute in a row is not 0.
  ///
  /// The attribute data may also be spread over multiple attribute data frames,
  /// for example one for each attribute:
  ///
  ///     var positionData = new AttributeDataFrame(2, [
  ///        0.0,  0.5,
  ///       -0.5, -0.5,
  ///        0.5, -0.5
  ///     ]);
  ///
  ///     var colorData = new AttributeDataFrame(3, [
  ///       1.0, 0.0, 0.0,
  ///       0.0, 1.0, 0.0,
  ///       0.0, 0.0, 1.0
  ///     ]);
  ///
  ///     var vertices = new BufferedVertexCollection.fromAttributeData({
  ///       'position': new Vector2Attribute(positionData),
  ///       'color': new Vector3Attribute(colorData)
  ///     });
  ///
  /// This allows different objects to share data on specific attributes. For
  /// example, two objects might share the same position data, but each uses
  /// different color data.
  BufferedVertexCollection.fromAttributeData(Map<String, VertexAttribute> attributes)
      : attributes = attributes,
        length = attributes.values.first.frame.length {
    attributes.forEach((name, attribute) {
      if (attribute.frame.length != length) {
        throw new ArgumentError(
            'The attribute named "$name" is defined on a frame of a different '
            'length than the attribute named "${attributes.keys.first}". All '
            'attributes must be defined on frames of equal length.');
      }
    });
  }

  Iterator<BufferedVertexView> get iterator =>
      new BufferedVertexCollectionIterator(this);

  Iterable<String> get attributeNames => attributes.keys;

  bool hasAttribute(String name) => attributes.containsKey(name);

  Set<AttributeDataFrame> get attributeDataFrames =>
      attributes.values.map((attribute) => attribute.frame).toSet();

  BufferedVertexView elementAt(int index) => this[index];

  int indexOf(Vertex vertex) {
    if (vertex is BufferedVertexView && vertex.vertexCollection == this) {
      return vertex.index;
    } else {
      return -1;
    }
  }

  BufferedVertexCollection subCollection(int start, [int end]) {
    RangeError.checkValidIndex(start, this);
    RangeError.checkValidRange(start, end, length);

    // Create map of old frames to corresponding new frames.
    final oldNewFrameMap = new Map<AttributeDataFrame, AttributeDataFrame>();

    attributeDataFrames.forEach((frame) {
      oldNewFrameMap[frame] = frame.subFrame(start, end ?? length);
    });

    // Create new attribute map on the new frames
    final newAttributeMap = new Map<String, VertexAttribute>();

    attributes.forEach((name, oldAttribute) {
      final newFrame = oldNewFrameMap[oldAttribute.frame];

      newAttributeMap[name] = oldAttribute.onFrame(newFrame);
    });

    return new BufferedVertexCollection.fromAttributeData(newAttributeMap);
  }

  BufferedVertexCollectionBuilder toBuilder() =>
      new BufferedVertexCollectionBuilder.fromBaseCollection(this);

  BufferedVertexView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new BufferedVertexView(this, index);
  }
}

/// Iterator over the vertices in a [BufferedVertexCollection].
class BufferedVertexCollectionIterator extends Iterator<BufferedVertexView> {
  final BufferedVertexCollection _vertexCollection;

  final int _vertexCollectionLength;

  int _currentIndex = -1;

  /// Instantiates a new [BufferedVertexCollection] iterator of the given
  /// [vertexCollection].
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

/// A [Vertex] as a view on the attribute data of a [BufferedVertexCollection].
///
/// Modifying the attributes of a [BufferedVertexView] will affect the
/// buffered attribute data of the [BufferedVertexCollection] and vice versa.
class BufferedVertexView implements Vertex {
  final BufferedVertexCollection vertexCollection;

  final int index;

  /// Instantiates a new [BufferedVertexView] as a view on the vertex in the
  /// given [BufferedVertexCollection] at the given index.
  BufferedVertexView(this.vertexCollection, this.index);

  Iterable<String> get attributeNames => vertexCollection.attributeNames;

  bool hasAttribute(String name) => vertexCollection.hasAttribute(name);

  Iterable<dynamic> get attributeValues => attributeNames.map(
      (name) => vertexCollection.attributes[name].extractValueAtRow(index));

  Map<String, dynamic> toMap() {
    final map = new Map();

    attributeNames.forEach((attribute) {
      map[attribute] = this[attribute];
    });

    return map;
  }

  operator [](String attributeName) =>
      vertexCollection.attributes[attributeName].extractValueAtRow(index);

  /// Sets attribute with the specified [attributeName] to the given [value].
  ///
  /// Can only be used to change existing attributes, not the add new attributes
  /// to the vertex. The [value] must match the type of the attribute's current
  /// value.
  ///
  /// Throws an [ArgumentError] if the vertex does not define an attribute with
  /// the given [attributeName].
  /// Throws an [ArgumentError] if the [value] is not of a valid type.
  void operator []=(String attributeName, value) {
    vertexCollection.attributes[attributeName].setValueAtRow(index, value);
  }
}

/// Builds a [BufferedVertexCollection].
///
/// Simplifies the creation of a [BufferedVertexCollection], particularly when
/// the aim is to create a modified instance of an existing
/// [BufferedVertexCollection]:
///
///     var modified =
///       new BufferedVertexCollectionBuilder.fromBaseCollection(baseCollection)
///           ..omit(someVertex)
///           ..appendAll(newVertices)
///           .build();
///
/// Alternatively, `toBuilder()` can be called on the existing
/// [BufferedVertexCollection]:
///
///     var modified = baseCollection.toBuilder()
///         ..omit(someVertex)
///         ..appendAll(newVertices)
///         .build();
///
class BufferedVertexCollectionBuilder
    implements IndexedVertexCollectionBuilder {
  /// The base collection used as the starting point by the builder.
  final BufferedVertexCollection baseCollection;

  final List<Vertex> _appendedVertices = new List();

  final List<int> _omittedVertexIndices = new List();

  /// Instantiates a new [BufferedVertexCollectionBuilder].
  BufferedVertexCollectionBuilder() : baseCollection = null;

  /// Instantiates a new [BufferedVertexCollectionBuilder] using an existing
  /// [BufferedVertexCollection] as a base.
  BufferedVertexCollectionBuilder.fromBaseCollection(this.baseCollection);

  void append(Vertex vertex) {
    _appendedVertices.add(vertex);
  }

  void appendAll(Iterable<Vertex> vertices) {
    _appendedVertices.addAll(vertices);
  }

  bool omit(Vertex vertex) {
    if (baseCollection != null &&
        vertex is BufferedVertexView &&
        vertex.vertexCollection == baseCollection) {
      _omittedVertexIndices.add(vertex.index);

      return true;
    } else {
      return false;
    }
  }

  void omitAt(int index) {
    if (baseCollection == null) {
      throw new UnsupportedError(
          'Can only call omitAt when the builder was given a base collection.');
    } else {
      RangeError.checkValidIndex(index, baseCollection);

      _omittedVertexIndices.add(index);
    }
  }

  void omitAll(Iterable<Vertex> vertices) {
    if (baseCollection != null) {
      vertices.forEach((vertex) {
        if (vertex is BufferedVertexView &&
            vertex.vertexCollection == baseCollection) {
          _omittedVertexIndices.add(vertex.index);
        }
      });
    }
  }

  BufferedVertexCollection build() {
    if (baseCollection == null) {
      return new BufferedVertexCollection(_appendedVertices);
    } else {
      // Currently this algorithm creates the new data buffers in two steps:
      // first an intermediate buffer is created where the omitted vertices
      // are removed from the base collection, then the final data buffer is
      // created where the appended vertices are added at the tail. A possible
      // optimization would be to do this in a single step, without creating
      // an intermediate data buffer, although this might not be a significant
      // optimization.

      final appendCount = _appendedVertices.length;

      // Create map of old frames to corresponding new frames.
      final oldNewFrameMap = new Map<AttributeDataFrame, AttributeDataFrame>();

      baseCollection.attributeDataFrames.forEach((frame) {
        final appendedData = new Float32List(frame.rowLength * appendCount);

        oldNewFrameMap[frame] = frame
            .withoutRows(_omittedVertexIndices)
            .withAppendedData(appendedData);
      });

      // Create new attribute map on the new frames
      final newAttributeMap = new Map<String, VertexAttribute>();

      baseCollection.attributes.forEach((name, oldAttribute) {
        final newFrame = oldNewFrameMap[oldAttribute.frame];

        newAttributeMap[name] = oldAttribute.onFrame(newFrame);
      });

      // Create new vertex collection
      final vertices =
          new BufferedVertexCollection.fromAttributeData(newAttributeMap);

      // Set the attribute data for the appended vertices
      var currentRow = baseCollection.length + 1;

      _appendedVertices.forEach((vertex) {
        newAttributeMap.forEach((name, attribute) {
          if (!vertex.hasAttribute(name)) {
            throw new StateError(
                'Tried to append a vertex to a buffered vertex collection, but '
                'the vertex does not the define an attribute named $name. '
                'Vertices appended to a buffered vertex collection must define '
                'the same attributes as the vertices in the buffered vertex '
                'collection.');
          } else {
            attribute.setValueAtRow(currentRow, vertex[name]);
          }

          currentRow++;
        });
      });

      return vertices;
    }
  }
}
