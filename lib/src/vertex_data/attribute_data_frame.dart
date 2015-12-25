part of vertex_data;

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
          [int offsetInBytes = 0, int length]) =>
      new AttributeDataFrame.fromFloat32List(
          new Float32List.view(buffer, offsetInBytes, length * rowLength),
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

  /// Creates a new attribute data frame as a view on a new byte buffer without
  /// the rows at the specified indices.
  ///
  /// This method is much more efficient than calling [withoutRow] repeatedly
  /// to remove multiple rows from the attribute data frame.
  ///
  /// Throws a [RangeError] if one of the specified row indices is smaller than
  /// 0 or greater than the total number of rows in the attribute data frame.
  AttributeDataFrame withoutRows(Iterable<int> indices) {
    // Algorithm first sorts the indices that are to be removed, then loops over
    // these indices to look for gaps in between indices. If gap is encountered
    // it copies the rows in the gap over to the new storage buffer in one go.

    final indexList = indices.toList();

    indexList.sort();

    var uniqueIndexCount = 0;

    if (indexList.isNotEmpty) {
      uniqueIndexCount = 1;

      for (var i = 1; i < indexList.length; i++) {
        if (indexList[i] != indexList[i - 1]) {
          uniqueIndexCount++;
        }
      }
    }

    final newSize = (length - uniqueIndexCount) * rowLength;
    final newStorage = new Float32List(newSize);

    var lastRemovedRow = -1;
    var copiedRowCount = 0;

    for (var index in indexList) {
      RangeError.checkValidIndex(index, this);

      // Check if there is a gap between the last removed row and the index of
      // the row that currently is to be removed. If a gap is found, copy over
      // the rows in the gap to the new frame's storage buffer.
      if (index > lastRemovedRow + 1) {
        final gapSizeInRows = index - lastRemovedRow - 1;
        final start = copiedRowCount * rowLength;
        final end = start + gapSizeInRows * rowLength;
        final skipCount = (lastRemovedRow + 1) * rowLength;

        newStorage.setRange(start, end, _storage, skipCount);
        copiedRowCount += gapSizeInRows;
      }

      lastRemovedRow = index;
    }

    // Check if there are rows at the tail of the frame that remain to be
    // copied. If remaining rows are found, copy them over to the new frame's
    // storage buffer.
    if (lastRemovedRow < length - 1) {
      final start = copiedRowCount * rowLength;
      final skipCount = (lastRemovedRow + 1) * rowLength;

      newStorage.setRange(start, newSize, _storage, skipCount);
    }

    return new AttributeDataFrame.fromFloat32List(newStorage, rowLength);
  }

  /// Returns a new attribute data frame with the given data appended onto the
  /// end.
  ///
  /// Returns a new attribute data frame as a view on a new byte buffer which
  /// contains the old frame's data with the additional data appended onto the
  /// end.
  AttributeDataFrame withAppendedData(Iterable<double> data) {
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
    final bStorage = attributeDataFrame._storage;
    final newStorage = new Float32List(rowCount * (aRowLength + bRowLength));
    var counter = 0;

    for (var i = 0; i < rowCount; i++) {
      final m = i * aRowLength;
      final n = i * bRowLength;

      for (var j = 0; j < aRowLength; j++) {
        newStorage[counter] = _storage[m + j];
        counter++;
      }

      for (var k = 0; k < bRowLength; k++) {
        newStorage[counter] = bStorage[n + k];
        counter++;
      }
    }

    return new AttributeDataFrame.fromFloat32List(
        newStorage, aRowLength + bRowLength);
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

    if (colEnd <= colStart) {
      throw new ArgumentError(
          'The ending column index must be greater than the starting column '
          'index.');
    }

    // Check to see if the column range encompasses all columns, because then
    // the rows can be copied over in one chunk. Otherwise loop over row range
    // and copy values in the column range individually.
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

  AttributeDataFrame subFrameView(int rowStart, [int rowEnd]) {
    rowEnd ??= length;

    RangeError.checkValueInInterval(rowStart, 0, length, 'rowStart');
    RangeError.checkValueInInterval(rowEnd, 0, length, 'rowEnd');

    final offset =
        offsetInBytes + rowStart * rowLength * Float32List.BYTES_PER_ELEMENT;
    final newLength = (rowEnd - rowStart) * rowLength;
    final newStorage = new Float32List.view(buffer, offset, newLength);

    return new AttributeDataFrame.fromFloat32List(newStorage, rowLength);
  }

  /// Returns a view of the data row at the given index.
  ///
  /// Throws a [RangeError] if the index is out of bounds.
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
    RangeError.checkValidIndex(index, this);

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
