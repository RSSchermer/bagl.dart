part of math;

abstract class _VertexBase extends _MatrixBase {
  final bool isSquare = false;

  Matrix _transpose;

  Iterable<double> get valuesRowPacked => valuesColumnPacked;

  Matrix get transpose {
    if (_transpose == null) {
      _transpose = new Matrix.fromList(_storage, rowDimension);
    }

    return _transpose;
  }

  double get determinant =>
      throw new UnsupportedError('Matrix must be square.');

  bool get isNonSingular =>
      throw new UnsupportedError('Matrix must be square.');

  Vector2 get inverse =>
      throw new UnsupportedError('This matrix is singular (has no inverse).');
}
