part of geometry;

/// List of integers used to describe how the vertices in a [VertexArray] are
/// connected into geometry primitives.
class IndexList extends DelegatingList<int> implements Uint16List {
  final Uint16List delegate;

  /// Whether or not this [IndexList] is marked as dynamic.
  ///
  /// When `true` it signals to the rendering back-end that this [IndexList] is
  /// intended to be modified regularly, allowing the rendering back-end to
  /// optimize for this.
  ///
  /// Note that this is merely a hint that can be used for tuning the
  /// performance of a rendering back-end: an [IndexList] that is not marked as
  /// dynamic can still be modified.
  final bool isDynamic;

  static const int BYTES_PER_ELEMENT = Uint16List.BYTES_PER_ELEMENT;

  /// Instantiates a new [IndexList] of the given [length] for which every
  /// position is initially set to `0`.
  factory IndexList(int length) =>
      new IndexList._fromUint16List(new Uint16List(length), false);

  /// Instantiates a new [IndexList] of the given [length] for which every
  /// position is initially set to `0`, marked as dynamic.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  factory IndexList.dynamic(int length) =>
      new IndexList._fromUint16List(new Uint16List(length), true);

  /// Instantiates a new [IndexList] of the given [length] with incrementing
  /// indices starting at [start].
  ///
  /// The indices start at [start] and increment by `1`. Specifying the [start]
  /// is optional. When omitted it defaults to `0`.
  factory IndexList.incrementing(int length, [int start = 0]) =>
      new IndexList._incrementingInternal(length, start, false);

  /// Instantiates a new [IndexList] of the given [length] with incrementing
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
  factory IndexList.dynamicIncrementing(int length, [int start = 0]) =>
      new IndexList._incrementingInternal(length, start, true);

  factory IndexList._incrementingInternal(int length, int start, bool dynamic) {
    final data = new Uint16List(length);

    for (var i = 0; i < length; i++) {
      data[i] = start + i;
    }

    return new IndexList._fromUint16List(data, dynamic);
  }

  IndexList._fromUint16List(this.delegate, this.isDynamic);

  /// Instantiates a new [IndexList] from the given list of [elements].
  ///
  /// Instantiates a new [IndexList] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  IndexList.fromList(List<int> elements)
      : isDynamic = false,
        delegate = new Uint16List.fromList(elements);

  /// Instantiates a new [IndexList] from the given list of [elements], marked
  /// as dynamic.
  ///
  /// Instantiates a new [IndexList] with the same length as the lists of
  /// [elements] and copies over the values from that list.
  ///
  /// When index geometry is marked as dynamic it signals to the rendering
  /// back-end that the indices are intended to be modified regularly, allowing
  /// the rendering back-end to optimize for this. Note that this is merely a
  /// hint that can be used for tuning the performance of a rendering back-end:
  /// the index data for geometry that is not marked as dynamic can still be
  /// modified.
  IndexList.dynamicFromList(List<int> elements)
      : isDynamic = true,
        delegate = new Uint16List.fromList(elements);

  /// Instantiates a new [IndexList] as a view of the specified region in the
  /// [buffer].
  ///
  /// Changes to the [IndexList] will affect the data in the [buffer] and vice
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
  IndexList.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = false,
        delegate = new Uint16List.view(buffer, offsetInBytes, length);

  /// Instantiates a new [IndexList] as a view of the specified region in the
  /// [buffer], marked as dynamic
  ///
  /// Changes to the [IndexList] will affect the data in the [buffer] and vice
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
  IndexList.dynamicView(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = true,
        delegate = new Uint16List.view(buffer, offsetInBytes, length);

  ByteBuffer get buffer => delegate.buffer;

  int get elementSizeInBytes => delegate.elementSizeInBytes;

  int get lengthInBytes => delegate.lengthInBytes;

  int get offsetInBytes => delegate.offsetInBytes;
}
