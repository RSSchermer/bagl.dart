part of matrix_list;

/// A fixed-length list of [Vector4] vectors that is viewable as a [TypedData].
class Vector4List extends ListBase<Vector4>
    with NonGrowableListMixin<Vector4>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 4;

  static const int _elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int elementSizeInBytes = _elementSizeInBytes;

  final int length;

  /// Creates a [Vector4List] of the specified length (in elements), all of
  /// whose elements are initially zero.
  Vector4List(int length)
      : length = length,
        _storage = new Float32List(_elementSizeInFloats * length);

  /// Creates a [Vector4List] with the same length as the [elements] list and
  /// copies over the elements.
  Vector4List.fromList(List<Vector4> elements) : length = elements.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      final s = i * _elementSizeInFloats;
      final value = elements[i];

      _storage[s] = value.x;
      _storage[s + 1] = value.y;
      _storage[s + 2] = value.z;
      _storage[s + 3] = value.w;
    }
  }

  /// Creates a [Vector4List] view of the specified region in [buffer].
  ///
  /// Changes in the [Vector4List] will be visible in the byte buffer and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the byte buffer). If the [length] is
  /// not specified, it defaults to `null`, which indicates that the view
  /// extends to the end of the byte buffer.
  ///
  /// Throws [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  Vector4List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : length = length ??
            (buffer.lengthInBytes - offsetInBytes) ~/ _elementSizeInBytes,
        _storage = new Float32List.view(
            buffer, offsetInBytes, length * _elementSizeInFloats);

  ByteBuffer get buffer => _storage.buffer;

  int get lengthInBytes =>
      length * Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  int get offsetInBytes => _storage.offsetInBytes;

  Vector4 operator [](int index) {
    RangeError.checkValidIndex(index, this);

    final s = index * _elementSizeInFloats;

    return new Vector4(
        _storage[s], _storage[s + 1], _storage[s + 2], _storage[s + 3]);
  }

  void operator []=(int index, Vector4 value) {
    RangeError.checkValidIndex(index, this);

    var s = index * _elementSizeInFloats;

    _storage[s] = value.x;
    _storage[s + 1] = value.y;
    _storage[s + 2] = value.z;
    _storage[s + 3] = value.w;
  }
}
