part of matrix_list;

/// A fixed-length list of [Vector2] vectors that is viewable as a [TypedData].
class Vector2List extends ListBase<Vector2>
    with NonGrowableListMixin<Vector2>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 2;

  static const int _elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int elementSizeInBytes = _elementSizeInBytes;

  final int length;

  /// Creates a [Vector2List] of the specified length (in elements), all of
  /// whose elements are initially zero.
  Vector2List(int length)
      : length = length,
        _storage = new Float32List(_elementSizeInFloats * length);

  /// Creates a [Vector2List] with the same length as the [elements] list and
  /// copies over the elements.
  Vector2List.fromList(List<Vector2> elements) : length = elements.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      final s = i * _elementSizeInFloats;
      final value = elements[i];

      _storage[s] = value.x;
      _storage[s + 1] = value.y;
    }
  }

  /// Creates a [Vector2List] view of the specified region in [buffer].
  ///
  /// Changes in the [Vector2List] will be visible in the byte buffer and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the byte buffer). If the [length] is
  /// not specified, it defaults to `null`, which indicates that the view
  /// extends to the end of the byte buffer.
  ///
  /// Throws [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  Vector2List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : length = length ??
            (buffer.lengthInBytes - offsetInBytes) ~/ _elementSizeInBytes,
        _storage = new Float32List.view(
            buffer, offsetInBytes, length * _elementSizeInFloats);

  ByteBuffer get buffer => _storage.buffer;

  int get lengthInBytes =>
      length * Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  int get offsetInBytes => _storage.offsetInBytes;

  Vector2 operator [](int index) {
    RangeError.checkValidIndex(index, this);

    final s = index * _elementSizeInFloats;

    return new Vector2(_storage[s], _storage[s + 1]);
  }

  void operator []=(int index, Vector2 value) {
    RangeError.checkValidIndex(index, this);

    var s = index * _elementSizeInFloats;

    _storage[s] = value.x;
    _storage[s + 1] = value.y;
  }
}
