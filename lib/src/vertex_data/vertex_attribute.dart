part of vertex_data;

/// Base class for defining typed attributes on an [AttributeDataTable].
///
/// Defines how to read and write attribute values from [AttributeDataTable].
///
/// Subtypes of this class are declared for all attributes types allowed by the
/// WebGL specification: [FloatAttribute], [Vector2Attribute],
/// [Vector3Attribute], [Vector4Attribute], [Matrix2Attribute],
/// [Matrix3Attribute], and [Matrix4Attribute].
///
/// An example:
///
///     // An attribute data table with a rowLength of 5, used to store
///     // interleaved position and color data.
///     var attributeDataTable = new AttributeDataTable.fromList(5, [
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ]);
///
///     // The `color` attribute as a Vector3. The offset for the color data in
///     // a row is 2.
///     var color = new Vector3Attribute(attributeDataTable, offset: 2);
///
///     // The `position` attribute as a Vector2. The offset of the position
///     // data in a row is 0, which is the default value so we may omit it.
///     var position = new Vector2Attribute(attributeDataTable);
///
///     // Extract the `position` value from the second row.
///     Vector2 secondPosition = position.extractFrom(attributeDataTable[1]);
///
///     // Extract the `color` value from the second row.
///     Vector3 secondColor = color.extractFrom(attributeDataTable[1]);
///
abstract class VertexAttribute<AttributeType> {
  /// The [AttributeDataTable] the attribute is defined on.
  final AttributeDataTable attributeDataTable;

  /// The number of columns for an attribute of this type.
  ///
  /// Corresponds to the number of attribute locations occupied by an attribute
  /// of this type in a GLSL shader program.
  final int columnCount;

  /// The number of floats per column for an attribute of this type.
  final int columnSize;

  /// The number of floats that are to be skipped at the start of a row before
  /// the sequence of floats for this attribute starts.
  ///
  /// See also [offsetInBytes].
  final int offset;

  Float32List _storage;

  int _rowCount;

  VertexAttribute(this.attributeDataTable, this.columnCount, this.columnSize,
      {this.offset: 0}) {
    if (columnCount * columnSize + offset > attributeDataTable.rowLength) {
      throw new ArgumentError('The sum of size of the attribute '
          '(${columnCount * columnSize}) and the offset of the attribute '
          '($offset), must not be greater the rowLength of the attribute data '
          'table (${attributeDataTable.rowLength}).');
    }

    _storage = attributeDataTable._storage;
    _rowCount = attributeDataTable.length;
  }

  /// The number of bytes that are to be skipped at the start of a row before
  /// the sequence of bytes for this attribute starts.
  ///
  /// See also [offset].
  int get offsetInBytes => offset * Float32List.BYTES_PER_ELEMENT;

  /// Extract the attribute value from the row at the given [rowIndex].
  ///
  /// Throws a [RangeError] when the [rowIndex] is smaller than 0 or greater
  /// than the total number of rows in the [attributeDataTable].
  AttributeType extractValueAtRow(int rowIndex);

  /// Update the attribute value on the row with the given index to the
  /// specified value.
  ///
  /// Throws a [RangeError] when the given row index is smaller than 0 or
  /// greater than the total number of rows in the [attributeDataTable].
  void setValueAtRow(int rowIndex, AttributeType value);

  /// Extract the attribute value from the given row.
  ///
  /// Throws an [ArgumentError] when the given row does not belong to to the
  /// [attributeDataTable] on which this attribute is defined.
  AttributeType extractFrom(AttributeDataRowView row) {
    if (row.attributeDataTable != attributeDataTable) {
      throw new ArgumentError(
          'Can only extract an attribute value from a row that belongs to the '
          'same attribute data table as this attribute is defined on.');
    }

    return extractValueAtRow(row.index);
  }

  /// Update the attribute value on the given row index to the specified value.
  ///
  /// Throws an [ArgumentError] when the given row does not belong to the
  /// [attributeDataTable] on which this attribute is defined.
  void setOn(AttributeDataRowView row, AttributeType value) {
    if (row.attributeDataTable != attributeDataTable) {
      throw new ArgumentError(
          'Can only set an attribute value on a row that belongs to the same '
          'attribute data tabke as this attribute is defined on.');
    }

    setValueAtRow(row.index, value);
  }

  /// Creates a copy of the attribute for a different [AttributeDataTable].
  ///
  /// Optionally, a new [offset] may be specified. If omitted this attribute's
  /// current offset will be used.
  VertexAttribute<AttributeType> onTable(AttributeDataTable attributeDataTable,
      {int offset});
}

/// Defines a float attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class FloatAttribute extends VertexAttribute<double> {
  /// Instantiates a new float attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new FloatAttribute(attributeDataTable, offset: 2);
  ///
  FloatAttribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 1, 1, offset: offset);

  double extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    return _storage[rowIndex * attributeDataTable.rowLength + offset];
  }

  void setValueAtRow(int rowIndex, double value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    _storage[rowIndex * attributeDataTable.rowLength + offset] = value;

    attributeDataTable._versionOutdated = true;
  }

  FloatAttribute onTable(AttributeDataTable attributeDataTable, {int offset}) =>
      new FloatAttribute(attributeDataTable, offset: offset ?? this.offset);
}

/// Defines a [Vector2] attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class Vector2Attribute extends VertexAttribute<Vector2> {
  /// Instantiates a new [Vector2] attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new Vector2Attribute(attributeDataTable, offset: 2);
  ///
  Vector2Attribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 1, 2, offset: offset);

  Vector2 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    return new Vector2(_storage[s], _storage[s + 1]);
  }

  void setValueAtRow(int rowIndex, Vector2 value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    _storage[s] = value.x;
    _storage[s + 1] = value.y;

    attributeDataTable._versionOutdated = true;
  }

  Vector2Attribute onTable(AttributeDataTable attributeDataTable,
          {int offset}) =>
      new Vector2Attribute(attributeDataTable, offset: offset ?? this.offset);
}

/// Defines a [Vector3] attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class Vector3Attribute extends VertexAttribute<Vector3> {
  /// Instantiates a new [Vector3] attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new Vector3Attribute(attributeDataTable, offset: 2);
  ///
  Vector3Attribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 1, 3, offset: offset);

  Vector3 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    return new Vector3(_storage[s], _storage[s + 1], _storage[s + 2]);
  }

  void setValueAtRow(int rowIndex, Vector3 value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    _storage[s] = value.x;
    _storage[s + 1] = value.y;
    _storage[s + 2] = value.z;

    attributeDataTable._versionOutdated = true;
  }

  Vector3Attribute onTable(AttributeDataTable attributeDataTable,
          {int offset}) =>
      new Vector3Attribute(attributeDataTable, offset: offset ?? this.offset);
}

/// Defines a [Vector4] attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class Vector4Attribute extends VertexAttribute<Vector4> {
  /// Instantiates a new [Vector4] attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new Vector4Attribute(attributeDataTable, offset: 2);
  ///
  Vector4Attribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 1, 4, offset: offset);

  Vector4 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    return new Vector4(
        _storage[s], _storage[s + 1], _storage[s + 2], _storage[s + 3]);
  }

  void setValueAtRow(int rowIndex, Vector4 value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    _storage[s] = value.x;
    _storage[s + 1] = value.y;
    _storage[s + 2] = value.z;
    _storage[s + 3] = value.w;

    attributeDataTable._versionOutdated = true;
  }

  Vector4Attribute onTable(AttributeDataTable attributeDataTable,
          {int offset}) =>
      new Vector4Attribute(attributeDataTable, offset: offset ?? this.offset);
}

/// Defines a [Matrix2] attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class Matrix2Attribute extends VertexAttribute<Matrix2> {
  /// Instantiates a new [Matrix2] attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new Matrix2Attribute(attributeDataTable, offset: 2);
  ///
  Matrix2Attribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 2, 2, offset: offset);

  Matrix2 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    return new Matrix2(
        _storage[s], _storage[s + 2], _storage[s + 1], _storage[s + 3]);
  }

  void setValueAtRow(int rowIndex, Matrix2 value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    _storage[s] = value.r0c0;
    _storage[s + 1] = value.r1c0;
    _storage[s + 2] = value.r0c1;
    _storage[s + 3] = value.r1c1;

    attributeDataTable._versionOutdated = true;
  }

  Matrix2Attribute onTable(AttributeDataTable attributeDataTable,
          {int offset}) =>
      new Matrix2Attribute(attributeDataTable, offset: offset ?? this.offset);
}

/// Defines a [Matrix3] attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class Matrix3Attribute extends VertexAttribute<Matrix3> {
  /// Instantiates a new [Matrix3] attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new Matrix3Attribute(attributeDataTable, offset: 2);
  ///
  Matrix3Attribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 3, 3, offset: offset);

  Matrix3 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    final s = rowIndex * attributeDataTable.rowLength + offset;

    return new Matrix3(
        _storage[s],
        _storage[s + 3],
        _storage[s + 6],
        _storage[s + 1],
        _storage[s + 4],
        _storage[s + 7],
        _storage[s + 2],
        _storage[s + 5],
        _storage[s + 8]);
  }

  void setValueAtRow(int rowIndex, Matrix3 value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    var s = rowIndex * attributeDataTable.rowLength + offset;

    _storage[s] = value.r0c0;
    _storage[s + 1] = value.r1c0;
    _storage[s + 2] = value.r2c0;
    _storage[s + 3] = value.r0c1;
    _storage[s + 4] = value.r1c1;
    _storage[s + 5] = value.r2c1;
    _storage[s + 6] = value.r0c2;
    _storage[s + 7] = value.r1c2;
    _storage[s + 8] = value.r2c2;

    attributeDataTable._versionOutdated = true;
  }

  Matrix3Attribute onTable(AttributeDataTable attributeDataTable,
          {int offset}) =>
      new Matrix3Attribute(attributeDataTable, offset: offset ?? this.offset);
}

/// Defines a [Matrix4] attribute on an [AttributeDataTable].
///
/// See the documentation for [VertexAttribute] for an example of defining
/// vertex attributes on an [AttributeDataTable].
class Matrix4Attribute extends VertexAttribute<Matrix4> {
  /// Instantiates a new [Matrix4] attribute definition on the given
  /// [attributeDataTable].
  ///
  /// Can be defined both on an [AttributeDataTable] that only holds data
  /// for this attribute, or on an [AttributeDataTable] that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the [offset] needs to
  /// be specified to indicate at which position the values for this attribute
  /// begin relative to the start of a row:
  ///
  ///     var attribute = new Matrix4Attribute(attributeDataTable, offset: 2);
  ///
  Matrix4Attribute(AttributeDataTable attributeDataTable, {int offset: 0})
      : super(attributeDataTable, 4, 4, offset: offset);

  Matrix4 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    var s = rowIndex * attributeDataTable.rowLength + offset;

    return new Matrix4(
        _storage[s],
        _storage[s + 4],
        _storage[s + 8],
        _storage[s + 12],
        _storage[s + 1],
        _storage[s + 5],
        _storage[s + 9],
        _storage[s + 13],
        _storage[s + 2],
        _storage[s + 6],
        _storage[s + 10],
        _storage[s + 14],
        _storage[s + 3],
        _storage[s + 7],
        _storage[s + 11],
        _storage[s + 15]);
  }

  void setValueAtRow(int rowIndex, Matrix4 value) {
    RangeError.checkValidIndex(
        rowIndex, attributeDataTable, 'rowIndex', _rowCount);

    var s = rowIndex * attributeDataTable.rowLength + offset;

    _storage[s] = value.r0c0;
    _storage[s + 1] = value.r1c0;
    _storage[s + 2] = value.r2c0;
    _storage[s + 3] = value.r3c0;
    _storage[s + 4] = value.r0c1;
    _storage[s + 5] = value.r1c1;
    _storage[s + 6] = value.r2c1;
    _storage[s + 7] = value.r3c1;
    _storage[s + 8] = value.r0c2;
    _storage[s + 9] = value.r1c2;
    _storage[s + 10] = value.r2c2;
    _storage[s + 11] = value.r3c2;
    _storage[s + 12] = value.r0c3;
    _storage[s + 13] = value.r1c3;
    _storage[s + 14] = value.r2c3;
    _storage[s + 15] = value.r3c3;

    attributeDataTable._versionOutdated = true;
  }

  Matrix4Attribute onTable(AttributeDataTable attributeDataTable,
          {int offset}) =>
      new Matrix4Attribute(attributeDataTable, offset: offset ?? this.offset);
}
