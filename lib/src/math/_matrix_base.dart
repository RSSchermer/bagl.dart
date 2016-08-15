part of math;

/// Base class for dimension specific matrices and vectors.
abstract class _MatrixBase implements Matrix {
  Float32List get _storage;

  PivotingLUDecomposition _luDecomposition;

  ReducedQRDecomposition _qrDecomposition;

  Iterable<double> get valuesRowPacked => new UnmodifiableListView(_storage);

  Iterable<double> get values => valuesRowPacked;

  List<double> rowAt(int index) {
    RangeError.checkValueInInterval(index, 0, rowDimension);

    final values = new Float32List(columnDimension);
    final start = index * columnDimension;

    for (var i = 0; i < columnDimension; i++) {
      values[i] = _storage[start + i];
    }

    return values;
  }

  double valueAt(int row, int column) {
    RangeError.checkValueInInterval(row, 0, rowDimension);
    RangeError.checkValueInInterval(column, 0, columnDimension);

    return _storage[row * columnDimension + column];
  }

  Matrix subMatrix(int rowStart, int rowEnd, int colStart, int colEnd) {
    if (rowEnd <= rowStart) {
      throw new ArgumentError(
          'The rowEnd index must be greater than the rowStart index.');
    }

    if (colEnd <= colStart) {
      throw new ArgumentError(
          'The colEnd index must be greater than the colStart index.');
    }

    final rows = (rowEnd - rowStart);
    final cols = (colEnd - colStart);
    final subMatrixVals = new Float32List(rows * cols);

    for (var i = rowStart; i < rowEnd; i++) {
      final m = (i - rowStart) * cols;

      for (var j = colStart; j < colEnd; j++) {
        subMatrixVals[m + j - colStart] = valueAt(i, j);
      }
    }

    return new Matrix.fromList(subMatrixVals, cols);
  }

  PivotingLUDecomposition get luDecomposition {
    if (_luDecomposition != null) {
      return _luDecomposition;
    }

    _luDecomposition = new PivotingLUDecomposition(this);

    return _luDecomposition;
  }

  ReducedQRDecomposition get qrDecomposition {
    if (_qrDecomposition != null) {
      return _qrDecomposition;
    }

    _qrDecomposition = new ReducedQRDecomposition(this);

    return _qrDecomposition;
  }

  Matrix matrixProduct(Matrix B) {
    if (columnDimension != B.rowDimension) {
      throw new ArgumentError('Matrix inner dimensions must agree.');
    }

    final rows = rowDimension;
    final bCols = B.columnDimension;
    final bVals = B.values;
    final productValues = new Float32List(rows * bCols);
    var counter = 0;

    for (var row = 0; row < rows; row++) {
      final m = row * columnDimension;

      for (var col = 0; col < bCols; col++) {
        var sum = 0.0;

        for (var j = 0; j < columnDimension; j++) {
          sum += _storage[m + j] * bVals.elementAt(j * bCols + col);
        }

        productValues[counter] = sum;
        counter++;
      }
    }

    return new Matrix.fromList(productValues, B.columnDimension);
  }

  Matrix solve(Matrix B) {
    if (columnDimension > rowDimension) {
      throw new UnsupportedError('Matrix has more columns than rows.');
    }

    if (isSquare) {
      return luDecomposition.solve(B);
    } else {
      return qrDecomposition.solve(B);
    }
  }

  Matrix solveTranspose(Matrix B) {
    if (rowDimension > columnDimension) {
      throw new UnsupportedError('Matrix has more rows than columns.');
    }

    return transpose.solve(B.transpose).transpose;
  }

  operator *(a) {
    if (a is num) {
      return scalarProduct(a);
    } else if (a is Matrix) {
      return matrixProduct(a);
    } else {
      throw new ArgumentError('Expected num or Matrix.');
    }
  }

  bool operator ==(dynamic other) =>
      identical(this, other) || other is Matrix &&
      columnDimension == other.columnDimension &&
          _iterableEquals(_storage, other.values);

  int get hashCode =>
      hash3(columnDimension, rowDimension, hashObjects(_storage));
}

Function _iterableEquals = const ListEquality().equals;

_assertEqualDimensions(Matrix A, Matrix B) {
  if (A.columnDimension != B.columnDimension ||
      A.rowDimension != B.rowDimension) {
    throw new ArgumentError('The dimenions of the matrices must match (the row '
        'dimenions must be equal and the column dimenions must be equal).');
  }
}
