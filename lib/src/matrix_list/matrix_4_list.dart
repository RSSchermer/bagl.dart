part of matrix_list;

/// A fixed-length list of [Matrix4] vectors that is viewable as a [TypedData].
class Matrix4List extends ListBase<Matrix4>
    with NonGrowableListMixin<Matrix4>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 16;

  static const int _elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int elementSizeInBytes = _elementSizeInBytes;

  final int length;

  /// Creates a [Matrix4List] of the specified length (in elements), all of
  /// whose elements are initially zero.
  Matrix4List(int length)
      : length = length,
        _storage = new Float32List(_elementSizeInFloats * length);

  /// Creates a [Matrix4List] with the same length as the [elements] list and
  /// copies over the elements.
  Matrix4List.fromList(List<Matrix4> elements) : length = elements.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, elements[i].storage);
    }
  }

  /// Creates a [Matrix4List] view of the specified region in [buffer].
  ///
  /// Changes in the [Matrix4List] will be visible in the byte buffer and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the byte buffer). If the [length] is
  /// not specified, it defaults to `null`, which indicates that the view
  /// extends to the end of the byte buffer.
  ///
  /// Throws [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  Matrix4List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : length = length ??
            (buffer.lengthInBytes - offsetInBytes) ~/ _elementSizeInBytes,
        _storage = new Float32List.view(
            buffer, offsetInBytes, length * _elementSizeInFloats);

  ByteBuffer get buffer => _storage.buffer;

  int get lengthInBytes =>
      length * Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  int get offsetInBytes => _storage.offsetInBytes;

  Matrix4 operator [](int index) {
    RangeError.checkValidIndex(index, this);

    return new Matrix4.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Matrix4 value) {
    RangeError.checkValidIndex(index, this);

    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}
