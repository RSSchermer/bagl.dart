part of geometry;

/// Enumerates the available sizes for the indices in a [IndexList].
enum IndexSize { unsignedByte, unsignedShort, unsignedInt }

/// List of integers used to describe how the vertices in a [VertexArray] are
/// connected into geometry primitives.
abstract class IndexList implements List<int>, TypedData {
  /// Whether or not this [IndexList] is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that this [IndexList] is
  /// intended to be modified regularly, allowing the rendering back-end to
  /// optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: an [IndexList] that is not marked as
  /// dynamic can still be modified.
  bool get isDynamic;

  /// The size of the indices stored in this [IndexList].
  IndexSize get indexSize;
}

/// An [IndexList] that stores its indices as unsigned bytes (8 bits).
///
/// See also [Index16List] and [Index32List].
class Index8List extends DelegatingList<int> implements IndexList, Uint8List {
  final Uint8List delegate;

  final bool isDynamic;

  final IndexSize indexSize = IndexSize.unsignedShort;

  static const int BYTES_PER_ELEMENT = Uint8List.BYTES_PER_ELEMENT;

  /// Instantiates a new [Index8List] of the given [length] for which every
  /// position is initially set to `0`.
  factory Index8List(int length) =>
      new Index8List._fromUint8List(new Uint8List(length), false);

  /// Instantiates a new [Index8List] of the given [length] for which every
  /// position is initially set to `0`, marked as dynamic.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory Index8List.dynamic(int length) =>
      new Index8List._fromUint8List(new Uint8List(length), true);

  /// Instantiates a new [Index8List] of the given [length] with incrementing
  /// indices starting at [start].
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  factory Index8List.incrementing(int length, [int start = 0]) =>
      new Index8List._incrementingInternal(length, start, false);

  /// Instantiates a new [Index8List] of the given [length] with incrementing
  /// indices starting at [start], marked as dynamic.
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory Index8List.dynamicIncrementing(int length, [int start = 0]) =>
      new Index8List._incrementingInternal(length, start, true);

  factory Index8List._incrementingInternal(
      int length, int start, bool dynamic) {
    final data = new Uint8List(length);

    for (var i = 0; i < length; i++) {
      data[i] = start + i;
    }

    return new Index8List._fromUint8List(data, dynamic);
  }

  Index8List._fromUint8List(this.delegate, this.isDynamic);

  /// Instantiates a new [Index8List] from the given list of [elements].
  ///
  /// Instantiates a new [Index8List] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  Index8List.fromList(List<int> elements)
      : isDynamic = false,
        delegate = new Uint8List.fromList(elements);

  /// Instantiates a new [Index8List] from the given list of [elements], marked
  /// as dynamic.
  ///
  /// Instantiates a new [Index8List] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  Index8List.dynamicFromList(List<int> elements)
      : isDynamic = true,
        delegate = new Uint8List.fromList(elements);

  /// Instantiates a new [Index8List] as a view of the specified region in the
  /// [buffer].
  ///
  /// Changes to the [Index8List] will affect the data in the [buffer] and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the [buffer]). If the [length] is not
  /// specified, it defaults to null, which indicates that the view extends to
  /// the end of the [buffer].
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// [BYTES_PER_ELEMENT].
  Index8List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = false,
        delegate = new Uint8List.view(buffer, offsetInBytes, length);

  /// Instantiates a new [Index8List] as a view of the specified region in the
  /// [buffer], marked as dynamic
  ///
  /// Changes to the [Index8List] will affect the data in the [buffer] and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the [buffer]). If the [length] is not
  /// specified, it defaults to null, which indicates that the view extends to
  /// the end of the [buffer].
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// [BYTES_PER_ELEMENT].
  Index8List.dynamicView(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = true,
        delegate = new Uint8List.view(buffer, offsetInBytes, length);

  ByteBuffer get buffer => delegate.buffer;

  int get elementSizeInBytes => delegate.elementSizeInBytes;

  int get lengthInBytes => delegate.lengthInBytes;

  int get offsetInBytes => delegate.offsetInBytes;
}

/// An [IndexList] that stores its indices as unsigned shorts (16 bits).
///
/// See also [Index8List] and [Index32List].
class Index16List extends DelegatingList<int> implements IndexList, Uint16List {
  final Uint16List delegate;

  final bool isDynamic;

  final IndexSize indexSize = IndexSize.unsignedShort;

  static const int BYTES_PER_ELEMENT = Uint16List.BYTES_PER_ELEMENT;

  /// Instantiates a new [Index16List] of the given [length] for which every
  /// position is initially set to `0`.
  factory Index16List(int length) =>
      new Index16List._fromUint16List(new Uint16List(length), false);

  /// Instantiates a new [Index16List] of the given [length] for which every
  /// position is initially set to `0`, marked as dynamic.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory Index16List.dynamic(int length) =>
      new Index16List._fromUint16List(new Uint16List(length), true);

  /// Instantiates a new [Index16List] of the given [length] with incrementing
  /// indices starting at [start].
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  factory Index16List.incrementing(int length, [int start = 0]) =>
      new Index16List._incrementingInternal(length, start, false);

  /// Instantiates a new [Index16List] of the given [length] with incrementing
  /// indices starting at [start], marked as dynamic.
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory Index16List.dynamicIncrementing(int length, [int start = 0]) =>
      new Index16List._incrementingInternal(length, start, true);

  factory Index16List._incrementingInternal(
      int length, int start, bool dynamic) {
    final data = new Uint16List(length);

    for (var i = 0; i < length; i++) {
      data[i] = start + i;
    }

    return new Index16List._fromUint16List(data, dynamic);
  }

  Index16List._fromUint16List(this.delegate, this.isDynamic);

  /// Instantiates a new [Index16List] from the given list of [elements].
  ///
  /// Instantiates a new [Index16List] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  Index16List.fromList(List<int> elements)
      : isDynamic = false,
        delegate = new Uint16List.fromList(elements);

  /// Instantiates a new [Index16List] from the given list of [elements], marked
  /// as dynamic.
  ///
  /// Instantiates a new [Index16List] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  Index16List.dynamicFromList(List<int> elements)
      : isDynamic = true,
        delegate = new Uint16List.fromList(elements);

  /// Instantiates a new [Index16List] as a view of the specified region in the
  /// [buffer].
  ///
  /// Changes to the [Index16List] will affect the data in the [buffer] and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the [buffer]). If the [length] is not
  /// specified, it defaults to null, which indicates that the view extends to
  /// the end of the [buffer].
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// [BYTES_PER_ELEMENT].
  Index16List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = false,
        delegate = new Uint16List.view(buffer, offsetInBytes, length);

  /// Instantiates a new [Index16List] as a view of the specified region in the
  /// [buffer], marked as dynamic
  ///
  /// Changes to the [Index16List] will affect the data in the [buffer] and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the [buffer]). If the [length] is not
  /// specified, it defaults to null, which indicates that the view extends to
  /// the end of the [buffer].
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// [BYTES_PER_ELEMENT].
  Index16List.dynamicView(ByteBuffer buffer,
      [int offsetInBytes = 0, int length])
      : isDynamic = true,
        delegate = new Uint16List.view(buffer, offsetInBytes, length);

  ByteBuffer get buffer => delegate.buffer;

  int get elementSizeInBytes => delegate.elementSizeInBytes;

  int get lengthInBytes => delegate.lengthInBytes;

  int get offsetInBytes => delegate.offsetInBytes;
}

/// An [IndexList] that stores its indices as unsigned ints (32 bits).
///
/// See also [Index8List] and [Index16List].
class Index32List extends DelegatingList<int> implements IndexList, Uint16List {
  final Uint32List delegate;

  final bool isDynamic;

  final IndexSize indexSize = IndexSize.unsignedInt;

  static const int BYTES_PER_ELEMENT = Uint32List.BYTES_PER_ELEMENT;

  /// Instantiates a new [Index32List] of the given [length] for which every
  /// position is initially set to `0`.
  factory Index32List(int length) =>
      new Index32List._fromUint32List(new Uint32List(length), false);

  /// Instantiates a new [Index32List] of the given [length] for which every
  /// position is initially set to `0`, marked as dynamic.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory Index32List.dynamic(int length) =>
      new Index32List._fromUint32List(new Uint32List(length), true);

  /// Instantiates a new [Index32List] of the given [length] with incrementing
  /// indices starting at [start].
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  factory Index32List.incrementing(int length, [int start = 0]) =>
      new Index32List._incrementingInternal(length, start, false);

  /// Instantiates a new [Index32List] of the given [length] with incrementing
  /// indices starting at [start], marked as dynamic.
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory Index32List.dynamicIncrementing(int length, [int start = 0]) =>
      new Index32List._incrementingInternal(length, start, true);

  factory Index32List._incrementingInternal(
      int length, int start, bool dynamic) {
    final data = new Uint32List(length);

    for (var i = 0; i < length; i++) {
      data[i] = start + i;
    }

    return new Index32List._fromUint32List(data, dynamic);
  }

  Index32List._fromUint32List(this.delegate, this.isDynamic);

  /// Instantiates a new [Index32List] from the given list of [elements].
  ///
  /// Instantiates a new [Index32List] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  Index32List.fromList(List<int> elements)
      : isDynamic = false,
        delegate = new Uint32List.fromList(elements);

  /// Instantiates a new [Index32List] from the given list of [elements], marked
  /// as dynamic.
  ///
  /// Instantiates a new [Index32List] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  Index32List.dynamicFromList(List<int> elements)
      : isDynamic = true,
        delegate = new Uint32List.fromList(elements);

  /// Instantiates a new [Index32List] as a view of the specified region in the
  /// [buffer].
  ///
  /// Changes to the [Index32List] will affect the data in the [buffer] and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the [buffer]). If the [length] is not
  /// specified, it defaults to null, which indicates that the view extends to
  /// the end of the [buffer].
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// [BYTES_PER_ELEMENT].
  Index32List.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = false,
        delegate = new Uint32List.view(buffer, offsetInBytes, length);

  /// Instantiates a new [Index32List] as a view of the specified region in the
  /// [buffer], marked as dynamic
  ///
  /// Changes to the [Index32List] will affect the data in the [buffer] and vice
  /// versa. If the [offsetInBytes] index of the region is not specified, it
  /// defaults to zero (the first byte in the [buffer]). If the [length] is not
  /// specified, it defaults to null, which indicates that the view extends to
  /// the end of the [buffer].
  ///
  /// Throws a [RangeError] if [offsetInBytes] or [length] are negative, or if
  /// `offsetInBytes + (length * elementSizeInBytes)` is greater than the length
  /// of buffer.
  ///
  /// Throws an [ArgumentError] if [offsetInBytes] is not a multiple of
  /// [BYTES_PER_ELEMENT].
  Index32List.dynamicView(ByteBuffer buffer,
      [int offsetInBytes = 0, int length])
      : isDynamic = true,
        delegate = new Uint32List.view(buffer, offsetInBytes, length);

  ByteBuffer get buffer => delegate.buffer;

  int get elementSizeInBytes => delegate.elementSizeInBytes;

  int get lengthInBytes => delegate.lengthInBytes;

  int get offsetInBytes => delegate.offsetInBytes;
}
