part of vertex_data;

/// Vertex attribute data frame viewed as rows of [double] values.
///
/// An attribute data frame consists of a sequence of rows. Each row in
/// represents the attribute data (for example position coordinates and/or RGB
/// color values) for a single vertex as a sequence of [double] values. All rows
/// are of equal length. A single row must not hold attribute data for more than
/// one vertex and the attribute data for a single vertex must not be spread
/// over more than one row. The rows are ordered and each row is uniquely
/// identified by consecutive integer indices starting at 0.
///
/// The following is an example of an attribute data frame that stores data for
/// a 2D position attribute, interleaved with data for RGB color values:
///
///     var attributeData = new AttributeDataFrame(5, [
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ]);
///
/// Note that not all attributes for a [VertexArray] need to be interleaved in
/// the same attribute data frame; the attribute data for different attributes
/// can be spread over multiple frames, but all frames must have the same length
/// (same number of rows). Rows at corresponding indices then describe different
/// attributes for the same vertex. For example, one frame might be used to
/// store interleaved data for a `position` attribute and a `vertexNormal`
/// attribute, and a second frame might be used to store data for a `color`
/// attribute.
class AttributeDataFrame extends IterableBase<AttributeDataRowView>
    with TypedData {
  /// The length of the rows in this attribute data frame as the number of
  /// [double] values (not the number of bytes).
  final int rowLength;

  final int length;

  /// Whether or not the attribute data frame is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that the data in the
  /// attribute data frame is intended to be modified regularly, allowing the
  /// rendering back-end to optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an attribute data frame
  /// that is not marked as dynamic can still be modified.
  final bool isDynamic;

  /// Typed [Float32List] view on the attribute data.
  final Float32List _storage;

  /// Creates a new attribute data frame, partitioned into rows of the
  /// specified [rowLength].
  ///
  ///     var attributeData = new AttributeDataFrame(5, [
  ///        // Position    // Color
  ///        0.0,  0.5,     1.0, 0.0, 0.0,
  ///       -0.5, -0.5,     0.0, 1.0, 0.0,
  ///        0.5, -0.5,     0.0, 0.0, 1.0
  ///     ]);
  ///
  /// Optionally, the [dynamic] parameter may be specified. When `true` it
  /// signals to the rendering back-end that the data in the attribute data
  /// frame is intended to be modified regularly, allowing the rendering
  /// back-end to optimize for this. The default value is `false`. Note that
  /// this is merely a hint that can be used for tuning the performance of a
  /// rendering back-end: the data in an attribute data frame that is not marked
  /// as dynamic can still be modified.
  factory AttributeDataFrame(int rowLength, List<double> data,
          {bool dynamic: false}) =>
      new AttributeDataFrame.fromFloat32List(
          rowLength, new Float32List.fromList(data),
          dynamic: dynamic);

  /// Creates a new attribute data frame as a view on the given [Float32List],
  /// partitioned into rows of the specified [rowLength].
  ///
  /// Optionally, the [dynamic] parameter may be specified. When `true` it
  /// signals to the rendering back-end that the data in the attribute data
  /// frame is intended to be modified regularly, allowing the rendering
  /// back-end to optimize for this. The default value is `false`. Note that
  /// this is merely a hint that can be used for tuning the performance of a
  /// rendering back-end: the data in an attribute data frame that is not marked
  /// as dynamic can still be modified.
  ///
  /// THe attribute data frame acts as a view on the [FLoat32List], which means
  /// that changes to the attribute data frame will affect the [Float32List]
  /// and vice versa.
  AttributeDataFrame.fromFloat32List(int rowLength, Float32List data,
      {bool dynamic: false})
      : rowLength = rowLength,
        length = data.length ~/ rowLength,
        isDynamic = dynamic,
        _storage = data;

  /// Creates an [AttributeDataFrame] view of the specified region in the byte
  /// buffer.
  ///
  /// If the [offsetInBytes] index of the region is not specified, it defaults
  /// to zero (the first byte in the byte buffer). If the [length] is not
  /// specified, it defaults to `null`, which indicates that the view extends to
  /// the end of the byte buffer.
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// `rowLength * Float32List.BYTES_PER_ELEMENT`.
  factory AttributeDataFrame.view(int rowLength, ByteBuffer buffer,
          [int offsetInBytes = 0, int length]) =>
      new AttributeDataFrame.fromFloat32List(rowLength,
          new Float32List.view(buffer, offsetInBytes, length * rowLength),
          dynamic: false);

  // TODO: when Dart support optional positional and named parameters on the
  // same method, merge dynamicView into view.

  /// Creates an [AttributeDataFrame] view of the specified region in the byte
  /// buffer that is marked as dynamic.
  ///
  /// If the [offsetInBytes] index of the region is not specified, it defaults
  /// to zero (the first byte in the byte buffer). If the [length] is not
  /// specified, it defaults to `null`, which indicates that the view extends to
  /// the end of the byte buffer.
  ///
  /// When a frame is marked as dynamic it signals to the rendering back-end
  /// that the data in the attribute data frame is intended to be modified
  /// regularly, allowing the rendering back-end to optimize for this. Note that
  /// this is merely a hint that can be used for tuning the performance of a
  /// rendering back-end: the data in an attribute data frame that is not marked
  /// as dynamic can still be modified.
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// `rowLength * Float32List.BYTES_PER_ELEMENT`.
  factory AttributeDataFrame.dynamicView(int rowLength, ByteBuffer buffer,
          [int offsetInBytes = 0, int length]) =>
      new AttributeDataFrame.fromFloat32List(rowLength,
          new Float32List.view(buffer, offsetInBytes, length * rowLength),
          dynamic: true);

  ByteBuffer get buffer => _storage.buffer;

  int get elementSizeInBytes => _storage.elementSizeInBytes * rowLength;

  int get offsetInBytes => _storage.offsetInBytes;

  int get lengthInBytes => _storage.lengthInBytes;

  AttributeDataFrameIterator get iterator =>
      new AttributeDataFrameIterator(this);

  AttributeDataRowView elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return new AttributeDataRowView(this, index);
  }

  /// Creates a new attribute data frame without the row at the given [index].
  ///
  /// Throws a [RangeError] when the given [index] is smaller than 0 or greater
  /// than the [length] of the attribute data frame.
  AttributeDataFrame withoutRow(int index) {
    RangeError.checkValidIndex(index, this);

    final newSize = _storage.length - rowLength;
    final rowStartPos = index * rowLength;

    // Note: Float32List.setRange compiles to very optimized javascript in
    // Dart2JS when the source list is itself also a Float32List.
    final newStorage = new Float32List(newSize)
      ..setRange(0, rowStartPos, _storage)
      ..setRange(rowStartPos, newSize, _storage, rowStartPos + rowLength);

    return new AttributeDataFrame(rowLength, newStorage, dynamic: isDynamic);
  }

  /// Creates a new attribute data frame as a view on a new byte buffer without
  /// the rows at the specified indices.
  ///
  /// This method is much more efficient than calling [withoutRow] repeatedly
  /// to remove multiple rows from the attribute data frame.
  ///
  /// Throws a [RangeError] if any of the specified row indices are smaller than
  /// 0 or greater than the [length] of the attribute data frame.
  AttributeDataFrame withoutRows(Iterable<int> indices) {
    // Algorithm first sorts the indices that are to be removed, then loops over
    // these indices to look for gaps in between indices. If gap is encountered
    // it copies the rows in the gap over to the new storage buffer.

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
      // the current row that is to be removed. If a gap is found, copy over
      // the rows in the gap to the new storage buffer.
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
    // copied. If remaining rows are found, copy them over to the new storage
    // buffer.
    if (lastRemovedRow < length - 1) {
      final start = copiedRowCount * rowLength;
      final skipCount = (lastRemovedRow + 1) * rowLength;

      newStorage.setRange(start, newSize, _storage, skipCount);
    }

    return new AttributeDataFrame.fromFloat32List(rowLength, newStorage,
        dynamic: isDynamic);
  }

  /// Returns a new attribute data frame with the given [data] appended onto the
  /// end.
  AttributeDataFrame withAppendedData(Iterable<double> data) {
    final newSize = _storage.length + data.length;

    // Note: Dart2JS Float32List.setRange compiles to highly optimized
    // javascript when the source list is itself also a Float32List.
    final newStorage = new Float32List(newSize)
      ..setRange(0, _storage.length, _storage)
      ..setRange(_storage.length, newSize, data);

    return new AttributeDataFrame(rowLength, newStorage, dynamic: isDynamic);
  }

  /// Returns a new attribute data frame in which the data in this frame is
  /// interleaved with the data in the given [attributeDataFrame].
  ///
  /// Interleaves this attribute data frame `A` with row length `a` and another
  /// attribute data data frame `B` with row length `b`, resulting in a new
  /// attribute data frame with row length `a + b`. The first `a` values of a
  /// row in the new frame will be values from frame `A` and the last `b`
  /// values of a row in the new frame will be values from frame `B`.
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
        aRowLength + bRowLength, newStorage,
        dynamic: isDynamic);
  }

  /// Creates a new attribute data frame from a range of rows and (optionally) a
  /// range of columns on this attribute data frame.
  ///
  /// Creates a new attribute data frame from a row range from [rowStart] until
  /// [rowEnd] and optionally a column range from [colStart] until [colEnd].
  /// The ending row defaults to null, indicating that the new attribute data
  /// frame should extend until the end of the old frame. The [colStart]
  /// defaults to 0, indicating that the new sub-frame's rows extend from the
  /// start of the old frame's rows. The [colEnd] defaults to null, indicating
  /// that the new sub frame's rows should extend until the end of the old
  /// frame's rows. [rowStart] and [colStart] are inclusive, the [rowEnd] and
  /// [colEnd] are exclusive.
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

    // Check if the column range encompasses all columns, because then the rows
    // can be copied over in one chunk. Otherwise loop over row range and copy
    // values in the column range individually.
    if (colEnd == 0 && colEnd == rowLength) {
      final skipCount = rowStart * rowLength;
      final newLength = length * rowLength;
      final newStorage = new Float32List(newLength)
        ..setRange(0, newLength, _storage, skipCount);

      return new AttributeDataFrame(rowLength, newStorage);
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

      return new AttributeDataFrame.fromFloat32List(newRowLength, newStorage,
          dynamic: isDynamic);
    }
  }

  /// Creates a new attribute data frame as a view on the current attribute
  /// data frame.
  ///
  /// Creates an attribute data frame as a view on the current attribute
  /// data frame, starting at [rowStart]. Optionally a [rowEnd] may be
  /// specified. If omitted the view will extend until the end of the current
  /// frame.
  ///
  /// The new attribute data frame acts as a view on the current frame, which
  /// means that changes to the data in the current frame will affect the data
  /// in the view and vice versa.
  ///
  /// See also [subFrame] which creates a new attribute data frame that is
  /// independent of the current frame and allows specifying a column range in
  /// addition to a row range.
  ///
  /// Throws a [RangeError] if the specified [rowStart] is out of bounds.
  /// Throws a [RangeError] if the specified [rowEnd] is out of bounds.
  /// Throws an [ArgumentError] if [rowEnd] is equal to or smaller than
  /// [rowEnd].
  AttributeDataFrame subFrameView(int rowStart, [int rowEnd]) {
    rowEnd ??= length;

    RangeError.checkValueInInterval(rowStart, 0, length, 'rowStart');
    RangeError.checkValueInInterval(rowEnd, 0, length, 'rowEnd');

    if (rowEnd <= rowStart) {
      throw new ArgumentError(
          'The ending row index must be greater than the starting row index.');
    }

    final offset =
        offsetInBytes + rowStart * rowLength * Float32List.BYTES_PER_ELEMENT;
    final newLength = (rowEnd - rowStart) * rowLength;
    final newStorage = new Float32List.view(buffer, offset, newLength);

    return new AttributeDataFrame.fromFloat32List(rowLength, newStorage,
        dynamic: isDynamic);
  }

  /// Returns a copy of attribute data frame that is marked as dynamic.
  ///
  /// The copy views the same attribute data as this current attribute data
  /// frame. Changes made to the attribute data through the copy will affect
  /// this current attribute data frame and vice versa.
  ///
  /// When a frame is marked as dynamic it signals to the rendering back-end
  /// that the data in the attribute data frame is intended to be modified
  /// regularly, allowing the rendering back-end to optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an attribute data frame
  /// that is not marked as dynamic can still be modified.
  AttributeDataFrame asDynamic() =>
      new AttributeDataFrame.fromFloat32List(rowLength, _storage,
          dynamic: true);

  /// Returns a copy of attribute data frame that is not marked as dynamic.
  ///
  /// The copy views the same attribute data as this current attribute data
  /// frame. Changes made to the attribute data through the copy will affect
  /// this current attribute data frame and vice versa.
  ///
  /// When a frame is not marked as dynamic it signals to the rendering back-end
  /// that the data in the attribute data frame is not intended to be modified
  /// regularly, allowing the rendering back-end to optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an attribute data frame
  /// that is not marked as dynamic can still be modified.
  AttributeDataFrame asStatic() =>
      new AttributeDataFrame.fromFloat32List(rowLength, _storage,
          dynamic: false);

  /// Returns a view of the data row at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
  AttributeDataRowView operator [](int index) => elementAt(index);
}

/// Iterator over the rows in an [AttributeDataFrame].
class AttributeDataFrameIterator extends Iterator<AttributeDataRowView> {
  final AttributeDataFrame frame;

  int _frameLength;

  int _currentRowIndex = -1;

  /// Instantiates a new iterator over the rows in the given attribute data
  /// frame.
  AttributeDataFrameIterator(AttributeDataFrame frame)
      : frame = frame,
        _frameLength = frame.length;

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

  final int length;

  final Float32List _storage;

  final int _rowDataOffset;

  /// Creates a new attribute data row view of a row in the given attribute data
  /// frame, with the given index.
  AttributeDataRowView(AttributeDataFrame frame, int index)
      : frame = frame,
        index = index,
        length = frame.rowLength,
        _storage = frame._storage,
        _rowDataOffset = frame.rowLength * index {
    RangeError.checkValidIndex(index, frame);
  }

  AttributeDataRowViewIterator get iterator =>
      new AttributeDataRowViewIterator(this);

  double elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return _storage[_rowDataOffset + index];
  }

  /// Returns the value at the specified index.
  double operator [](int index) => elementAt(index);

  /// Sets the value at the specified index to the given value.
  void operator []=(int index, double value) {
    RangeError.checkValidIndex(index, this);

    _storage[_rowDataOffset + index] = value;
  }
}

/// Iterator over the values in an [AttributeDataRowView].
class AttributeDataRowViewIterator extends Iterator<double> {
  final AttributeDataRowView row;

  final Float32List _storage;

  final int _rowLength;

  final int _rowDataOffset;

  int _currentValueIndex = -1;

  /// Creates a new iterator over the values in an attribute data row view.
  AttributeDataRowViewIterator(AttributeDataRowView row)
      : row = row,
        _storage = row.frame._storage,
        _rowLength = row.length,
        _rowDataOffset = row._rowDataOffset;

  double get current {
    if (_currentValueIndex >= 0 && _currentValueIndex < _rowLength) {
      return _storage[_rowDataOffset + _currentValueIndex];
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentValueIndex++;

    return _currentValueIndex < _rowLength;
  }
}
