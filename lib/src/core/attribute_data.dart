part of bagl;

/// Vertex attribute data frame as a view on a byte buffer.
///
/// An attribute data frame consists of a set of rows, each row representing
/// attribute data (for example position coordinates and/or RGB color values)
/// for a single vertex. A single row must not hold attribute data for more than
/// one vertex and the attribute data for a single vertex must not be spread
/// over more than one row.
///
/// The following is an example of an attribute data frame that stores data for
/// a 2D position attribute, interleaved with data for RGB color values:
///
///     var attributeData = new AttributeDataFrame([
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ], 5);
///
/// Note, that not all attributes for a [VertexSet] need to be interleaved in
/// the same attribute data frame; the attribute data for different attributes
/// can be spread over multiple frames, but all frames must have the same length
/// (same number of rows). Rows at corresponding indices then describe different
/// attributes for the same vertex. For example, one frame might be used to
/// store interleaved data for a `position` attribute and a `vertexNormal`
/// attribute, and a second frame might be used to store a `color` attribute for
/// the same set of vertices.
///
/// An attribute data frame acts as a view on a byte buffer in which the actual
/// attribute data is stored. Operations that change the data in an attribute
/// data frame change the data in the byte buffer and vice versa.
class AttributeDataFrame extends IterableBase<AttributeDataRowView>
    with TypedData {
  /// Typed [Float32List] view on the byte buffer in which this attribute data
  /// frame's data is stored.
  final Float32List _storage;

  /// The length of the rows in this attribute data frame as the number of
  /// float32 values (not the number of bytes).
  final int rowLength;

  /// Creates a new attribute data frame, partitioned into rows of the
  /// specified row length.
  ///
  ///     var attributeData = new AttributeDataFrame([
  ///        // Position    // Color
  ///        0.0,  0.5,     1.0, 0.0, 0.0,
  ///       -0.5, -0.5,     0.0, 1.0, 0.0,
  ///        0.5, -0.5,     0.0, 0.0, 1.0
  ///     ], 5);
  ///
  factory AttributeDataFrame(List<double> data, int rowLength) =>
      new AttributeDataFrame.fromFloat32List(
          new Float32List.fromList(data), rowLength);

  /// Creates a new attribute data frame as a view on the given Float32List's
  /// byte buffer, partitioned into rows of the specified row length.
  AttributeDataFrame.fromFloat32List(this._storage, this.rowLength);

  factory AttributeDataFrame.view(ByteBuffer buffer, int rowLength,
          [int offsetInBytes = 0, int lengthInBytes]) =>
      new AttributeDataFrame.fromFloat32List(
          new Float32List.view(buffer, offsetInBytes, lengthInBytes),
          rowLength);

  ByteBuffer get buffer => _storage.buffer;

  int get elementSizeInBytes => _storage.elementSizeInBytes * rowLength;

  int get offsetInBytes => _storage.offsetInBytes;

  int get lengthInBytes => _storage.lengthInBytes;

  AttributeDataFrameIterator get iterator =>
      new AttributeDataFrameIterator(this);

  int get length => _storage.length ~/ rowLength;

  AttributeDataRowView elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return new AttributeDataRowView(this, index);
  }

  /// Creates a new attribute data frame as a view on a new byte buffer without
  /// the row at the given index.
  ///
  /// Throws a [RangeError] when the given row index is smaller than 0 or
  /// greater than the total number of rows in the attribute data frame.
  AttributeDataFrame withoutRow(int index) {
    RangeError.checkValidIndex(index, this);

    final newSize = _storage.length - rowLength;
    final rowStartPos = index * rowLength;

    // Note: Float32List.setRange compiles to very optimized javascript in
    // Dart2JS when the source list is itself also a Float32List.
    final newStorage = new Float32List(newSize)
      ..setRange(0, rowStartPos, _storage)
      ..setRange(rowStartPos, newSize, _storage, rowStartPos + rowLength);

    return new AttributeDataFrame(newStorage, rowLength);
  }

  // TODO: implement withoutRows(List<int> indices)
  AttributeDataFrame withoutRows(List<int> indices) {}

  /// Returns a new attribute data frame with the given data appended onto the
  /// end.
  ///
  /// Returns a new attribute data frame as a view on a new byte buffer which
  /// contains the old frame's data with the additional data appended onto the
  /// end.
  AttributeDataFrame withAppendedData(List<double> data) {
    final newSize = _storage.length + data.length;

    // Note: Float32List.setRange compiles to very optimized javascript in
    // Dart2JS when the source list is itself also a Float32List.
    final newStorage = new Float32List(newSize)
      ..setRange(0, _storage.length, _storage)
      ..setRange(_storage.length, newSize, data);

    return new AttributeDataFrame(newStorage, rowLength);
  }

  /// Interleaves the data in this frame with the data in the given frame,
  /// resulting in a new attribute data.
  ///
  /// Interleaves this attribute data frame `A` with row length `a` and another
  /// attribute data data frame `B` with row length `b`, resulting in a new
  /// attribute data frame with row length `a + b`. The first `a` values of a
  /// row in the new frame will be values from frame `A` and the last `b`
  /// values of a row in the new frame will be values from frame `B`. A new
  /// byte buffer will be created to store the data for the new attribute data
  /// frame.
  ///
  /// Throws an [ArgumentError] if the lengths (rowCount) of `A` and `B` are not
  /// equal.
  AttributeDataFrame interleavedWith(AttributeDataFrame attributeDataFrame) {
    if (attributeDataFrame.length != length) {
      throw new ArgumentError(
          'Both attribute data frame must have the same number of rows.');
    }

    final rowCount = length;
    final aRowLength = rowLength;
    final bRowLength = attributeDataFrame.rowLength;
    final s = new Float32List(rowCount * (aRowLength + bRowLength));
    var counter = 0;

    for (var i = 0; i < rowCount; i++) {
      final m = i * aRowLength;
      final n = i * bRowLength;

      for (var j = 0; j < aRowLength; j++) {
        s[counter] = _storage[m + j];
        counter++;
      }

      for (var k = 0; k < bRowLength; k++) {
        s[counter] = _storage[n + k];
        counter++;
      }
    }

    return new AttributeDataFrame.fromFloat32List(s, aRowLength + bRowLength);
  }

  /// Creates a new attribute data frame from a range of rows and (optionally) a
  /// range of columns on this attribute data frame.
  ///
  /// Creates a new attribute data frame from a row range from [rowStart] until
  /// [rowEnd] and optionally a column range from [colStart] until [colEnd].
  /// The ending row defaults to null, indicating that the new attribute data
  /// frame should extend until the end of the old frame. The starting columns
  /// defaults to 0, indicating that the new sub-frame's rows extend from the
  /// start of the old frame's rows. The ending columns defaults to null,
  /// indicating that the new sub frame's rows should extend until the end of
  /// the old sub-frame's rows. Starting row and starting column indices are
  /// inclusive, the ending row and ending column are exclusive.
  ///
  /// Creates a new byte buffer to store the new attribute data frames data. See
  /// also [subFrameView] which does not create a byte buffer, but creates the
  /// new attribute data frame as a new view on the existing byte buffer.
  ///
  /// Throws a [RangeError] if [rowStart] or [rowEnd] is smaller than 0 or
  /// greater than the total number of rows in this frame.
  /// Throws a [RangeError] if [colStart] or [colEnd] is smaller than 0 or
  /// greater than the length of rows in this frame.
  /// Throws an [ArgumentError] if [rowEnd] is equal to or smaller than
  /// [rowStart], or [colEnd] is equal to or smaller than [colStart].
  AttributeDataFrame subFrame(int rowStart,
      [int rowEnd, int colStart = 0, int colEnd]) {
    rowEnd ??= length;
    colEnd ??= rowLength;

    RangeError.checkValueInInterval(rowStart, 0, length, 'rowStart');
    RangeError.checkValueInInterval(rowEnd, 0, length, 'rowEnd');
    RangeError.checkValueInInterval(colStart, 0, rowLength, 'colStart');
    RangeError.checkValueInInterval(colEnd, 0, rowLength, 'colEnd');

    if (rowEnd <= rowStart) {
      throw new ArgumentError(
          'The ending row index must be greater than the starting row index.');
    }

    if (rowEnd <= rowStart) {
      throw new ArgumentError(
          'The ending column index must be greater than the starting column '
          'index.');
    }

    if (colEnd == 0 && colEnd == rowLength) {
      final skipCount = rowStart * rowLength;
      final newLength = length * rowLength;
      final newStorage = new Float32List(newLength)
        ..setRange(0, newLength, _storage, skipCount);

      return new AttributeDataFrame(newStorage, rowLength);
    } else {
      final newRowLength = colEnd - colStart;
      final newStorage = new Float32List((rowEnd - rowStart) * newRowLength);
      var counter = 0;

      for (var i = rowStart; i < rowEnd; i++) {
        final m = i * rowLength;

        for (var j = colStart; j < colEnd; j++) {
          newStorage[counter] = _storage[m + j];
          counter++;
        }
      }

      return new AttributeDataFrame.fromFloat32List(newStorage, newRowLength);
    }
  }

  // TODO: implement subFrameView

  /// Returns a view of the data row at the given index.
  AttributeDataRowView operator [](int index) => elementAt(index);
}

/// Iterator over the rows in an [AttributeDataFrame].
class AttributeDataFrameIterator extends Iterator<AttributeDataRowView> {
  final AttributeDataFrame frame;

  int _frameLength;

  int _currentRowIndex = -1;

  /// Instantiates a new iterator of the rows in the given attribute data frame.
  AttributeDataFrameIterator(this.frame) {
    _frameLength = frame.length;
  }

  AttributeDataRowView get current {
    if (_currentRowIndex >= 0 && _currentRowIndex < _frameLength) {
      return new AttributeDataRowView(frame, _currentRowIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentRowIndex++;

    return _currentRowIndex < _frameLength;
  }
}

/// View of a row in an [AttributeDataFrame].
class AttributeDataRowView extends IterableBase<double> {
  /// The attribute data frame this row belongs to.
  final AttributeDataFrame frame;

  /// The index of the row in the attribute data frame.
  final int index;

  Float32List _storagePointer;

  int _rowDataOffset;

  /// Creates a new attribute data row view of a row in the given attribute data
  /// frame, with the given index.
  AttributeDataRowView(this.frame, this.index) {
    RangeError.checkValidIndex(index, frame);

    _storagePointer = frame._storage;
    _rowDataOffset = frame.rowLength * index;
  }

  AttributeDataRowViewIterator get iterator =>
      new AttributeDataRowViewIterator(this);

  int get length => frame.rowLength;

  double elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return _storagePointer[_rowDataOffset + index];
  }

  /// Returns the value at the specified index.
  double operator [](int index) => elementAt(index);

  /// Sets the value at the specified index to the given value.
  void operator []=(int index, double value) {
    _storagePointer[_rowDataOffset + index] = value;
  }
}

/// Iterator over the values in an [AttributeDataRowView].
class AttributeDataRowViewIterator extends Iterator<double> {
  final AttributeDataRowView row;

  Float32List _storagePointer;

  int _rowLength;

  int _rowDataOffset;

  int _currentValueIndex = -1;

  /// Creates a new iterator over the values in an attribute data row view.
  AttributeDataRowViewIterator(this.row) {
    _storagePointer = row.frame._storage;
    _rowLength = row.length;
    _rowDataOffset = row._rowDataOffset;
  }

  double get current {
    if (_currentValueIndex >= 0 && _currentValueIndex < _rowLength) {
      return _storagePointer[_rowDataOffset + _currentValueIndex];
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentValueIndex++;

    return _currentValueIndex < _rowLength;
  }
}

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
