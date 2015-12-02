part of bagl;

/// A fixed-length list of [Vector2] vectors that is viewable as a [TypedData].
class Vector2List extends ListBase<Vector2>
    with NonGrowableListMixin<Vector2>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 2;

  static const int _elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int elementSizeInBytes = _elementSizeInBytes;

  final int offsetInBytes = 0;

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
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, elements[i].storage);
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
        _storage = new Float32List.view(buffer, offsetInBytes, length);

  ByteBuffer get buffer => _storage.buffer;

  int get lengthInBytes =>
      length * Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  Vector2 operator [](int index) {
    return new Vector2.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Vector2 value) {
    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}

class Vector3List extends ListBase<Vector3>
    with NonGrowableListMixin<Vector3>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 3;

  final int elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int lengthInBytes;

  final int offsetInBytes = 0;

  final int length;

  Vector3List.fromList(List<Vector3> values)
      : lengthInBytes = values.length *
            Float32List.BYTES_PER_ELEMENT *
            _elementSizeInFloats,
        length = values.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, values[i].storage);
    }
  }

  ByteBuffer get buffer => _storage.buffer;

  Vector3 operator [](int index) {
    return new Vector3.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Vector3 value) {
    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}

class Vector4List extends ListBase<Vector4>
    with NonGrowableListMixin<Vector4>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 4;

  final int elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int lengthInBytes;

  final int offsetInBytes = 0;

  final int length;

  Vector4List.fromList(List<Vector4> values)
      : lengthInBytes = values.length *
            Float32List.BYTES_PER_ELEMENT *
            _elementSizeInFloats,
        length = values.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, values[i].storage);
    }
  }

  ByteBuffer get buffer => _storage.buffer;

  Vector4 operator [](int index) {
    return new Vector4.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Vector4 value) {
    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}

class Matrix2List extends ListBase<Matrix2>
    with NonGrowableListMixin<Matrix2>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 4;

  final int elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int lengthInBytes;

  final int offsetInBytes = 0;

  final int length;

  Matrix2List.fromList(List<Matrix2> values)
      : lengthInBytes = values.length *
            Float32List.BYTES_PER_ELEMENT *
            _elementSizeInFloats,
        length = values.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, values[i].storage);
    }
  }

  ByteBuffer get buffer => _storage.buffer;

  Matrix2 operator [](int index) {
    return new Matrix2.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Matrix2 value) {
    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}

class Matrix3List extends ListBase<Matrix3>
    with NonGrowableListMixin<Matrix3>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 9;

  final int elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int lengthInBytes;

  final int offsetInBytes = 0;

  final int length;

  Matrix3List.fromList(List<Matrix3> values)
      : lengthInBytes = values.length *
            Float32List.BYTES_PER_ELEMENT *
            _elementSizeInFloats,
        length = values.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, values[i].storage);
    }
  }

  ByteBuffer get buffer => _storage.buffer;

  Matrix3 operator [](int index) {
    return new Matrix3.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Matrix3 value) {
    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}

class Matrix4List extends ListBase<Matrix4>
    with NonGrowableListMixin<Matrix4>, TypedData {
  Float32List _storage;

  static const int _elementSizeInFloats = 16;

  final int elementSizeInBytes =
      Float32List.BYTES_PER_ELEMENT * _elementSizeInFloats;

  final int lengthInBytes;

  final int offsetInBytes = 0;

  final int length;

  Matrix4List.fromList(List<Matrix4> values)
      : lengthInBytes = values.length *
            Float32List.BYTES_PER_ELEMENT *
            _elementSizeInFloats,
        length = values.length {
    _storage = new Float32List(_elementSizeInFloats * length);

    for (var i = 0; i < length; i++) {
      _storage.setRange(i * _elementSizeInFloats,
          (i + 1) * _elementSizeInFloats, values[i].storage);
    }
  }

  ByteBuffer get buffer => _storage.buffer;

  Matrix4 operator [](int index) {
    return new Matrix4.fromFloat32List(new Float32List(_elementSizeInFloats)
      ..setRange(
          0, _elementSizeInFloats, _storage, index * _elementSizeInFloats));
  }

  void operator []=(int index, Matrix4 value) {
    var s = index * _elementSizeInFloats;

    _storage.setRange(s, s + _elementSizeInFloats, value.storage);
  }
}
