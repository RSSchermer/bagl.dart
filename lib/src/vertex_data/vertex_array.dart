part of vertex_data;

/// A sequence of vertices as a view on one or more [AttributeDataTable]s.
///
/// Vertices are ordered and uniquely identified by consecutive integer indices
/// starting at 0.
///
/// A [VertexArray] can be instantiated from a collection of vertices:
///
///     var vertices = new VertexArray([
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
/// This will create a single new [AttributeDataTable] in which each row stores
/// the attribute values of a vertex as interleaved attribute data.
///
/// A [VertexArray] can also be instantiated from [VertexAttribute]s:
///
///     var attributeData = new AttributeDataTable(5, [
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ]);
///
///     var vertices = new VertexArray.fromAttributes({
///       'position': new Vector2Attribute(attributeData),
///       'color': new Vector3Attribute(attributeData, offset: 2)
///     });
///
/// Note that for large collections of vertices, instantiating a [VertexArray]
/// from attributes may be more efficient than instantiating a [VertexArray]
/// from a collection of vertices.
///
/// It is not possible to replace a vertex in a [VertexArray]. However, it is
/// possible to update the value of individual attribute a vertex in a
/// [VertexArray]. One might for example change the `position` value of the
/// vertex at index 2:
///
///     vertices[2]['position'] = new Vector2(0.5, 0.5);
///
/// Vertices may not be added or removed from a [VertexArray]. However,
/// `toBuilder()` may be called to create a new [VertexArrayBuilder] instance,
/// which may be used to create new [VertexArray] instances as modified versions
/// of the current [VertexArray]. The builder will use this [VertexArray] as a
/// base. The builder can be instructed to omit or append vertices for the new
/// instances it builds:
///
///     var modified = vertices.toBuilder()
///         ..omit(someVertex)
///         ..appendAll(newVertices)
///         .build();
///
/// See [VertexArrayBuilder] for further details on using the builder.
class VertexArray extends IterableBase<VertexArrayVertexView> {
  /// Map of the [VertexAttribute]s defined on the attribute data, keyed by the
  /// attribute names.
  final Map<String, VertexAttribute> attributes;

  final int length;

  /// Instantiates a new [VertexArray] from a collection of vertices.
  ///
  /// Every vertex map must define the same attributes and the value type for
  /// each particular attribute must be the same for all vertices.
  ///
  ///     var vertices = new VertexArray([
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
  /// This will create a single new [AttributeDataTable] which stores the
  /// attribute values of the vertices as interleaved data.
  ///
  /// Optionally, the [dynamic] parameter may be specified. When `true` it
  /// signals to the rendering back-end that the attribute data is intended to
  /// be modified regularly, allowing the rendering back-end to optimize for
  /// this. The default value is `false`. Note that this is merely a hint that
  /// can be used for tuning the performance of a rendering back-end: attribute
  /// data that is not marked as dynamic may still be modified.
  ///
  /// Throws an [ArgumentError] when the [vertices] collection is empty.
  ///
  /// Throws an [ArgumentError] when a vertex defines attributes that are not
  /// consistent with the attributes defined on preceding vertices.
  factory VertexArray(Iterable<Vertex> vertices, {bool dynamic: false}) {
    if (vertices.isEmpty) {
      throw new ArgumentError(
          'Cannot instantiate a VertexArray from an empty collection of '
          'vertices.');
    }

    // If the vertex collection is a VertexArray, return a copy.
    if (vertices is VertexArray) {
      return vertices.subArray(0);
    }

    final firstVertexAttributes = vertices.first.toMap();

    // Create empty attribute data table with the correct dimensions
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
    final table = new AttributeDataTable(rowLength, data, dynamic: dynamic);

    // Define attributes on the attribute data table
    final attributes = new Map<String, VertexAttribute>();
    var offset = 0;

    firstVertexAttributes.forEach((name, value) {
      if (value is double) {
        attributes[name] = new FloatAttribute(table, offset: offset);
        offset += 1;
      } else if (value is Vector2) {
        attributes[name] = new Vector2Attribute(table, offset: offset);
        offset += 2;
      } else if (value is Vector3) {
        attributes[name] = new Vector3Attribute(table, offset: offset);
        offset += 3;
      } else if (value is Vector4) {
        attributes[name] = new Vector4Attribute(table, offset: offset);
        offset += 4;
      } else if (value is Matrix2) {
        attributes[name] = new Matrix2Attribute(table, offset: offset);
        offset += 4;
      } else if (value is Matrix3) {
        attributes[name] = new Matrix3Attribute(table, offset: offset);
        offset += 9;
      } else if (value is Matrix4) {
        attributes[name] = new Matrix4Attribute(table, offset: offset);
        offset += 16;
      } else {
        throw new ArgumentError(
            'The vertex at position 0 sets attribute "$name" to value '
            '"$value" of type "${value.runtimeType}", but this is not a valid '
            'value type for a vertex attribute. Valid value types are: double, '
            'Vector2, Vector3, Vector4, Matrix2, Matrix3, Matrix4.');
      }
    });

    // Fill the table with the attribute data
    final attributesLength = attributes.length;
    var counter = 0;

    for (var vertex in vertices) {
      if (vertex.attributeNames.length != attributesLength) {
        throw new ArgumentError('The vertex at position $counter defines '
            '${vertex.attributeNames.length} attributes, whereas the preceding'
            'vertices define $attributesLength attributes. All vertices must '
            'define the same attributes.');
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
                'with the value type used for this attribute by the preceding '
                'vertices. The value type for an attribute must be consistent'
                'for all vertices.');
          }
        }
      });

      counter++;
    }

    return new VertexArray.fromAttributes(attributes);
  }

  /// Instantiates a new [VertexArray] from one or more [VertexAttributes]
  /// defined on one or more [AttributeDataTable]s.
  ///
  /// The attribute data for multiple attributes may be interleaved in a single
  /// [AttributeDataTable]:
  ///
  ///     var attributeData = new AttributeDataTable(5, [
  ///        // Position    // Color
  ///        0.0,  0.5,     1.0, 0.0, 0.0,
  ///       -0.5, -0.5,     0.0, 1.0, 0.0,
  ///        0.5, -0.5,     0.0, 0.0, 1.0
  ///     ]);
  ///
  ///     var vertices = new VertexArray.fromAttributeData({
  ///       'position': new Vector2Attribute(attributeData),
  ///       'color': new Vector3Attribute(attributeData, offset: 2)
  ///     });
  ///
  /// Note that attributes might have to specify an `offset` if the offset of
  /// the attribute relative to the start of a row is not 0.
  ///
  /// The attribute data may also be spread over multiple [AttributeDataTable]s,
  /// for example one for each attribute:
  ///
  ///     var positionData = new AttributeDataTable(2, [
  ///        0.0,  0.5,
  ///       -0.5, -0.5,
  ///        0.5, -0.5
  ///     ]);
  ///
  ///     var colorData = new AttributeDataTable(3, [
  ///       1.0, 0.0, 0.0,
  ///       0.0, 1.0, 0.0,
  ///       0.0, 0.0, 1.0
  ///     ]);
  ///
  ///     var vertices = new VertexArray.fromAttributeData({
  ///       'position': new Vector2Attribute(positionData),
  ///       'color': new Vector3Attribute(colorData)
  ///     });
  ///
  /// This allows different objects to share data for specific attributes. For
  /// example: two objects might share the same position data, but each uses
  /// different color data.
  VertexArray.fromAttributes(Map<String, VertexAttribute> attributes)
      : attributes = attributes,
        length = attributes.values.first.attributeDataTable.length {
    attributes.forEach((name, attribute) {
      if (attribute.attributeDataTable.length != length) {
        throw new ArgumentError(
            'The attribute named "$name" is defined on an AttributeDataTable '
            'of a different length than the attribute named '
            '"${attributes.keys.first}". All attributes must be defined on '
            'AttributeDataTables of equal length.');
      }
    });
  }

  Iterator<VertexArrayVertexView> get iterator => new VertexArrayIterator(this);

  /// The names of the attributes defined for the vertices in this vertex array.
  Iterable<String> get attributeNames => attributes.keys;

  /// Returns `true` if an attribute with the given [name] is defined for the
  /// vertices in this vertex array, `false` otherwise.
  bool hasAttribute(String name) => attributes.containsKey(name);

  /// Returns the [AttributeDataTable]s that contain the attribute data for
  /// this vertex array.
  Set<AttributeDataTable> get attributeDataTables =>
      attributes.values.map((a) => a.attributeDataTable).toSet();

  VertexArrayVertexView elementAt(int index) => this[index];

  /// Returns the index of the given [vertex] in this vertex array.
  ///
  /// Returns -1 if [vertex] is not found in this vertex array.
  int indexOf(Vertex vertex) {
    if (vertex is VertexArrayVertexView && vertex.vertexArray == this) {
      return vertex.index;
    } else {
      return -1;
    }
  }

  /// Returns a new vertex array from [start] inclusive to [end] exclusive.
  ///
  /// If [end] is omitted, the [length] of this current vertex array is used as
  /// the default value.
  ///
  /// Throws an [ArgumentError] if [start] is outside of the range `0..length`
  /// or if [end] is outside of the range `start..length`.
  VertexArray subArray(int start, [int end]) {
    RangeError.checkValidIndex(start, this);
    RangeError.checkValidRange(start, end, length);

    // Create map of old tables to corresponding new tables.
    final oldNewTableMap = new Map<AttributeDataTable, AttributeDataTable>();

    attributeDataTables.forEach((table) {
      oldNewTableMap[table] = table.subTable(start, end ?? length);
    });

    // Create new attribute map on the new tables
    final newAttributeMap = new Map<String, VertexAttribute>();

    attributes.forEach((name, oldAttribute) {
      final newTable = oldNewTableMap[oldAttribute.attributeDataTable];

      newAttributeMap[name] = oldAttribute.onTable(newTable);
    });

    return new VertexArray.fromAttributes(newAttributeMap);
  }

  /// Returns a builder which can be used to create a modified version of this
  /// vertex array.
  ///
  ///     var modified = vertices.toBuilder()
  ///         ..omit(someVertex)
  ///         ..appendAll(newVertices)
  ///         .build();
  ///
  /// See [IndexedVertexCollectionBuilder].
  VertexArrayBuilder toBuilder() => new VertexArrayBuilder.fromBaseArray(this);

  /// Returns the vertex at the specified [index].
  ///
  /// Throws a [RangeError] when the [index] is out of bounds.
  VertexArrayVertexView operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new VertexArrayVertexView(this, index);
  }
}

/// Iterator over the vertices in a [VertexArray].
class VertexArrayIterator extends Iterator<VertexArrayVertexView> {
  final VertexArray _vertexArray;

  final int _vertexArrayLength;

  int _currentIndex = -1;

  /// Instantiates a new [VertexArrayIterator] over the given [VertexArray].
  VertexArrayIterator(VertexArray vertexArray)
      : _vertexArray = vertexArray,
        _vertexArrayLength = vertexArray.length;

  VertexArrayVertexView get current {
    if (_currentIndex >= 0 && _currentIndex < _vertexArrayLength) {
      return new VertexArrayVertexView(_vertexArray, _currentIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentIndex++;

    return _currentIndex < _vertexArrayLength;
  }
}

/// View on a vertex in a [VertexArray].
class VertexArrayVertexView implements Vertex {
  /// The [VertexArray] on which this [VertexArrayVertexView] is defined.
  final VertexArray vertexArray;

  /// The index of the vertex in the [vertexArray].
  final int index;

  /// Instantiates a new [VertexArrayVertexView] as a view on the vertex in the
  /// given [VertexArray] at the given [index].
  VertexArrayVertexView(this.vertexArray, this.index);

  Iterable<String> get attributeNames => vertexArray.attributeNames;

  bool hasAttribute(String name) => vertexArray.hasAttribute(name);

  Iterable<dynamic> get attributeValues => attributeNames
      .map((name) => vertexArray.attributes[name].extractValueAtRow(index));

  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();

    attributeNames.forEach((attribute) {
      map[attribute] = this[attribute];
    });

    return map;
  }

  operator [](String attributeName) =>
      vertexArray.attributes[attributeName]?.extractValueAtRow(index);

  /// Sets the attribute with the specified [attributeName] to the given
  /// [value].
  ///
  /// This will update the attribute data of the [VertexArray] viewed by this
  /// vertex view.
  ///
  /// Can only be used to update existing attributes, not to add new attributes
  /// to the vertex. The [value] must match the type of the attribute's current
  /// value.
  ///
  /// Throws an [ArgumentError] if the vertex does not define an attribute with
  /// the given [attributeName].
  ///
  /// Throws an [ArgumentError] if the [value] is not of a valid type.
  void operator []=(String attributeName, value) {
    final attribute = vertexArray.attributes[attributeName];

    if (attribute == null) {
      throw new ArgumentError(
          'Tried to set an attribute named "$attributeName" to a new value, '
          'but no attribute with that name is present on the vertex view. Only '
          'existing attributes can be updated on a vertex view, no new '
          'attributes can be created.');
    } else {
      attribute.setValueAtRow(index, value);
    }
  }
}

/// Builds a [VertexArray].
///
/// Simplifies the creation of a [VertexArray], particularly when the aim is to
/// create a modified instance of an existing [VertexArray]:
///
///     var modified =
///       new VertexArrayBuilder.fromBaseCollection(baseCollection)
///           ..omit(someVertex)
///           ..appendAll(newVertices)
///           .build();
///
/// Alternatively, `toBuilder()` can be called on the existing [VertexArray]:
///
///     var modified = baseCollection.toBuilder()
///         ..omit(someVertex)
///         ..appendAll(newVertices)
///         .build();
///
class VertexArrayBuilder {
  /// The base [VertexArray] used as the starting point by this builder.
  final VertexArray baseArray;

  final List<Vertex> _appendedVertices = new List();

  final List<int> _omittedVertexIndices = new List();

  /// Instantiates a new [VertexArrayBuilder].
  VertexArrayBuilder() : baseArray = null;

  /// Instantiates a new [VertexArrayBuilder] using the [baseArray] as a base.
  VertexArrayBuilder.fromBaseArray(this.baseArray);

  /// Adds the [vertex] to the collection of vertices that are to be appended
  /// onto new [VertexArray] instances build with this builder.
  ///
  /// See [appendAll] for adding multiple vertices at once.
  void append(Vertex vertex) {
    _appendedVertices.add(vertex);
  }

  /// Adds the [vertices] to the collection of vertices that are to be appended
  /// onto new [VertexArray] instances build with this builder.
  ///
  /// See [append] for adding a single vertex.
  void appendAll(Iterable<Vertex> vertices) {
    _appendedVertices.addAll(vertices);
  }

  /// Instructs this builder to omit the [vertex] from new [VertexArray]
  /// instances build with the builder.
  ///
  /// If an existing [VertexArray] is used as a base for this builder and the
  /// [vertex] is present in this base array, then the builder will omit the
  /// [vertex] from any new [VertexArray] instances it builds.
  ///
  /// Returns `true` if the vertex was in the base array, `false` otherwise.
  ///
  /// See [omitAll] for omitting multiple vertices at once.
  bool omit(Vertex vertex) {
    if (baseArray != null &&
        vertex is VertexArrayVertexView &&
        vertex.vertexArray == baseArray) {
      _omittedVertexIndices.add(vertex.index);

      return true;
    } else {
      return false;
    }
  }

  /// Instructs this builder to omit the vertex at the given [index] from new
  /// [VertexArray] instances created with this builder.
  ///
  /// If an existing [VertexArray] is used as a base for this builder, then this
  /// builder will omit the vertex at the given [index] from any new
  /// [VertexArray] instances it builds.
  ///
  /// Throws a [RangeError] if the [index] is not a valid index for the base
  /// array.
  ///
  /// Throws an [UnsupportedError] if no base array was specified for this
  /// builder.
  void omitAt(int index) {
    if (baseArray == null) {
      throw new UnsupportedError(
          'Can only call omitAt when the builder was given a base array.');
    } else {
      RangeError.checkValidIndex(index, baseArray);

      _omittedVertexIndices.add(index);
    }
  }

  /// Instructs this builder to omit the [vertices] from new [VertexArray]
  /// instances created with the builder.
  ///
  /// If an existing [VertexArray] is used as a base for this builder and any of
  /// the [vertices] are present in this base array, then the builder will omit
  /// these [vertices] from any new [VertexArray] instances it builds.
  ///
  /// See [omit] for omitting a single vertex.
  void omitAll(Iterable<Vertex> vertices) {
    if (baseArray != null) {
      vertices.forEach((vertex) {
        if (vertex is VertexArrayVertexView &&
            vertex.vertexArray == baseArray) {
          _omittedVertexIndices.add(vertex.index);
        }
      });
    }
  }

  /// Instantiates a new [VertexArray] based on the build instructions provided
  /// to the builder.
  ///
  /// Example:
  ///
  ///     var newCollection = oldCollection.toBuilder()
  ///         ..omit(someVertex)
  ///         ..appendAll(newVertices)
  ///         .build();
  ///
  VertexArray build() {
    if (baseArray == null) {
      return new VertexArray(_appendedVertices);
    } else {
      // Currently this algorithm creates the new attribute data tables in two
      // steps: first an intermediate table is created in which the omitted
      // vertices are removed from the base array, then the final table is
      // created in which the appended vertices are added at the tail. A
      // possible optimization would be to do this in a single step, without
      // creating an intermediate table, although this might not be a
      // significant optimization.

      final appendCount = _appendedVertices.length;

      // Create map of old tables to corresponding new tables.
      final oldNewTableMap = new Map<AttributeDataTable, AttributeDataTable>();

      baseArray.attributeDataTables.forEach((table) {
        final appendedData = new Float32List(table.rowLength * appendCount);

        oldNewTableMap[table] = table
            .withoutRows(_omittedVertexIndices)
            .withAppendedData(appendedData);
      });

      // Create new attribute map on the new tables
      final newAttributeMap = new Map<String, VertexAttribute>();

      baseArray.attributes.forEach((name, oldAttribute) {
        final newTable = oldNewTableMap[oldAttribute.attributeDataTable];

        newAttributeMap[name] = oldAttribute.onTable(newTable);
      });

      // Create new VertexArray
      final vertices = new VertexArray.fromAttributes(newAttributeMap);

      // Set the attribute data for the appended vertices
      var currentRow = baseArray.length - _omittedVertexIndices.length;

      _appendedVertices.forEach((vertex) {
        newAttributeMap.forEach((name, attribute) {
          if (!vertex.hasAttribute(name)) {
            throw new StateError(
                'Tried to append a vertex to a VertexArray, but the vertex '
                'does not the define an attribute named "$name". Vertices '
                'appended to a VertexArray must define the same attributes as '
                'the vertices in the VertexArray that is used as a base.');
          } else {
            try {
              attribute.setValueAtRow(currentRow, vertex[name]);
            } on TypeError {
              throw new StateError(
                  'Tried to append a vertex that declares the attribute named '
                  '"$name" to have value "${vertex[name]}" of type '
                  '"${vertex[name].runtimeType}", but this value type is not '
                  'consistent with the value type for this attribute used by '
                  'existing vertices. All vertices must use a consistent '
                  'value type for an attribute.');
            }
          }
        });

        currentRow++;
      });

      return vertices;
    }
  }
}
