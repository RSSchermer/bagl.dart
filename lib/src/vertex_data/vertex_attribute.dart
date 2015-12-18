part of vertex_data;

/// Base class for defining attributes of a certain type on an
/// [AttributeDataFrom].
///
/// Defines how to extract and update attribute values for the rows of the
/// attribute data frame the attribute is defined on.
///
/// Subtypes of this class are declared for all attributes types allowed by
/// WebGL: [FloatAttribute], [Vector2Attribute], [Vector3Attribute],
/// [Vector4Attribute], [Matrix2Attribute], [Matrix3Attribute], and
/// [Matrix4Attribute].
///
/// An example:
///
///     // An attribute data frame partitioned into rows of length 5. Used to
///     // store interleaved position and color data.
///     var attributeDataFrame = new AttributeDataFrame([
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ], 5);
///
///     // The color attribute value in an attribute data row as a Vector3. The
///     // offset for the color data in a row is 2.
///     var color = new Vector3Attribute(attributeDataFrame, offset: 2);
///
///     // The position attribute value in an attribute data row as a Vector2.
///     // The offset of the position data in a row is 0, which is the default
///     // value so we may omit it.
///     var position = new Vector2Attribute(attributeDataFrame);
///
///     // The position value for the second row.
///     Vector2 secondVertexPosition = position.extractFrom(attributeData[1]);
///
///     // The color value for the second row.
///     Vector3 secondVertexColor = color.extractFrom(attributeData[1]);
///
abstract class VertexAttribute<AttributeType> {
  /// The attribute data frame the attribute is defined on.
  final AttributeDataFrame frame;

  /// The length of the sequence of numbers used to store an attribute of this
  /// type.
  final int size;

  /// The number of values that are to be skipped at the start of a row before
  /// the sequence of values for this attribute starts.
  ///
  /// Note that the offset is defined relative to the start of a row, not
  /// relative to the start of the entire storage list of the attribute data
  /// frame.
  final int offset;

  Float32List _storage;

  int _rowCount;

  VertexAttribute(this.frame, this.size, {this.offset: 0}) {
    if (size + offset > frame.rowLength) {
      throw new ArgumentError(
          'The sum of size of the attribute data ($size) and the offset of the '
          'data relative to the start of a row ($offset), must not be greater '
          'the length of rows in the attribute data frame '
          '(${frame.rowLength}).');
    }

    _storage = frame._storage;
    _rowCount = frame.length;
  }

  /// Extract the attribute value from the row with the given index.
  ///
  /// Throws a [RangeError] when the given row index is smaller than 0 or
  /// greater than the total number of rows in the attribute data frame.
  AttributeType extractValueAtRow(int rowIndex);

  /// Update the attribute value on the row with the given index to the
  /// specified value.
  ///
  /// Throws a [RangeError] when the given row index is smaller than 0 or
  /// greater than the total number of rows in the attribute data frame.
  void setValueAtRow(int rowIndex, AttributeType value);

  /// Extract the attribute value from the given row.
  ///
  /// Throws an [ArgumentError] when the given row does not belong to the same
  /// attribute data frame as this attribute is defined on.
  AttributeType extractFrom(AttributeDataRowView row) {
    if (row.frame != frame) {
      throw new ArgumentError(
          'Can only extract an attribute value from a row that belongs to the '
          'same attribute data frame as this pointer is defined on.');
    }

    return extractValueAtRow(row.index);
  }

  /// Update the attribute value on the given row index to the specified value.
  ///
  /// Throws an [ArgumentError] when the given row does not belong to the same
  /// attribute data frame as this attribute is defined on.
  void setOn(AttributeDataRowView row, AttributeType value) {
    if (row.frame != frame) {
      throw new ArgumentError(
          'Can set an attribute value on a row that belongs to the same '
          'attribute data frame as this pointer is defined on.');
    }

    setValueAtRow(row.index, value);
  }
}

/// Defines a float attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class FloatAttribute extends VertexAttribute<double> {
  /// Instantiates a new float attribute definition on the specified attribute
  /// data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the value for this attribute
  /// resides relative to the start of the row:
  ///
  ///     var attribute = new FloatAttribute(attributeDataFrame, offset: 2);
  ///
  FloatAttribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 1, offset: offset);

  double extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    return _storage[rowIndex * frame.rowLength + offset];
  }

  void setValueAtRow(int rowIndex, double value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    _storage[rowIndex * frame.rowLength + offset] = value;
  }
}

/// Defines a [Vector2] attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class Vector2Attribute extends VertexAttribute<Vector2> {
  /// Instantiates a new [Vector2] attribute definition on the specified
  /// attribute data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the sequence of values for this
  /// attribute begins relative to the start of the row:
  ///
  ///     var attribute = new Vector2Attribute(attributeDataFrame, offset: 2);
  ///
  Vector2Attribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 2, offset: offset);

  Vector2 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    return new Vector2(_storage[s], _storage[s + 1]);
  }

  void setValueAtRow(int rowIndex, Vector2 value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    _storage.setRange(s, s + 2, value.storage);
  }
}

/// Defines a [Vector3] attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class Vector3Attribute extends VertexAttribute<Vector3> {
  /// Instantiates a new [Vector3] attribute definition on the specified
  /// attribute data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the sequence of values for this
  /// attribute begins relative to the start of the row:
  ///
  ///     var attribute = new Vector3Attribute(attributeDataFrame, offset: 2);
  ///
  Vector3Attribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 3, offset: offset);

  Vector3 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    return new Vector3(_storage[s], _storage[s + 1], _storage[s + 2]);
  }

  void setValueAtRow(int rowIndex, Vector3 value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    _storage.setRange(s, s + 3, value.storage);
  }
}

/// Defines a [Vector4] attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class Vector4Attribute extends VertexAttribute<Vector4> {
  /// Instantiates a new [Vector4] attribute definition on the specified
  /// attribute data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the sequence of values for this
  /// attribute begins relative to the start of the row:
  ///
  ///     var attribute = new Vector4Attribute(attributeDataFrame, offset: 2);
  ///
  Vector4Attribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 4, offset: offset);

  Vector4 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    return new Vector4(
        _storage[s], _storage[s + 1], _storage[s + 2], _storage[s + 3]);
  }

  void setValueAtRow(int rowIndex, Vector4 value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    _storage.setRange(s, s + 4, value.storage);
  }
}

/// Defines a [Matrix2] attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class Matrix2Attribute extends VertexAttribute<Matrix2> {
  /// Instantiates a new [Matrix2] attribute definition on the specified
  /// attribute data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the sequence of values for this
  /// attribute begins relative to the start of the row:
  ///
  ///     var attribute = new Matrix2Attribute(attributeDataFrame, offset: 2);
  ///
  Matrix2Attribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 4, offset: offset);

  Matrix2 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    return new Matrix2(
        _storage[s], _storage[s + 1], _storage[s + 2], _storage[s + 3]);
  }

  void setValueAtRow(int rowIndex, Matrix2 value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    _storage.setRange(s, s + 4, value.storage);
  }
}

/// Defines a [Matrix3] attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class Matrix3Attribute extends VertexAttribute<Matrix3> {
  /// Instantiates a new [Matrix3] attribute definition on the specified
  /// attribute data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the sequence of values for this
  /// attribute begins relative to the start of the row:
  ///
  ///     var attribute = new Matrix3Attribute(attributeDataFrame, offset: 2);
  ///
  Matrix3Attribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 9, offset: offset);

  Matrix3 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    final s = rowIndex * frame.rowLength + offset;

    return new Matrix3(
        _storage[s],
        _storage[s + 1],
        _storage[s + 2],
        _storage[s + 3],
        _storage[s + 4],
        _storage[s + 5],
        _storage[s + 6],
        _storage[s + 7],
        _storage[s + 8]);
  }

  void setValueAtRow(int rowIndex, Matrix3 value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    var s = rowIndex * frame.rowLength + offset;

    _storage.setRange(s, s + 9, value.storage);
  }
}

/// Defines a [Matrix4] attribute on an [AttributeDataFrame].
///
/// See the documentation for the [VertexAttribute] class for an example of
/// defining vertex attributes on an attribute data frame.
class Matrix4Attribute extends VertexAttribute<Matrix4> {
  /// Instantiates a new [Matrix4] attribute definition on the specified
  /// attribute data frame.
  ///
  /// Can be used defined both on an attribute data frame that only holds data
  /// for this attribute, or on an attribute data frame that holds interleaved
  /// data for several attributes. In the latter case, if this attribute is not
  /// the first to appear in a row (at position 0), then the offset needs to be
  /// specified to indicate at which position the sequence of values for this
  /// attribute begins relative to the start of the row:
  ///
  ///     var attribute = new Matrix4Attribute(attributeDataFrame, offset: 2);
  ///
  Matrix4Attribute(AttributeDataFrame attributeDataFrame, {int offset: 0})
      : super(attributeDataFrame, 16, offset: offset);

  Matrix4 extractValueAtRow(int rowIndex) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    var s = rowIndex * frame.rowLength + offset;

    return new Matrix4(
        _storage[s],
        _storage[s + 1],
        _storage[s + 2],
        _storage[s + 3],
        _storage[s + 4],
        _storage[s + 5],
        _storage[s + 6],
        _storage[s + 7],
        _storage[s + 8],
        _storage[s + 9],
        _storage[s + 10],
        _storage[s + 11],
        _storage[s + 12],
        _storage[s + 13],
        _storage[s + 14],
        _storage[s + 15]);
  }

  void setValueAtRow(int rowIndex, Matrix4 value) {
    RangeError.checkValidIndex(rowIndex, frame, 'rowIndex', _rowCount);

    var s = rowIndex * frame.rowLength + offset;

    _storage.setRange(s, s + 16, value.storage);
  }
}
