part of bagl.matrix_list;

/// A fixed-length list of [Matrix2] vectors that is viewable as a [TypedData].
class Matrix2List extends ListBase<Matrix2>
    with NonGrowableListMixin<Matrix2>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 4;

  static const int _elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int elementSizeInBytes = _elementSizeInBytes;

  final int length;

  /// Creates a [Matrix2List] of the specified length (in elements), all of
  /// whose elements are initially zero.
  Matrix2List(int length)
      : length = length,
        _storage = new Float32List(_elementSizeInFloats * length);

  /// Creates a [Matrix2List] with the same length as the [elements] list and
  /// copies over the elements.
  Matrix2List.fromList(List<Matrix2> elements) : length = elements.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      final s = i * _elementSizeInFloats;
      final value = elements[i];

      _storage[s] = value.r0c0;
      _storage[s + 1] = value.r1c0;
      _storage[s + 2] = value.r0c1;
      _storage[s + 3] = value.r1c1;
    }
  }

  /// Creates a [Matrix2List] view of the specified region in [buffer].
  ///
  /// The buffer is viewed in column major order. Changes in the [Matrix2List]
  /// will be visible in the byte buffer and vice versa. If the [offsetInBytes]
  /// index of the region is not specified, it defaults to zero (the first byte
  /// in the byte buffer). If the [length] is not specified, it defaults to
  /// `null`, which indicates that the view extends to the end of the byte
  /// buffer.
  ///
  /// Throws [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  Matrix2List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : length = length ??
            (buffer.lengthInBytes - offsetInBytes) ~/ _elementSizeInBytes,
        _storage = new Float32List.view(
            buffer, offsetInBytes, length * _elementSizeInFloats);

  ByteBuffer get buffer => _storage.buffer;

  int get lengthInBytes =>
      length * Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  int get offsetInBytes => _storage.offsetInBytes;

  Matrix2 operator [](int index) {
    RangeError.checkValidIndex(index, this);

    final s = index * _elementSizeInFloats;

    return new Matrix2(
        _storage[s], _storage[s + 2], _storage[s + 1], _storage[s + 3]);
  }

  void operator []=(int index, Matrix2 value) {
    RangeError.checkValidIndex(index, this);

    var s = index * _elementSizeInFloats;

    _storage[s] = value.r0c0;
    _storage[s + 1] = value.r1c0;
    _storage[s + 2] = value.r0c1;
    _storage[s + 3] = value.r1c1;
  }
}
