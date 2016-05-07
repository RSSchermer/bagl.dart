part of vertex_data;

/// Vertex attribute data viewed as rows of [double] values.
///
/// Each row in represents the attribute data for a single vertex as a sequence
/// of [double] values. All rows are of equal length. A single row must not hold
/// attribute data for more than one vertex and the attribute data for a single
/// vertex must not be spread over more than one row. The rows are ordered and
/// each row is uniquely identified by consecutive integer indices starting at
/// 0.
///
/// The following is an example of a [AttributeDataTable] that stores data for
/// a 2D position attribute, interleaved with data for an RGB color attribute:
///
///     var attributeData = new AttributeDataTable(5, [
///        // Position    // Color
///        0.0,  0.5,     1.0, 0.0, 0.0,
///       -0.5, -0.5,     0.0, 1.0, 0.0,
///        0.5, -0.5,     0.0, 0.0, 1.0
///     ]);
///
/// Note that not all attribute data for a [VertexArray] needs to be interleaved
/// in a single [AttributeDataTable]; the attribute data for different
/// attributes can be spread over multiple [AttributeDataTable]s. However, all
/// [AttributeDataTable]s must have the same length (same number of rows). Rows
/// at corresponding indices then describe different attributes of the same
/// vertex. For example, one [AttributeDataTable] might be used to store data
/// for a `position` attribute, and a separate [AttributeDataTable] might be
/// used to store data for a `color` attribute.
class AttributeDataTable extends IterableBase<AttributeDataRowView>
    with TypedData {
  /// The length of the rows in this [AttributeDataTable].
  ///
  /// Represents the number of Float32 values per row, not the number of bytes
  /// per row.
  final int rowLength;

  /// The number of rows in this [AttributeDataTable].
  final int length;

  /// Whether or not this [AttributeDataTable] is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that the data in the
  /// [AttributeDataTable] is intended to be modified regularly, allowing the
  /// rendering back-end to optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in a [AttributeDataTable]
  /// that is not marked as dynamic can still be modified.
  final bool isDynamic;

  /// Typed [Float32List] view on the attribute data.
  final Float32List _storage;

  /// Instantiates a new [AttributeDataTable] with the specified [rowLength],
  /// filled with the given [data].
  ///
  ///     var attributeData = new AttributeDataTable(5, [
  ///        // Position    // Color
  ///        0.0,  0.5,     1.0, 0.0, 0.0,
  ///       -0.5, -0.5,     0.0, 1.0, 0.0,
  ///        0.5, -0.5,     0.0, 0.0, 1.0
  ///     ]);
  ///
  /// Optionally, the [dynamic] parameter may be specified. When `true` it
  /// signals to the rendering back-end that the data in the
  /// [AttributeDataTable] is intended to be modified regularly, allowing the
  /// rendering back-end to optimize for this. The default value is `false`.
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an [AttributeDataTable]
  /// that is not marked as dynamic can still be modified.
  factory AttributeDataTable(int rowLength, List<double> data,
          {bool dynamic: false}) =>
      new AttributeDataTable.fromFloat32List(
          rowLength, new Float32List.fromList(data),
          dynamic: dynamic);

  /// Creates a new [AttributeDataTable] as a view on the given [Float32List],
  /// partitioned into rows of the specified [rowLength].
  ///
  /// Optionally, the [dynamic] parameter may be specified. When `true` it
  /// signals to the rendering back-end that the data in the
  /// [AttributeDataTable] is intended to be modified regularly, allowing the
  /// rendering back-end to optimize for this. The default value is `false`.
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an [AttributeDataTable]
  /// that is not marked as dynamic can still be modified.
  ///
  /// The [AttributeDataTable] acts as a view on the [FLoat32List], which means
  /// that changes to the [AttributeDataTable] will affect the [Float32List]
  /// and vice versa.
  AttributeDataTable.fromFloat32List(int rowLength, Float32List data,
      {bool dynamic: false})
      : rowLength = rowLength,
        length = data.length ~/ rowLength,
        isDynamic = dynamic,
        _storage = data;

  /// Creates an [AttributeDataTable] view of the specified region in the
  /// [buffer].
  ///
  /// If the [offsetInBytes] of the region is not specified, it defaults to zero
  /// (the first byte in the [buffer]). If the [length] is not specified, it
  /// defaults to `null`, which indicates that the view extends to the end of
  /// the [buffer].
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of the [buffer].
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// `rowLength * Float32List.BYTES_PER_ELEMENT`.
  factory AttributeDataTable.view(int rowLength, ByteBuffer buffer,
          [int offsetInBytes = 0, int length]) =>
      new AttributeDataTable.fromFloat32List(rowLength,
          new Float32List.view(buffer, offsetInBytes, length * rowLength),
          dynamic: false);

  // TODO: when Dart support optional positional and named parameters on the
  // same method, merge dynamicView into view.

  /// Creates an [AttributeDataTable] view of the specified region in the
  /// [buffer] that is marked as dynamic.
  ///
  /// If the [offsetInBytes] of the region is not specified, it defaults to zero
  /// (the first byte in the [buffer]). If the [length] is not specified, it
  /// defaults to `null`, which indicates that the view extends to the end of
  /// the [buffer].
  ///
  /// When a [AttributeDataTable] is marked as dynamic it signals to the
  /// rendering back-end that the data in the [AttributeDataTable] is intended
  /// to be modified regularly, allowing the rendering back-end to optimize for
  /// this. Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an [AttributeDataTable]
  /// that is not marked as dynamic can still be modified.
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of the [buffer].
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// `rowLength * Float32List.BYTES_PER_ELEMENT`.
  factory AttributeDataTable.dynamicView(int rowLength, ByteBuffer buffer,
          [int offsetInBytes = 0, int length]) =>
      new AttributeDataTable.fromFloat32List(rowLength,
          new Float32List.view(buffer, offsetInBytes, length * rowLength),
          dynamic: true);

  ByteBuffer get buffer => _storage.buffer;

  int get elementSizeInBytes => _storage.elementSizeInBytes * rowLength;

  int get offsetInBytes => _storage.offsetInBytes;

  int get lengthInBytes => _storage.lengthInBytes;

  AttributeDataTableIterator get iterator =>
      new AttributeDataTableIterator(this);

  AttributeDataRowView elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return new AttributeDataRowView(this, index);
  }

  /// Returns a new [AttributeDataTable] without the row at the given [index].
  ///
  /// Throws a [RangeError] when the given [index] is smaller than 0 or greater
  /// than the [length] of the [AttributeDataTable].
  AttributeDataTable withoutRow(int index) {
    RangeError.checkValidIndex(index, this);

    final newSize = _storage.length - rowLength;
    final rowStartPos = index * rowLength;

    // Note: Float32List.setRange compiles to very optimized javascript in
    // Dart2JS when the source list is itself also a Float32List.
    final newStorage = new Float32List(newSize)
      ..setRange(0, rowStartPos, _storage)
      ..setRange(rowStartPos, newSize, _storage, rowStartPos + rowLength);

    return new AttributeDataTable(rowLength, newStorage, dynamic: isDynamic);
  }

  /// Returns a new [AttributeDataTable] without the rows at the specified
  /// indices.
  ///
  /// This method is more efficient than calling [withoutRow] repeatedly to
  /// remove multiple rows from the [AttributeDataTable].
  ///
  /// Throws a [RangeError] if any of the specified row indices are smaller than
  /// 0 or greater than the [length] of the [AttributeDataTable].
  AttributeDataTable withoutRows(Iterable<int> indices) {
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

    // Check if there are rows at the tail of the table that remain to be
    // copied. If remaining rows are found, copy them over to the new storage
    // buffer.
    if (lastRemovedRow < length - 1) {
      final start = copiedRowCount * rowLength;
      final skipCount = (lastRemovedRow + 1) * rowLength;

      newStorage.setRange(start, newSize, _storage, skipCount);
    }

    return new AttributeDataTable.fromFloat32List(rowLength, newStorage,
        dynamic: isDynamic);
  }

  /// Returns a new [AttributeDataTable] with the given [data] appended onto the
  /// end.
  AttributeDataTable withAppendedData(Iterable<double> data) {
    final newSize = _storage.length + data.length;

    // Note: Dart2JS Float32List.setRange compiles to highly optimized
    // javascript when the source list is itself also a Float32List.
    final newStorage = new Float32List(newSize)
      ..setRange(0, _storage.length, _storage)
      ..setRange(_storage.length, newSize, data);

    return new AttributeDataTable(rowLength, newStorage, dynamic: isDynamic);
  }

  /// Returns a new [AttributeDataTable] in which the data in this current
  /// [AttributeDataTable] is interleaved with the data in the given
  /// [attributeDataTable].
  ///
  /// Interleaves this [AttributeDataTable] `A` with row length `a` and another
  /// [AttributeDataTable] `B` with row length `b`, resulting in a new
  /// [AttributeDataTable] with row length `a + b`. The first `a` values of a
  /// row in the new table will be values from table `A` and the last `b`
  /// values of a row in the new table will be values from table `B`.
  ///
  /// Throws an [ArgumentError] if the lengths (rowCount) of `A` and `B` are not
  /// equal.
  AttributeDataTable interleavedWith(AttributeDataTable attributeDataTable) {
    if (attributeDataTable.length != length) {
      throw new ArgumentError(
          'Both attribute data tables must have the same number of rows.');
    }

    final rowCount = length;
    final aRowLength = rowLength;
    final bRowLength = attributeDataTable.rowLength;
    final bStorage = attributeDataTable._storage;
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

    return new AttributeDataTable.fromFloat32List(
        aRowLength + bRowLength, newStorage,
        dynamic: isDynamic);
  }

  /// Creates a new [AttributeDataTable] from a range of rows and (optionally) a
  /// range of columns on this current [AttributeDataTable].
  ///
  /// Creates a new [AttributeDataTable] from a row range from [rowStart] to
  /// [rowEnd] and optionally a column range from [colStart] to [colEnd]. The
  /// [rowEnd] defaults to null, indicating that the new [AttributeDataTable]
  /// should extend until the end of the old table. The [colStart] defaults to
  /// 0, indicating that the new sub-table's columns extend from the start of
  /// the old table's columns. The [colEnd] defaults to null, indicating that
  /// the new sub-table's columns should extend until the end of the old table's
  /// columns. [rowStart] and [colStart] are inclusive, the [rowEnd] and
  /// [colEnd] are exclusive.
  ///
  /// Creates a new byte sequence to store the new attribute data. See also
  /// [subTableView] which does not create a new byte sequence, but creates the
  /// new [AttributeDataTable] as a view on the existing attribute data.
  ///
  /// Throws a [RangeError] if [rowStart] or [rowEnd] is smaller than 0 or
  /// greater than the [length] of this [AttributeDataTable].
  ///
  /// Throws a [RangeError] if [colStart] or [colEnd] is smaller than 0 or
  /// greater than the [rowLength] in this [AttributeDataTable].
  ///
  /// Throws an [ArgumentError] if [rowEnd] is equal to or smaller than
  /// [rowStart].
  ///
  /// Throws an [ArgumentError] if [colEnd] is equal to or smaller than
  /// [colStart].
  AttributeDataTable subTable(int rowStart,
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

      return new AttributeDataTable(rowLength, newStorage);
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

      return new AttributeDataTable.fromFloat32List(newRowLength, newStorage,
          dynamic: isDynamic);
    }
  }

  /// Creates a new [AttributeDataTable] as a view on this current
  /// [AttributeDataTable].
  ///
  /// Creates a new [AttributeDataTable] as a view on this current
  /// [AttributeDataTable], starting at [rowStart]. Optionally a [rowEnd] may be
  /// specified. If omitted the view will extend until the end of the current
  /// [AttributeDataTable]. The [rowStart] is inclusive, the [rowEnd] is
  /// exclusive.
  ///
  /// The new [AttributeDataTable] acts as a view on this current
  /// [AttributeDataTable], which means that changes to the data in this current
  /// [AttributeDataTable] will affect the data in the view and vice versa.
  ///
  /// See also [subTable] which creates a new [AttributeDataTable] that is
  /// independent of this current [AttributeDataTable] and allows specifying a
  /// column range in addition to a row range.
  ///
  /// Throws a [RangeError] if the specified [rowStart] is out of bounds.
  ///
  /// Throws a [RangeError] if the specified [rowEnd] is out of bounds.
  ///
  /// Throws an [ArgumentError] if [rowEnd] is equal to or smaller than
  /// [rowStart].
  AttributeDataTable subTableView(int rowStart, [int rowEnd]) {
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

    return new AttributeDataTable.fromFloat32List(rowLength, newStorage,
        dynamic: isDynamic);
  }

  /// Returns a new [AttributeDataTable] that is marked as dynamic.
  ///
  /// The new [AttributeDataTable] views the same attribute data as this current
  /// [AttributeDataTable]. Changes made to the attribute data through the new
  /// [AttributeDataTable] will affect this current [AttributeDataTable] and
  /// vice versa.
  ///
  /// When an [AttributeDataTable] is marked as dynamic it signals to the
  /// rendering back-end that the data in the [AttributeDataTable] is intended
  /// to be modified regularly, allowing the rendering back-end to optimize for
  /// this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an [AttributeDataTable]
  /// that is not marked as dynamic can still be modified.
  AttributeDataTable asDynamic() =>
      new AttributeDataTable.fromFloat32List(rowLength, _storage,
          dynamic: true);

  /// Returns a new [AttributeDataTable] that is not marked as dynamic.
  ///
  /// The new [AttributeDataTable] views the same attribute data as this current
  /// [AttributeDataTable]. Changes made to the attribute data through the new
  /// [AttributeDataTable] will affect this current [AttributeDataTable] and
  /// vice versa.
  ///
  /// When an [AttributeDataTable] is not marked as dynamic it signals to the
  /// rendering back-end that the data in the [AttributeDataTable] is not
  /// intended to be modified regularly, allowing the rendering back-end to
  /// optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: the data in an [AttributeDataTable]
  /// that is not marked as dynamic can still be modified.
  AttributeDataTable asStatic() =>
      new AttributeDataTable.fromFloat32List(rowLength, _storage,
          dynamic: false);

  /// Returns the data row at the given [index].
  ///
  /// Throws a [RangeError] if the index is out of bounds.
  AttributeDataRowView operator [](int index) => elementAt(index);
}

/// Iterator over the rows in an [AttributeDataTable].
class AttributeDataTableIterator extends Iterator<AttributeDataRowView> {
  final AttributeDataTable attributeDataTable;

  int _tableLength;

  int _currentRowIndex = -1;

  /// Instantiates a new iterator over the rows in the given
  /// [attributeDataTable].
  AttributeDataTableIterator(AttributeDataTable attributeDataTable)
      : attributeDataTable = attributeDataTable,
        _tableLength = attributeDataTable.length;

  AttributeDataRowView get current {
    if (_currentRowIndex >= 0 && _currentRowIndex < _tableLength) {
      return new AttributeDataRowView(attributeDataTable, _currentRowIndex);
    } else {
      return null;
    }
  }

  bool moveNext() {
    _currentRowIndex++;

    return _currentRowIndex < _tableLength;
  }
}

/// View of a row in an [AttributeDataTable].
class AttributeDataRowView extends IterableBase<double> {
  /// The [AttributeDataTable] this row belongs to.
  final AttributeDataTable attributeDataTable;

  /// The index of the row in the [AttributeDataTable].
  final int index;

  final int length;

  final Float32List _storage;

  final int _rowDataOffset;

  /// Creates a new [AttributeDataRowView] of the row in the
  /// [attributeDataTable] at the specified [index].
  AttributeDataRowView(AttributeDataTable attributeDataTable, int index)
      : attributeDataTable = attributeDataTable,
        index = index,
        length = attributeDataTable.rowLength,
        _storage = attributeDataTable._storage,
        _rowDataOffset = attributeDataTable.rowLength * index {
    RangeError.checkValidIndex(index, attributeDataTable);
  }

  AttributeDataRowViewIterator get iterator =>
      new AttributeDataRowViewIterator(this);

  double elementAt(int index) {
    RangeError.checkValidIndex(index, this);

    return _storage[_rowDataOffset + index];
  }

  /// Returns the value at the [index].
  double operator [](int index) => elementAt(index);

  /// Sets the value at the [index] to the given [value].
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

  /// Creates a new iterator over the values in an [AttributeDataRowView].
  AttributeDataRowViewIterator(AttributeDataRowView row)
      : row = row,
        _storage = row.attributeDataTable._storage,
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
