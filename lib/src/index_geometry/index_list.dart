part of index_geometry;

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

  /// Instantiates a new [IndexList
  factory IndexList(int length) => new IndexList._internal(length, false);

  factory IndexList.dynamic(int length) =>
      new IndexList._internal(length, true);

  factory IndexList._internal(int length, bool dynamic) {
    final data = new Uint16List(length);

    for (var i = 0; i < length; i++) {
      data[i] = i;
    }

    return new IndexList._fromUint16List(data, dynamic);
  }

  IndexList._fromUint16List(this.delegate, this.isDynamic);

  IndexList.fromList(List<int> elements)
      : isDynamic = false,
        delegate = new Uint16List.fromList(elements);

  IndexList.dynamicFromList(List<int> elements)
      : isDynamic = true,
        delegate = new Uint16List.fromList(elements);

  IndexList.view(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = false,
        delegate = new Uint16List.view(buffer, offsetInBytes, length);

  IndexList.dynamicView(ByteBuffer buffer, [int offsetInBytes = 0, int length])
      : isDynamic = true,
        delegate = new Uint16List.view(buffer, offsetInBytes, length);

  ByteBuffer get buffer => delegate.buffer;

  int get elementSizeInBytes => delegate.elementSizeInBytes;

  int get lengthInBytes => delegate.lengthInBytes;

  int get offsetInBytes => delegate.offsetInBytes;
}
