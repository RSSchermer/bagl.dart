part of bagl.matrix_list;

/// A fixed-length list of [Matrix3] vectors that is viewable as a [TypedData].
class Matrix3List extends ListBase<Matrix3>
    with NonGrowableListMixin<Matrix3>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 9;

  static const int _elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int elementSizeInBytes = _elementSizeInBytes;

  final int length;

  /// Creates a [Matrix3List] of the specified length (in elements), all of
  /// whose elements are initially zero.
  Matrix3List(int length)
      : length = length,
        _storage = new Float32List(_elementSizeInFloats * length);

  /// Creates a [Matrix3List] with the same length as the [elements] list and
  /// copies over the elements.
  Matrix3List.fromList(List<Matrix3> elements) : length = elements.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      final s = i * _elementSizeInFloats;
      final value = elements[i];

      _storage[s] = value.r0c0;
      _storage[s + 1] = value.r1c0;
      _storage[s + 2] = value.r2c0;
      _storage[s + 3] = value.r0c1;
      _storage[s + 4] = value.r1c1;
      _storage[s + 5] = value.r2c1;
      _storage[s + 6] = value.r0c2;
      _storage[s + 7] = value.r1c2;
      _storage[s + 8] = value.r2c2;
    }
  }

  /// Creates a [Matrix3List] view of the specified region in [buffer].
  ///
  /// The buffer is viewed in column major order. Changes in the [Matrix3List]
  /// will be visible in the byte buffer and vice versa. If the [offsetInBytes]
  /// index of the region is not specified, it defaults to zero (the first byte
  /// in the byte buffer). If the [length] is not specified, it defaults to
  /// `null`, which indicates that the view extends to the end of the byte
  /// buffer.
  ///
  /// Throws [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  Matrix3List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : length = length ??
            (buffer.lengthInBytes - offsetInBytes) ~/ _elementSizeInBytes,
        _storage = new Float32List.view(
            buffer, offsetInBytes, length * _elementSizeInFloats);

  ByteBuffer get buffer => _storage.buffer;

  int get lengthInBytes =>
      length * Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  int get offsetInBytes => _storage.offsetInBytes;

  Matrix3 operator [](int index) {
    RangeError.checkValidIndex(index, this);

    final s = index * _elementSizeInFloats;

    return new Matrix3(
        _storage[s],
        _storage[s + 3],
        _storage[s + 6],
        _storage[s + 1],
        _storage[s + 4],
        _storage[s + 7],
        _storage[s + 2],
        _storage[s + 5],
        _storage[s + 8]);
  }

  void operator []=(int index, Matrix3 value) {
    RangeError.checkValidIndex(index, this);

    var s = index * _elementSizeInFloats;

    _storage[s] = value.r0c0;
    _storage[s + 1] = value.r1c0;
    _storage[s + 2] = value.r2c0;
    _storage[s + 3] = value.r0c1;
    _storage[s + 4] = value.r1c1;
    _storage[s + 5] = value.r2c1;
    _storage[s + 6] = value.r0c2;
    _storage[s + 7] = value.r1c2;
    _storage[s + 8] = value.r2c2;
  }
}
